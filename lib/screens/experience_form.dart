import 'package:material_ui/material_ui.dart';
import 'package:myportfolio_mobile/widgets/left_drawer.dart';

/// Halaman formulir untuk menambahkan pengalaman portofolio.
class ExperienceFormPage extends StatefulWidget {
  const ExperienceFormPage({super.key});

  @override
  State<ExperienceFormPage> createState() => _ExperienceFormPageState();
}

class _ExperienceFormPageState extends State<ExperienceFormPage> {
  final _formKey = GlobalKey<FormState>();

  static const String _defaultCategory = 'full-time';

  static const Map<String, String> _categoryChoices = {
    'internship': 'Internship',
    'research': 'Research',
    'volunteer': 'Volunteer',
    'part-time': 'Part-Time',
    'full-time': 'Full-Time',
    'freelance': 'Freelance',
  };

  final _titleController = TextEditingController();
  final _organisationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _thumbnailController = TextEditingController();
  final _startedAtController = TextEditingController();
  final _endedAtController = TextEditingController();

  String _category = _defaultCategory;
  DateTime? _startedAt;
  DateTime? _endedAt;

  @override
  void dispose() {
    _titleController.dispose();
    _organisationController.dispose();
    _descriptionController.dispose();
    _thumbnailController.dispose();
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

  bool _isValidHttpUrl(String value) {
    final uri = Uri.tryParse(value);
    return uri != null &&
        uri.hasScheme &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
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
    _titleController.clear();
    _organisationController.clear();
    _descriptionController.clear();
    _thumbnailController.clear();
    _startedAtController.clear();
    _endedAtController.clear();
    setState(() {
      _category = _defaultCategory;
      _startedAt = null;
      _endedAt = null;
    });
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    final title = _titleController.text.trim();
    final rawOrg = _organisationController.text.trim();
    final organisation = rawOrg.isEmpty ? 'Personal' : rawOrg;
    final categoryDisplay = _categoryChoices[_category] ?? _category;
    final description = _descriptionController.text.trim();
    final thumbnail = _thumbnailController.text.trim();
    final startedAtText = _formatDate(_startedAt!);
    final endedAtText = _endedAt != null
        ? _formatDate(_endedAt!)
        : 'Masih berlangsung (Present)';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pengalaman berhasil ditambahkan!'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Posisi/Peran: $title'),
                const SizedBox(height: 4),
                Text('Organisasi: $organisation'),
                const SizedBox(height: 4),
                Text('Kategori: $categoryDisplay'),
                const SizedBox(height: 4),
                Text('Deskripsi: $description'),
                const SizedBox(height: 4),
                Text('Thumbnail: ${thumbnail.isEmpty ? '-' : thumbnail}'),
                const SizedBox(height: 4),
                Text('Waktu Mulai: $startedAtText'),
                const SizedBox(height: 4),
                Text('Waktu Selesai: $endedAtText'),
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
    String? hint,
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
          'Tambah Pengalaman',
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
                controller: _titleController,
                maxLength: 255,
                decoration: _inputDecoration(
                  label: 'Nama Posisi / Peran',
                  hint: 'Contoh: Staff of Documentation',
                ),
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama posisi/peran tidak boleh kosong!';
                  }
                  if (value.trim().length > 255) {
                    return 'Nama posisi/peran maksimal 255 karakter!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12.0),

              TextFormField(
                controller: _organisationController,
                maxLength: 255,
                decoration: _inputDecoration(
                  label: 'Nama Organisasi (opsional)',
                  hint: 'Contoh: BEM Fasilkom UI (default: Personal)',
                ),
                validator: (String? value) {
                  if (value != null && value.trim().length > 255) {
                    return 'Nama organisasi maksimal 255 karakter!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12.0),

              DropdownButtonFormField<String>(
                decoration: _inputDecoration(label: 'Kategori Pengalaman'),
                initialValue: _category,
                items: _categoryChoices.entries
                    .map(
                      (entry) => DropdownMenuItem(
                        value: entry.key,
                        child: Text(entry.value),
                      ),
                    )
                    .toList(),
                onChanged: (String? newValue) {
                  if (newValue == null) return;
                  setState(() {
                    _category = newValue;
                  });
                },
              ),
              const SizedBox(height: 16.0),

              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: _inputDecoration(
                  label: 'Deskripsi Pengalaman',
                  hint: 'Jelaskan peran dan kontribusi...',
                ),
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Deskripsi pengalaman tidak boleh kosong!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              TextFormField(
                controller: _thumbnailController,
                keyboardType: TextInputType.url,
                decoration: _inputDecoration(
                  label: 'URL Thumbnail (opsional)',
                  hint: 'Contoh: https://github.com/...',
                ),
                validator: (String? value) {
                  final trimmed = value?.trim() ?? '';
                  if (trimmed.isNotEmpty && !_isValidHttpUrl(trimmed)) {
                    return 'Masukkan URL valid (diawali http:// atau https://)!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              TextFormField(
                controller: _startedAtController,
                readOnly: true,
                decoration: _inputDecoration(
                  label: 'Waktu Mulai',
                  hint: 'Pilih tanggal mulai (YYYY-MM-DD)',
                  suffixIcon: const Icon(Icons.calendar_today),
                ),
                onTap: () => _pickDate(isStartDate: true),
                validator: (String? value) {
                  if (_startedAt == null ||
                      value == null ||
                      value.trim().isEmpty) {
                    return 'Waktu mulai harus dipilih!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              TextFormField(
                controller: _endedAtController,
                readOnly: true,
                decoration: _inputDecoration(
                  label: 'Waktu Selesai (opsional)',
                  hint: 'Kosongkan jika masih berlangsung',
                  suffixIcon: _endedAt != null
                      ? IconButton(
                          tooltip: 'Hapus waktu selesai',
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
                    return 'Waktu selesai tidak boleh lebih awal dari waktu mulai!';
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
