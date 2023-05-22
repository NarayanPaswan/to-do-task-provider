import 'package:flutter/material.dart';
import 'package:todotaskprovider/utils/style/app_colors.dart';




void showMessage({String? message, BuildContext? context}) {
  ScaffoldMessenger.of(context!).showSnackBar(SnackBar(
      content: Text(
        message!,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: AppColors.primaryColor));
}
