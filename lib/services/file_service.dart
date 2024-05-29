// lib/services/file_service.dart

import 'dart:io';
import 'package:file_picker/file_picker.dart';

class FileService {
  // Pick an image
  Future<File?> pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null && result.files.isNotEmpty) {
      return File(result.files.single.path!);
    }

    return null;
  }

  // Pick a file
  Future<File?> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.isNotEmpty) {
      return File(result.files.single.path!);
    }

    return null;
  }
}
