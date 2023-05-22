import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../database/db_provider.dart';
import '../../utils/components/app_url.dart';
import '../../utils/exports.dart';
import '../model/student_model.dart';

class StudentTaskProvider extends ChangeNotifier {
  final dio = Dio();
  //setter
  
  bool _isLoading = false;
  String _responseMessage = '';
  //getter
  
  bool get isLoading => _isLoading;
  String get responseMessage => _responseMessage;

  Future<void> addTask({
    required String fullName,
    BuildContext? context,
  }) async {
    // print(AppUrl.registrationUri);
    final token = await DatabaseProvider().getToken();
    final userId = await DatabaseProvider().getUserId();
    _isLoading = true;
    notifyListeners();
    final body = {
      'name': fullName,
      'user_id': userId,
    };
    // print(body);

    try {
      final response = await dio.post(
        AppUrl.addJobUri,
        // data: body,
          data: body,
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization":"Bearer $token",
          }));
      //  print(response.data);
      
      if (response.statusCode == 200) {
        // print(response.data);
        _isLoading = false;
        _responseMessage = "Successfully added student";
        notifyListeners();
        
        
      } else {
        _isLoading = false;
        if (response.statusCode == 401) {
          _responseMessage = "Something went wrong";
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
      _responseMessage = 'Please try again';
      notifyListeners();
      if (kDebugMode) {
        print("Your error is $e");
      }
    }
  }

   Future<List<StudentData>> getAllStudents(int pageNo) async {
    try {
      final token = await DatabaseProvider().getToken();
      final url = '${AppUrl.allJobsUri}?page=$pageNo';
      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      final studentsModel = StudentsModel.fromJson(response.data);
      return studentsModel.data?.data ?? [];
    } catch (error) {
      // Handle error
      if (kDebugMode) {
        print('Error fetching students: $error');
      }
      return [];
    }
  }

  String _name='';
  String get name => _name;
  set name(String name){
    _name = name;
    notifyListeners();  
  }

    String? validateFullName(String value) {

    if (value.isEmpty) {
      return 'Please enter full name';
    }
    return null;

  }

  


    void clear() {
    _responseMessage = '';
    notifyListeners();
  }
  
}
