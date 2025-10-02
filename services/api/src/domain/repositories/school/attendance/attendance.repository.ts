import { BaseRepository } from "../../base.repository";
import { IAttendance, IClass, IDetailsRecord } from "../../../models";
import mongoose, { Model, Types } from "mongoose";
import { AttendanceStatusEnum } from "../../../../common/enum/attendanceStatus.enum";
import { HttpError } from "../../../../common/utils/HttpError";
import DateUtils from "../../../../common/utils/DateUtils";

class AttendanceRepository extends BaseRepository<IAttendance> {
  private readonly classModel: Model<IClass>;
  private readonly detailsRecordModel: Model<IDetailsRecord>;

  constructor(
    attendanceModel: Model<IAttendance>,
    detailsRecordModel: Model<IDetailsRecord>,
    classModel: Model<IClass>
  ) {
    super(attendanceModel);
    this.detailsRecordModel = detailsRecordModel;
    this.classModel = classModel;
  }

  async findByUserId(userId: string) {
    return this.detailsRecordModel
      .find({ studentId: new Types.ObjectId(userId) })
      .populate("attendanceId")
      .exec();
  }

  /**
   * Khởi tạo điểm danh cho lớp học (atomic: Attendance + DetailsRecord[])
   */
  async initializeClassAttendance(attendanceData: Partial<IAttendance>) {
    console.log("Initialize class attendance:", attendanceData);
    const session = await mongoose.startSession();
    session.startTransaction();

    try {
      const classDoc = await this.classModel
        .findById(attendanceData.classId)
        .session(session)
        .lean();

      if (!classDoc) {
        throw new HttpError(400, "Không tìm thấy lớp học");
      }

      const attendance = await this.model.create(
        [
          {
            classId: attendanceData.classId,
            schoolId: attendanceData.schoolId,
            date: attendanceData.date ?? new Date(),
          },
        ],
        { session }
      );

      if (classDoc.students?.length) {
        const detailRecords = classDoc.students.map(
          (studentId: Types.ObjectId) => ({
            studentId,
            attendanceId: attendance[0]._id,
            status: AttendanceStatusEnum.Present,
          })
        );

        await this.detailsRecordModel.insertMany(detailRecords, { session });
      }

      await session.commitTransaction();
      return attendance[0];
    } catch (error) {
      await session.abortTransaction();
      throw error;
    } finally {
      session.endSession();
    }
  }

  async getOrInitializeTodayAttendance(
    attendanceData: Partial<IAttendance>,
    timeZone: string = "Asia/Ho_Chi_Minh"
  ): Promise<IAttendance> {
    const { start, end } = DateUtils.getUtcDayRange(
      attendanceData.date,
      timeZone
    );

    // 1. Kiểm tra đã có Attendance trong ngày chưa
    const attendance = await this.model.findOne({
      classId: attendanceData.classId,
      schoolId: attendanceData.schoolId,
      date: { $gte: start, $lte: end },
    });

    // 2. Nếu chưa thì khởi tạo mới
    if (!attendance) {
      return await this.initializeClassAttendance(attendanceData);
    }

    throw new HttpError(
      400,
      "Đã tồn tại bảng điểm danh cho lớp này trong ngày"
    );
  }
}

export default AttendanceRepository;
