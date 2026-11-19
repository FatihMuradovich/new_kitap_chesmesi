import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:new_kitap_chesmesi/common/constants/base_url.dart';
import 'package:new_kitap_chesmesi/features/home/domain/model/banner_model.dart';
import 'package:new_kitap_chesmesi/common/widgets/shimmer_loading.dart';

class CustomBanner extends StatefulWidget {
  const CustomBanner({
    super.key,
    required this.banners,
  });
  final List<BannerModel> banners;

  @override
  State<CustomBanner> createState() => _CustomBannerState();
}

class _CustomBannerState extends State<CustomBanner> {
  int currentSlide = 0;

  @override
  Widget build(BuildContext context) {
    final bool hasMultipleBanners = widget.banners.length > 1;

    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Stack(
        children: [
          CarouselSlider.builder(
            itemCount: widget.banners.length,
            itemBuilder: (context, index, realIndex) {
              final bannerImages = widget.banners[index];
              return Container(
                color: Colors.red,
                // height: 400,
                // width: double.infinity,
                child: CachedNetworkImage(
                  imageUrl: '${BaseUrl.baseUrl}${bannerImages.image}',
                  fit: BoxFit.fitWidth,
                  // width: double.infinity,
                  // height: 400,
                  placeholder: (context, url) => const BannerShimmer(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              );
            },
            options: CarouselOptions(
              autoPlayAnimationDuration: const Duration(seconds: 3),
              autoPlayInterval: const Duration(
                seconds: 5,
              ),
              aspectRatio: 2 / 1,
              viewportFraction: 1,
              initialPage: 0,
              autoPlay:
                  hasMultipleBanners, // Sadece birden fazla banner varsa otomatik oynat
              enableInfiniteScroll:
                  hasMultipleBanners, // Tek banner varsa döngüyü kapat
              onPageChanged: (index, reason) {
                setState(() {
                  currentSlide = index;
                });
              },
            ),
          ),
          // Sayı göstergesini sadece birden fazla banner varsa göster
          if (hasMultipleBanners)
            Positioned(
              bottom: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Text(
                  '${currentSlide + 1}/${widget.banners.length}',
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
