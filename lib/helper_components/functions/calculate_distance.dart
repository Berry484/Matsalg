import 'dart:math';

class CalculateDistance {
  static double calculateDistance(
      double lat1, double lng1, double lat2, double lng2) {
    const earthRadius = 6371.0;
    double degreesToRadians(double degrees) => degrees * pi / 180;

    double dLat = degreesToRadians(lat2 - lat1);
    double dLng = degreesToRadians(lng2 - lng1);
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(degreesToRadians(lat1)) *
            cos(degreesToRadians(lat2)) *
            sin(dLng / 2) *
            sin(dLng / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }
}
