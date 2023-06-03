import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:todotaskprovider/model/country_list_model.dart';
import '../../database/db_provider.dart';
import '../../utils/components/app_url.dart';
import '../../utils/exports.dart';
import '../model/state_model.dart';
import '../model/student_model.dart';

class StudentTaskProvider extends ChangeNotifier {
  final dio = Dio();
  //setter

  bool _isLoading = false;
  String _responseMessage = '';
  //getter

  bool get isLoading => _isLoading;
  String get responseMessage => _responseMessage;

  int? selectedCountryId;
  void setSelectedCountryId(int? id) {
    selectedCountryId = id;
     print("selectedCountryId: $selectedCountryId");
    notifyListeners();
  }
 
  DateTime? _selectedDate;
  DateTime? get selectedDate => _selectedDate;
  void updateSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  Future<void> addJob({required String fullName,String? contactNumber, String? dateOfBirth,
    String? countryId, String? stateId, File? photo, BuildContext? context,
  }) async {
    // print(AppUrl.registrationUri);
    final token = await DatabaseProvider().getToken();
    final userId = await DatabaseProvider().getUserId();
    _isLoading = true;
    notifyListeners();

    FormData formData;

    if (photo != null) {
      final bytes = await photo.readAsBytes();
      formData = FormData.fromMap({
        'photo': MultipartFile.fromBytes(bytes, filename: photo.path.split('/').last),
        'name': fullName,
        'user_id': userId,
      });
    } else {
      formData = FormData.fromMap({
        'name': fullName,
        'user_id': userId,
      });
    }
    
    // final bytes = await photo!.readAsBytes();
    // final formData = FormData.fromMap({
      
     
    //   // 'photo': MultipartFile.fromBytes(bytes, filename: photo.path.split('/').last) ,
    //   'photo': photo != null ? await MultipartFile.fromBytes(bytes, filename: photo.path.split('/').last) : null,
    //   'name': fullName,
    //   'contact_number': contactNumber,
    //   'date_of_birth': dateOfBirth,
    //   'country_id': countryId,
    //   'state_id': stateId,
    //   'user_id': userId,
    // });

   /* 
    final bytes = await photo!.readAsBytes();
    final formData = FormData.fromMap({
      'photo': MultipartFile.fromBytes(bytes, filename: photo.path.split('/').last) ,
      'name': fullName,
      'contact_number': contactNumber,
      'date_of_birth': dateOfBirth,
      'country_id': countryId,
      'state_id': stateId,
      'user_id': userId,
    });
  */
    try {
      final response = await dio.post(AppUrl.addJobUri,
          data: formData,
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
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
  
  /* don't delete this code. when we save without image upload.

  Future<void> addJob({required String fullName,String? contactNumber, String? dateOfBirth,
    String? countryId, String? stateId, BuildContext? context,
  }) async {
    // print(AppUrl.registrationUri);
    final token = await DatabaseProvider().getToken();
    final userId = await DatabaseProvider().getUserId();
    _isLoading = true;
    notifyListeners();
    final body = {
      'name': fullName,
      'contact_number': contactNumber,
      'date_of_birth': dateOfBirth,
      'country_id': countryId,
      'state_id': stateId,
      'user_id': userId,
    };
    // print(body);

    try {
      final response = await dio.post(AppUrl.addJobUri,
          data: body,
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
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
  */

  Future<void> updateJob({required int id,BuildContext? context,String? fullName,
    String? contactNumber, String? dateOfBirth, String? countryId,
  }) async {
    final urlUpdateJob = '${AppUrl.updateJobUri}?id=$id';
    final token = await DatabaseProvider().getToken();

    _isLoading = true;
    notifyListeners();
    final body = {
      'name': fullName,
      'contact_number': contactNumber,
      'date_of_birth': dateOfBirth,
      'country_id': countryId,
    };
    try {
      final response = await dio.post(urlUpdateJob,
          data: body,
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          }));
      //  print(response.data);

      if (response.statusCode == 200) {
        _isLoading = false;
        _responseMessage = "Successfully updated student";
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

  Future<void> deleteJob({required int id, BuildContext? context}) async {
    final urlDeleteJob = '${AppUrl.deleteJobUri}?id=$id';
    final token = await DatabaseProvider().getToken();

    _isLoading = true;
    notifyListeners();
    try {
      final response = await dio.delete(urlDeleteJob,
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          }));
      // print(response.data);

      if (response.statusCode == 200) {
        _isLoading = false;
        _responseMessage = "Successfully deleted!";
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

  String _name = '';
  String get name => _name;
  set name(String name) {
    _name = name;
    notifyListeners();
  }

  String? validateFullName(String value) {
    if (value.isEmpty) {
      return 'Please enter full name';
    }
    return null;
  }


  String? validatePhone(String? value) { // Update the parameter to be nullable
  if (value == null || value.isEmpty) {
    return "Please enter mobile no.";
  } else if (value.length != 10) {
    return "Please enter a 10 digit no";
  } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
    return "Please enter valid number";
  }
  return null;
}

Future<CountryListModel?> fetchCountryList() async {
    try {
      final token = await DatabaseProvider().getToken();
      const urlCountries = AppUrl.allCountriesUri;
      // print(urlCountries);

      final response = await dio.get(
        urlCountries,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      // print(response.data);
      return CountryListModel.fromJson(response.data);
    } catch (error) {
      // Handle error
      if (kDebugMode) {
        print('Error fetching students: $error');
      }
      return null;
      
    }
  }

  int? selectedStateId;
  void setSelectedStateId(int? id) {
    selectedStateId = id;
     print("selectedStateId: $selectedStateId");
    notifyListeners();
  }

List<StateData> states = [];

Future<void> fetchStatesForCountry(countryId) async {
  try {
    final token = await DatabaseProvider().getToken();
    final urlStateList = '${AppUrl.stateFromCountryUri}?country_id=$countryId';
    // print(urlStateList);

    final response = await dio.get(
      urlStateList,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );

    // print(response.data);
    final stateListModel = StateModel.fromJson(response.data);
    states = stateListModel.data ?? [];
    /*
     states.map((e){
        print(e.stateName);
    }).toList();
    */
    notifyListeners();

  } catch (error) {
    // Handle error
    if (kDebugMode) {
      print('Error fetching states: $error');
    }
  }
}


  


  void clear() {
    _responseMessage = '';
    notifyListeners();
  }
}
