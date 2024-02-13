// import 'dart:io';
// import 'package:firebase_storage/firebase_storage.dart';

// class StorageProvider {
//   final FirebaseStorage _firebaseStorage;

//   StorageProvider({required FirebaseStorage firebaseStorage})
//       : _firebaseStorage = firebaseStorage;

//   Future<List<String>> uploadImage(List<File> files) async {
//     List<String> imageLinks = [];
//     for (final file in files) {
//       final uploadedImage = await _firebaseStorage.
//     }
//   }
// }

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:x_clone/core/failure.dart';
import 'package:x_clone/core/providers/firebase_providers.dart';
import 'package:x_clone/core/type_defs.dart';

final storageRepositoryProvider = Provider(
  (ref) => StorageRepository(
    firebaseStorage: ref.watch(storageProvider),
  ),
);

class StorageRepository {
  final FirebaseStorage _firebaseStorage;

  StorageRepository({required FirebaseStorage firebaseStorage})
      : _firebaseStorage = firebaseStorage;

  FutureEither<String> storeFile(
      {required String path,
      required String id,
      required File? file,
      Uint8List? webFile}) async {
    try {
      final ref = _firebaseStorage.ref().child(path).child(id);
      UploadTask uploadTask;

      if (kIsWeb) {
        uploadTask = ref.putData(webFile!);
      } else {
        uploadTask = ref.putFile(file!);
      }

      final snapshot = await uploadTask;
      return right(await snapshot.ref.getDownloadURL());
    } catch (e, stackTrace) {
      return left(FailureClass(e.toString(), stackTrace));
    }
  }
}
