/**
 * QR Helper Utility
 * Handles encoding, decoding, and validation of QR code payloads for attendance
 */

// QR Payload structure
export interface QRPayload {
  attendanceId: string;
  timestamp: string;
  dynamicCode: string;
}

// QR Scan Request (from mobile app)
export interface ScanRequest {
  qrData: string;
  latitude: number;
  longitude: number;
  deviceId: string;
  timestamp: string;
}

// QR Scan Response (to mobile app)
export interface ScanResponse {
  status: string;
  message: string;
  attendanceTime?: string;
  distance?: number;
  attendanceId?: string;
}

/**
 * Encode payload to QR data (base64)
 */
export const encodeQRPayload = (payload: QRPayload): string => {
  return Buffer.from(JSON.stringify(payload)).toString("base64");
};

/**
 * Decode QR data back to payload
 * Returns null if decoding fails
 */
export const decodeQRPayload = (qrData: string): QRPayload | null => {
  try {
    const decoded = Buffer.from(qrData, "base64").toString("utf-8");
    const payload = JSON.parse(decoded);

    // Validate required fields
    if (!payload.attendanceId || !payload.timestamp || !payload.dynamicCode) {
      return null;
    }

    return payload as QRPayload;
  } catch (error) {
    console.error("[QrHelper] Failed to decode QR payload:", error);
    return null;
  }
};

/**
 * Check if QR code has expired
 */
export const isQRExpired = (expiry: Date | string): boolean => {
  const expiryDate = typeof expiry === "string" ? new Date(expiry) : expiry;
  return new Date() > expiryDate;
};

/**
 * Generate a random 6-digit dynamic code
 */
export const generateDynamicCode = (): string => {
  return Math.floor(100000 + Math.random() * 900000).toString();
};

/**
 * Create a new QR payload with expiry
 * @param attendanceId The attendance session ID
 * @param expiryMinutes Number of minutes until QR expires (default: 3)
 */
export const createQRPayload = (
  attendanceId: string,
  expiryMinutes: number = 3
): { payload: QRPayload; expiry: Date; qrData: string } => {
  const now = new Date();
  const expiry = new Date(now.getTime() + expiryMinutes * 60 * 1000);
  const dynamicCode = generateDynamicCode();

  const payload: QRPayload = {
    attendanceId,
    timestamp: now.toISOString(),
    dynamicCode,
  };

  return {
    payload,
    expiry,
    qrData: encodeQRPayload(payload),
  };
};
