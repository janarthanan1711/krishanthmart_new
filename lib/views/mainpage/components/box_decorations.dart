import 'package:flutter/material.dart';

import '../../../utils/colors.dart';

class BoxDecorations {
  static BoxDecoration buildBoxDecoration_1({double radius =6.0}) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      color: MyTheme.white,
      boxShadow: [
        BoxShadow(
          color: MyTheme.black.withOpacity(.08),
          blurRadius: 20,
          spreadRadius: 0.0,
          offset: Offset(0.0, 10.0), // shadow direction: bottom right
        )
      ],
    );
  }

  static BoxDecoration buildCartCircularButtonDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(16.0),
      color:  Color.fromRGBO(229,241,248, 1),

    );
  }

  static BoxDecoration buildCircularButtonDecoration_1() {
    return
      BoxDecoration(
        borderRadius: BorderRadius.circular(36.0),
        color: MyTheme.white.withOpacity(.80),
        boxShadow: [
          BoxShadow(
            color: MyTheme.black.withOpacity(.08),
            blurRadius: 20,
            spreadRadius: 0.0,
            offset: const Offset(0.0, 10.0), // shadow direction: bottom right
          )
        ],
      );
  }


}

