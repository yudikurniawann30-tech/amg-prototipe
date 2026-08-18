import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/attendance_model.dart';
import '../services/attendance_service.dart';

class TakeAttendanceScreen extends StatefulWidget {
  final String type; // 'Check-In' atau 'Check-Out'
  const TakeAttendanceScreen({super.key, required this.type});

  @override
  State<TakeAttendanceScreen> createState() => _TakeAttendanceScreenState();
}

class _TakeAttendanceScreenState extends State<TakeAttendanceScreen> {
  bool _isLocating = true;
  bool _isInsideRadius = true;
  double _currentLat = -6.20882;
  double _currentLng = 106.84562;
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _simulateGpsCheck();
  }

  void _simulateGpsCheck() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        _isLocating = false;
        _isInsideRadius = true; // Sesuai toleransi radius kantor
      });
    }
  }

  void _submitAttendance() {
    final service = Provider.of<AttendanceService>(context, listen: false);
    final newRecord = AttendanceRecord(
      id: 'REC-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      employeeName: 'Muhammad Yudi',
      employeeId: 'AMG-007',
      timestamp: DateTime.now(),
      type: widget.type,
      latitude: _currentLat,
      longitude: _currentLng,
      address: 'AMG Central Office (Terverifikasi Radius 15m)',
      status: widget.type == 'Check-In' ? 'Tepat Waktu' : 'Selesai Tugas',
      notes: _notesController.text.isEmpty ? 'Presensi Mandiri' : _notesController.text,
    );

    service.addRecord(newRecord);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Color(0xFF10B981)),
            SizedBox(width: 10),
            Text('Presensi Berhasil!', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: Text(
          'Presensi ${widget.type} Anda berhasil tercatat dengan koordinat GPS dan foto selfie valid.',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB)),
            child: const Text('Kembali ke Menu', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        title: Text('Verifikasi ${widget.type}', style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Preview Kamera Selfie
            Container(
              height: 240,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF3B82F6), width: 2),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.face_retouching_natural, size: 76, color: Color(0xFF60A5FA)),
                      const SizedBox(height: 10),
                      const Text('Kamera Selfie Aktif', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                      const SizedBox(height: 4),
                      Text('Wajah Terdeteksi Otomatis', style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
                    ],
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text('LIVE FACE OK', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Indikator Status GPS
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Row(
                children: [
                  Icon(
                    _isInsideRadius ? Icons.verified_user : Icons.gpp_bad,
                    color: _isInsideRadius ? const Color(0xFF10B981) : Colors.red,
                    size: 30,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isInsideRadius ? 'Radius Kantor Sesuai' : 'Di Luar Jangkauan Kantor',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Jarak ke kantor: ~15 meter (Toleransi: 100m)',
                          style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Form Catatan Kegiatan
            TextField(
              controller: _notesController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Catatan Kegiatan / Laporan Singkat (Opsional)',
                labelStyle: TextStyle(color: Colors.grey.shade400),
                prefixIcon: const Icon(Icons.note_alt_outlined, color: Color(0xFF60A5FA)),
                filled: true,
                fillColor: const Color(0xFF1E293B),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFF334155)),
                ),
              ),
            ),
            const SizedBox(height: 28),

            // Tombol Kirim Presensi
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _isInsideRadius ? _submitAttendance : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 4,
                ),
                child: Text(
                  'Kirim ${widget.type} Sekarang',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
