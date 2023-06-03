// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import '../../model/country_list_model.dart';
// import '../../provider/student_provider.dart';
// import '../../utils/components/routers.dart';
// import '../../utils/components/snack_message.dart';
// import '../../utils/exports.dart';
// import '../../utils/labels.dart';
// import '../../widgets/app_textform_field.dart';
// import '../../widgets/custom_button.dart';
// import '../../widgets/custom_textfield.dart';
// import '../home/home_screen.dart';

// // ignore: must_be_immutable
// class UpdateStudentScreen extends StatefulWidget {
//   int id;

//   String? countryId;
//   String? stateId;

//   UpdateStudentScreen({
//     super.key,
//     required this.id,

//     this.countryId,
//     this.stateId,
//   });

//   @override
//   State<UpdateStudentScreen> createState() => _UpdateStudentScreenState();
// }

// class _UpdateStudentScreenState extends State<UpdateStudentScreen> {
//   final _formKey = GlobalKey<FormState>();
 
//   final _countryIdController = TextEditingController();
//   final _stateIdController = TextEditingController();

//   final studentTaskProvider = StudentTaskProvider();

//   @override
//   void initState(){
//     super.initState();
//     print("Your state id is: ${widget.stateId}");
//     print("Your Country id is: ${widget.countryId}");
//     studentTaskProvider.fetchStatesForCountry(widget.countryId);
//     setState(() {
   
//       _countryIdController.text=widget.countryId ?? '';
//       _stateIdController.text=widget.stateId ?? '';
      
//     });
//   }

//   @override
//   void dispose() {
   
//     _countryIdController.dispose();
//     _stateIdController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // print("Rebuild widget");
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Update Task"),
//       ),
//       body: Form(
//         key: _formKey,
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
              
//               Consumer<StudentTaskProvider>(
//                 builder: (context, studentTaskProvider1, _) {
//                   return FutureBuilder<CountryListModel?>(
//                   future: studentTaskProvider.fetchCountryList(),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const CircularProgressIndicator();
//                     } else
//                      if (snapshot.hasError) {
//                       return Text('Error: ${snapshot.error}');
//                     } else if (!snapshot.hasData) {
//                       return const Text('No data available');
//                     } else {
//                       final countryList = snapshot.data!.data;
//                       final selectedCountryId = int.tryParse(_countryIdController.text);
                  
//                       return Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Container(
//                           height: 56,
//                           padding: const EdgeInsets.only(left: 6, right: 6),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             border: Border.all(
//                                 color: AppColors.dropdownBorderColor, width: 1),
//                             borderRadius: BorderRadius.circular(8),
//                           ),
                          
//                           child: DropdownButton<int>(
//                           style: AppTextStyle.interQuestionResponse,
//                           hint: const Text("Select country: "),
//                           isExpanded: true,
//                            underline: const SizedBox(),
//                             value: selectedCountryId, 
//                             items: countryList!.map((country) {
//                               return DropdownMenuItem<int>(
//                                 value: country.id,
//                                 child: Text(country.countryName ?? ''),
//                               );
//                             }).toList(),
//                             onChanged: (newCountryId) async{
//                                _countryIdController.text = newCountryId.toString();
//                                studentTaskProvider1.setSelectedCountryId(newCountryId);
//                                print('new country id is $newCountryId') ;
                               
//                               studentTaskProvider1.selectedStateId = null;
//                               _stateIdController.text = '';
//                               // Fetch states based on the selected country
//                              await studentTaskProvider1.fetchStatesForCountry(studentTaskProvider1.selectedCountryId);
                             
//                             },
//                           ),
                  
//                         ),
                        
//                       );
                  
//                     }
//                   },
//                 );
//                 }
//                 ),

//                   const Padding(
//                  padding:  EdgeInsets.all(8.0),
//                  child:  Align(
//                   alignment: Alignment.centerLeft,
//                   child: Text("States")
//                   ),
//                ),
              
//               Consumer<StudentTaskProvider>(
//               builder: (context, studentTaskProvider1, _) {
//                   final selectedStateId = int.tryParse(_stateIdController.text);
//                 print("selected StateId ByEdit: $selectedStateId");
             
//                 return  Padding(
//                  padding: const EdgeInsets.all(8.0),
//                  child: DropdownButton<int>(
//                   value: selectedStateId,
//                    items: studentTaskProvider1.states.map((newValueState) {
//                     return DropdownMenuItem<int>(
//                       value: newValueState.id,
//                       child: Text(newValueState.stateName ?? ''),
//                       );
//                   }).toList(),

//                   onChanged: (newValueStateId)async{
//                 _stateIdController.text = newValueStateId.toString();
//                   studentTaskProvider1.setSelectedStateId(newValueStateId);  
//                    widget.stateId = newValueStateId.toString(); 
//                   },
                  
//                   isExpanded: true,
//                   menuMaxHeight: 350,
                 
                  
//                   ),
//                );
//               }),

             
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
