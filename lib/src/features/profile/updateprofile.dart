import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simone/src/components/input_text_field.dart';
import 'package:simone/src/constants/text_strings.dart';
import 'package:simone/src/features/authentication/controllers/profile_controller.dart';
import 'package:simone/src/features/authentication/models/user_model.dart';
import 'package:simone/src/features/profile/profile.dart';
import 'package:simone/src/utils/colorpalette.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final controller = Get.put(ProfileController());
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        surfaceTintColor: Colors.white,
        title: const Text(
          "Update Profile",
          style: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: ColorPalette.primaryLighter.withOpacity(0.04),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            FutureBuilder(
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    UserModel userData = snapshot.data as UserModel;

                    final email = TextEditingController(text: userData.email);
                    final fullName =
                        TextEditingController(text: userData.fullName);
                    final phoneNo =
                        TextEditingController(text: userData.phoneNo);
                    final id = TextEditingController(text: userData.id);

                    return SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Full Name',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          InputTextField(
                            controller: fullName,
                            hintText: 'Enter Full Name',
                            prefixIcon: const Icon(Icons.person),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            phone,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          InputTextField(
                            controller: phoneNo,
                            hintText: 'Enter $phone',
                            prefixIcon: const Icon(Icons.phone_android),
                          ),
                          const SizedBox(height: 50),
                          SizedBox(
                            height: 45,
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                final users = UserModel(
                                  id: id.text.trim(),
                                  fullName: fullName.text.trim(),
                                  phoneNo: phoneNo.text.trim(),
                                  email: email.text.trim(),
                                  agentCode: userData.agentCode.trim(),
                                  password: userData.password.trim(),
                                );
                                await controller.updateRecord(users);
                                await user?.verifyBeforeUpdateEmail(
                                  email.text.trim(),
                                );
                                Get.to(() => const Profile());
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xfffe5000),
                              ),
                              child: const Text(
                                "Update Profile",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  } else {
                    return const Center(
                      child: Text('Something went wrong'),
                    );
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
              future: controller.getUserData(),
            ),
          ],
        ),
      ),
    );
  }
}
