import 'package:flutter/material.dart';
import 'package:krishanthmart_new/utils/qunatity_number_formatter.dart';

class QuantityInputField {
  static TextField show(TextEditingController controller,
      {required VoidCallback onSubmitted, bool isDisable = false}) {
    return TextField(
      controller: controller,
      textAlign: TextAlign.center,
      readOnly: isDisable,
      keyboardType: TextInputType.number,
      inputFormatters: [OnlyNumberFormatter()],
      onSubmitted: (str) {
        onSubmitted();
      },
      decoration: const InputDecoration.collapsed(
        hintText: "0",
        border: InputBorder.none,
      ),
    );
  }
}
