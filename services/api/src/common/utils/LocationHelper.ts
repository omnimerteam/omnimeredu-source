/**
 * Location Helper Utility
 * Handles distance calculations using Haversine formula for geofencing
 */

// Earth's radius in meters
const EARTH_RADIUS_METERS = 6371000;

/**
 * Convert degrees to radians
 */
const toRadians = (degrees: number): number => {
  return degrees * (Math.PI / 180);
};

/**
 * Calculate distance between two coordinates using Haversine formula
 * @returns Distance in meters
 */
export const calculateDistance = (
  lat1: number,
  lon1: number,
  lat2: number,
  lon2: number
): number => {
  const dLat = toRadians(lat2 - lat1);
  const dLon = toRadians(lon2 - lon1);

  const a =
    Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos(toRadians(lat1)) *
      Math.cos(toRadians(lat2)) *
      Math.sin(dLon / 2) *
      Math.sin(dLon / 2);

  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

  return EARTH_RADIUS_METERS * c;
};

/**
 * Check if user location is within allowed radius of a center point
 * @returns Object with isValid boolean and calculated distance
 */
export const isWithinRadius = (
  userLat: number,
  userLon: number,
  centerLat: number,
  centerLon: number,
  radius: number
): { isValid: boolean; distance: number } => {
  const distance = calculateDistance(userLat, userLon, centerLat, centerLon);

  return {
    isValid: distance <= radius,
    distance: Math.round(distance), // Round to nearest meter
  };
};

/**
 * Default allowed radius in meters (100m)
 */
export const DEFAULT_ALLOWED_RADIUS = 100;
