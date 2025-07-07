import 'package:flutter/material.dart';
import 'task.dart';

class AddTaskDialog extends StatefulWidget {
  final VoidCallback onCancel;
  final void Function(Map<String, dynamic> taskData) onAdd;
  final Task? initialTask;
  final bool isEdit;
  const AddTaskDialog({
    Key? key,
    required this.onCancel,
    required this.onAdd,
    this.initialTask,
    this.isEdit = false,
  }) : super(key: key);

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descController;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String _priority = 'Rendah';
  String _label = 'Pekerjaan';
  bool _loading = false;

  final List<String> _priorities = ['Rendah', 'Sedang', 'Tinggi'];
  final List<String> _labels = ['Pekerjaan', 'Pribadi', 'Prioritas Tinggi'];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.initialTask?.title ?? '',
    );
    _descController = TextEditingController(
      text: widget.initialTask?.description ?? '',
    );
    if (widget.initialTask?.dueDate != null) {
      _selectedDate = widget.initialTask!.dueDate;
      _selectedTime = TimeOfDay.fromDateTime(widget.initialTask!.dueDate!);
    } else {
      _selectedDate = DateTime.now();
    }
    // Optionally set _priority and _label if Task has those fields in the future
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  widget.isEdit ? 'Edit Tugas' : 'Tambah Tugas Baru',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Judul Tugas',
                    hintText: 'Masukkan judul tugas',
                    border: OutlineInputBorder(),
                  ),
                  validator:
                      (v) =>
                          v == null || v.isEmpty ? 'Judul wajib diisi' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descController,
                  decoration: const InputDecoration(
                    labelText: 'Deskripsi',
                    hintText: 'Deskripsi tugas (opsional)',
                    border: OutlineInputBorder(),
                  ),
                  minLines: 1,
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Tanggal',
                    border: const OutlineInputBorder(),
                    hintText: 'dd/mm/yyyy',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  controller: TextEditingController(
                    text:
                        _selectedDate == null
                            ? ''
                            : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                  ),
                  onTap: _pickDate,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Waktu',
                    border: const OutlineInputBorder(),
                    hintText: '--:--',
                    suffixIcon: Icon(Icons.access_time),
                  ),
                  controller: TextEditingController(
                    text:
                        _selectedTime == null
                            ? ''
                            : _selectedTime!.format(context),
                  ),
                  onTap: _pickTime,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _priority,
                  items:
                      _priorities
                          .map(
                            (p) => DropdownMenuItem(value: p, child: Text(p)),
                          )
                          .toList(),
                  onChanged: (v) => setState(() => _priority = v ?? _priority),
                  decoration: const InputDecoration(
                    labelText: 'Prioritas',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _label,
                  items:
                      _labels
                          .map(
                            (l) => DropdownMenuItem(value: l, child: Text(l)),
                          )
                          .toList(),
                  onChanged: (v) => setState(() => _label = v ?? _label),
                  decoration: const InputDecoration(
                    labelText: 'Label',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _loading ? null : widget.onCancel,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Batal'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed:
                            _loading
                                ? null
                                : () {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() => _loading = true);
                                    widget.onAdd({
                                      'title': _titleController.text.trim(),
                                      'description':
                                          _descController.text.trim(),
                                      'date': _selectedDate,
                                      'time': _selectedTime,
                                      'priority': _priority,
                                      'label': _label,
                                      'id': widget.initialTask?.id,
                                      'userId': widget.initialTask?.userId,
                                      'createdAt':
                                          widget.initialTask?.createdAt,
                                      'completed':
                                          widget.initialTask?.completed,
                                    });
                                    setState(() => _loading = false);
                                  }
                                },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0A3576),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child:
                            _loading
                                ? const SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                                : Text(
                                  widget.isEdit
                                      ? 'Simpan Perubahan'
                                      : 'Tambah Tugas',
                                ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
