import 'package:material_ui/material_ui.dart';
import 'package:myportfolio_mobile/widgets/left_drawer.dart';

/// Menyimpan controller untuk setiap item media (PortfolioItem) dalam form.
class _PortfolioItemControllers {
  final TextEditingController title = TextEditingController();
  final TextEditingController imageUrl = TextEditingController();
  final TextEditingController videoEmbedUrl = TextEditingController();

  void dispose() {
    title.dispose();
    imageUrl.dispose();
    videoEmbedUrl.dispose();
  }
}

/// Halaman form utk menambahkan creative project beserta item medianya.
class CreativeProjectFormPage extends StatefulWidget {
  const CreativeProjectFormPage({super.key});

  @override
  State<CreativeProjectFormPage> createState() =>
      _CreativeProjectFormPageState();
}

class _CreativeProjectFormPageState extends State<CreativeProjectFormPage> {
  static const int _maxPortfolioItems = 3;

  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _startedAtController = TextEditingController();
  final _endedAtController = TextEditingController();

  final List<_PortfolioItemControllers> _portfolioItems = [];

  DateTime? _startedAt;
  DateTime? _endedAt;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _startedAtController.dispose();
    _endedAtController.dispose();
    for (final item in _portfolioItems) {
      item.dispose();
    }
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

  bool _isValidImagePathOrUrl(String value) {
    return value.startsWith('/static/') || _isValidHttpUrl(value);
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

  void _addPortfolioItem() {
    if (_portfolioItems.length >= _maxPortfolioItems) return;
    setState(() {
      _portfolioItems.add(_PortfolioItemControllers());
    });
  }

  void _removePortfolioItem(int index) {
    setState(() {
      final removed = _portfolioItems.removeAt(index);
      removed.dispose();
    });
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _titleController.clear();
    _descriptionController.clear();
    _startedAtController.clear();
    _endedAtController.clear();
    setState(() {
      for (final item in _portfolioItems) {
        item.dispose();
      }
      _portfolioItems.clear();
      _startedAt = null;
      _endedAt = null;
    });
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    final startedAtText = _formatDate(_startedAt!);
    final endedAtText = _endedAt != null
        ? _formatDate(_endedAt!)
        : 'Masih berlangsung (Present)';

    final itemSummaries = _portfolioItems.asMap().entries.map((entry) {
      final idx = entry.key + 1;
      final item = entry.value;
      final itemTitle = item.title.text.trim();
      final imageUrl = item.imageUrl.text.trim();
      final videoUrl = item.videoEmbedUrl.text.trim();
      return (
        index: idx,
        title: itemTitle,
        imageUrl: imageUrl.isEmpty ? '-' : imageUrl,
        videoUrl: videoUrl.isEmpty ? '-' : videoUrl,
      );
    }).toList();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Creative project berhasil ditambahkan!'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nama Karya/Acara: $title'),
                const SizedBox(height: 4),
                Text('Deskripsi: $description'),
                const SizedBox(height: 4),
                Text('Tanggal Mulai: $startedAtText'),
                const SizedBox(height: 4),
                Text('Tanggal Selesai: $endedAtText'),
                const SizedBox(height: 8),
                Text(
                  'Item Media (${itemSummaries.length}):',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (itemSummaries.isEmpty)
                  const Text('- Tidak ada item media')
                else
                  ...itemSummaries.map(
                    (summary) => Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${summary.index}. ${summary.title}'),
                          Text('   Gambar: ${summary.imageUrl}'),
                          Text('   Video: ${summary.videoUrl}'),
                        ],
                      ),
                    ),
                  ),
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

  Widget _buildPortfolioItemCard(int index, _PortfolioItemControllers item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      elevation: 1.0,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Item Media #${index + 1}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  tooltip: 'Hapus item media',
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => _removePortfolioItem(index),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            TextFormField(
              controller: item.title,
              maxLength: 255,
              decoration: _inputDecoration(
                label: 'Judul Media (Alt Text)',
                hint: 'Contoh: Dokumentasi Hari ke-1',
              ),
              validator: (String? value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Judul item media tidak boleh kosong!';
                }
                if (value.trim().length > 255) {
                  return 'Judul item media maksimal 255 karakter!';
                }
                return null;
              },
            ),
            const SizedBox(height: 12.0),
            TextFormField(
              controller: item.imageUrl,
              maxLength: 500,
              keyboardType: TextInputType.url,
              decoration: _inputDecoration(
                label: 'URL / Path Gambar (opsional)',
                hint: 'Link Imgur atau /static/img/...',
              ),
              validator: (String? value) {
                final trimmed = value?.trim() ?? '';
                if (trimmed.length > 500) {
                  return 'URL/path gambar maksimal 500 karakter!';
                }
                if (trimmed.isNotEmpty && !_isValidImagePathOrUrl(trimmed)) {
                  return 'Gunakan URL http(s):// atau path /static/...!';
                }
                return null;
              },
            ),
            const SizedBox(height: 12.0),
            TextFormField(
              controller: item.videoEmbedUrl,
              keyboardType: TextInputType.url,
              decoration: _inputDecoration(
                label: 'URL Embed Video (opsional)',
                hint: 'Contoh: https://www.youtube.com/embed/...',
              ),
              validator: (String? value) {
                final trimmed = value?.trim() ?? '';
                if (trimmed.isNotEmpty && !_isValidHttpUrl(trimmed)) {
                  return 'Masukkan URL valid (diawali http:// atau https://)!';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tambah Creative Project',
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
                  label: 'Nama Karya / Acara',
                  hint: 'Contoh: Dokumentasi CF18',
                ),
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama karya/acara tidak boleh kosong!';
                  }
                  if (value.trim().length > 255) {
                    return 'Nama karya/acara maksimal 255 karakter!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12.0),

              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: _inputDecoration(
                  label: 'Deskripsi Acara',
                  hint: 'Ceritakan tentang karya/acara ini...',
                ),
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Deskripsi acara tidak boleh kosong!';
                  }
                  return null;
                },
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
              const SizedBox(height: 20.0),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Item Media (${_portfolioItems.length}/$_maxPortfolioItems)',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _portfolioItems.length < _maxPortfolioItems
                        ? _addPortfolioItem
                        : null,
                    icon: const Icon(Icons.add_photo_alternate_outlined),
                    label: const Text('Tambah Item'),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),

              ..._portfolioItems.asMap().entries.map(
                (entry) => _buildPortfolioItemCard(entry.key, entry.value),
              ),

              const SizedBox(height: 20.0),

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
