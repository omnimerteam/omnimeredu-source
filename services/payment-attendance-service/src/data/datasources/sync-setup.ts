import { registerSyncHooks } from "shared-lib";
import { noSQLClient } from "./mongodb/client";
import { SyncService } from "../messaging/SyncService";

// Import Models
import { AttendanceModel } from "./postgres/models/AttendanceModel";
import { AttendanceRecordModel } from "./postgres/models/AttendanceRecordModel";
import { TuitionModel } from "./postgres/models/TuitionModel";
import { PaymentModel } from "./postgres/models/PaymentModel";
import { HolidayModel } from "./postgres/models/HolidayModel";

const syncService = new SyncService(noSQLClient);

export const setupSyncHooks = () => {
  registerSyncHooks(AttendanceModel, syncService, "attendances");
  registerSyncHooks(AttendanceRecordModel, syncService, "attendance_records");
  registerSyncHooks(TuitionModel, syncService, "tuitions");
  registerSyncHooks(PaymentModel, syncService, "payments");
  registerSyncHooks(HolidayModel, syncService, "holidays");

  console.log("✅ Sync hooks registered for all models");
};
