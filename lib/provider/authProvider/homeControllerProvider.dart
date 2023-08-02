// ignore_for_file: file_names

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../database/db_provider.dart';
import '../../model/service_booking_field.dart';
import '../../model/task_type_model.dart';
import '../../utils/components/app_url.dart';
import '../../utils/exports.dart';



class HomeControllerProvider extends ChangeNotifier {
  final dio = Dio();
    //setter
  final bool _isLoading = false;
  String _responseMessage = '';
  //getter
  bool get isLoading => _isLoading;
  String get responseMessage => _responseMessage;

  void clear() {
    _responseMessage = '';
    notifyListeners();
  }
  
  Future<ServiceBookingFieldModel?> allServiceBookingFields() async {
    final token = await DatabaseProvider().getToken();
    try {
      const urlAllBookingFieldsUri = AppUrl.allBookingFieldsUri;
      final response = await dio.get(
        urlAllBookingFieldsUri,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            "Authorization": "Bearer $token",
          },
        ),
      );
      
      return ServiceBookingFieldModel.fromJson(response.data);
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching on boarding: $error');
      }
      return null;
      
    }
  }

  int? _selectedTaskTypeId;
   int? get selectedTaskTypeId => _selectedTaskTypeId;
  void setSelectedTaskTypeId(int? id) {
    _selectedTaskTypeId = id;
    //  print("selectedUserTypeId: $_selectedTaskTypeId");
    notifyListeners();
  }
  void clearSelectedTaskTypeId() {
    _selectedTaskTypeId = null;
    notifyListeners();
  }


  Future<TaskTypeModel?> fetchTasktype() async {
    
    final token = await DatabaseProvider().getToken();

    try {
      
      const urlTaskType = AppUrl.taskTypeUri;
      final response = await dio.get(
        urlTaskType,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            "Authorization": "Bearer $token",
            
          },
        ),
      );
      return TaskTypeModel.fromJson(response.data);
    } catch (error) {
      // Handle error
      if (kDebugMode) {
        print('Error fetching user type: $error');
      }
      return null;
      
    }
  }


}