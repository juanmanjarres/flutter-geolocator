import 'dart:async';

import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';

export 'package:geolocator_platform_interface/geolocator_platform_interface.dart';

/// Wraps CLLocationManager (on iOS) and FusedLocationProviderClient or
/// LocationManager
/// (on Android), providing support to retrieve position information
/// of the device.
///
/// Permissions are automatically handled when retrieving position information.
/// However utility methods for manual permission management are also
/// provided.
class Geolocator {
  /// Returns a [Future] indicating if the user allows the App to access
  /// the device's location.
  static Future<LocationPermission> checkPermission() =>
      GeolocatorPlatform.instance.checkPermission();

  /// Request permission to access the location of the device.
  ///
  /// Returns a [Future] which when completes indicates if the user granted
  /// permission to access the device's location.
  /// Throws a [PermissionDefinitionsNotFoundException] when the required
  /// platform specific configuration is missing (e.g. in the
  /// AndroidManifest.xml on Android or the Info.plist on iOS).
  /// A [PermissionRequestInProgressException] is thrown if permissions are
  /// requested while an earlier request has not yet been completed.
  static Future<LocationPermission> requestPermission() =>
      GeolocatorPlatform.instance.requestPermission();

  /// Returns a [Future] containing a [bool] value indicating whether location
  /// services are enabled on the device.
  static Future<bool> isLocationServiceEnabled() =>
      GeolocatorPlatform.instance.isLocationServiceEnabled();

  /// Returns the last known position stored on the users device.
  ///
  /// On Android you can force the plugin to use the old Android
  /// LocationManager implementation over the newer FusedLocationProvider by
  /// passing true to the [forceAndroidLocationManager] parameter. On iOS
  /// this parameter is ignored.
  /// When no position is available, null is returned.
  /// Throws a [PermissionDeniedException] when trying to request the device's
  /// location when the user denied access.
  static Future<Position?> getLastKnownPosition(
          {bool forceAndroidLocationManager = false}) =>
      GeolocatorPlatform.instance.getLastKnownPosition(
          forceAndroidLocationManager: forceAndroidLocationManager);

  /// Returns the current position taking the supplied [desiredAccuracy] into
  /// account.
  ///
  /// You can control the precision of the location updates by supplying the
  /// [desiredAccuracy] parameter (defaults to "best"). On Android you can
  /// force the use of the Android LocationManager instead of the
  /// FusedLocationProvider by setting the [forceAndroidLocationManager]
  /// parameter to true. The [timeLimit] parameter allows you to specify a
  /// timeout interval (by default no time limit is configured).
  ///
  /// Throws a [TimeoutException] when no location is received within the
  /// supplied [timeLimit] duration.
  /// Throws a [PermissionDeniedException] when trying to request the device's
  /// location when the user denied access.
  /// Throws a [LocationServiceDisabledException] when the user allowed access,
  /// but the location services of the device are disabled.
  static Future<Position> getCurrentPosition({
    LocationAccuracy desiredAccuracy = LocationAccuracy.best,
    bool forceAndroidLocationManager = false,
    Duration? timeLimit,
  }) =>
      GeolocatorPlatform.instance.getCurrentPosition(
        desiredAccuracy: desiredAccuracy,
        forceAndroidLocationManager: forceAndroidLocationManager,
        timeLimit: timeLimit,
      );

  /// Returns a stream emitting NMEA-0183 sentences Android only, no-op on iOS.
  ///
  /// With devices running an Android API level lower than 24 NMEA-0183
  /// sentences are received from the GPS engine. From API level 24 and up the
  /// GNSS engine is used.
  ///
  /// This event starts all location sensors on the device and will keep them
  /// active until you cancel listening to the stream or when the application
  /// is killed.
  ///
  /// ```
  /// StreamSubscription<NmeaMessage> nmeaStream =
  ///     Geolocator.getNmeaMessageStream().listen((NmeaMessage nmea) {
  ///       // Handle NMEA changes
  ///     });
  /// ```
  ///
  /// When no longer needed cancel the subscription
  /// nmeaStream.cancel();
  ///
  /// Throws a [PermissionDeniedException] when trying to request the device's
  /// location when the user denied access.
  /// Throws a [LocationServiceDisabledException] when the user allowed access,
  /// but the location services of the device are disabled.
  ///
  /// for more info about NMEA 0183 see https://en.wikipedia.org/wiki/NMEA_0183
  static Stream<NmeaMessage> getNmeaMessageStream() =>
      GeolocatorPlatform.instance.getNmeaMessageStream();

