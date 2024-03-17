import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:routemaster/routemaster.dart';
import 'package:x_clone/features/posts/widgets/image_full_view.dart';

class CarouselImage extends StatefulWidget {
  final List<String?>? imageLinks;
  const CarouselImage({
    super.key,
    required this.imageLinks,
  });

  @override
  State<CarouselImage> createState() => _CarouselImageState();
}

class _CarouselImageState extends State<CarouselImage> {
  int _current = 0;

  final customCacheManger = CacheManager(
    Config(
      'customCacheKey',
      stalePeriod: const Duration(days: 30),
      maxNrOfCacheObjects: 100,
      fileService: HttpFileService(),
    ),
  );

  Widget _buildImage(String? link) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: CachedNetworkImage(
        cacheManager: customCacheManger,
        imageUrl: link!,
        // cacheKey: generateUniqueCacheKey(link),
        fit: BoxFit.cover,
        progressIndicatorBuilder: (context, url, downloadProgress) =>
            const CircularProgressIndicator(),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }

  void _openFullPicture() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImageCarousel(
          imageLinks: widget.imageLinks, // Pass imageUrls here
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              widget.imageLinks!.length == 1
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ...widget.imageLinks!
                                .map((link) => _buildImage(link))
                          ],
                        ),
                      ),
                    )
                  : widget.imageLinks!.length == 2
                      ? Row(
                          children: widget.imageLinks!
                              .map((link) => Expanded(
                                    child: GestureDetector(
                                      onTap: _openFullPicture,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: AspectRatio(
                                          aspectRatio: 7 / 8,
                                          child: CachedNetworkImage(
                                              imageUrl: link!,
                                              cacheManager: customCacheManger,
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                    ),
                                  ))
                              .toList(),
                        )
                      : widget.imageLinks!.length == 3
                          ? GestureDetector(
                              onTap: _openFullPicture,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    flex: 2,
                                    child: AspectRatio(
                                      aspectRatio: 7 / 8,
                                      child: CachedNetworkImage(
                                          imageUrl: widget.imageLinks![0]!,
                                          cacheManager: customCacheManger,
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      children: <Widget>[
                                        AspectRatio(
                                          aspectRatio: 6.1 / 7,
                                          child: CachedNetworkImage(
                                              imageUrl: widget.imageLinks![1]!,
                                              cacheManager: customCacheManger,
                                              fit: BoxFit.cover),
                                        ),
                                        AspectRatio(
                                          aspectRatio: 6.1 / 7,
                                          child: CachedNetworkImage(
                                              imageUrl: widget.imageLinks![2]!,
                                              cacheManager: customCacheManger,
                                              fit: BoxFit.cover),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : widget.imageLinks!.length == 4
                              ? GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 2 / 1,
                                  ),
                                  itemCount: 4,
                                  itemBuilder: (context, index) {
                                    return CachedNetworkImage(
                                        imageUrl: widget.imageLinks![index]!,
                                        cacheManager: customCacheManger,
                                        fit: BoxFit.cover);
                                  },
                                )
                              : Container()
            ],
          ),
        ],
      ),
    );
  }
}
