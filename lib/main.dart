import 'package:provider/provider.dart';
import 'package:todotaskprovider/provider/student_provider.dart';
import 'package:todotaskprovider/provider/authProvider/auth_provider.dart';
import 'package:todotaskprovider/splash_screen.dart';
import 'package:todotaskprovider/utils/exports.dart';

import 'database/db_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
       ChangeNotifierProvider(create: (_)=> AuthenticationProvider()),
       ChangeNotifierProvider(create: (_)=> DatabaseProvider()),
       ChangeNotifierProvider(create: (_)=> StudentTaskProvider()),
       
      ],
      child:  MaterialApp(
          theme: ThemeData(
           appBarTheme: AppBarTheme(
            color: AppColors.primaryColor,
           ),
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor:  AppColors.primaryColor,
            ),
            primaryColor: AppColors.primaryColor
          ),
          home: const SplashScreen(),
        ),
    );
  }
}


