// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';
// import 'package:todotaskprovider/model/country_list_model.dart';
// import '../../database/db_provider.dart';
// import '../../utils/components/app_url.dart';
// import '../../utils/exports.dart';
// import '../model/state_model.dart';
// import '../model/student_model.dart';

// class StudentTaskProvider extends ChangeNotifier {
//   final dio = Dio();
//   //setter

//   bool _isLoading = false;
//   String _responseMessage = '';
//   //getter

//   bool get isLoading => _isLoading;
//   String get responseMessage => _responseMessage;


//   Future<void> addJob({required String fullName,File? photo, BuildContext? context,
//   }) async {
    
//     final token = await DatabaseProvider().getToken();
//     final userId = await DatabaseProvider().getUserId();
//     _isLoading = true;
//     notifyListeners();
    
//     final bytes = await photo!.readAsBytes();

//     final formData = FormData.fromMap({
//       'photo': MultipartFile.fromBytes(bytes, filename: photo.path.split('/').last) ,
//       'name': fullName,
//       'user_id': userId,
//     });

//     try {
//       final response = await dio.post(AppUrl.addJobUri,
//           data: formData,
//           options: Options(headers: {
//             "Content-Type": "application/json",
//             "Authorization": "Bearer $token",
//           }));
   

//       if (response.statusCode == 200) {
        
//         _isLoading = false;
//         _responseMessage = "Successfully added student";
//         notifyListeners();
//       } else {
//         _isLoading = false;
//         if (response.statusCode == 401) {
//           _responseMessage = "Something went wrong";
//         } else {
//           _responseMessage = "Error: ${response.statusCode}";
//         }
//         notifyListeners();
//       }
//     } on SocketException catch (_) {
//       _isLoading = false;
//       _responseMessage = "Internet connection is not available";
//       notifyListeners();
//     } catch (e) {
//       _isLoading = false;
//       _responseMessage = 'Please try again';
//       notifyListeners();
//       if (kDebugMode) {
//         print("Your error is $e");
//       }
//     }
//   }

// }
