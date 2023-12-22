import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:krishanthmart_new/utils/colors.dart';
import 'package:krishanthmart_new/views/home/components/product_card.dart';

import '../../../models/product_response_model.dart';
import '../../../utils/device_info.dart';
class ProductCardList extends StatelessWidget {
  const ProductCardList({super.key, required this.productList, required this.onTap});

  final List<Product> productList;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    if (productList == null || productList.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: productList.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
            child: ProductCard(product: productList[index],onTap: onTap,));
      },
    );
  }
}
