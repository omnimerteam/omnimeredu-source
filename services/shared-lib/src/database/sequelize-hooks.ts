import { Model } from "sequelize";
import { ISyncService } from "./sync-service";

export const registerSyncHooks = (
  model: any, // Sequelize Model type is complex to type strictly without specific generic
  syncService: ISyncService,
  collectionName: string
) => {
  model.afterCreate(async (instance: any) => {
    try {
      await syncService.sync(instance.toJSON(), "CREATE", collectionName);
      console.log(`Synced CREATE for ${collectionName}`);
    } catch (error) {
      console.error(`Failed to sync CREATE for ${collectionName}`, error);
    }
  });

  model.afterUpdate(async (instance: any) => {
    try {
      await syncService.sync(instance.toJSON(), "UPDATE", collectionName);
      console.log(`Synced UPDATE for ${collectionName}`);
    } catch (error) {
      console.error(`Failed to sync UPDATE for ${collectionName}`, error);
    }
  });

  model.afterDestroy(async (instance: any) => {
    try {
      await syncService.sync(instance.toJSON(), "DELETE", collectionName);
      console.log(`Synced DELETE for ${collectionName}`);
    } catch (error) {
      console.error(`Failed to sync DELETE for ${collectionName}`, error);
    }
  });
};
