import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_projects/features/navigation/main_screen.dart';
import 'package:flutter_projects/features/profile/user_detiles_screen.dart';
import 'package:flutter_projects/features/welcom/welcom_screen.dart';
import 'package:flutter_projects/core/services/preference_manger.dart';
import 'package:flutter_projects/core/themes/theme_controller.dart';
import 'package:flutter_projects/core/widgets/custom_svg_wedget.dart';
import 'package:flutter_projects/main.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String userName;

  late String? pio;
  String? userImagePath;
  File? _selectedImage;
  bool is_loading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    setState(() {
      userName = PreferenceManger().getString("userName") ?? '';
      pio =
          PreferenceManger().getString("pio") ??
          'One task at a time. One step closer.';
      userImagePath = PreferenceManger().getString("image_profile");
      is_loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: is_loading
            ? Center(child: CircularProgressIndicator(color: Colors.white))
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      "My Profile",
                      style: Theme.of(
                        context,
                      ).textTheme.displayLarge!.copyWith(fontSize: 20),
                    ),
                  ),
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          backgroundImage: userImagePath == null
                              ? AssetImage("assets/images/avatar.png")
                              : FileImage(File(userImagePath!)),
                          radius: 55,
                          backgroundColor: Colors.transparent,
                        ),

                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () async {
                              _showImageDialog(context,(XFile file ){
                                setState(() {
                                  userImagePath = file.path;
                                  _save_image(file);
                                });
                              });

                            },
                            child: Container(
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Icon(
                                Icons.camera_alt,
                                // color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 4),
                    child: Center(
                      child: Text(
                        userName,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      "$pio",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  SizedBox(height: 24),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Profile Info",
                      style: Theme.of(
                        context,
                      ).textTheme.displayLarge!.copyWith(fontSize: 20),
                    ),
                  ),
                  SizedBox(height: 17),
                  ListTile(
                    onTap: () async {
                      final bool? result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return UserDetilesScreen(
                              userName: userName!,
                              pio: pio!,
                            );
                          },
                        ),
                      );
                      if (result != null && result) {
                        _loadUserData();
                      }
                    },
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      "User Details",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    leading: CustomSvgWedget(path: "assets/images/profile.svg"),
                    trailing: CustomSvgWedget(
                      path: "assets/images/arrow-right.svg",
                    ),
                  ),

                  Divider(),
                  SizedBox(height: 4),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      "Dark Mode",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    leading: CustomSvgWedget(path: "assets/images/moon-01.svg"),

                    trailing: ValueListenableBuilder(
                      valueListenable: ThemeController.themeNotifier,
                      builder: (BuildContext context, value, Widget? child) {
                        return Switch(
                          value: value == ThemeMode.dark,
                          onChanged: (bool value) {
                            ThemeController.toggelTheme();
                          },
                        );
                      },
                    ),
                  ),
                  Divider(),
                  SizedBox(height: 4),
                  ListTile(
                    onTap: () async {
                      PreferenceManger().remove("userName");
                      PreferenceManger().remove("pio");
                      PreferenceManger().remove("tasks");

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return WelcomScreen();
                          },
                        ),
                        (Route<dynamic> route) => false,
                      );
                    },
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      "Log Out",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    leading: CustomSvgWedget(
                      path: "assets/images/log-out-01.svg",
                    ),
                    trailing: CustomSvgWedget(
                      path: "assets/images/arrow-right.svg",
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  void _showImageDialog(BuildContext context,Function(XFile) selected_image) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text(
            "Chose Image Sourse",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          children: [
            SimpleDialogOption(
              onPressed: () async{
                Navigator.pop(context);
                XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);
                if(image != null){
                  selected_image(image);
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Icon(Icons.camera_alt),
                    SizedBox(width: 8),
                    Text("Camera"),
                  ],
                ),
              ),
            ),
            SimpleDialogOption(
              onPressed: () async {
                Navigator.pop(context);
                XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
                if(image != null){
                  selected_image(image);

                }
              },
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Icon(Icons.photo_library),
                    SizedBox(width: 8),
                    Text("Gallery"),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _save_image(XFile file) async {
    final appDir = await getApplicationDocumentsDirectory();
    final newFile = await File(file.path).copy("${appDir.path}/${file.name}");
    PreferenceManger().setString("image_profile", newFile.path);
  }

  // void _showDateTime(BuildContext context) async {
  //   final date = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now().subtract(Duration(days: 5)),
  //     firstDate: DateTime(2024),
  //     lastDate: DateTime.now().add(Duration(days: 5)),
  //   );
  //   print(date);
  //   final time = await showTimePicker(
  //     context: context,
  //     initialTime: TimeOfDay(hour: 12, minute: 0),
  //   );
  //   print(time);
  // }
}
