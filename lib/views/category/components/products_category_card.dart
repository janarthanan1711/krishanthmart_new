import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:krishanthmart_new/models/product_response_model.dart';
import '../../../utils/colors.dart';

class ProductCategoryCardLarge extends StatelessWidget {
  ProductCategoryCardLarge({super.key, required this.product});

  Product product;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 142.h,
      margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Image.network(
              product.thumbnail_image!,
              height: 110.h,
              width: 105.w,
              fit: BoxFit.fill,
            ),
            Container(
              height: 142.h,
              width: 1.h,
              color: MyTheme.medium_grey,
            ),
            SizedBox(width: 2.5.w,),
            Container(
              width: 232.w,
              padding: EdgeInsets.only(left: 5.w, right: 5.w),
              decoration: const BoxDecoration(
                color: MyTheme.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                // border: Border(left: BorderSide(color: MyTheme.medium_grey))
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 5.h,
                  ),
                  SizedBox(
                    width: 250.h,
                    child: Text(
                      product.name!,
                      style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Row(
                    children: [
                      RatingBar(
                        itemSize: 15.0,
                        ignoreGestures: true,
                        initialRating: 0,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemCount: 5,
                        ratingWidget: RatingWidget(
                          full: Icon(Icons.star, color: MyTheme.green),
                          half: Icon(Icons.star_half, color: MyTheme.green),
                          empty: const Icon(Icons.star,
                              color: Color.fromRGBO(224, 224, 225, 1)),
                        ),
                        itemPadding: const EdgeInsets.only(right: 1.0),
                        onRatingUpdate: (rating) {
                          //print(rating);
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: Text(
                          product.rating.toString(),
                          style: TextStyle(
                              color: const Color.fromRGBO(152, 152, 153, 1),
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Row(
                    children: [
                      Text(product.main_price!,
                          style: TextStyle(
                              fontSize: 12.sp, fontWeight: FontWeight.bold)),
                      SizedBox(
                        width: 15.h,
                      ),
                      if (product.has_discount!)
                        Text(
                          product.stroked_price!,
                          style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: MyTheme.medium_grey,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              decorationColor: MyTheme.green),
                        ),
                    ],
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  InkWell(
                    onTap: () {
                      // productController.getVariantData(product.id);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          // color: MyTheme.medium_grey,
                          border: Border.all(color: MyTheme.green),
                          borderRadius: BorderRadius.circular(5)),
                      height: 20.h,
                      width: 250.w,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Choose Option"),
                          Icon(Icons.arrow_drop_down_outlined)
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Container(
                          height: 30.h,
                          width: 60.w,
                          decoration: BoxDecoration(
                              color: MyTheme.green_new,
                              borderRadius: BorderRadius.circular(10)),
                          child: const Center(
                              child: Icon(
                            Icons.favorite,
                            color: MyTheme.white,
                          )),
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Container(
                          height: 30.h,
                          width: 60.w,
                          decoration: BoxDecoration(
                              color: MyTheme.green_new,
                              borderRadius: BorderRadius.circular(10)),
                          child: const Center(
                              child: Icon(
                            Icons.share,
                            color: MyTheme.white,
                          )),
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Container(
                          height: 30.h,
                          width: 60.w,
                          decoration: BoxDecoration(
                              color: MyTheme.green_new,
                              borderRadius: BorderRadius.circular(10)),
                          child: const Center(
                              child: Icon(
                            Icons.shopping_cart_rounded,
                            color: MyTheme.white,
                          )),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
