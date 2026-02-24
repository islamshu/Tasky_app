import 'package:flutter/material.dart';
import 'package:flutter_projects/core/constances/storage_key.dart';
import 'package:flutter_projects/core/services/preference_manger.dart';
import 'package:flutter_projects/core/widgets/custom_text_form_filed.dart';

class UserDetilesScreen extends StatefulWidget {
   const UserDetilesScreen({super.key,required this.userName,required this.pio});
   final String userName;
   final String? pio;

  @override
  State<UserDetilesScreen> createState() => _UserDetilesScreenState();
}

class _UserDetilesScreenState extends State<UserDetilesScreen> {
late final TextEditingController nameController ;

late final TextEditingController? pioController ;

  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   nameController =  TextEditingController(text:  widget.userName) ;
   pioController =  TextEditingController(text:  widget.pio) ;

  }
  // void _loadUserData() async {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User Details")),
      body: Padding(
        padding: const EdgeInsets.only(right: 16, left: 16, bottom: 16),

        child: Form(
          key: _key,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),

              CustomTextFormFiled(
                lable: "User Name",
                controller: nameController,
                isValid: true,
                errorMessage: "Please Enter Your name",
                placeHolder: "eg islamsh",
              ),
              SizedBox(height: 20),

              CustomTextFormFiled(
                lable: "Motivation Quote",
                controller: pioController!,
                isValid: false,
                maxLines: 6,
                placeHolder: "One task at a time. One step closer.",
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_key.currentState?.validate() ?? false) {
                        await PreferenceManger().setString(StorageKey.username, nameController.text);
                        await PreferenceManger().setString("pio", pioController!.text);
                       Navigator.of(context).pop(true);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(double.maxFinite, 40),
                    ),
                    child: Text("Save Changes"),

                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
