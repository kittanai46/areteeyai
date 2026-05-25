import 'package:flutter/foundation.dart';
import '../../../core/models/delivery_request.dart';
import 'package:uuid/uuid.dart';

class DeliveryViewModel extends ChangeNotifier {
  final _uuid = const Uuid();

  String _pickupAddress = '';
  String _dropoffAddress = '';
  DeliveryRequest? _activeRequest;
  bool _isLoading = false;
  String? _errorMessage;

  String get pickupAddress => _pickupAddress;
  String get dropoffAddress => _dropoffAddress;
  DeliveryRequest? get activeRequest => _activeRequest;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  bool get canRequest =>
      _pickupAddress.trim().isNotEmpty && _dropoffAddress.trim().isNotEmpty;

  void updatePickupAddress(String address) {
    _pickupAddress = address;
    notifyListeners();
  }

  void updateDropoffAddress(String address) {
    _dropoffAddress = address;
    notifyListeners();
  }

  Future<void> requestDelivery() async {
    if (!canRequest) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));

      _activeRequest = DeliveryRequest(
        id: _uuid.v4(),
        pickupAddress: _pickupAddress,
        dropoffAddress: _dropoffAddress,
        estimatedFee: 50.0,
        distanceKm: 5.0,
        status: DeliveryStatus.searching,
        createdAt: DateTime.now(),
      );
    } catch (e) {
      _errorMessage = 'ส่งคำขอไม่สำเร็จ กรุณาลองใหม่';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void cancelRequest() {
    _activeRequest = null;
    _pickupAddress = '';
    _dropoffAddress = '';
    notifyListeners();
  }
}
