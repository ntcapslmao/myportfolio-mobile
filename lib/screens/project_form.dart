import 'package:material_ui/material_ui.dart';
import 'package:myportfolio_mobile/widgets/left_drawer.dart';

class ProjectFormPage extends StatefulWidget {
  const ProjectFormPage({super.key});

  @override
  State<ProjectFormPage> createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<ProjectFormPage> {
  final _formKey = GlobalKey<FormState>();

  static const String _defaultCategory = 'Web Development';

  final _projectNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _technologiesController = TextEditingController();
  final _projectLinkController = TextEditingController();

  String _category = _defaultCategory;

  final List<String> _categories = const [
    'Web Development',
    'Mobile Development',
    'Machine Learning',
    'Data Science',
    'Other',
  ];

  @override
  void dispose() {
    _projectNameController.dispose();
    _descriptionController.dispose();
    _technologiesController.dispose();
    _projectLinkController.dispose();
    super.dispose();
  }

  bool _isValidHttpUrl(String value) {
    final uri = Uri.tryParse(value);
    return uri != null &&
        uri.hasScheme &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _projectNameController.clear();
    _descriptionController.clear();
    _technologiesController.clear();
    _projectLinkController.clear();
    setState(() {
      _category = _defaultCategory;
    });
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    final projectName = _projectNameController.text.trim();
    final description = _descriptionController.text.trim();
    final technologies = _technologiesController.text.trim();
    final projectLink = _projectLinkController.text.trim();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Proyek berhasil ditambahkan!'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nama Proyek: $projectName'),
                const SizedBox(height: 4),
                Text('Deskripsi: $description'),
                const SizedBox(height: 4),
                Text('Kategori: $_category'),
                const SizedBox(height: 4),
                Text(
                  'Teknologi: ${technologies.isEmpty ? '-' : technologies}',
                ),
                const SizedBox(height: 4),
                Text('Tautan: ${projectLink.isEmpty ? '-' : projectLink}'),
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
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tambah Proyek',
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
                controller: _projectNameController,
                maxLength: 255,
                decoration: _inputDecoration(
                  label: 'Nama Proyek',
                  hint: 'Nama Proyek',
                ),
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama proyek tidak boleh kosong!';
                  }
                  if (value.trim().length > 255) {
                    return 'Nama proyek maksimal 255 karakter!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12.0),

              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: _inputDecoration(
                  label: 'Deskripsi Proyek',
                  hint: 'Deskripsi Proyek',
                ),
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Deskripsi proyek tidak boleh kosong!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              DropdownButtonFormField<String>(
                decoration: _inputDecoration(label: 'Kategori Proyek'),
                initialValue: _category,
                items: _categories
                    .map(
                      (category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
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
                controller: _technologiesController,
                maxLength: 255,
                decoration: _inputDecoration(
                  label: 'Teknologi yang Digunakan',
                  hint: 'Contoh: Flutter, Django, Figma',
                ),
                validator: (String? value) {
                  if (value != null && value.trim().length > 255) {
                    return 'Teknologi maksimal 255 karakter!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12.0),

              TextFormField(
                controller: _projectLinkController,
                keyboardType: TextInputType.url,
                decoration: _inputDecoration(
                  label: 'Tautan Proyek',
                  hint: 'URL Proyek (opsional)',
                ),
                validator: (String? value) {
                  final trimmed = value?.trim() ?? '';
                  if (trimmed.isNotEmpty && !_isValidHttpUrl(trimmed)) {
                    return 'Masukkan URL valid (diawali http:// atau https://)!';
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
