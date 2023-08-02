import 'package:provider/provider.dart';

import '../../model/task_type_model.dart';
import '../../provider/authProvider/auth_provider.dart';
import '../../provider/booking_controller_provider.dart';
import '../../utils/components/app_error_snackbar.dart';
import '../../utils/components/routers.dart';
import '../../utils/components/snack_message.dart';
import '../../utils/exports.dart';
import '../../widgets/app_textform_field.dart';
import '../../widgets/custom_button.dart';
import 'measurement_view.dart';


class ServiceBookingView extends StatefulWidget {
  const ServiceBookingView({super.key});

  @override
  State<ServiceBookingView> createState() => _ServiceBookingViewState();
}

class _ServiceBookingViewState extends State<ServiceBookingView> {
final _formKey = GlobalKey<FormState>();
final authenticationProvider = AuthenticationProvider();
final bookingControllerProvider = BookingControllerProvider();
final TextEditingController _fullName = TextEditingController();
final TextEditingController _email = TextEditingController();
final TextEditingController _phone = TextEditingController();
final TextEditingController _taskTypeId = TextEditingController();


@override
  void dispose() {
    super.dispose();
    _fullName.dispose();
    _email.dispose();
    _phone.dispose();

  }


  @override
  Widget build(BuildContext context) {
     final bookingProviderVisible = Provider.of<BookingControllerProvider>(context); 

    return Scaffold(
       appBar: AppBar(
        title: const Text("Service Booking"),
        
      ),
      body:  SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                
                
           
              const Padding(
                padding: EdgeInsets.only(top:8.0, bottom: 8.0),
                child: Align(
                  alignment : Alignment.centerLeft,
                  child: Text("Task type")),
              ),
               Consumer<BookingControllerProvider>(
              builder: (context, bookingProvider, _) {
                return FutureBuilder<TaskTypeModel?>(
                future: bookingProvider.fetchTaskType(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else
                   if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData) {
                    return const Text('No data available');
                  } else {
                    final taskTypeList = snapshot.data!.items;
                
                    return Container(
                      height: 56,
                      padding: const EdgeInsets.only(left: 6, right: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            color: AppColors.dropdownBorderColor, width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      
                      child: DropdownButton<int>(
                      style: AppTextStyle.smallTextStyle,
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
                        onChanged: (newTaskTypeId) async{
                           bookingProvider.setSelectedTaskTypeId(newTaskTypeId);
                          _taskTypeId.text = newTaskTypeId.toString();
                           
                        },
                        
                      ),
                      
                
                    );
                
                  }
                },
              );
              }
              ),

                const SizedBox(
                      height: 5,
                    ),


                  AppTextFormField(
                    controller: _fullName,
                    hintText: "Full Name",
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
                  hintText: "Email",
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
                  hintText: "Mobile No",
                  keyboardType: TextInputType.number,
                  validator: (value) {
                        return bookingControllerProvider.validateMobile(value!);
                      },
                ),
                
                const SizedBox(
                    height: 5,
                  ), 
                
      
               

       

               Visibility(
                  visible: bookingProviderVisible.selectedTaskTypeId == 1 ? true : false,
                  child: Padding(
                    padding: const EdgeInsets.only(top:16.0),
                    child: TextFormField(
                      onTap: (){
                         PageNavigator(ctx: context).nextPage(
                      page: const MeasurementView(),
                    );
                      },
                    
                    readOnly: true,  
                    style: AppTextStyle.smallTextStyle,
                    decoration:  InputDecoration(
                      hintText: "measeurement details",
                      
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
                      border:  OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)
                      ),
                      suffixIcon: Container(
                        margin: const EdgeInsets.only(right: 10),
                                    width: 20,
                                    decoration:  BoxDecoration(
                                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                                      color: AppColors.grey, 
                                    ),
                              
                                    child: const Center(
                                      child: Icon(
                                        Icons.arrow_forward_ios,
                                        size: 25,
                                      ),
                                    ),
                                  ),
                    ),
                          
                                 ),
                  ),
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
                    text: "Booking",
                       ontap: () async {
                      if (_formKey.currentState!.validate()) {
          
                          try {
                          await  book.newBooking(
                          fullName: _fullName.text.trim(),
                          email: _email.text.trim(), 
                          phone: _phone.text.trim(),
                          tasktypeid: _taskTypeId.text.trim(),
                              onSuccess: () {
                              // Clear the text form field values here
                              _fullName.clear();
                              _email.clear();
                              _phone.clear();
                              _taskTypeId.clear();
                            },
                          );
                          
                          } catch (e) {
                            AppErrorSnackBar(context).error(e);
                          }
          
          
                      }
                    },
              
                  context: context,
                  status: book.isLoading,
              
                  );
                }
              ),      
           
              ],
            ),
          ),
        ),
      ),

    
    );
  }
}