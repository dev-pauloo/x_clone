import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class FullScreenImageCarousel extends StatefulWidget {
  final List<String?>? imageLinks;
  final String? link;
  final int initialIndex; // Optional: Specify the initial image index

  const FullScreenImageCarousel({
    super.key,
    this.imageLinks,
    this.link,
    this.initialIndex = 0,
  });

  @override
  State<FullScreenImageCarousel> createState() =>
      _FullScreenImageCarouselState();
}

class _FullScreenImageCarouselState extends State<FullScreenImageCarousel> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex; // Set initial index from widget
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Fullscreen image carousel
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: CarouselSlider(
              items: widget.imageLinks!.map((imageUrl) {
                return Center(
                  child: CachedNetworkImage(
                    imageUrl: imageUrl!,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                );
              }).toList(),
              carouselController: CarouselController(),
              options: CarouselOptions(
                initialPage: _currentIndex,
                viewportFraction: 1.0,
                height: MediaQuery.of(context).size.height,
                enableInfiniteScroll: false,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
            ),
          ),

          // Close button
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // Optional: Indicator for current image (if needed)
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < widget.imageLinks!.length; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: CircleAvatar(
                      backgroundColor:
                          _currentIndex == i ? Colors.white : Colors.grey,
                      radius: 4.0,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
