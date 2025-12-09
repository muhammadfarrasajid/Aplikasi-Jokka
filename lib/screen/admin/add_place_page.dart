import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  String _selectedCategory = 'wisata';
  File? _imageFile;
  bool _isLoading = false;

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
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadAndSave() async {
    if (!_formKey.currentState!.validate()) return;
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Wajib memilih foto!')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageRef =
          FirebaseStorage.instance.ref().child('places/$fileName.jpg');
      UploadTask uploadTask = storageRef.putFile(_imageFile!);
      TaskSnapshot snapshot = await uploadTask;
      String imageUrl = await snapshot.ref.getDownloadURL();

      double rating = double.tryParse(_ratingController.text) ?? 0.0;
      double latitude = double.tryParse(_latController.text) ?? 0.0;
      double longitude = double.tryParse(_longController.text) ?? 0.0;

      await FirebaseFirestore.instance.collection('places').add({
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
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data berhasil ditambahkan!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Tambah Data Baru",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
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
                        ? DecorationImage(
                            image: FileImage(_imageFile!), fit: BoxFit.cover)
                        : null,
                  ),
                  child: _imageFile == null
                      ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_a_photo,
                                size: 50, color: Colors.grey),
                            SizedBox(height: 8),
                            Text("Ketuk untuk upload foto",
                                style: TextStyle(color: Colors.grey)),
                          ],
                        )
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
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
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
              _buildTextField(_descController, "Deskripsi Singkat", maxLines: 3),
              const SizedBox(height: 16),
              
              _buildTextField(_locationController, "Alamat"),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(_priceController, "Harga",
                        keyboardType: TextInputType.text),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(_ratingController, "Rating",
                        keyboardType: TextInputType.number),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text("Koordinat Peta (Wajib untuk Maps)",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                      child: _buildTextField(_latController, "Latitude",
                          keyboardType: TextInputType.number)),
                  const SizedBox(width: 16),
                  Expanded(
                      child: _buildTextField(_longController, "Longitude",
                          keyboardType: TextInputType.number)),
                ],
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _uploadAndSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: JokkaColors.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Simpan Data",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
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