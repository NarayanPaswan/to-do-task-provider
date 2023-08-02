// ignore_for_file: unused_field

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../utils/exports.dart';
import '../database/db_provider.dart';
import '../screens/home/home_view.dart';
import '../utils/components/app_url.dart';
import '../utils/components/routers.dart';
import '../widgets/app_textform_field.dart';


// ignore: must_be_immutable
class MeasurementView extends StatefulWidget {
  String address; String taskTypeId; String fullName; String email; String phone; String dateAndTimeOfBooking;
  String? remarks; String? notes;

  MeasurementView({super.key, required this.address, required this.taskTypeId, required this.fullName, 
  required this.email, required this.phone, required this.dateAndTimeOfBooking, this.remarks, this.notes});

  @override
  State<MeasurementView> createState() => _MeasurementViewState();
}

class _MeasurementViewState extends State<MeasurementView> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _noOfRollsBoxSqftControllers = [];
  final List<TextEditingController> _noOfSurfaceControllers = [];
  final List<TextEditingController> _surfaceDetailsControllers = [];
  final List<TextEditingController> _surfaceConditionStatusControllers = [];
  final List<TextEditingController> _materialCodeControllers = [];
  final List<TextEditingController> _typeOfMaterialControllers = [];
  final List<TextEditingController> _remarksControllers = [];
  

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _addField();
    });
  }

  _addField() {
    setState(() {
      _noOfRollsBoxSqftControllers.add(TextEditingController());
      _noOfSurfaceControllers.add(TextEditingController());
      _surfaceDetailsControllers.add(TextEditingController());
      _surfaceConditionStatusControllers.add(TextEditingController());
      _materialCodeControllers.add(TextEditingController());
      _typeOfMaterialControllers.add(TextEditingController());
      _remarksControllers.add(TextEditingController());
      
    });
  }

  _removeField(i) {
    setState(() {
      _noOfRollsBoxSqftControllers.removeAt(i);
      _noOfSurfaceControllers.removeAt(i);
      _surfaceDetailsControllers.removeAt(i);
      _surfaceConditionStatusControllers.removeAt(i);
      _materialCodeControllers.removeAt(i);
      _typeOfMaterialControllers.removeAt(i);
      _remarksControllers.removeAt(i);
      
    });
  }

   bool _isLoading = false;

  void _submitForm() async {
  final token = await DatabaseProvider().getToken();

  setState(() {
    _isLoading = true;
  });

  if (_formKey.currentState!.validate()) {
    final List<Map<String, dynamic>> measurements = [];
    
    for (var i = 0; i < _noOfRollsBoxSqftControllers.length; i++) {
      measurements.add({
        "no_of_rolls_box_sqft": _noOfRollsBoxSqftControllers[i].text,
        "no_of_surface": _noOfSurfaceControllers[i].text,
        "surface_details": _surfaceDetailsControllers[i].text,
        "surface_condition_status": _surfaceConditionStatusControllers[i].text,
        "material_code": _materialCodeControllers[i].text,
        "type_of_material": _typeOfMaterialControllers[i].text,
        "remarks": _remarksControllers[i].text,
        
      });
    }
    
    final Map<String, dynamic> requestData = {
      "address": widget.address.toString(),
      "task_type_id": widget.taskTypeId.toString(),
      "client_name": widget.fullName.toString(),
      'client_email_address': widget.email.toString(),
      'client_mobile_number': widget.phone.toString(),
      'date_time': widget.dateAndTimeOfBooking.toString(),
      'remarks': widget.remarks.toString(),
      'notes': widget.notes.toString(),
      
      "measure": measurements,
    };

    try {
      final dio = Dio();
      const urlstoreServiceBooking = AppUrl.storeServiceBookingUri;
      final response = await dio.post(
        urlstoreServiceBooking,
        options: Options(
          headers: {
            'Content-Type': 'application/json', // Use application/json content type
            "Authorization": "Bearer $token",
          },
        ),
        data: requestData, // Send the data as JSON
      );

      if (response.statusCode == 200) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar( SnackBar(
          backgroundColor: AppColors.primaryColor,
          content: const Text('New booking created successfully'),
        ));

        setState(() {
          _isLoading = false;
          _noOfRollsBoxSqftControllers.clear();
          _noOfSurfaceControllers.clear();
        PageNavigator(ctx: context).nextPage(page: const HomeView());
        });
        
      } else {
        // Request failed
        setState(() {
          _isLoading = false;
        });
        if (kDebugMode) {
          print('Error submitting data: ${response.statusCode}');
        }
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text('$error'),
      ));
    }
  }
}


   @override
  void dispose() {
    for (var noOfRollsBoxSqftControllers in _noOfRollsBoxSqftControllers) {
      noOfRollsBoxSqftControllers.dispose();
    }
     for (var noOfSurfaceControllers in _noOfSurfaceControllers) {
      noOfSurfaceControllers.dispose();
    }
    //  _taskTypeIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Measurement details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    _addField();
                  },
                  child: const Icon(Icons.add_circle),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  for (int i = 0; i < _noOfRollsBoxSqftControllers.length; i++)
                    Card(
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, right: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () {
                                    _removeField(i);
                                  },
                                  child: const Icon(Icons.remove_circle),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                AppTextFormField(
                                  controller: _noOfRollsBoxSqftControllers[i],
                                  hintText: "Enter no of rolls box/sqft",
                                  keyboardType: TextInputType.name,
                                ),
                                AppTextFormField(
                                  controller: _noOfSurfaceControllers[i],
                                  hintText: "Enter no of surface",
                                  keyboardType: TextInputType.name,
                                ),
                                AppTextFormField(
                                  controller: _surfaceDetailsControllers[i],
                                  hintText: "Enter surface details",
                                  keyboardType: TextInputType.name,
                                ),
                                AppTextFormField(
                                  controller: _surfaceConditionStatusControllers[i],
                                  hintText: "Enter surface condition status",
                                  keyboardType: TextInputType.name,
                                ),
                                 AppTextFormField(
                                  controller: _materialCodeControllers[i],
                                  hintText: "Enter material_code",
                                  keyboardType: TextInputType.name,
                                ),
                                AppTextFormField(
                                  controller: _typeOfMaterialControllers[i],
                                  hintText: "Enter type of material",
                                  keyboardType: TextInputType.name,
                                ),
                                AppTextFormField(
                                  controller: _remarksControllers[i],
                                  hintText: "Enter remarks",
                                  keyboardType: TextInputType.name,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                ],
              ),
            ),
         const SizedBox(height: 10,),
          TextButton(
          onPressed: (){
            _submitForm();
          }, 
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            backgroundColor: Colors.amber,
            minimumSize: const Size.fromHeight(50),
          ),
          child: Text('Book service')
          ),
          ],
        ),
      ),
    );
  }
}
