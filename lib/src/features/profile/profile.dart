import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:simone/src/features/authentication/controllers/signup_controller.dart';
import 'package:simone/src/features/authentication/models/user_model.dart';
import 'package:simone/src/features/profile/updateprofile.dart';
import 'package:simone/src/repository/authentication_repository/authentication_repository.dart';
import 'package:simone/src/utils/colorpalette.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  final db = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;
  String branchName = '';
  String code = '';
  String name = '';
  String email = '';
  String phoneNumber = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getBranch();
  }

  Future<void> getBranch() async {
    // final controller = Get.put(ProfileController());
    // var userData = await controller.getUserData();
    setState(() {
      isLoading = true;
    });
    final resultUser = await GetStorage().read('userData');
    final responseBranch = await GetStorage().read('branch');
    final result = UserModel.fromJson(resultUser);
    setState(() {
      branchName = (responseBranch['branch']);
      code = result.agentCode;
      name = result.fullName;
      email = result.email;
      phoneNumber = result.phoneNo;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: ColorPalette.primaryLighter.withOpacity(0.02),
        child: Column(
          children: [
            SizedBox(
              height: 160,
              child: Stack(
                children: [
                  Container(
                    height: 100,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          ColorPalette.primaryColor,
                          ColorPalette.primaryLighter,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    bottom: 0,
                    child: Row(
                      children: [
                        Material(
                          elevation: 1,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Image.asset('assets/EZHUB Icon.png'),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 30),
                            isLoading
                                ? const FadeShimmer(
                                    height: 23,
                                    width: 200,
                                    radius: 4,
                                    highlightColor: ColorPalette.greyE3,
                                    baseColor: ColorPalette.greyLight,
                                  )
                                : Text(
                                    name,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                            const SizedBox(height: 2),
                            isLoading
                                ? const FadeShimmer(
                                    height: 18,
                                    width: 150,
                                    radius: 4,
                                    highlightColor: ColorPalette.greyE3,
                                    baseColor: ColorPalette.greyLight,
                                  )
                                : Text(
                                    email,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: ColorPalette.greyLight,
                                    ),
                                  ),
                          ],
                        )
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 25, top: 20),
                    child: Text(
                      "Agent's Profile",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileCard(
                    onTap: () {},
                    name: 'Branch',
                    icon: Icons.business,
                    trailing: isLoading
                        ? const FadeShimmer(
                            height: 23,
                            width: 100,
                            radius: 4,
                            highlightColor: ColorPalette.greyE3,
                            baseColor: ColorPalette.greyLight,
                          )
                        : Text(
                            branchName,
                            style: const TextStyle(
                              color: ColorPalette.primaryColor,
                              fontSize: 14,
                            ),
                          ),
                  ),
                  const SizedBox(height: 10),
                  _buildProfileCard(
                    onTap: () {},
                    name: 'Agent Code',
                    icon: Icons.account_box,
                    trailing: isLoading
                        ? const FadeShimmer(
                            height: 23,
                            width: 100,
                            radius: 4,
                            highlightColor: ColorPalette.greyE3,
                            baseColor: ColorPalette.greyLight,
                          )
                        : Text(
                            code,
                            style: const TextStyle(
                              color: ColorPalette.primaryColor,
                              fontSize: 14,
                            ),
                          ),
                  ),
                  const SizedBox(height: 10),
                  _buildProfileCard(
                    onTap: () {},
                    name: 'Phone Number',
                    icon: Icons.phone_android,
                    trailing: isLoading
                        ? const FadeShimmer(
                            height: 23,
                            width: 100,
                            radius: 4,
                            highlightColor: ColorPalette.greyE3,
                            baseColor: ColorPalette.greyLight,
                          )
                        : Text(
                            phoneNumber,
                            style: const TextStyle(
                              color: ColorPalette.primaryColor,
                              fontSize: 14,
                            ),
                          ),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildProfileCard(
                    onTap: () => Get.to(() => const UpdateProfile()),
                    name: 'Update Profile',
                    icon: Icons.edit_rounded,
                    trailing: const Icon(
                      Icons.chevron_right_rounded,
                      color: ColorPalette.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildProfileCard(
                    onTap: () {
                      AwesomeDialog(
                        context: context,
                        animType: AnimType.scale,
                        dialogType: DialogType.warning,
                        title: 'Change Password',
                        desc: 'Would you like to change your password?',
                        btnCancelOnPress: () {},
                        btnOkOnPress: () {
                          SignUpController.instance.sendResetEmail(email);
                          showTopSnackBar(
                            Overlay.of(context),
                            displayDuration: const Duration(milliseconds: 1500),
                            const CustomSnackBar.success(
                              message:
                                  "An instruction has been sent to your email.",
                            ),
                          );
                        },
                      ).show();
                    },
                    name: 'Change Password',
                    icon: Icons.lock_person_sharp,
                    trailing: const Icon(
                      Icons.chevron_right_rounded,
                      color: ColorPalette.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildProfileCard(
                    onTap: () {
                      AwesomeDialog(
                        context: context,
                        animType: AnimType.scale,
                        dialogType: DialogType.warning,
                        title: 'Logout',
                        desc: 'Are you sure you want to logout?',
                        btnCancelOnPress: () {},
                        btnOkOnPress: () {
                          AuthenticationRepository.instance.logOut();
                        },
                      ).show();
                    },
                    name: 'Logout',
                    bgColor: Colors.red[400]!.withOpacity(0.7),
                    textColor: Colors.white,
                    icon: Icons.logout_rounded,
                    trailing: const Icon(
                      Icons.chevron_right_rounded,
                      color: ColorPalette.neutralWhite,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard({
    required Function() onTap,
    required String name,
    required IconData icon,
    required Widget trailing,
    Color? bgColor,
    Color? textColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Material(
        elevation: 1,
        borderRadius: BorderRadius.circular(10),
        color: bgColor ?? Colors.white,
        child: ListTile(
          title: Text(
            name,
            style: TextStyle(
              color: textColor ?? Colors.black,
            ),
          ),
          leading: Icon(
            icon,
            color: textColor ?? Colors.black,
          ),
          trailing: trailing,
        ),
      ),
    );
  }
}
