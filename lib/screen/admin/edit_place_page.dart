import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/theme/app_theme.dart';

class EditPlacePage extends StatefulWidget {
  final String placeId;
  final Map<String, dynamic> currentData;

  const EditPlacePage({
    super.key, 
    required this.placeId, 
    required this.currentData
  });

  @override
  State<EditPlacePage> createState() => _EditPlacePageState();
}

class _EditPlacePageState extends State<EditPlacePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late TextEditingController _locationController;
  late TextEditingController _priceController;
  late TextEditingController _ratingController;
  late TextEditingController _latController;
  late TextEditingController _longController;

  String _selectedCategory = 'wisata';
  String? _currentImageUrl;
  File? _newImageFile;
  bool _isLoading = false;

  final List<String> _categories = ['wisata', 'kuliner', 'event'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentData['name']);
    _descController = TextEditingController(text: widget.currentData['description']);
    _locationController = TextEditingController(text: widget.currentData['location']);
    _priceController = TextEditingController(text: widget.currentData['price']);
    _ratingController = TextEditingController(text: (widget.currentData['rating'] ?? 0.0).toString());
    _latController = TextEditingController(text: (widget.currentData['latitude'] ?? 0.0).toString());
    _longController = TextEditingController(text: (widget.currentData['longitude'] ?? 0.0).toString());
    
    _selectedCategory = widget.currentData['category'] ?? 'wisata';
    _currentImageUrl = widget.currentData['imageUrl'];
  }

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
        _newImageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _updateData() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);

    try {
      String imageUrl = _currentImageUrl ?? '';

      if (_newImageFile != null) {
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference storageRef = FirebaseStorage.instance.ref().child('places/$fileName.jpg');
        UploadTask uploadTask = storageRef.putFile(_newImageFile!);
        TaskSnapshot snapshot = await uploadTask;
        imageUrl = await snapshot.ref.getDownloadURL();
      }

      double rating = double.tryParse(_ratingController.text) ?? 0.0;
      double latitude = double.tryParse(_latController.text) ?? 0.0;
      double longitude = double.tryParse(_longController.text) ?? 0.0;

      await FirebaseFirestore.instance.collection('places').doc(widget.placeId).update({
        'name': _nameController.text,
        'description': _descController.text,
        'category': _selectedCategory,
        'location': _locationController.text,
        'price': _priceController.text,
        'rating': rating,
        'imageUrl': imageUrl,
        'latitude': latitude,
        'longitude': longitude,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data berhasil diperbarui!')),
        );
        Navigator.pop(context); 
        Navigator.pop(context); 
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text("Edit Data", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
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
                    image: _newImageFile != null
                        ? DecorationImage(image: FileImage(_newImageFile!), fit: BoxFit.cover)
                        : (_currentImageUrl != null 
                            ? DecorationImage(image: NetworkImage(_currentImageUrl!), fit: BoxFit.cover)
                            : null),
                  ),
                  child: (_newImageFile == null && _currentImageUrl == null)
                      ? const Center(child: Icon(Icons.add_a_photo, size: 50, color: Colors.grey))
                      : null,
                ),
              ),
              const SizedBox(height: 8),
              const Center(child: Text("Ketuk gambar untuk mengganti foto", style: TextStyle(color: Colors.grey, fontSize: 12))),
              
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
                onChanged: (newValue) => setState(() => _selectedCategory = newValue!),
              ),
              const SizedBox(height: 16),
              _buildTextField(_descController, "Deskripsi Singkat", maxLines: 3),
              const SizedBox(height: 16),
              _buildTextField(_locationController, "Alamat"),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildTextField(_priceController, "Harga")),
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
                  onPressed: _isLoading ? null : _updateData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: JokkaColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Simpan Perubahan", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
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