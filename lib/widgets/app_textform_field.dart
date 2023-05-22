import '../../utils/exports.dart';

class AppTextFormField extends StatelessWidget {
  final String? hintText;
  // final String labelText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? suffixIconOnPressed;
  final TextInputType? keyboardType; 
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final String? initialValue;
  final bool obscureText;
  final TextEditingController? controller;
  
  
  const AppTextFormField({super.key, 
  this.hintText = "Response",
  // required this.labelText, 
  this.prefixIcon, this.suffixIcon,  
  this.suffixIconOnPressed, 
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
                prefixIcon: Icon(prefixIcon),
                // labelText: labelText,
                suffixIcon: suffixIcon != null
                ? IconButton(
                    onPressed: suffixIconOnPressed,
                    icon: Icon(suffixIcon),
                  )
                : null,
              ),
             keyboardType: keyboardType, 
             onChanged: onChanged,
            controller: controller,
             validator: validator,
             initialValue: initialValue,
             obscureText: obscureText,
             ),
    );
  }
}
