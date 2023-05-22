import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todotaskprovider/provider/authProvider/auth_provider.dart';
import 'package:todotaskprovider/screens/authentication/register_screen.dart';
import 'package:todotaskprovider/screens/home/home_screen.dart';
import 'package:todotaskprovider/utils/components/routers.dart';

import '../../utils/components/app_error_snackbar.dart';
import '../../utils/components/snack_message.dart';
import '../../utils/labels.dart';
import '../../utils/style/app_text_style.dart';
import '../../widgets/app_textform_field.dart';
import '../../widgets/custom_button.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
   final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final authenticationProvider = AuthenticationProvider();
  
  @override
  void dispose() {
    
    _email.dispose();
    _password.dispose();

    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
  // final authenticationProvider = Provider.of<AuthenticationProvider>(context);  
    print("Re-Build");
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Sign In",
              style: AppTextStyle.playFireBigHeading,
            ),
            const SizedBox(
              height: 25,
            ),
             AppTextFormField(
              controller: _email,
              hintText: Labels.email,
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                    return authenticationProvider.emailValidate(value!);
                  },
            ),
            const SizedBox(
              height: 15,
            ),

              Consumer<AuthenticationProvider>(
              builder: (context, auth, child) {
              return AppTextFormField(
              controller: _password,
              hintText: Labels.password,
              prefixIcon: Icons.lock_outline_rounded,
              suffixIcon: auth.obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
              suffixIconOnPressed: () {
                    auth.obscurePassword =
                        !auth.obscurePassword;
                  },
               obscureText: auth.obscurePassword,
                validator: (value) {
                    return auth.validatePassword(value!);
                  },             
              keyboardType: TextInputType.emailAddress,
            );
            }),

              
           
            
            const SizedBox(
              height: 25,
            ),
            
            Consumer<AuthenticationProvider>(
              builder: (context, auth, child) {
                     WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (auth.responseMessage != '') {
                          showMessage(
                           message: auth.responseMessage, context: context);
                          ///Clear the response message to avoid duplicate
                          auth.clear();
                        }
                      });

                return customButton(
                  text: Labels.signIn,
                  ontap: () async {
                    if (_formKey.currentState!.validate()) {
                       try {
                        await auth.login( 
                        email: _email.text.trim(), 
                        password: _password.text.trim());
                        Future.delayed(const Duration(seconds: 2), () {
                          PageNavigator(ctx: context).nextPageOnly(page: const HomeScreen());
                        });
                        } catch (e) {
                          AppErrorSnackBar(context).error(e);
                        }
                    }
                  },
               
                context: context,
                status: auth.isLoading,
            
                );
              }
            ),
            
            const SizedBox(
              height: 25,
            ),
            GestureDetector(
              onTap: (){
                   PageNavigator(ctx: context).nextPageOnly(
                    page: const RegisterScreen(),
                 );
              },
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  
                  text: Labels.dontHaveAccount,
                  style: AppTextStyle.smallTextStyle,
                  children: const[
                    TextSpan(
                      text: Labels.register,
                      style: TextStyle(fontWeight: FontWeight.bold),
                      
                    )
                  ]
                  ),
              ),
            )
          ],
        ),
      ),
    );
  }
}