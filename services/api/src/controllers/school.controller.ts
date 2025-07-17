import SchoolService from '../services/school.services';
import { Request, Response } from 'express';
import { ISchool } from '../models/School';

class SchoolController {
    private readonly schoolService: SchoolService;

    constructor(SchoolService: SchoolService) {
        this.schoolService = SchoolService;
    }

    async getAllSchools(req: Request, res: Response): Promise<void> {
        try {
            const schools = await this.schoolService.getAllSchools();
            if (!schools || schools.length === 0) {
                res.status(404).json({ message: 'No schools found' });
                return;
            }
            res.status(200).json(schools);
        } catch (error) {
            res.status(500).json({ message: 'Error retrieving schools', error });
        }
    }

    async getSchoolById(req: Request, res: Response): Promise<void> {
        try {
            const schoolId = req.params.id;
            const school = await this.schoolService.getSchoolById(schoolId);
            if (!school) {
                res.status(404).json({ message: 'School not found' });
                return;
            }
            console.log('Retrieved school:', school);
            res.status(200).json(school);
        } catch (error) {
            res.status(500).json({ message: 'Error retrieving school', error });
        }
    }

    async getSchoolByNameOrCode(req: Request, res: Response): Promise<void> {
        try {
            // Ở hàm này sẽ lấy giá trị từ query trực tiếp trên url
            const { name, code } = req.query;
            if (!name && !code) {
                res.status(400).json({ message: 'Name or code query parameter is required' });
                return;
            }
            const school = await this.schoolService.getSchoolByNameOrCode(name as string, code as string);
            if (!school) {
                res.status(404).json({ message: 'School not found' });
                return;
            }
            res.status(200).json(school);
        } catch (error) {
            res.status(500).json({ message: 'Error retrieving school by name or code', error });
        }
    }

    async createSchool(req: Request, res: Response): Promise<void> {
        try {
            const schoolData: Partial<ISchool> = req.body;
            console.log('schoolData:', schoolData);
            const newSchool = await this.schoolService.createSchool(schoolData);
            res.status(201).json(newSchool);
        } catch (error) {
            res.status(500).json({ message: 'Error creating school', error });
        }
    }

    async updateSchool(req: Request, res: Response): Promise<void> {
        try {
            const schoolId = req.params.id;
            const schoolData: Partial<ISchool> = req.body;
            const updatedSchool = await this.schoolService.updateSchool(schoolId, schoolData);
            if (!updatedSchool) {
                res.status(404).json({ message: 'School not found' });
                return;
            }
            res.status(200).json(updatedSchool);
        } catch (error) {
            res.status(500).json({ message: 'Error updating school', error });
        }
    }

    async deleteSchool(req: Request, res: Response): Promise<void> {
        try {
            const schoolId = req.params.id;
            const deleted = await this.schoolService.deleteSchool(schoolId);
            if (!deleted) {
                res.status(404).json({ message: 'School not found' });
                return;
            }
            res.status(204).send('School deleted successfully');
        } catch (error) {
            res.status(500).json({ message: 'Error deleting school', error });
        }
    }
}
//ở đây chỉ export ra 1 class duy nhất, không cần phải export từng hàm

export default SchoolController;    