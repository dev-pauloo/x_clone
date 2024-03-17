import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomImageGrid extends ConsumerStatefulWidget {
  final List<String?>? imageLinks;
  const CustomImageGrid({required this.imageLinks, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CustomImageGridState();
}

final customCacheManger = CacheManager(
  Config(
    'customCachKey',
    stalePeriod: const Duration(days: 15),
    maxNrOfCacheObjects: 100,
    fileService: HttpFileService(),
  ),
);

class _CustomImageGridState extends ConsumerState<CustomImageGrid> {
  @override
  Widget build(BuildContext context) {
    return _buildImageList(widget.imageLinks);
  }

  Widget _buildImageList(List<String?>? imageLinks) {
    if (imageLinks == null || imageLinks.isEmpty) {
      return const SizedBox(); // Handle empty image list case (optional)
    }
    final filteredLinks = imageLinks.where((link) => link != null).toList();

    return GridView.builder(
      shrinkWrap: true, // Adjust if needed
      physics: const NeverScrollableScrollPhysics(), // Disable scrolling
      itemCount: filteredLinks.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: imageLinks.length <= 2 ? 2 : 1,
        mainAxisSpacing: 10.0, // Spacing between rows
        crossAxisSpacing: 5.0, // Spacing between columns
        childAspectRatio: 1.0, // Square aspect ratio
      ),
      itemBuilder: (context, index) {
        final link = filteredLinks[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 10.0), // Adjust padding
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.zero,
              bottomRight: Radius.zero,
            ),
            child: CachedNetworkImage(
              imageUrl: link!,
              fit: BoxFit.cover,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        );
      },
    );
  }
}
