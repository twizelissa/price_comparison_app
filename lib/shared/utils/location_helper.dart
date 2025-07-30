import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../../core/error/exceptions.dart';

class LocationHelper {
  // Get current position
  static Future<Position> getCurrentPosition() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw const LocationException(message: 'Location services are disabled');
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw const LocationException(message: 'Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw const LocationException(
          message: 'Location permissions are permanently denied, we cannot request permissions',
        );
      }

      // Get current position
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 15),
      );
    } catch (e) {
      if (e is LocationException) rethrow;
      throw LocationException(message: 'Failed to get current location: ${e.toString()}');
    }
  }

  // Get address from coordinates
  static Future<String> getAddressFromCoordinates(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        return _formatAddress(place);
      }
      return 'Unknown location';
    } catch (e) {
      throw LocationException(message: 'Failed to get address: ${e.toString()}');
    }
  }

  // Get coordinates from address
  static Future<Position?> getCoordinatesFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        Location location = locations[0];
        return Position(
          latitude: location.latitude,
          longitude: location.longitude,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0,
        );
      }
      return null;
    } catch (e) {
      throw LocationException(message: 'Failed to get coordinates: ${e.toString()}');
    }
  }

  // Calculate distance between two points
  static double calculateDistance(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  // Check if location permission is granted
  static Future<bool> isLocationPermissionGranted() async {
    LocationPermission permission = await Geolocator.checkPermission();
    return permission == LocationPermission.always || permission == LocationPermission.whileInUse;
  }

  // Request location permission
  static Future<bool> requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    
    return permission == LocationPermission.always || permission == LocationPermission.whileInUse;
  }

  // Open location settings
  static Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  // Open app settings
  static Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
  }

  // Get location stream for real-time updates
  static Stream<Position> getPositionStream({
    LocationAccuracy accuracy = LocationAccuracy.high,
    int distanceFilter = 10,
  }) {
    return Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: accuracy,
        distanceFilter: distanceFilter,
      ),
    );
  }

  // Get last known position
  static Future<Position?> getLastKnownPosition() async {
    try {
      return await Geolocator.getLastKnownPosition();
    } catch (e) {
      return null;
    }
  }

  // Format address from placemark
  static String _formatAddress(Placemark place) {
    List<String> addressComponents = [];
    
    if (place.name != null && place.name!.isNotEmpty) {
      addressComponents.add(place.name!);
    }
    
    if (place.street != null && place.street!.isNotEmpty && place.street != place.name) {
      addressComponents.add(place.street!);
    }
    
    if (place.locality != null && place.locality!.isNotEmpty) {
      addressComponents.add(place.locality!);
    }
    
    if (place.administrativeArea != null && place.administrativeArea!.isNotEmpty) {
      addressComponents.add(place.administrativeArea!);
    }
    
    if (place.country != null && place.country!.isNotEmpty) {
      addressComponents.add(place.country!);
    }
    
    return addressComponents.join(', ');
  }

  // Check if coordinates are in Rwanda
  static bool isInRwanda(double latitude, double longitude) {
    // Rwanda approximate bounds
    const double minLat = -2.917;
    const double maxLat = -1.047;
    const double minLng = 28.862;
    const double maxLng = 30.899;
    
    return latitude >= minLat && 
           latitude <= maxLat && 
           longitude >= minLng && 
           longitude <= maxLng;
  }

  // Get Rwanda districts (simplified list)
  static List<String> getRwandaDistricts() {
    return [
      'Kigali',
      'Nyarugenge',
      'Gasabo',
      'Kicukiro',
      'Bugesera',
      'Gatsibo',
      'Kayonza',
      'Kirehe',
      'Ngoma',
      'Nyagatare',
      'Rwamagana',
      'Huye',
      'Kamonyi',
      'Muhanga',
      'Nyamagabe',
      'Nyanza',
      'Ruhango',
      'Gicumbi',
      'Musanze',
      'Burera',
      'Gakenke',
      'Rulindo',
      'Karongi',
      'Ngororero',
      'Nyabihu',
      'Rubavu',
      'Rusizi',
      'Nyamasheke',
      'Gisagara',
      'Nyaruguru',
    ];
  }

  // Format distance for display
  static String formatDistance(double distanceInMeters) {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.round()}m';
    } else {
      double distanceInKm = distanceInMeters / 1000;
      if (distanceInKm < 10) {
        return '${distanceInKm.toStringAsFixed(1)}km';
      } else {
        return '${distanceInKm.round()}km';
      }
    }
  }

  // Get nearby places (mock implementation)
  static Future<List<NearbyPlace>> getNearbyPlaces(
    double latitude,
    double longitude,
    String type,
    {double radiusInMeters = 5000}
  ) async {
    // This would typically call a places API like Google Places
    // For now, return mock data
    await Future.delayed(const Duration(seconds: 1));
    
    return [
      NearbyPlace(
        name: 'Kimironko Market',
        address: 'Kimironko, Gasabo, Kigali',
        latitude: -1.9441,
        longitude: 30.1056,
        type: 'market',
        distance: 1200,
      ),
      NearbyPlace(
        name: 'Nyabugogo Market',
        address: 'Nyabugogo, Nyarugenge, Kigali',
        latitude: -1.9706,
        longitude: 30.0419,
        type: 'market',
        distance: 2500,
      ),
    ];
  }
}

class NearbyPlace {
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String type;
  final double distance; // in meters

  NearbyPlace({
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.type,
    required this.distance,
  });
}