import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:x_clone/features/posts/view/image_full_view.dart';

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

  // String generateUniqueCacheKey(String imageUrl) {
  //   final timestamp = DateTime.now().millisecondsSinceEpoch;
  //   return 'cache_key${imageUrl.hashCode}_$timestamp';
  // }

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

  void openFullPicture() {
    Routemaster.of(context).push('/image-full-view');
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            widget.imageLinks!.length == 2
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ...widget.imageLinks!.map((link) => _buildImage(link))
                        ],
                      ),
                    ),
                  )
                // ? GridView.builder(
                //     shrinkWrap: true, // Adjust if needed
                //     physics:
                //         const NeverScrollableScrollPhysics(), // Disable scrolling
                //     itemCount: widget.imageLinks!.length,
                //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                //       crossAxisCount: widget.imageLinks!.length <= 2 ? 2 : 1,
                //       mainAxisSpacing: 5.0, // Spacing between rows
                //       crossAxisSpacing: 3.0, // Spacing between columns
                //       childAspectRatio: 0.8, // Square aspect ratio
                //     ),
                //     itemBuilder: (context, index) {
                //       final link = widget.imageLinks![index];
                //       return Padding(
                //         padding:
                //             const EdgeInsets.only(top: 10.0), // Adjust padding
                //         child: ClipRRect(
                //           borderRadius: const BorderRadius.only(
                //             topLeft: Radius.circular(10),
                //             topRight: Radius.circular(10),
                //             bottomLeft: Radius.circular(10),
                //             bottomRight: Radius.circular(10),
                //           ),
                //           child: CachedNetworkImage(
                //             imageUrl: link!,
                //             cacheManager: customCacheManger,
                //             fit: BoxFit.cover,
                //             placeholder: (context, url) =>
                //                 const CircularProgressIndicator(),
                //             errorWidget: (context, url, error) =>
                //                 const Icon(Icons.error),
                //           ),
                //         ),
                //       );
                //     },
                //   )
                : GestureDetector(
                    onTap: openFullPicture,
                    child: SizedBox(
                      height: 350,
                      child: CarouselSlider(
                        items: widget.imageLinks!.map(
                          (link) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 2,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  // margin: const EdgeInsets.all(10),
                                  child: CachedNetworkImage(
                                    cacheManager: customCacheManger,
                                    imageUrl: link!,
                                    // cacheKey: generateUniqueCacheKey(link),
                                    fit: BoxFit.cover,
                                    progressIndicatorBuilder:
                                        (context, url, downloadProgress) =>
                                            const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                              ),
                            );
                          },
                        ).toList(),
                        options: CarouselOptions(
                          viewportFraction: 1,
                          height: MediaQuery.of(context).size.height / 2,
                          enableInfiniteScroll: false,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _current = index;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
            widget.imageLinks!.length > 2
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: widget.imageLinks!.asMap().entries.map((e) {
                        return Container(
                          width: 6,
                          height: 6,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black
                                .withOpacity(_current == e.key ? 0.9 : 0.4),
                          ),
                        );
                      }).toList(),
                    ),
                  )
                : const SizedBox(height: 0),
          ],
        ),
      ],
    );
  }
}
