import 'package:provider/provider.dart';
import '../../provider/student_provider.dart';
import '../../utils/components/routers.dart';
import '../../utils/components/snack_message.dart';
import '../../utils/exports.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import '../home/home_screen.dart';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
   final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _address = TextEditingController();
  
   final studentTaskProvider = StudentTaskProvider();
  @override
  Widget build(BuildContext context) {
    print("widget build");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Task"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            CustomTextField(
              controller: _fullName,
              hintText: 'Full Name',
               onChanged: (newName) {
                    studentTaskProvider.name = newName;
                  },
               validator: (value) {
                    return studentTaskProvider.validateFullName(value!);
              },
            ),

             CustomTextField(
              controller: _address,
              hintText: 'Address',
            ),



            const SizedBox(height: 15,),
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
                    // text: Labels.signIn,
                    ontap: () async {
                    if (_formKey.currentState!.validate()) {
                      addstudent.addTask(fullName: _fullName.text.trim());
                      Future.delayed(const Duration(seconds: 2), () {
                        PageNavigator(ctx: context).nextPageOnly(page: const HomeScreen());
                      });
                    }
                  },
                  context: context,
                  status: addstudent.isLoading,
              
                  );
                }
              ),
          ],
        ),
      ),
    );
  }
}