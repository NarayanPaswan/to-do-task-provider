// import 'dart:io';

// import 'package:image_picker/image_picker.dart';
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
// import 'package:intl/intl.dart';

// class AddStudentScreen extends StatefulWidget {
//   const AddStudentScreen({super.key});

//   @override
//   State<AddStudentScreen> createState() => _AddStudentScreenState();
// }

// class _AddStudentScreenState extends State<AddStudentScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _fullNameController = TextEditingController();
 
  
//   File? _imageFile;
//   final _picker = ImagePicker();

//   Future getImage()async{
//     final pickedFile = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
//     if(pickedFile != null){
//       setState(() {
//         _imageFile = File(pickedFile.path);
//         print('your image path is: $_imageFile');
//       });
//     }
//   }

//   final studentTaskProvider = StudentTaskProvider();

//   @override
//   void dispose() {
//     _fullNameController.dispose();
   
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // final studentTaskProvider1 = Provider.of<StudentTaskProvider>(context);

//     // print("Re build widget");
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Add Task"),
//       ),
//       body: Form(
//         key: _formKey,
//         child: SingleChildScrollView(
//           physics: const AlwaysScrollableScrollPhysics(),
//           child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Container(
//                   width: MediaQuery.of(context).size.width,
//                   height: 100,
//                   decoration: BoxDecoration(
//                     image: _imageFile == null ? null : DecorationImage(
//                       image: FileImage(_imageFile ?? File('')),
//                       )
//                   ),
//                   child: Center(
//                     child: IconButton(
//                       onPressed: (){
//                         getImage();
//                       }, 
//                       icon: const Icon(Icons.image, size: 50, color: Colors.black,)),
//                   ),
              
//                 ),
//               ),
//               CustomTextField(
//                 controller: _fullNameController,
//                 hintText: 'Full Name',
//                 validator: (value) {
//                   return studentTaskProvider.validateFullName(value!);
//                 },
//               ),
              
            
//               const SizedBox(
//                 height: 15,
//               ),
//               Consumer<StudentTaskProvider>(
//                   builder: (context, addstudent, child) {
//                 WidgetsBinding.instance.addPostFrameCallback((_) {
//                   if (addstudent.responseMessage != '') {
//                     showMessage(
//                         message: addstudent.responseMessage, context: context);
                
//                     ///Clear the response message to avoid duplicate
//                     addstudent.clear();
//                   }
//                 });
//                 return customButton(
//                   // text: Labels.signIn,
//                   ontap: () async {
//                     if (_formKey.currentState!.validate()) {
//                       addstudent.addJob(
//                         fullName: _fullNameController.text.trim(),
//                       );
//                       Future.delayed(const Duration(seconds: 1), () {
//                         PageNavigator(ctx: context)
//                             .nextPageOnly(page: const HomeScreen());
//                       });
//                     }
//                   },
//                   context: context,
//                   status: addstudent.isLoading,
//                 );
//               }),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
