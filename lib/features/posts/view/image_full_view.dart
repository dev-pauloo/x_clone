import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ImageFullView extends ConsumerWidget {
  final List<String?>? imageUrl;
  const ImageFullView({required this.imageUrl, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Hero(
          tag: imageUrl!,
          child: InteractiveViewer(
            child: CachedNetworkImage(
              imageUrl: imageUrl.toString(),
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
