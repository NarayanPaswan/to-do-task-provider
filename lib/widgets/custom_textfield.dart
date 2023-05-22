import '../../utils/exports.dart';

class CustomTextField extends StatelessWidget {
  final String? hintText;
  // final String labelText;
  final TextInputType? keyboardType; 
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final String? initialValue;
  final bool obscureText;
  final TextEditingController? controller;
  
  
  const CustomTextField({super.key, 
  this.hintText = "Response",
  // required this.labelText, 
  this.keyboardType,  this.validator, 
  this.obscureText = false, 
  this.onChanged, 
  this.initialValue,
  this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
              style: AppTextStyle.interQuestionResponse,
              decoration:  InputDecoration(
                hintText: hintText,
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
                // labelText: labelText,
              ),
             keyboardType: keyboardType, 
            //  onChanged: onChanged,
            controller: controller,
             validator: validator,
             initialValue: initialValue,
             obscureText: obscureText,
             ),
    );
  }
}
