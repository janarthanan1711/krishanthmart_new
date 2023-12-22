import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:krishanthmart_new/models/product_response_model.dart';
import 'package:krishanthmart_new/views/product_details/product_details.dart';
import '../../../utils/colors.dart';

class LargeProductCard extends StatelessWidget {
  LargeProductCard({super.key, required this.product});

  Product product;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220.h,
      width: 280.w,
      margin:  EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Container(
            height: 124.h,
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                InkWell(
                  child: Image.network(
                    product.thumbnail_image!,
                    height: 100.h,
                    width: 100.w,
                  ),
                  onTap: (){
                    Get.to(()=>ProductDetails(id: product.id,),);
                  },
                ),
                 SizedBox(
                  width: 10.w,
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        product.name!,
                        style:  TextStyle(fontSize: 16.sp),
                        maxLines: 2,overflow: TextOverflow.ellipsis,
                      ),
                       SizedBox(
                        height: 5.h,
                      ),
                      // const Row(
                      //   children: [
                      //     Text("1kg", style: TextStyle(fontSize: 16)),
                      //     SizedBox(
                      //       width: 5,
                      //     ),
                      //     Text("610.00/1kg", style: TextStyle(fontSize: 16)),
                      //   ],
                      // ),
                      Row(
                        children: [
                          Text(product.main_price!,
                              style: TextStyle(fontSize: 14.sp,color: MyTheme.accent_color)),
                           SizedBox(
                            width: 10.w,
                          ),
                          if (product.has_discount!)
                            Text(
                              product.stroked_price!,
                              style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: MyTheme.medium_grey,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 57.h,
            decoration: const BoxDecoration(
              color: MyTheme.light_purple,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
            ),
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                product.has_discount!
                    ? Container(
                        decoration:  const BoxDecoration(
                          color: MyTheme.accent_color2,
                          borderRadius:  BorderRadius.only(
                            topRight: Radius.circular(6.0),
                            bottomLeft: Radius.circular(6.0),
                            topLeft: Radius.circular(6.0),
                            bottomRight: Radius.circular(6.0),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x14000000),
                              offset: Offset(-1, 1),
                              blurRadius: 1,
                            ),
                          ],
                        ),
                        height: 50,
                        width: 60,
                        child: Center(
                          child: Text(
                            product.discount ?? "",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xffffffff),
                              fontWeight: FontWeight.w700,
                              height: 1.8,
                            ),
                            textHeightBehavior: const TextHeightBehavior(
                                applyHeightToFirstAscent: false),
                            softWrap: false,
                          ),
                        ),
                      )
                    : const SizedBox(),
                InkWell(
                  onTap: () {},
                  child: Container(
                    decoration: BoxDecoration(
                        color: MyTheme.green,
                        borderRadius: BorderRadius.circular(5)),
                    height: 25.h,
                    width: 140.w,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Add",
                          style: TextStyle(color: MyTheme.white),
                        ),
                        Icon(
                          Icons.add,
                          color: MyTheme.white,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
