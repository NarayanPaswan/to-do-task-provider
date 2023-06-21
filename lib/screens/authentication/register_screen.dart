import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todotaskprovider/screens/authentication/login_screen.dart';
import 'package:todotaskprovider/utils/components/routers.dart';
import '../../provider/authProvider/auth_provider.dart';
import '../../utils/components/app_error_snackbar.dart';
import '../../utils/components/snack_message.dart';
import '../../utils/labels.dart';
import '../../utils/style/app_text_style.dart';
import '../../widgets/app_textform_field.dart';
import '../../widgets/custom_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final authenticationProvider = AuthenticationProvider();
   final TextEditingController _name = TextEditingController();
   final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  
  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
                 const SizedBox(
                height: 100,
              ),
              Text(
                "Register",
                style: AppTextStyle.playFireBigHeading,
              ),
              const SizedBox(
                height: 25,
              ),
               AppTextFormField(
                controller: _name,
                hintText: Labels.name,
                prefixIcon: Icons.person,
                keyboardType: TextInputType.name,
              ),
              const SizedBox(
                height: 15,
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
                 onChanged: (newPasswordValue) {
                      auth.passwordValue = newPasswordValue;
                    },
                validator: (value) {
                    return auth.validatePassword(value!);
                  },             
              
            );
            }),

            
      
              const SizedBox(
                height: 15,
              ),
      
        
              Consumer<AuthenticationProvider>(
              builder: (context, auth, child) {
              return AppTextFormField(
              controller: _confirmPassword,
              hintText: Labels.confirmPassword,
              prefixIcon: Icons.lock_outline_rounded,
              suffixIcon: auth.obscureConfirmPassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
              suffixIconOnPressed: () {
                    auth.obscureConfirmPassword =
                        !auth.obscureConfirmPassword;
                  },
               obscureText: auth.obscureConfirmPassword,
                validator: (value) {
                    return auth.validateConfirmPassword(value!);
                  },             
             
            );
            }),
             
      
              const SizedBox(
                height: 15,
              ),
      
                AppTextFormField(
                controller: _phone,
                hintText: Labels.phone,
                prefixIcon: Icons.mobile_friendly,
                keyboardType: TextInputType.number,
              ),
              
              const SizedBox(
                height: 25,
              ),

              Consumer<AuthenticationProvider>(
              builder: (context, auth, child) {
                     WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (auth.responseMessage != '') {
                          showMessage(
                              message: auth.responseMessage, context: context);
                          auth.clear();
                        }
                      });

                return customButton(
                  text: Labels.register,
                     ontap: () async {
                    if (_formKey.currentState!.validate()) {

                        try {
                        await  auth.register(
                        name: _name.text.trim(),
                        email: _email.text.trim(), 
                        password: _password.text.trim(),
                        confirmPassword: _confirmPassword.text.trim(),
                        phone: _phone.text.trim()
                        );
                         // ignore: use_build_context_synchronously
                         PageNavigator(ctx: context).nextPageOnly(page: const LoginScreen());
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
                      page: const LoginScreen(),
                   );
                },
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    
                    text: Labels.alreadyHaveAccount,
                    style: AppTextStyle.smallTextStyle,
                    children: const[
                      TextSpan(
                        text: Labels.signIn,
                        style: TextStyle(fontWeight: FontWeight.bold),
                        
                      )
                    ]
                    ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}