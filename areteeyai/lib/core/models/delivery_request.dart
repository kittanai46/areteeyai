import 'package:equatable/equatable.dart';

enum DeliveryStatus { searching, found, pickedUp, onWay, delivered }

class DeliveryRequest extends Equatable {
  final String id;
  final String pickupAddress;
  final String dropoffAddress;
  final double estimatedFee;
  final double distanceKm;
  final DeliveryStatus status;
  final String? driverName;
  final String? driverPhone;
  final DateTime createdAt;

  const DeliveryRequest({
    required this.id,
    required this.pickupAddress,
    required this.dropoffAddress,
    required this.estimatedFee,
    required this.distanceKm,
    required this.status,
    this.driverName,
    this.driverPhone,
    required this.createdAt,
  });

  String get statusLabel {
    switch (status) {
      case DeliveryStatus.searching:
        return 'กำลังหาคนขับ';
      case DeliveryStatus.found:
        return 'พบคนขับแล้ว';
      case DeliveryStatus.pickedUp:
        return 'รับพัสดุแล้ว';
      case DeliveryStatus.onWay:
        return 'กำลังนำส่ง';
      case DeliveryStatus.delivered:
        return 'ส่งสำเร็จ';
    }
  }

  @override
  List<Object?> get props => [id];
}
