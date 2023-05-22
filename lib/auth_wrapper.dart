import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'database/db_provider.dart';
import 'package:todotaskprovider/screens/authentication/login_screen.dart';
import 'package:todotaskprovider/screens/home/home_screen.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  Widget build(BuildContext context) {
    final token = DatabaseProvider().getToken();
      return FutureBuilder<String>(
        future: token,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            // Check if the token has expired
            final tokenExpireTime = JwtDecoder.getExpirationDate(snapshot.data!);
            final currentTime = DateTime.now();
            if (currentTime.isAfter(tokenExpireTime)) {
              // Token has expired, logout and clear token
              DatabaseProvider().logOut();
              return const LoginScreen();
              
            } else {
              // Token is valid, show HomeView
              return const HomeScreen();
              
            }
          } else {
            return const LoginScreen();
          }
        },
          );
  }
}