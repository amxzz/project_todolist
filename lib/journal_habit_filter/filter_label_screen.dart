import 'package:flutter/material.dart';
import 'label_service.dart';

class FilterLabelScreen extends StatefulWidget {
  const FilterLabelScreen({Key? key}) : super(key: key);

  @override
  FilterLabelScreenState createState() => FilterLabelScreenState();
}

class FilterLabelScreenState extends State<FilterLabelScreen> {
  final _service = LabelService();
  final _controller = TextEditingController();
  bool _loading = false;
  String? _error;
  List<Map<String, dynamic>> _labels = [];
  String _selectedFilter = 'Semua';

  final List<Color> _labelColors = [
    Colors.green,
    Colors.orange,
    Colors.red,
    Colors.purple,
    Colors.blue,
    Colors.teal,
    Colors.pink,
  ];

  @override
  void initState() {
    super.initState();
    _fetchLabels();
  }

  Future<void> _fetchLabels() async {
    setState(() => _loading = true);
    try {
      final labels = await _service.fetchLabels();
      if (mounted) {
        setState(() {
          _labels = labels;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _error = 'Failed to load labels');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _addLabel() async {
    final name = _controller.text.trim();
    if (name.isEmpty) return;
    setState(() => _loading = true);
    try {
      final color = _labelColors[_labels.length % _labelColors.length];
      final success = await _service.addLabel(
        name,
        color: '#${color.value.toRadixString(16)}',
      );
      if (success) {
        _controller.clear();
        await _fetchLabels();
      } else {
        if (mounted) setState(() => _error = 'Failed to add label');
      }
    } catch (e) {
      if (mounted) setState(() => _error = 'Failed to add label');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _deleteLabel(String id) async {
    setState(() => _loading = true);
    try {
      final success = await _service.deleteLabel(id);
      if (success) {
        await _fetchLabels();
      } else {
        if (mounted) setState(() => _error = 'Failed to delete label');
      }
    } catch (e) {
      if (mounted) setState(() => _error = 'Failed to delete label');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? theme.scaffoldBackgroundColor : const Color(0xFFF7F7FB),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              _buildSection(
                context,
                title: 'Label',
                child: Column(
                  children: [
                    if (_loading && _labels.isEmpty)
                      const Center(child: CircularProgressIndicator())
                    else
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children:
                            _labels.map((label) {
                              final colorStr =
                                  label['color'] as String? ?? '#8BC34A';
                              final color = Color(
                                int.parse(colorStr.substring(1), radix: 16) +
                                    0xFF000000,
                              );
                              return Chip(
                                label: Text(label['name'] ?? ''),
                                backgroundColor: color.withOpacity(
                                  isDark ? 0.3 : 1,
                                ),
                                labelStyle: TextStyle(
                                  color: isDark ? color : Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                side:
                                    isDark
                                        ? BorderSide(color: color)
                                        : BorderSide.none,
                              );
                            }).toList(),
                      ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _showAddLabelDialog,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      child: const Text('Tambah Label Baru'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _buildSection(
                context,
                title: 'Filter Berdasarkan',
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children:
                      [
                            'Semua',
                            'Prioritas Tinggi',
                            'Deadline Hari Ini',
                            'Belum Dijadwalkan',
                          ]
                          .map(
                            (filter) => _FilterChip(
                              label: filter,
                              isSelected: _selectedFilter == filter,
                              onSelected: (val) {
                                if (val)
                                  setState(() => _selectedFilter = filter);
                              },
                            ),
                          )
                          .toList(),
                ),
              ),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    _error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required Widget child,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? theme.cardColor : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  void _showAddLabelDialog() async {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    _controller.clear();
    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: isDark ? theme.cardColor : Colors.white,
            title: Text('Tambah Label Baru', style: theme.textTheme.titleLarge),
            content: TextField(
              controller: _controller,
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
              decoration: const InputDecoration(hintText: 'Nama label'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Batal',
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _addLabel();
                  Navigator.of(context).pop();
                },
                child: const Text('Simpan'),
              ),
            ],
          ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Function(bool) onSelected;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onSelected,
      selectedColor: theme.colorScheme.primary,
      backgroundColor: isDark ? theme.cardColor : Colors.grey[200],
      labelStyle: TextStyle(
        color:
            isSelected
                ? (isDark ? Colors.black : Colors.white)
                : (isDark ? Colors.white70 : Colors.black87),
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color:
              isSelected
                  ? theme.colorScheme.primary
                  : (isDark ? Colors.white24 : Colors.grey.shade300),
          width: 1.5,
        ),
      ),
    );
  }
}
