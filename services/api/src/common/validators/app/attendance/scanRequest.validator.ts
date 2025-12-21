import { z } from "zod";

/**
 * Validators for QR Attendance scan requests
 */

// Single scan request from mobile app
export const scanRequestSchema = z.object({
  qrData: z.string().min(1, "QR data is required"),
  latitude: z.number().min(-90).max(90),
  longitude: z.number().min(-180).max(180),
  deviceId: z.string().min(1, "Device ID is required"),
  timestamp: z.string().datetime({ message: "Invalid timestamp format" }),
});

// Batch sync request for offline scans
export const syncScansSchema = z.object({
  scans: z.array(scanRequestSchema).min(1, "At least one scan is required"),
});

export type ScanRequestBody = z.infer<typeof scanRequestSchema>;
export type SyncScansBody = z.infer<typeof syncScansSchema>;
