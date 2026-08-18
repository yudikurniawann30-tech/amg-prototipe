import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/attendance_model.dart';

class AttendanceService extends ChangeNotifier {
  // Target Koordinat Kantor AMG
  // Latitude & Longitude bisa disesuaikan nantinya
  final double officeLat = -6.2088; 
  final double officeLng = 106.8456;
  final double maxRadiusMeter = 100.0; // Maksimal radius 100 meter

  final List<AttendanceRecord> _records = [
    AttendanceRecord(
      id: 'REC-001',
      employeeName: 'Ahmad Fauzi',
      employeeId: 'AMG-011',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      type: 'Check-In',
      latitude: -6.20885,
      longitude: 106.84565,
      address: 'AMG Office Center, Jakarta',
      status: 'Tepat Waktu',
      notes: 'Hadir tepat waktu',
    ),
    AttendanceRecord(
      id: 'REC-002',
      employeeName: 'Siti Rahma',
      employeeId: 'AMG-014',
      timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 40)),
      type: 'Check-In',
      latitude: -6.20890,
      longitude: 106.84570,
      address: 'AMG Office Center, Jakarta',
      status: 'Terlambat (10 mnt)',
      notes: 'Macet di jalan',
    ),
  ];

  List<AttendanceRecord> get records => List.unmodifiable(_records);

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 + 
          c(lat1 * p) * c(lat2 * p) * 
          (1 - c((lon2 - lon1) * p))/2;
    return 12742 * asin(sqrt(a)) * 1000; // Jarak dalam satuan meter
  }

  bool isInsideOfficeRadius(double userLat, double userLng) {
    double distance = calculateDistance(officeLat, officeLng, userLat, userLng);
    return distance <= maxRadiusMeter;
  }

  void addRecord(AttendanceRecord record) {
    _records.insert(0, record);
    notifyListeners();
  }
}
