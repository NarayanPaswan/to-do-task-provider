

import '../exports.dart';

class AppErrorSnackBar {
  final BuildContext context;
  AppErrorSnackBar(this.context);
  void error(Object e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "$e",
          style: AppTextStyle.regularHeading,
        ),
        // behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red,
      ),
    );
  }
}
