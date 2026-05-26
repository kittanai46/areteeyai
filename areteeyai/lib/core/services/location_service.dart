import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  LocationService._();

  /// Returns a short human-readable location string, e.g. "สุขุมวิท, กรุงเทพฯ"
  /// Falls back to a friendly message on any error.
  static Future<String> getCurrentLocationName() async {
    try {
      // Check if location services are enabled
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return 'ไม่ได้เปิด GPS';

      // Check / request permission
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return 'ไม่ได้รับอนุญาตตำแหน่ง';
      }

      // Get position (low accuracy is fast enough for a display label)
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
          timeLimit: Duration(seconds: 8),
        ),
      );

      // Reverse-geocode to address
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isEmpty) return 'ไม่ทราบตำแหน่ง';

      final place = placemarks.first;

      // Build compact label: subLocality + locality (or administrativeArea)
      final parts = <String>[
        if ((place.subLocality ?? '').isNotEmpty) place.subLocality!,
        if ((place.locality ?? '').isNotEmpty)
          place.locality!
        else if ((place.administrativeArea ?? '').isNotEmpty)
          place.administrativeArea!,
      ];

      return parts.isNotEmpty ? parts.join(', ') : 'ไม่ทราบตำแหน่ง';
    } catch (_) {
      return 'ไม่ทราบตำแหน่ง';
    }
  }
}
