import 'package:flutter/material.dart';

class CustomTextFormFiled extends StatelessWidget {
  const CustomTextFormFiled({
    super.key,
    required this.lable,
    required this.controller,
    required this.isValid,
    this.errorMessage,
    this.placeHolder,
    this.maxLines
  });

  final TextEditingController controller;

  final bool isValid;
  final String lable;
  final String? errorMessage;
  final String? placeHolder;
  final int? maxLines ;

  _get_error_message(isValid , errorMessage){
    if(isValid && errorMessage != null){
      return errorMessage;
    }else{

      return "This Filed Is Required";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          lable,
          style:Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 16),

        ),
        SizedBox(height: 8),
        TextFormField(
          style: TextTheme.of(context).labelMedium!.copyWith(fontSize: 16),
          validator: (String? value) {
            if (isValid) {
              if (value?.trim().isEmpty ?? false) {
                return _get_error_message(isValid,errorMessage);
              }
              return null;
            }
          },
          cursorColor: Colors.white,
          controller: controller,
          maxLines: maxLines ==1 ? 1 : maxLines,
          decoration: InputDecoration(
            hintText: placeHolder,

          ),
        ),
      ],
    );
  }
}
