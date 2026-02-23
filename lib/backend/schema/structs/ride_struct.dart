// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class RideStruct extends BaseStruct {
  RideStruct({
    LatLng? userLocation,
    String? userUid,
    LatLng? driverLocation,
    String? driverUid,
    LatLng? destinationLocation,
    String? destinationAddress,
    String? userAddress,
    String? userName,
    String? driverName,
    bool? isDriverAssigned,
  })  : _userLocation = userLocation,
        _userUid = userUid,
        _driverLocation = driverLocation,
        _driverUid = driverUid,
        _destinationLocation = destinationLocation,
        _destinationAddress = destinationAddress,
        _userAddress = userAddress,
        _userName = userName,
        _driverName = driverName,
        _isDriverAssigned = isDriverAssigned;

  // "user_location" field.
  LatLng? _userLocation;
  LatLng? get userLocation => _userLocation;
  set userLocation(LatLng? val) => _userLocation = val;

  bool hasUserLocation() => _userLocation != null;

  // "user_uid" field.
  String? _userUid;
  String get userUid => _userUid ?? '';
  set userUid(String? val) => _userUid = val;

  bool hasUserUid() => _userUid != null;

  // "driver_location" field.
  LatLng? _driverLocation;
  LatLng? get driverLocation => _driverLocation;
  set driverLocation(LatLng? val) => _driverLocation = val;

  bool hasDriverLocation() => _driverLocation != null;

  // "driver_uid" field.
  String? _driverUid;
  String get driverUid => _driverUid ?? '';
  set driverUid(String? val) => _driverUid = val;

  bool hasDriverUid() => _driverUid != null;

  // "destination_location" field.
  LatLng? _destinationLocation;
  LatLng? get destinationLocation => _destinationLocation;
  set destinationLocation(LatLng? val) => _destinationLocation = val;

  bool hasDestinationLocation() => _destinationLocation != null;

  // "destination_address" field.
  String? _destinationAddress;
  String get destinationAddress => _destinationAddress ?? '';
  set destinationAddress(String? val) => _destinationAddress = val;

  bool hasDestinationAddress() => _destinationAddress != null;

  // "user_address" field.
  String? _userAddress;
  String get userAddress => _userAddress ?? '';
  set userAddress(String? val) => _userAddress = val;

  bool hasUserAddress() => _userAddress != null;

  // "user_name" field.
  String? _userName;
  String get userName => _userName ?? '';
  set userName(String? val) => _userName = val;

  bool hasUserName() => _userName != null;

  // "driver_name" field.
  String? _driverName;
  String get driverName => _driverName ?? '';
  set driverName(String? val) => _driverName = val;

  bool hasDriverName() => _driverName != null;

  // "is_driver_assigned" field.
  bool? _isDriverAssigned;
  bool get isDriverAssigned => _isDriverAssigned ?? false;
  set isDriverAssigned(bool? val) => _isDriverAssigned = val;

  bool hasIsDriverAssigned() => _isDriverAssigned != null;

  static RideStruct fromMap(Map<String, dynamic> data) => RideStruct(
        userLocation: data['user_location'] as LatLng?,
        userUid: data['user_uid'] as String?,
        driverLocation: data['driver_location'] as LatLng?,
        driverUid: data['driver_uid'] as String?,
        destinationLocation: data['destination_location'] as LatLng?,
        destinationAddress: data['destination_address'] as String?,
        userAddress: data['user_address'] as String?,
        userName: data['user_name'] as String?,
        driverName: data['driver_name'] as String?,
        isDriverAssigned: data['is_driver_assigned'] as bool?,
      );

  static RideStruct? maybeFromMap(dynamic data) =>
      data is Map ? RideStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'user_location': _userLocation,
        'user_uid': _userUid,
        'driver_location': _driverLocation,
        'driver_uid': _driverUid,
        'destination_location': _destinationLocation,
        'destination_address': _destinationAddress,
        'user_address': _userAddress,
        'user_name': _userName,
        'driver_name': _driverName,
        'is_driver_assigned': _isDriverAssigned,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'user_location': serializeParam(
          _userLocation,
          ParamType.LatLng,
        ),
        'user_uid': serializeParam(
          _userUid,
          ParamType.String,
        ),
        'driver_location': serializeParam(
          _driverLocation,
          ParamType.LatLng,
        ),
        'driver_uid': serializeParam(
          _driverUid,
          ParamType.String,
        ),
        'destination_location': serializeParam(
          _destinationLocation,
          ParamType.LatLng,
        ),
        'destination_address': serializeParam(
          _destinationAddress,
          ParamType.String,
        ),
        'user_address': serializeParam(
          _userAddress,
          ParamType.String,
        ),
        'user_name': serializeParam(
          _userName,
          ParamType.String,
        ),
        'driver_name': serializeParam(
          _driverName,
          ParamType.String,
        ),
        'is_driver_assigned': serializeParam(
          _isDriverAssigned,
          ParamType.bool,
        ),
      }.withoutNulls;

  static RideStruct fromSerializableMap(Map<String, dynamic> data) =>
      RideStruct(
        userLocation: deserializeParam(
          data['user_location'],
          ParamType.LatLng,
          false,
        ),
        userUid: deserializeParam(
          data['user_uid'],
          ParamType.String,
          false,
        ),
        driverLocation: deserializeParam(
          data['driver_location'],
          ParamType.LatLng,
          false,
        ),
        driverUid: deserializeParam(
          data['driver_uid'],
          ParamType.String,
          false,
        ),
        destinationLocation: deserializeParam(
          data['destination_location'],
          ParamType.LatLng,
          false,
        ),
        destinationAddress: deserializeParam(
          data['destination_address'],
          ParamType.String,
          false,
        ),
        userAddress: deserializeParam(
          data['user_address'],
          ParamType.String,
          false,
        ),
        userName: deserializeParam(
          data['user_name'],
          ParamType.String,
          false,
        ),
        driverName: deserializeParam(
          data['driver_name'],
          ParamType.String,
          false,
        ),
        isDriverAssigned: deserializeParam(
          data['is_driver_assigned'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'RideStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is RideStruct &&
        userLocation == other.userLocation &&
        userUid == other.userUid &&
        driverLocation == other.driverLocation &&
        driverUid == other.driverUid &&
        destinationLocation == other.destinationLocation &&
        destinationAddress == other.destinationAddress &&
        userAddress == other.userAddress &&
        userName == other.userName &&
        driverName == other.driverName &&
        isDriverAssigned == other.isDriverAssigned;
  }

  @override
  int get hashCode => const ListEquality().hash([
        userLocation,
        userUid,
        driverLocation,
        driverUid,
        destinationLocation,
        destinationAddress,
        userAddress,
        userName,
        driverName,
        isDriverAssigned
      ]);
}

RideStruct createRideStruct({
  LatLng? userLocation,
  String? userUid,
  LatLng? driverLocation,
  String? driverUid,
  LatLng? destinationLocation,
  String? destinationAddress,
  String? userAddress,
  String? userName,
  String? driverName,
  bool? isDriverAssigned,
}) =>
    RideStruct(
      userLocation: userLocation,
      userUid: userUid,
      driverLocation: driverLocation,
      driverUid: driverUid,
      destinationLocation: destinationLocation,
      destinationAddress: destinationAddress,
      userAddress: userAddress,
      userName: userName,
      driverName: driverName,
      isDriverAssigned: isDriverAssigned,
    );
