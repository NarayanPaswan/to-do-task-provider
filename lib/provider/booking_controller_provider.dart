import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../utils/exports.dart';
import '../database/db_provider.dart';
import '../model/task_type_model.dart';
import '../utils/components/app_url.dart';



class BookingControllerProvider extends ChangeNotifier {
  final dio = Dio();
  //setter

  bool _isLoading = false;
  String _responseMessage = '';
  //getter

  bool get isLoading => _isLoading;
  String get responseMessage => _responseMessage;

   String? validateBlankField(String value) {
 
  if (value.isEmpty) {
        return 'Data required here';
  }
 
  return null;
  } 

  String? validateMobile(String value) {
  String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
  RegExp regExp = RegExp(patttern);
  if (value.isEmpty) {
        return 'Please enter mobile number';
  }
  else if (!regExp.hasMatch(value)) {
        return 'Please enter valid mobile number';
  }
  return null;
  } 

   String? validateName(String value) {
  final RegExp nameRegExp = RegExp('[a-zA-Z]'); 
 
  if (value.isEmpty) {
        return 'Please enter name';
  }
  else if (!nameRegExp.hasMatch(value)) {
        return 'Please enter valid name';
  }
  return null;
  } 

  String? validateDateTime(String value) {
 
  if (value.isEmpty) {
        return 'Please enter booking date & time';
  }
  
  return null;
  } 

  DateTime? _selectedDate;
  DateTime? get selectedDate => _selectedDate;
  void updateSelectedDateTime(DateTime date) {
    _selectedDate = date;
    // print("new date is : $date");
    notifyListeners();
  }

   void clear() {
    _responseMessage = '';
    notifyListeners();
  }

    Future<void> newBooking({required String fullName, required String tasktypeid, String? email,String? phone, 
    BuildContext? context,
    required Function() onSuccess,
    
  }) async {
    // print(AppUrl.registrationUri);
    final token = await DatabaseProvider().getToken();
    final userId = await DatabaseProvider().getUserId();
    _isLoading = true;
    notifyListeners();
    final body = {
      'client_name': fullName,
      'task_type_id': tasktypeid,
      'client_email_address': email,
      'client_mobile_number': phone,
      'created_by_user_id': userId,
      
    };
    // print(body);

    try {
      final response = await dio.post(AppUrl.storeServiceBookingUri,
          data: body,
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          }));
      if (response.statusCode == 200) {
        _isLoading = false;
        _responseMessage = "Booking successfull! ";
        notifyListeners();
        onSuccess();
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

  
  int? get selectedTaskTypeId => _selectedTaskTypeId;
  int? _selectedTaskTypeId;  
  void setSelectedTaskTypeId(int? id) {
    _selectedTaskTypeId = id;
    //  print("select Task Type Id: $selectedTaskTypeId");
    notifyListeners();
  }

  

  Future<TaskTypeModel?> fetchTaskType() async {
    try {
      final token = await DatabaseProvider().getToken();
      const urlTaskType = AppUrl.taskTypeUri;
      final response = await dio.get(
        urlTaskType,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      return TaskTypeModel.fromJson(response.data);
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching students: $error');
      }
      return null;
      
    }
  }
  

}