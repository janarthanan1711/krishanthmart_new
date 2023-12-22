import 'package:flutter/material.dart';
import 'package:krishanthmart_new/models/product_response_model.dart';
import 'large_product_card.dart';

class ProductLargeCardList extends StatelessWidget {
  const ProductLargeCardList({super.key, required this.productList, required this.onTap});

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
        return LargeProductCard(product: productList[index],);
      },
    );
  }
}