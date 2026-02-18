import 'package:flutter/material.dart';
import 'package:flutter_projects/Screens/home_screen.dart';
import 'package:flutter_projects/Screens/main_screen.dart';
import 'package:flutter_projects/core/services/preference_manger.dart';
import 'package:flutter_projects/core/widgets/custom_svg_wedget.dart';
import 'package:flutter_projects/core/widgets/custom_text_form_filed.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WelcomScreen extends StatelessWidget {
  WelcomScreen({super.key});

  final TextEditingController controller = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _key,
            child: Column(
              children: [
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomSvgWedget.withOutFilter(path: "assets/images/Vector.svg"),

                    SizedBox(width: 16),
                    Text(
                      "Tasky",
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ],
                ),
                SizedBox(height: 118),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Welcome To Tasky",
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    SizedBox(width: 6),
                    CustomSvgWedget.withOutFilter(
                      path:
                          "assets/images/waving-hand-medium-light-skin-tone-svgrepo-com 1.svg",
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  "Your productivity journey starts here.",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: 24),
                CustomSvgWedget.withOutFilter(path: "assets/images/pana.svg"),
                SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextFormFiled(
                        lable: "Full Name",
                        controller: controller,
                        isValid: true,
                        errorMessage: "Enter Your Full Name",
                        placeHolder: "e.g. Leen",
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(MediaQuery.of(context).size.width, 40),
                    ),

                    onPressed: () async {
                      _key.currentState?.validate();
                      if (_key.currentState?.validate() ?? false) {
                        await PreferenceManger().setString(
                          'userName',
                          controller.value.text,
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return MainScreen();
                            },
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Enter Your Full Name"),
                            elevation: 10,
                            // backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: Text(
                      "Let’s Get Started",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
