import { IHoliday } from "../../models/system/Holiday";
import HolidayRepository from "../../repositories/system/Holiday.repository";
import { DefaultLogger } from "../../../common/utils/DefaultLogger";

class HolidayService{
    private readonly holidayRepository: HolidayRepository;
    private readonly logger: DefaultLogger;
    constructor(holidayRepository: HolidayRepository, logger: DefaultLogger){
        this.holidayRepository = holidayRepository;
        this.logger = logger;
    }

    async getAllHolidaies(actorId: string, userRole: string){
        try {
            const holidaies = await this.holidayRepository.findAll();
            await this.logger.log({
                userId: actorId,
                action: "GET_ALL_HOLIDAY",
                roleSnapshot: userRole,
                metadata: {count: holidaies.length}
            });
            return holidaies;
        } catch (error) {
            await this.logger.log({
                userId: actorId,
                action: "ERROR_GET_ALL_HOLIDAY",
                roleSnapshot: userRole,
                metadata: {error: (error as Error).message}
            })
            throw error;
        }
    }

    async getHolidayById(id: string, actorId: string, userRole: string){
        try {
            const holiday = await this.holidayRepository.findById(id);
            await this.logger.log({
                userId: actorId,
                action: "GET_HOLIDAY_BY_ID",
                roleSnapshot: userRole,
                targetId: id,
                metadata: {found: !holiday}
            });
            return holiday;
        } catch (error) {
            await this.logger.log({
                userId: actorId,
                action: "ERROR_GET_HOLIDAY_BY_ID",
                roleSnapshot: userRole,
                targetId: id,
                metadata: {error: (error as Error).message}
            })
            throw error;
        }
    }

    async createHoliday(data: Partial<IHoliday>, actorId: string, userRole: string){
        try {
            
            const startDate = data.startDate;
            const endDate = data.endDate;

            if(!startDate || !endDate){
                throw new Error("Vui lòng nhập đầy đủ ngày bắt đầu và ngày kết thúc")
            }

            if(new Date(startDate) > new Date(endDate)){
                throw new Error("Ngày bắt đầu không được lớn hơn ngày kết thúc");
            }

            const holiday = await this.holidayRepository.create(data);

            await this.logger.log({
                userId: actorId,
                action: "CREATE_HOLIDAY",
                roleSnapshot: userRole,
                metadata: {found: !holiday}
            });
            return holiday;
        } catch (error) {
            await this.logger.log({
                userId: actorId,
                action: "ERROR_CREATE_HOLIDAY",
                roleSnapshot: userRole,
                metadata: {error: (error as Error).message}
            })
            throw error;
        }
    }

    async updateHoliday(id: string, data: Partial<IHoliday>, actorId: string, userRole: string){
        try {
            const startDate = data.startDate;
            const endDate = data.endDate;

            if(!startDate || !endDate){
                throw new Error("Vui lòng nhập đầy đủ ngày bắt đầu và ngày kết thúc")
            }

            if(new Date(startDate) > new Date(endDate)){
                throw new Error("Ngày bắt đầu không được lớn hơn ngày kết thúc");
            }
            
            const holiday = await this.holidayRepository.update(id, data);

            await this.logger.log({
                userId: actorId,
                action: "UPDATE_HOLIDAY",
                roleSnapshot: userRole,
                targetId: id,
                metadata: {found: !holiday}
            });

            return holiday;

        } catch (error) {
            await this.logger.log({
                userId: actorId,
                action: "ERROR_UPDATE_HOLIDAY",
                roleSnapshot: userRole,
                metadata: {error: (error as Error).message}
            })
            throw error;
        }
    }

    async deleteHoliday(id: string, actorId: string, userRole: string){
        try {
            const holiday = await this.holidayRepository.delete(id);
            await this.logger.log({
                userId: actorId,
                action: "DELETE_HOLIDAY",
                roleSnapshot: userRole,
                targetId: id,
                metadata: {found: !holiday}
            });

            return holiday;
            
        } catch (error) {
            await this.logger.log({
                userId: actorId,
                action: "ERROR_DELETE_HOLIDAY",
                roleSnapshot: userRole,
                metadata: {error: (error as Error).message}
            })
            throw error;
        }
    }
}


export default HolidayService;