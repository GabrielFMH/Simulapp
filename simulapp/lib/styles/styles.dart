import 'package:flutter/material.dart';

import 'colors.dart';
import 'sizes.dart';

class AppStyles {
  static const TextStyle kForgotPassStyle = TextStyle(
    fontSize: 14,
    color: MyColors.blue,
    fontWeight: FontWeight.w600,
  );

  static final ButtonStyle kCustomButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: MyColors.blue,
    padding: Sizes.kPadding,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Sizes.kRadius),
    ),
  );
}
