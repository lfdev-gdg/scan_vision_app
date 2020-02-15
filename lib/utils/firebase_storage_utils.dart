import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class FirebaseStorageUtils {
  static Future<String> uploadFile(
    File file,
  ) async {
    final ref = FirebaseStorage.instance.ref().child(basename(file.path));

    final uploadTask = ref.putFile(file);
    final storageTaskSnapshot = await uploadTask.onComplete;

    return await storageTaskSnapshot.ref.getDownloadURL();
  }

  static Future<void> deleteFile(
    String file,
  ) async {
    final ref =
        FirebaseStorage.instance.ref().child(basename(file).split('?')[0]);

    return await ref.delete();
  }
}