  /// Returns a stream emitting the location changes inside the bounds of the
  /// [desiredAccuracy].
  ///
  /// This event starts all location sensors on the device and will keep them
  /// active until you cancel listening to the stream or when the application
  /// is killed.
  ///
  /// ```
  /// StreamSubscription<Position> positionStream =
  ///     Geolocator.getPositionStream()
  ///     .listen((Position position) {
  ///       // Handle position changes
  ///     });
  ///
  /// // When no longer needed cancel the subscription
  /// positionStream.cancel();
  /// ```
  ///
  /// You can control the precision of the location updates by supplying the
  /// [desiredAccuracy] parameter (defaults to "best"). The [distanceFilter]
  /// parameter controls the minimum distance the device needs to move before
  /// the update is emitted (default value is 0 indicator no filter is used).
  /// On Android you can force the use of the Android LocationManager instead
  /// of the FusedLocationProvider by setting the [forceAndroidLocationManager]
  /// parameter to true. Using the [intervalDuration] you can control the amount
  /// of time that needs to pass before the next position update is send. The
  /// [timeLimit] parameter allows you to specify a timeout interval (by
  /// default no time limit is configured).
  ///
  /// Throws a [TimeoutException] when no location is received within the
  /// supplied [timeLimit] duration.
  /// Throws a [PermissionDeniedException] when trying to request the device's
  /// location when the user denied access.
  /// Throws a [LocationServiceDisabledException] when the user allowed access,
  /// but the location services of the device are disabled.
  static Stream<Position> getPositionStream({
    LocationAccuracy desiredAccuracy = LocationAccuracy.best,
    int distanceFilter = 0,
    bool forceAndroidLocationManager = false,
    Duration? intervalDuration,
    Duration? timeLimit,
  }) =>
      GeolocatorPlatform.instance.getPositionStream(
        desiredAccuracy: desiredAccuracy,
        distanceFilter: distanceFilter,
        forceAndroidLocationManager: forceAndroidLocationManager,
        timeInterval: intervalDuration?.inMilliseconds ?? 0,
        timeLimit: timeLimit,
      );

  /// Returns a [Future] containing a [LocationAccuracyStatus]
  /// When the user has given permission for approximate location,
  /// [LocationAccuracyStatus.reduced] will be returned, if the user has
  /// given permission for precise location, [LocationAccuracyStatus.precise]
  /// will be returned
  static Future<LocationAccuracyStatus> getLocationAccuracy() =>
      GeolocatorPlatform.instance.getLocationAccuracy();

  /// Fires whenever the location services are disabled/enabled in the notification
  /// bar or in the device settings. Returns ServiceStatus.enabled when location
  /// services are enabled and returns ServiceStatus.disabled when location
  /// services are disabled
  static Stream<ServiceStatus> getServiceStatusStream() =>
      GeolocatorPlatform.instance.getServiceStatusStream();

  /// Requests temporary precise location when the user only gave permission
  /// for approximate location (iOS 14+ only)
  ///
  /// When using this method, the value of the required property `purposeKey`
  /// should match the <key> value given in the
  /// `NSLocationTemporaryUsageDescription` dictionary in the
  /// Info.plist.
  ///
  /// Throws a [PermissionDefinitionsNotFoundException] when the necessary key
  /// in the Info.plist is not added
  /// Returns [LocationAccuracyStatus.precise] when using iOS 13 or below or
  /// using other platforms.
  static Future<LocationAccuracyStatus> requestTemporaryFullAccuracy({
    required String purposeKey,
  }) =>
      GeolocatorPlatform.instance.requestTemporaryFullAccuracy(
        purposeKey: purposeKey,
      );

  /// Opens the App settings page.
  ///
  /// Returns [true] if the location settings page could be opened, otherwise
  /// [false] is returned.
  static Future<bool> openAppSettings() =>
      GeolocatorPlatform.instance.openAppSettings();

  /// Opens the location settings page.
  ///
  /// Returns [true] if the location settings page could be opened, otherwise
  /// [false] is returned.
  static Future<bool> openLocationSettings() =>
      GeolocatorPlatform.instance.openLocationSettings();

  /// Calculates the distance between the supplied coordinates in meters.
  ///
  /// The distance between the coordinates is calculated using the Haversine
  /// formula (see https://en.wikipedia.org/wiki/Haversine_formula). The
  /// supplied coordinates [startLatitude], [startLongitude], [endLatitude] and
  /// [endLongitude] should be supplied in degrees.
  static double distanceBetween(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) =>
      GeolocatorPlatform.instance.distanceBetween(
        startLatitude,
        startLongitude,
        endLatitude,
        endLongitude,
      );

  /// Calculates the initial bearing between two points
  ///
  /// The initial bearing will most of the time be different than the end
  /// bearing, see https://www.movable-type.co.uk/scripts/latlong.html#bearing.
  /// The supplied coordinates [startLatitude], [startLongitude], [endLatitude]
  /// and [endLongitude] should be supplied in degrees.
  static double bearingBetween(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) =>
      GeolocatorPlatform.instance.bearingBetween(
        startLatitude,
        startLongitude,
        endLatitude,
        endLongitude,
      );
}
