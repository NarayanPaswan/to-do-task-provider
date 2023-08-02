import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../dealer_booking/installation_view.dart';
import '../../dealer_booking/measurement_view.dart';
import '../../google_map_address/add_address_view.dart';
import '../../model/task_type_model.dart';
import '../../provider/authProvider/auth_provider.dart';
import '../../provider/booking_controller_provider.dart';
import '../../utils/assets_path.dart';
import '../../utils/components/app_error_snackbar.dart';
import '../../utils/components/routers.dart';
import '../../utils/components/snack_message.dart';
import '../../utils/exports.dart';
import '../../widgets/app_textform_field.dart';
import '../../widgets/custom_button.dart';


class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _formKey = GlobalKey<FormState>();
  final authenticationProvider = AuthenticationProvider();
  final bookingControllerProvider = BookingControllerProvider();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _taskTypeId = TextEditingController();
  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _dateAndTimeOfBooking = TextEditingController();
  final TextEditingController _remarks = TextEditingController();
  final TextEditingController _notes = TextEditingController();
  

  @override
  void dispose() {
    super.dispose();
     _address.dispose();
    _fullName.dispose();
    _email.dispose();
    _phone.dispose();
    _dateAndTimeOfBooking.dispose();
    _remarks.dispose();
    _notes.dispose();
    _taskTypeId.dispose();
    
  }

  Future<Position?> getCurrentLocation() async {
     LocationPermission permission = await Geolocator.requestPermission();
     if (permission == LocationPermission.denied) {
      return null;
     }else if(permission == LocationPermission.deniedForever){
      return null;
     }
      return await Geolocator.getCurrentPosition();
   }

    Future<String?> getLatitudeValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('latitude');
  }

  Future<String?> getLongitudeValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('longitude');
  }


  @override
  Widget build(BuildContext context) {
    final bookingProviderVisible =
        Provider.of<BookingControllerProvider>(context);

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          'New service',
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'search address',
                    filled: true,
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        width: 1.0,
                        color: Colors.black,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        width: 1.0,
                        color: AppColors.dropdownBorderColor,
                      ),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    suffixIcon: InkWell(
                    onTap: () async {

                       String? latitude = await getLatitudeValue();
                      String? longitude = await getLongitudeValue();
                     
                    if (latitude == null || longitude == null) {
                      print("Latitude or Longitude is null");

                    Position? position = await getCurrentLocation();
                    if (position != null) {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setString('latitude', position.latitude.toString());
                      prefs.setString('longitude', position.longitude.toString());

                      latitude = position.latitude.toString();
                      longitude = position.longitude.toString();

                      // ignore: use_build_context_synchronously
                      String? selectedAddress = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddAddressView(
                            latitudeValue: latitude.toString(),
                            longitudeValue: longitude.toString(),
                            onAddressSelected: (address) {
                              setState(() {
                                _address.text = address; // Set the address to the _address controller
                              });
                            },
                          ),
                        ),
                      );

                      if (selectedAddress != null) {
                        setState(() {
                          _address.text = selectedAddress; // Set the address to the _address controller
                        });
                      }

                       print("new saved Latitude: $latitude");
                      print("new saved Longitude: $longitude");

                    }
                  
                    }  else {
                       // ignore: use_build_context_synchronously
                       String? selectedAddress = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddAddressView(
                            latitudeValue: latitude.toString(),
                            longitudeValue: longitude.toString(),
                            onAddressSelected: (address) {
                              setState(() {
                                _address.text = address; // Set the address to the _address controller
                              });
                            },
                          ),
                        ),
                      );

                      if (selectedAddress != null) {
                        setState(() {
                          _address.text = selectedAddress; // Set the address to the _address controller
                        });
                      }
    
                    }
                    
                     
                    },
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        width: 25,
                        decoration: const BoxDecoration(
                          borderRadius:
                              BorderRadius.all(Radius.circular(5)),
                          
                        ),
                        child:  Center(
                          child: Image.asset(
                            AssetsPath.iconsPath,
                            width: 48.0,
                            height: 38.0,
                            fit: BoxFit.cover,
                          ),
                        
                        ),
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.name,
                  controller: _address,
                  validator: (value) {
                    return bookingControllerProvider.validateBlankField(value!);
                  },
                ),
                const SizedBox(
                  height: 5,
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('service type')),
                ),
                Form(
                  child: Consumer<BookingControllerProvider>(
                      builder: (context, bookingProvider, _) {
                    return FutureBuilder<TaskTypeModel?>(
                      future: bookingProvider.fetchTaskType(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData) {
                          return const Text('No data available');
                        } else {
                          final taskTypeList = snapshot.data!.items;

                          if (bookingProviderVisible.selectedTaskTypeId ==
                              null) {
                            return Container(
                              height: 56,
                              padding: const EdgeInsets.only(left: 6, right: 6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors
                                      .red, // Set the border color to red to highlight the error
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: DropdownButton<int>(
                                hint: const Text("Select Service Type: "),
                                isExpanded: true,
                                underline: const SizedBox(),
                                value: bookingProvider.selectedTaskTypeId,
                                items: taskTypeList!.map((taskType) {
                                  return DropdownMenuItem<int>(
                                    value: taskType.id,
                                    child: Text(taskType.taskName ?? ''),
                                  );
                                }).toList(),
                                onChanged: (newTaskTypeId) async {
                                  bookingProvider
                                      .setSelectedTaskTypeId(newTaskTypeId);
                                  _taskTypeId.text = newTaskTypeId.toString();
                                },
                              ),
                            );
                          } else {
                            return Container(
                              height: 56,
                              padding: const EdgeInsets.only(left: 6, right: 6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    color: AppColors.dropdownBorderColor,
                                    width: 1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: DropdownButton<int>(
                                hint: const Text("Select Service Type: "),
                                isExpanded: true,
                                underline: const SizedBox(),
                                value: bookingProvider.selectedTaskTypeId,
                                items: taskTypeList!.map((taskType) {
                                  return DropdownMenuItem<int>(
                                    value: taskType.id,
                                    child: Text(taskType.taskName ?? ''),
                                  );
                                }).toList(),
                                onChanged: (newTaskTypeId) async {
                                  bookingProvider
                                      .setSelectedTaskTypeId(newTaskTypeId);
                                  _taskTypeId.text = newTaskTypeId.toString();
                                },
                              ),
                            );
                          }
                        }
                      },
                    );
                  }),
                ),
                const SizedBox(
                  height: 5,
                ),
                AppTextFormField(
                  controller: _fullName,
                  hintText: 'full name',
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    return bookingControllerProvider.validateName(value!);
                  },
                ),
                const SizedBox(
                  height: 5,
                ),
                AppTextFormField(
                  controller: _email,
                  hintText: 'email',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    return authenticationProvider.emailValidate(value!);
                  },
                ),
                const SizedBox(
                  height: 5,
                ),
                AppTextFormField(
                  controller: _phone,
                  hintText: 'mobile no',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    return bookingControllerProvider.validateMobile(value!);
                  },
                ),
                const SizedBox(
                  height: 5,
                ),
                AppTextFormField(
                  readOnly: true,
                  controller: _dateAndTimeOfBooking,
                  suffixIcon: Icons.calendar_today_rounded,
                  hintText: 'DD/MM/YYYY',
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2030),
                    );

                    if (pickedDate != null) {
                      // ignore: use_build_context_synchronously
                      TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );

                      if (pickedTime != null) {
                        DateTime selectedDateTime = DateTime(
                          pickedDate.year,
                          pickedDate.month,
                          pickedDate.day,
                          pickedTime.hour,
                          pickedTime.minute,
                        );

                        bookingControllerProvider
                            .updateSelectedDateTime(selectedDateTime);
                        _dateAndTimeOfBooking.text =
                            DateFormat('dd/MM/yyyy HH:mm')
                                .format(selectedDateTime);
                      }
                    }
                  },
                  validator: (value) {
                    return bookingControllerProvider.validateDateTime(value!);
                  },
                ),
                const SizedBox(
                  height: 5,
                ),
                AppTextFormField(
                  controller: _remarks,
                  hintText: 'remarks',
                  keyboardType: TextInputType.multiline,
                  
                ),
                const SizedBox(
                  height: 5,
                ),
                AppTextFormField(
                  
                  controller: _notes,
                  hintText: 'notes',
                  keyboardType: TextInputType.multiline,
                  
                ),
                const SizedBox(
                  height: 5,
                ),
                Consumer<BookingControllerProvider>(
                    builder: (context, book, child) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (book.responseMessage != '') {
                      showMessage(
                          message: book.responseMessage, context: context);
                      book.clear();
                    }
                  });

                  return customButton(
                    text: 'Next',
                    ontap: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          if (bookingProviderVisible.selectedTaskTypeId == 1) {
                            await PageNavigator(ctx: context).nextPage(
                                page: MeasurementView(
                              address: _address.text.trim(),
                              fullName: _fullName.text.trim(),
                              taskTypeId: _taskTypeId.text.trim(),
                              email: _email.text.trim(),
                              phone: _phone.text.trim(),
                              dateAndTimeOfBooking: _dateAndTimeOfBooking.text,
                              remarks: _remarks.text.trim(),
                              notes: _notes.text.trim(),
                            ));
                          } else if (bookingProviderVisible
                                  .selectedTaskTypeId ==
                              2) {
                            await PageNavigator(ctx: context).nextPage(
                                page: InstallationView(
                              address: _address.text.trim(),
                              fullName: _fullName.text.trim(),
                              taskTypeId: _taskTypeId.text.trim(),
                              email: _email.text.trim(),
                              phone: _phone.text.trim(),
                              dateAndTimeOfBooking: _dateAndTimeOfBooking.text,
                              remarks: _remarks.text.trim(),
                              notes: _notes.text.trim(),
                            ));
                          }
                        } catch (e) {
                          AppErrorSnackBar(context).error(e);
                        }
                      }
                    },
                    context: context,
                    status: book.isLoading,
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
