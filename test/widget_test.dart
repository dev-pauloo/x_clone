// Successfully store multiple files
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:x_clone/core/providers/firebase_providers.dart';
import 'package:x_clone/core/providers/storage_repository_provider.dart';

void main() {
  test('Successfully store multiple files', () async {
    // Arrange
    final firebaseStorage = FirebaseStorage.instance;
    final storageRepository =
        StorageRepository(firebaseStorage: firebaseStorage);
    final files = [
      File('path/to/file1.jpg'),
      File('path/to/file2.jpg'),
      File('path/to/file3.jpg'),
    ];
    final path = 'images';

    // Act
    final result = await storageRepository.storeFiles(path: path, files: files);

    // Assert
    expect(result.length, 3);
    for (final link in result) {
      expect(link, isA<String>());
    }
  });
}
