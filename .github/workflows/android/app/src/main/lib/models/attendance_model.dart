class AttendanceRecord {
  final String id;
  final String employeeName;
  final String employeeId;
  final DateTime timestamp;
  final String type; // Check-In / Check-Out
  final double latitude;
  final double longitude;
  final String address;
  final String status; // Tepat Waktu / Terlambat
  final String? notes;

  AttendanceRecord({
    required this.id,
    required this.employeeName,
    required this.employeeId,
    required this.timestamp,
    required this.type,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.status,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'employeeName': employeeName,
      'employeeId': employeeId,
      'timestamp': timestamp.toIso8601String(),
      'type': type,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'status': status,
      'notes': notes,
    };
  }

  factory AttendanceRecord.fromMap(Map<String, dynamic> map) {
    return AttendanceRecord(
      id: map['id'],
      employeeName: map['employeeName'],
      employeeId: map['employeeId'],
      timestamp: DateTime.parse(map['timestamp']),
      type: map['type'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      address: map['address'],
      status: map['status'],
      notes: map['notes'],
    );
  }
}
