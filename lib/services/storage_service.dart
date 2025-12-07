import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> uploadImage(File imageFile, String folderName) async {
    try {
      // 1. Buat nama file unik
      String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      
      // 2. Tentukan alamat tujuan di Firebase
      Reference ref = _storage.ref().child('$folderName/$fileName');
      
      // 3. Mulai proses upload
      UploadTask uploadTask = ref.putFile(imageFile);
      
      // 4. Tunggu sampai selesai
      TaskSnapshot snapshot = await uploadTask;
      
      // 5. Ambil link download-nya
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
      
    } catch (e) {
      print('Error upload gambar: $e');
      return null;
    }
  }
}