import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../model/country_list_model.dart';
import '../../provider/student_provider.dart';
import '../../utils/components/routers.dart';
import '../../utils/components/snack_message.dart';
import '../../utils/exports.dart';
import '../../utils/labels.dart';
import '../../widgets/app_textform_field.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import '../home/home_screen.dart';

// ignore: must_be_immutable
class UpdateStudentScreen extends StatefulWidget {
  int id;
  String? studenName;
  String? contactNumber;
  String? dateOfBirth;
  String? countryId;
  String? stateId;
  String? photo;

  UpdateStudentScreen({
    super.key,
    required this.id,
    this.studenName,
    this.contactNumber,
    this.dateOfBirth,
    this.countryId,
    this.stateId,
    this.photo,
  });

  @override
  State<UpdateStudentScreen> createState() => _UpdateStudentScreenState();
}

class _UpdateStudentScreenState extends State<UpdateStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _contactNumberController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  final _countryIdController = TextEditingController();
  final _stateIdController = TextEditingController();

  final studentTaskProvider = StudentTaskProvider();
  File? _imageFile;
  final _picker = ImagePicker();

   Future getImage()async{
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if(pickedFile != null){
      setState(() {
        _imageFile = File(pickedFile.path);
        // print('your image path is: $_imageFile');
      });
    }
  }

  @override
  void initState(){
    super.initState();
    // print("Your state id is: ${widget.stateId}");
    // print("Your Country id is: ${widget.countryId}");
    print("Your phot link is ${widget.photo}");
    studentTaskProvider.fetchStatesForCountry(widget.countryId);
    setState(() {
      _fullNameController.text = widget.studenName.toString();
      _contactNumberController.text = widget.contactNumber ?? '';
      _dateOfBirthController.text = widget.dateOfBirth ?? '';
      _countryIdController.text=widget.countryId ?? '';
      _stateIdController.text=widget.stateId ?? '';
      
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _contactNumberController.dispose();
    _dateOfBirthController.dispose();
    _countryIdController.dispose();
    _stateIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print("Rebuild widget");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Task"),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 200.0,
                width: 200.0,
                child: Image.network(widget.photo.toString()),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Container(
              //     width: MediaQuery.of(context).size.width,
              //     height: 100,
              //     decoration: BoxDecoration(
              //      image: widget.photo != null 
              //        ? DecorationImage(
              //         image: FileImage(File(widget.photo!)),
              //         )
              //       : null,
              //       // image: _imageFile == null ? null : DecorationImage(
              //       //   image: FileImage(_imageFile ?? File('')),
              //       //   )
              //     ),
              //     child: Center(
              //       child: IconButton(
              //         onPressed: (){
              //           getImage();
              //         }, 
              //         icon: const Icon(Icons.image, size: 50, color: Colors.black,)),
              //     ),
              
              //   ),
              // ),

              CustomTextField(
                controller: _fullNameController,
                hintText: 'Full Name',
                onChanged: (newName) {
                  studentTaskProvider.name = newName;
                },
                validator: (value) {
                  return studentTaskProvider.validateFullName(value!);
                },
              ),
              AppTextFormField(
                controller: _contactNumberController,
                hintText: Labels.phone,
                prefixIcon: Icons.mobile_friendly,
                keyboardType: TextInputType.number,
                maxLength: 10,
                validator: studentTaskProvider.validatePhone,
              ),
              AppTextFormField(
                readOnly: true,
                controller: _dateOfBirthController,
                suffixIcon: Icons.calendar_today_rounded,
                hintText: 'Select date of birth:',
                onTap: () async {
                  DateTime? pickDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1950),
                      lastDate: DateTime.now());
                  if (pickDate != null) {
                    studentTaskProvider.updateSelectedDate(pickDate);
                    _dateOfBirthController.text = DateFormat('yyyy-MM-dd').format(pickDate);
                  }
                },
              ),
              
              Consumer<StudentTaskProvider>(
                builder: (context, studentTaskProvider1, _) {
                  return FutureBuilder<CountryListModel?>(
                  future: studentTaskProvider.fetchCountryList(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else
                     if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData) {
                      return const Text('No data available');
                    } else {
                      final countryList = snapshot.data!.data;
                      final selectedCountryId = int.tryParse(_countryIdController.text);
                  
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 56,
                          padding: const EdgeInsets.only(left: 6, right: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: AppColors.dropdownBorderColor, width: 1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          
                          child: DropdownButton<int>(
                          style: AppTextStyle.interQuestionResponse,
                          hint: const Text("Select country: "),
                          isExpanded: true,
                           underline: const SizedBox(),
                            value: selectedCountryId, 
                            items: countryList!.map((country) {
                              return DropdownMenuItem<int>(
                                value: country.id,
                                child: Text(country.countryName ?? ''),
                              );
                            }).toList(),
                            onChanged: (newCountryId) async{
                               _countryIdController.text = newCountryId.toString();
                               studentTaskProvider1.setSelectedCountryId(newCountryId);
                              //  print('new country id is $newCountryId') ;
                              
                              studentTaskProvider1.selectedStateId = null;
                              _stateIdController.text = '';
                              // Fetch states based on the selected country
                             await studentTaskProvider1.fetchStatesForCountry(studentTaskProvider1.selectedCountryId);
                             
                            },
                          ),
                  
                        ),
                        
                      );
                  
                    }
                  },
                );
                }
                ),

                  const Padding(
                 padding:  EdgeInsets.all(8.0),
                 child:  Align(
                  alignment: Alignment.centerLeft,
                  child: Text("States")
                  ),
               ),
              
               Consumer<StudentTaskProvider>(
              builder: (context, studentTaskProvider1, _) {
                 final selectedStateId = int.tryParse(_stateIdController.text);
                return  Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: DropdownButton<int>(
                  value: studentTaskProvider1.selectedStateId ?? selectedStateId,
                  
                  onChanged: (newValueStateId)async{
                     studentTaskProvider1.setSelectedStateId(newValueStateId);
                      _stateIdController.text = newValueStateId.toString();
                      // print("Selected state value ${studentTaskProvider1.selectedStateId}");  
                  },
                  
                  isExpanded: true,
                  menuMaxHeight: 350,
                  items: studentTaskProvider1.states.map((newValueState) {
                    return DropdownMenuItem<int>(
                      value: newValueState.id,
                      child: Text(newValueState.stateName ?? ''),
                      );
                  }).toList(),
                  
                  ),
               );
              }),

              const SizedBox(
                height: 15,
              ),
              Consumer<StudentTaskProvider>(
                  builder: (context, addstudent, child) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (addstudent.responseMessage != '') {
                    showMessage(
                        message: addstudent.responseMessage, context: context);
        
                    ///Clear the response message to avoid duplicate
                    addstudent.clear();
                  }
                });
                return customButton(
                  text: Labels.update,
                  ontap: () async {
                    if (_formKey.currentState!.validate()) {
                      addstudent.updateJob(
                        id: widget.id,
                        fullName: _fullNameController.text.trim(),
                        // contactNumber: _contactNumberController.text.trim(),
                        // dateOfBirth: _dateOfBirthController.text,
                        // countryId:_countryIdController.text,
                      );
                      Future.delayed(const Duration(seconds: 1), () {
                        PageNavigator(ctx: context)
                            .nextPageOnly(page: const HomeScreen());
                      });
                    }
                  },
                  context: context,
                  status: addstudent.isLoading,
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
