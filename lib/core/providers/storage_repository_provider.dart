// import 'dart:io';

// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:fpdart/fpdart.dart';
// import 'package:x_clone/core/failure.dart';
// import 'package:x_clone/core/providers/firebase_providers.dart';
// import 'package:x_clone/core/type_defs.dart';

// final storageRepositoryProvider = Provider(
//   (ref) => StorageRepository(
//     firebaseStorage: ref.watch(storageProvider),
//   ),
// );

// class StorageRepository {
//   final FirebaseStorage _firebaseStorage;

//   StorageRepository({required FirebaseStorage firebaseStorage})
//       : _firebaseStorage = firebaseStorage;

//   FutureEither<String> storeFile(
//       {required String path,
//       required String id,
//       required File? file,
//       Uint8List? webFile}) async {
//     try {
//       final ref = _firebaseStorage.ref().child(path).child(id);
//       UploadTask uploadTask;

//       if (kIsWeb) {
//         uploadTask = ref.putData(webFile!);
//       } else {
//         uploadTask = ref.putFile(file!);
//       }

//       final snapshot = await uploadTask;
//       return right(await snapshot.ref.getDownloadURL());
//     } catch (e, stackTrace) {
//       return left(FailureClass(e.toString(), stackTrace));
//     }
//   }
// }

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/core/providers/firebase_providers.dart';

final storageRepositoryProvider = Provider(
  (ref) => StorageRepository(
    firebaseStorage: ref.watch(storageProvider),
  ),
);

/**
 * The `StorageRepository` class is responsible for storing files in Firebase Storage.
 * It provides a method called `storeFiles` that takes a path and a list of files as input
 * and uploads each file to the specified path in Firebase Storage. It returns a list of
 * the download URLs of the uploaded files.
 */
class StorageRepository {
  final FirebaseStorage _firebaseStorage;

  StorageRepository({required FirebaseStorage firebaseStorage})
      : _firebaseStorage = firebaseStorage;

  /**
   * Uploads each file in the list to the specified path in Firebase Storage.
   * Returns a list of the download URLs of the uploaded files.
   *
   * @param path The path in Firebase Storage where the files will be uploaded.
   * @param files The list of files to be uploaded.
   * @return A list of the download URLs of the uploaded files.
   */
  Future<List<String>> storeFiles({
    required String path,
    required String id,
    required List<File> files,
  }) async {
    List<String> imageLinks = [];

    for (int i = 0; i < files.length; i++) {
      final file = files[i];
      try {
        final metaData = SettableMetadata(contentType: 'image/jpeg');

        // Generate a unique filename or path for each file
        final uniqueFilename =
            '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
        final ref =
            _firebaseStorage.ref().child(path).child(id).child(uniqueFilename);

        final uploadTask = ref.putFile(file, metaData);
        final snapshot = await uploadTask;
        final downloadUrl = await snapshot.ref.getDownloadURL();

        imageLinks.add(downloadUrl);
      } catch (e, stackTrace) {
        // Handle any errors that occur during file upload
        print('Error uploading file: $e, $stackTrace');
      }
    }

    return imageLinks;
  }
}
