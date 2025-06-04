import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_kitap_chesmesi/features/home/presentation/cubit/images_cubit.dart';

class CustomBanner extends StatefulWidget {
  const CustomBanner({
    super.key,
  });

  @override
  State<CustomBanner> createState() => _CustomBannerState();
}

class _CustomBannerState extends State<CustomBanner> {
  int currentSlide = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImagesCubit, ImageState>(builder: (context, state) {
      if (state is ImageLoading) {
        return CircularProgressIndicator();
      } else if (state is ImageLoaded) {
        final bannerImages = state.images;
        return ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Stack(
            children: [
              CarouselSlider(
                items: bannerImages.map((bannerImages) {
                  return Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(bannerImages),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }).toList(),
                options: CarouselOptions(
                  autoPlayAnimationDuration: const Duration(seconds: 3),
                  autoPlayInterval: const Duration(
                    seconds: 5,
                  ),
                  aspectRatio: 2 / 1,
                  viewportFraction: 1,
                  initialPage: 1,
                  autoPlay: true,
                ),
              ),
              Positioned(
                bottom: 10,
                right: 10,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    // ignore: deprecated_member_use
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Text(
                    '1/${bannerImages.length}',
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        return Center(
          child: Text('no images'),
        );
      }
    });
  }
}
