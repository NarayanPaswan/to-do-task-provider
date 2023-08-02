import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../provider/student_provider.dart';
import '../../utils/components/app_url.dart';
import '../../utils/components/routers.dart';
import '../../utils/components/snack_message.dart';
import '../../utils/exports.dart';
import '../../utils/labels.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import '../home/home_screen.dart';

// ignore: must_be_immutable
class UpdateStudentScreen extends StatefulWidget {
  int id;
  String? studenName;
  // String? contactNumber;
  // String? dateOfBirth;
  // String? countryId;
  // String? stateId;
  String? photo;

  UpdateStudentScreen({
    super.key,
    required this.id,
    this.studenName,
    // this.contactNumber,
    // this.dateOfBirth,
    // this.countryId,
    // this.stateId,
    this.photo,
  });

  @override
  State<UpdateStudentScreen> createState() => _UpdateStudentScreenState();
}

class _UpdateStudentScreenState extends State<UpdateStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  // final _contactNumberController = TextEditingController();
  // final _dateOfBirthController = TextEditingController();
  // final _countryIdController = TextEditingController();
  // final _stateIdController = TextEditingController();

  final studentTaskProvider = StudentTaskProvider();
  File? _imageFile;
  final _picker = ImagePicker();
  DecorationImage? _decorationImage;


   Future getImage()async{
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if(pickedFile != null){
      setState(() {
        _imageFile = File(pickedFile.path);
        print('your image path is: $_imageFile');
       _decorationImage = DecorationImage(
        image: FileImage(_imageFile!),
      );
      });
    }
  }
 

  @override
  void initState(){
    super.initState();
    // print("Your state id is: ${widget.stateId}");
    // print("Your Country id is: ${widget.countryId}");
    print("Your phot link is ${widget.photo}");
    // studentTaskProvider.fetchStatesForCountry(widget.countryId);

     if (widget.photo != null) {
    _decorationImage = DecorationImage(
      image: NetworkImage(AppUrl.imageUrl + widget.photo!),
      fit: BoxFit.cover,
    );
    }

    setState(() {

      _fullNameController.text = widget.studenName.toString();
      // _contactNumberController.text = widget.contactNumber ?? '';
      // _dateOfBirthController.text = widget.dateOfBirth ?? '';
      // _countryIdController.text=widget.countryId ?? '';
      // _stateIdController.text=widget.stateId ?? '';
      
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    // _contactNumberController.dispose();
    // _dateOfBirthController.dispose();
    // _countryIdController.dispose();
    // _stateIdController.dispose();
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
              // Container(
              //   height: 200.0,
              //   width: 200.0,
              //   child: Image.network(widget.photo.toString()),
              // ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: (){
                   getImage();
                  },
                  child: Container(
                    height: 200.0,
                    width: 200.0,
                    decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(100),
                      image: _decorationImage,
                    ),
                    
                  ),
                ),

              ),

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
                        photo: _imageFile,
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
