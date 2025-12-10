import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_theme.dart';

class AddPlacePage extends StatefulWidget {
  const AddPlacePage({super.key});

  @override
  State<AddPlacePage> createState() => _AddPlacePageState();
}

class _AddPlacePageState extends State<AddPlacePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _ratingController = TextEditingController();
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _longController = TextEditingController();
  final TextEditingController _openingHoursController = TextEditingController();

  String _selectedCategory = 'wisata';
  File? _imageFile;
  bool _isLoading = false;
  
  DateTime? _startDate;
  DateTime? _endDate;

  final List<String> _categories = ['wisata', 'kuliner', 'event'];

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _locationController.dispose();
    _priceController.dispose();
    _ratingController.dispose();
    _latController.dispose();
    _longController.dispose();
    _openingHoursController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) setState(() => _imageFile = File(pickedFile.path));
  }

  Future<void> _selectDateTime(bool isStart) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && mounted) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          final dateTime = DateTime(
            pickedDate.year, pickedDate.month, pickedDate.day,
            pickedTime.hour, pickedTime.minute
          );
          if (isStart) {
            _startDate = dateTime;
          } else {
            _endDate = dateTime;
          }
        });
      }
    }
  }

  Future<void> _uploadAndSave() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Wajib memilih foto!')));
      return;
    }

    if (_selectedCategory == 'event') {
      if (_startDate == null || _endDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tanggal mulai dan selesai wajib diisi untuk Event!')));
        return;
      }
      if (_endDate!.isBefore(_startDate!)) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tanggal selesai tidak boleh sebelum tanggal mulai!')));
        return;
      }
    }

    setState(() => _isLoading = true);

    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageRef = FirebaseStorage.instance.ref().child('places/$fileName.jpg');
      UploadTask uploadTask = storageRef.putFile(_imageFile!);
      String imageUrl = await (await uploadTask).ref.getDownloadURL();

      double rating = double.tryParse(_ratingController.text) ?? 0.0;
      double latitude = double.tryParse(_latController.text) ?? 0.0;
      double longitude = double.tryParse(_longController.text) ?? 0.0;

      Map<String, dynamic> dataToSave = {
        'name': _nameController.text,
        'description': _descController.text,
        'category': _selectedCategory,
        'location': _locationController.text,
        'price': _priceController.text,
        'rating': rating,
        'imageUrl': imageUrl,
        'latitude': latitude,
        'longitude': longitude,
        'createdAt': FieldValue.serverTimestamp(),
      };

      if (_selectedCategory == 'event') {
        dataToSave['startDate'] = Timestamp.fromDate(_startDate!);
        dataToSave['endDate'] = Timestamp.fromDate(_endDate!);
      } else {
        dataToSave['openingHours'] = _openingHoursController.text;
      }

      await FirebaseFirestore.instance.collection('places').add(dataToSave);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Data berhasil ditambahkan!')));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Tambah Data Baru", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey[400]!),
                    image: _imageFile != null
                        ? DecorationImage(image: FileImage(_imageFile!), fit: BoxFit.cover)
                        : null,
                  ),
                  child: _imageFile == null
                      ? const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Icon(Icons.add_a_photo, size: 50, color: Colors.grey),
                          Text("Ketuk untuk upload foto", style: TextStyle(color: Colors.grey)),
                        ])
                      : null,
                ),
              ),
              const SizedBox(height: 24),
              
              _buildTextField(_nameController, "Nama"),
              const SizedBox(height: 16),
              
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: "Kategori",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category.toUpperCase()),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedCategory = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),

              if (_selectedCategory == 'event') ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue[200]!)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Waktu Event", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => _selectDateTime(true),
                              icon: const Icon(Icons.calendar_today, size: 16),
                              label: Text(_startDate == null 
                                ? "Mulai" 
                                : DateFormat('dd/MM/yy HH:mm').format(_startDate!)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Icon(Icons.arrow_forward, color: Colors.grey),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => _selectDateTime(false),
                              icon: const Icon(Icons.event_busy, size: 16),
                              label: Text(_endDate == null 
                                ? "Selesai" 
                                : DateFormat('dd/MM/yy HH:mm').format(_endDate!)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              if (_selectedCategory != 'event') ...[
                 _buildTextField(_openingHoursController, "Jam Operasional"),
                 const SizedBox(height: 16),
              ],

              _buildTextField(_descController, "Deskripsi Singkat", maxLines: 3),
              const SizedBox(height: 16),
              _buildTextField(_locationController, "Alamat"),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(child: _buildTextField(_priceController, _selectedCategory == 'event' ? "Harga Tiket" : "Harga")),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTextField(_ratingController, "Rating", keyboardType: TextInputType.number)),
                ],
              ),
              const SizedBox(height: 16),
              const Text("Koordinat Peta", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: _buildTextField(_latController, "Latitude", keyboardType: TextInputType.number)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTextField(_longController, "Longitude", keyboardType: TextInputType.number)),
                ],
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _uploadAndSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: JokkaColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Simpan Data", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (value) => value!.isEmpty ? "$label tidak boleh kosong" : null,
    );
  }
}