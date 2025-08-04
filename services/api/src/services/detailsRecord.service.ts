import { IDetailsRecord } from '../models/DetailsRecord.js';
import DetailsRecordRepository from '../repositories/detailsRecord.repository.js';
import { DefaultLogger } from '../utils/DefaultLogger.js';
class DetailsRecordService {
    private readonly detailsRecordRepository: DetailsRecordRepository;
    private readonly logger: DefaultLogger;
    constructor(detailsRecordRepository: DetailsRecordRepository, logger: DefaultLogger) {
        this.detailsRecordRepository = detailsRecordRepository;
        this.logger = logger;
    }


    async getAllDetailsRecords(userId: string, userRole: string) {
        try {
            const records = await this.detailsRecordRepository.findAll();
            await this.logger.log({
                userId,
                action: "GET_ALL_DETAILS_RECORDS",
                roleSnapshot: userRole,
                metadata: { count: records.length }
            });
            return records;
        } catch (error) {
            await this.logger.log({
                userId,
                action: "GET_ALL_DETAILS_RECORDS_FAILED",
                roleSnapshot: userRole,
                metadata: { error: (error as Error).message }
            });
            throw error;
        }
    }

    async getDetailsRecordById(recordId: string, userId: string, userRole: string) {
        try {
            const record = await this.detailsRecordRepository.findById(recordId);
            await this.logger.log({
                userId,
                action: "GET_DETAIL_RECORD_BY_ID",
                roleSnapshot: userRole,
                targetId: recordId,
                metadata: { found: !!record }
            });
            return record;
        } catch (error) {
            await this.logger.log({
                userId,
                action: "GET_DETAIL_RECORD_BY_ID_FAILED",
                roleSnapshot: userRole,
                targetId: recordId,
                metadata: { error: (error as Error).message }
            });
            throw error;
        }
    }

    async createDetailsRecord(recordData: Partial<IDetailsRecord>, userId: string, userRole: string) {
        try {
            const record = await this.detailsRecordRepository.create(recordData);
            await this.logger.log({
                userId,
                action: "CREATE_DETAIL_RECORD",
                roleSnapshot: userRole,
                metadata: { found: !!record }
            });
            return record;
        } catch (error) {
            await this.logger.log({
                userId,
                action: "CREATE_DETAIL_RECORD_FAILED",
                roleSnapshot: userRole,
                metadata: { error: (error as Error).message }
            });
            throw error;
        }
    }

    async updateDetailsRecord(recordId: string, recordData: Partial<IDetailsRecord>, userId: string, userRole: string) {
        try {
            const record = await this.detailsRecordRepository.update(recordId, recordData);
            await this.logger.log({
                userId,
                action: "UPDATE_DETAIL_RECORD",
                roleSnapshot: userRole,
                targetId: recordId,
                metadata: { found: !!record }
            });
            return record;
        } catch (error) {
            await this.logger.log({
                userId,
                action: "UPDATE_DETAIL_RECORD_FAILED",
                roleSnapshot: userRole,
                targetId: recordId,
                metadata: { error: (error as Error).message }
            });
            throw error;
        }
    }

    async deleteDetailsRecord(recordId: string, userId: string, userRole: string) {
        try {
            const record = await this.detailsRecordRepository.delete(recordId);
            await this.logger.log({
                userId,
                action: "DELETE_DETAIL_RECORD",
                roleSnapshot: userRole,
                targetId: recordId,
                metadata: { found: !!record }
            });
            return record;
        } catch (error) {
            await this.logger.log({
                userId,
                action: "DELETE_DETAIL_RECORD_FAILED",
                roleSnapshot: userRole,
                targetId: recordId,
                metadata: { error: (error as Error).message }
            });
            throw error;
        }
    }
}
export default DetailsRecordService;