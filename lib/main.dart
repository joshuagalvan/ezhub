import 'package:animate_do/animate_do.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:simone/firebase_options.dart';
import 'package:simone/server.dart';
import 'package:simone/src/helpers/applinkdeeplink.dart';
import 'package:simone/src/helpers/mysql.dart';
import 'package:simone/src/repository/authentication_repository/authentication_repository.dart';
import 'package:simone/src/utils/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await mySQL().connect();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final AppLinksDeepLink appLinksDeepLink = AppLinksDeepLink.instance;
  appLinksDeepLink.onInit();
  await GetStorage.init();
  boot();
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // double screenWidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;
    return ResponsiveApp(builder: (context) {
      return GetMaterialApp(
        theme: AppTheme.lightTheme.copyWith(
          primaryColor: const Color(0xfffe5000),
        ),
        //darkTheme: appTheme.darkTheme,
        themeMode: ThemeMode.system,
        useInheritedMediaQuery: true,
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        debugShowCheckedModeBanner: false,
        defaultTransition: Transition.rightToLeft,
        home: const SplashView(),
      );
    });
  }
}

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  init() async {
    await Future.delayed(
      const Duration(milliseconds: 2500),
      () {
        setState(() {
          Get.put(AuthenticationRepository());
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FadeInUp(
        duration: const Duration(seconds: 2),
        child: Center(
          child: Image.asset('assets/EZHUB.png'),
        ),
      ),
    );
  }
}
