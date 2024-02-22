import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:krishanthmart_new/controllers/home_controller.dart';
import '../../../utils/colors.dart';

class CustomCarousel extends StatelessWidget {
  const CustomCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (homeControllers) {
      return Stack(
        children: [
          CarouselSlider.builder(
            itemCount: homeControllers.carouselImageList.length,
            itemBuilder: (context, index, realIndex) {
              final imageUrl = homeControllers.carouselImageList[index];
              if (homeControllers.carouselImageList.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Image.network(imageUrl, fit: BoxFit.fill);
              }
            },
            options: CarouselOptions(
              height: 180.h,
              autoPlay: true,
              viewportFraction: 1,
              enlargeCenterPage: false,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              onPageChanged: (index, reason) {
                homeControllers.currentPage.value = index;
              },
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(left: 16.h,right: 16.h,bottom: 16.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  homeControllers.carouselImageList.length,
                  (index) => Obx(
                    () {
                      return Container(
                        width: 8.0,
                        height: 8.0,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: homeControllers.currentPage.value == index
                              ? MyTheme.green
                              : MyTheme.medium_grey,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
