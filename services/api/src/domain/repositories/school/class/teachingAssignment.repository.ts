import { Model, Types } from "mongoose";
import { ITeachingAssignment } from "../../../models";
import { BaseRepository } from "../../base.repository";
import DateUtils from "../../../../common/utils/DateUtils";

class TeachingAssignmentRepository extends BaseRepository<ITeachingAssignment> {
  constructor(TeachingAssignmentModel: Model<ITeachingAssignment>) {
    super(TeachingAssignmentModel);
  }

  async findClassesByTeacher(
    teacherId: string,
    schoolId: string,
    date: Date = new Date(),
    timezone: string = "Asia/Ho_Chi_Minh"
  ): Promise<any[]> {
    const { start, end } = DateUtils.getUtcDayRange(date, timezone);

    return this.model.aggregate([
      {
        $match: {
          teacherId: new Types.ObjectId(teacherId),
          schoolId: new Types.ObjectId(schoolId),
        },
      },
      {
        $lookup: {
          from: "classes",
          localField: "classId",
          foreignField: "_id",
          as: "classId",
          pipeline: [
            {
              $project: {
                _id: 1,
                name: 1,
                code: 1,
                maxStudents: 1,
                schoolId: 1,
                studentsCount: { $size: "$students" },
                gradeId: 1,
              },
            },
            {
              $lookup: {
                from: "grades",
                localField: "gradeId",
                foreignField: "_id",
                as: "gradeId",
                pipeline: [
                  {
                    $project: {
                      _id: 1,
                      name: 1,
                    },
                  },
                ],
              },
            },
            { $unwind: { path: "$gradeId", preserveNullAndEmptyArrays: true } },
          ],
        },
      },
      { $unwind: "$classId" },
      {
        $lookup: {
          from: "attendances",
          let: {
            classId: "$classId._id",
            schoolId: "$schoolId",
          },
          pipeline: [
            {
              $match: {
                $expr: {
                  $and: [
                    { $eq: ["$classId", "$$classId"] },
                    { $eq: ["$schoolId", "$$schoolId"] },
                    { $gte: ["$date", start] },
                    { $lte: ["$date", end] },
                  ],
                },
              },
            },
            { $limit: 1 },
          ],
          as: "attendanceDocs",
        },
      },
      {
        $addFields: {
          isHaveAttendance: { $gt: [{ $size: "$attendanceDocs" }, 0] },
        },
      },
      { $sort: { "classId.name": 1 } },
      {
        $project: {
          attendanceDocs: 0,
        },
      },
    ]);
  }
}

export default TeachingAssignmentRepository;
