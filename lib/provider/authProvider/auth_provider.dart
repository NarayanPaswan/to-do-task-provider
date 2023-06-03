import 'dart:io';
import 'package:dio/dio.dart';
import '../../database/db_provider.dart';
import '../../utils/components/app_url.dart';
import '../../utils/exports.dart';

class AuthenticationProvider extends ChangeNotifier {
  final dio = Dio();
  //setter
  bool _isLoading = false;
  String _responseMessage = '';
  //getter
  bool get isLoading => _isLoading;
  String get responseMessage => _responseMessage;


  bool _obscurePassword =true;
  bool get obscurePassword => _obscurePassword;
  set obscurePassword(bool obscureText) {
    _obscurePassword = obscureText;
    notifyListeners();
  }

  bool _obscureConfirmPassword =true;
   bool get obscureConfirmPassword => _obscureConfirmPassword;
  set obscureConfirmPassword(bool obscureConfirmText) {
    _obscureConfirmPassword = obscureConfirmText;
    notifyListeners();
  }

   String _passwordValue ='';
  String get password => _passwordValue;
  set passwordValue(String passwordValue){
    _passwordValue = passwordValue;
    notifyListeners();
  }

  String? validateConfirmPassword(String value) {

    if(value.isEmpty){
      return 'Please enter confirm password';
    }
    else if(value != password){
      return 'Confirm password does not match.';
    }
    else{
      return null;
    }

  }

  String? validatePassword(String value) {

    if (value.isEmpty) {
      return 'Please enter password';
    } else if(value.length< 8){
      return 'Password can not be less than 8 char.';
    }
    else{
      return null;
    }

  }

    String? emailValidate(String value){
    const String format = r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
    return !RegExp(format).hasMatch(value) ? "Enter valid email" : null;
  }

 

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    required String phone,
    BuildContext? context,
  }) async {
    // print(AppUrl.registrationUri);
    _isLoading = true;
    notifyListeners();
    final body = {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': confirmPassword,
      'phone': phone,
    };
    // print(body);

    try {
      final response = await dio.post(
        AppUrl.registrationUri,
        data: body,
      );
      if (response.statusCode == 200) {
        // print(response.data);
        _isLoading = false;
        _responseMessage = "Account created!";
        notifyListeners();
        
        
      } else {
        _isLoading = false;
        if (response.statusCode == 401) {
          _responseMessage = "Invalid username or password";
        } else {
          _responseMessage = "Error: ${response.statusCode}";
        }
        notifyListeners();
      }
    } on SocketException catch (_) {
      _isLoading = false;
      _responseMessage = "Internet connection is not available";
      notifyListeners();
    } catch (e) {
      _isLoading = false;
       notifyListeners();
    
      if (e is DioError) {
      final errorResponse = e.response?.data;
      if (errorResponse != null && errorResponse['name'] != null) {
        throw _responseMessage = errorResponse['name'][0];
        

      }else if (errorResponse != null && errorResponse['email'] != null) {
        throw _responseMessage = errorResponse['email'][0];
        // throw Exception(_responseMessage);
      }
      else if (errorResponse != null && errorResponse['password'] != null) {
        throw _responseMessage = errorResponse['password'][0];
       
      }
      else if (errorResponse != null && errorResponse['phone'] != null) {
        throw _responseMessage = errorResponse['phone'][0];
        
      }
      
      else if (errorResponse != null && errorResponse['error'] != null) {
        throw Exception(errorResponse['error']);
      }
     
    }
    throw Exception('Register failed');
   
    
    }
  }

  Future<void> login({
    required String email,
    required String password,
    BuildContext? context,
  }) async {
    // print(AppUrl.loginUri);
    _isLoading = true;
    notifyListeners();
    final body = {'email': email, 'password': password};
    // print(body);

    try {
      final response = await dio.post(
        AppUrl.loginUri,
        data: body,
      );

      if (response.statusCode == 200) {
        // print(response.data);
        _isLoading = false;
        _responseMessage = "Login successful!";
        notifyListeners();
        //save in sharedprefrences
        final userId = response.data['user']['id'].toString();
        final token = response.data['token'];
        // print("Your user id is : $userId");
        // print("Your token is : $token");
        DatabaseProvider().saveToken(token);
        DatabaseProvider().saveUserId(userId);
           

      } else {
        _isLoading = false;
        if (response.statusCode == 401) {
          _responseMessage = "Invalid username or password";
        } else {
          _responseMessage = "Error: ${response.statusCode}";
        }
        notifyListeners();
      }
    } on SocketException catch (_) {
      _isLoading = false;
      _responseMessage = "Internet connection is not available";
      notifyListeners();
    } catch (e) {
       _isLoading = false;
       notifyListeners();
   
      if (e is DioError) {
      final errorResponse = e.response?.data;
      if (errorResponse != null && errorResponse['email'] != null) {
        throw _responseMessage = errorResponse['email'][0];
        // throw Exception(_responseMessage);
      }
      else if (errorResponse != null && errorResponse['password'] != null) {
        throw _responseMessage = errorResponse['password'][0];
       
      }
      else if (errorResponse != null && errorResponse['error'] != null) {
        throw Exception(errorResponse['error']);
      }
     
    }
    throw Exception('Register failed');
    }
  }
  
  

  void clear() {
    _responseMessage = '';
    notifyListeners();
  }
}
