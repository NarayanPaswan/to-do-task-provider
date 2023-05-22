import 'package:flutter/material.dart';
import '../utils/style/app_colors.dart';

Widget customButton(
    {
    VoidCallback? ontap,
    bool? status = false,
    String? text = 'Save',
    BuildContext? context}) {
  return GestureDetector(
    onTap: status == true ? null : ontap,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 48,
        margin: const EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: status == false ? AppColors.primaryColor : AppColors.grey,
            borderRadius: BorderRadius.circular(8)),
        width: MediaQuery.of(context!).size.width,
        child: Text(
          status == false ? text! : 'Please wait...',
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    ),
  );
}