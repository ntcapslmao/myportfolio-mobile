import 'package:material_ui/material_ui.dart';
import 'package:myportfolio_mobile/widgets/left_drawer.dart';

/// Halaman formulir untuk menambahkan riwayat edukasi portofolio.
class EducationFormPage extends StatefulWidget {
  const EducationFormPage({super.key});

  @override
  State<EducationFormPage> createState() => _EducationFormPageState();
}

class _EducationFormPageState extends State<EducationFormPage> {
  final _formKey = GlobalKey<FormState>();

  final _institutionController = TextEditingController();
  final _degreeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _startedAtController = TextEditingController();
  final _endedAtController = TextEditingController();

  DateTime? _startedAt;
  DateTime? _endedAt;

  @override
  void dispose() {
    _institutionController.dispose();
    _degreeController.dispose();
    _descriptionController.dispose();
    _startedAtController.dispose();
    _endedAtController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  Future<void> _pickDate({required bool isStartDate}) async {
    final now = DateTime.now();
    final initialDate = isStartDate
        ? (_startedAt ?? now)
        : (_endedAt ?? _startedAt ?? now);

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
    );

    if (picked == null) return;

    setState(() {
      if (isStartDate) {
        _startedAt = picked;
        _startedAtController.text = _formatDate(picked);
      } else {
        _endedAt = picked;
        _endedAtController.text = _formatDate(picked);
      }
    });
  }

  void _clearEndDate() {
    setState(() {
      _endedAt = null;
      _endedAtController.clear();
    });
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _institutionController.clear();
    _degreeController.clear();
    _descriptionController.clear();
    _startedAtController.clear();
    _endedAtController.clear();
    setState(() {
      _startedAt = null;
      _endedAt = null;
    });
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    final institution = _institutionController.text.trim();
    final degree = _degreeController.text.trim();
    final description = _descriptionController.text.trim();
    final startedAtText = _formatDate(_startedAt!);
    final endedAtText = _endedAt != null
        ? _formatDate(_endedAt!)
        : 'Masih berlangsung (Present)';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edukasi berhasil ditambahkan!'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Institusi: $institution'),
                const SizedBox(height: 4),
                Text('Gelar/Jurusan: $degree'),
                const SizedBox(height: 4),
                Text('Deskripsi: ${description.isEmpty ? '-' : description}'),
                const SizedBox(height: 4),
                Text('Tanggal Mulai: $startedAtText'),
                const SizedBox(height: 4),
                Text('Tanggal Selesai: $endedAtText'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _resetForm();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
      suffixIcon: suffixIcon,
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tambah Edukasi',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF0C0E1A),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _institutionController,
                maxLength: 255,
                decoration: _inputDecoration(
                  label: 'Nama Institusi',
                  hint: 'Contoh: Universitas Indonesia',
                ),
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama institusi tidak boleh kosong!';
                  }
                  if (value.trim().length > 255) {
                    return 'Nama institusi maksimal 255 karakter!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12.0),

              TextFormField(
                controller: _degreeController,
                maxLength: 255,
                decoration: _inputDecoration(
                  label: 'Gelar / Jurusan',
                  hint: 'Contoh: S1 Ilmu Komputer',
                ),
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Gelar/jurusan tidak boleh kosong!';
                  }
                  if (value.trim().length > 255) {
                    return 'Gelar/jurusan maksimal 255 karakter!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12.0),

              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: _inputDecoration(
                  label: 'Deskripsi (opsional)',
                  hint: 'Jelaskan pencapaian, organisasi, atau aktivitas...',
                ),
              ),
              const SizedBox(height: 16.0),

              TextFormField(
                controller: _startedAtController,
                readOnly: true,
                decoration: _inputDecoration(
                  label: 'Tanggal Mulai',
                  hint: 'Pilih tanggal mulai (YYYY-MM-DD)',
                  suffixIcon: const Icon(Icons.calendar_today),
                ),
                onTap: () => _pickDate(isStartDate: true),
                validator: (String? value) {
                  if (_startedAt == null ||
                      value == null ||
                      value.trim().isEmpty) {
                    return 'Tanggal mulai harus dipilih!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              TextFormField(
                controller: _endedAtController,
                readOnly: true,
                decoration: _inputDecoration(
                  label: 'Tanggal Selesai (opsional)',
                  hint: 'Kosongkan jika masih berlangsung',
                  suffixIcon: _endedAt != null
                      ? IconButton(
                          tooltip: 'Hapus tanggal selesai',
                          icon: const Icon(Icons.clear),
                          onPressed: _clearEndDate,
                        )
                      : const Icon(Icons.calendar_today),
                ),
                onTap: () => _pickDate(isStartDate: false),
                validator: (String? value) {
                  if (_endedAt != null &&
                      _startedAt != null &&
                      _endedAt!.isBefore(_startedAt!)) {
                    return 'Tanggal selesai tidak boleh lebih awal dari tanggal mulai!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24.0),

              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32.0,
                      vertical: 14.0,
                    ),
                  ),
                  onPressed: _submitForm,
                  child: const Text('Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
