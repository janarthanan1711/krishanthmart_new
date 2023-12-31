import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'colors.dart';

class ChooseOptionButton extends StatelessWidget {
  const ChooseOptionButton({super.key, this.onTap, this.height, this.width, this.bgColor, this.iconColor});
  final onTap;
  final height;
  final width;
  final bgColor;
  final iconColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: MyTheme.green),
        ),
        height: height,
        width: width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context)!.choose_option,
              style: const TextStyle(color: MyTheme.font_grey),
            ),
            Icon(
              Icons.arrow_drop_down_outlined,
              color: iconColor,
            )
          ],
        ),
      ),
    );
  }
}
