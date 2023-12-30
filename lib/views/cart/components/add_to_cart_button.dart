import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/cart_controller.dart';

class AddToCartButton extends StatelessWidget {
  final int? productId;
  final bool isGreen;

  AddToCartButton({required this.productId, required this.isGreen});

  final cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25,
      width: 150,
      decoration: BoxDecoration(
        color: isGreen ? Colors.green : Colors.grey,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text("Text")
    );
  }
}
