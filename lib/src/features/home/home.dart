import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:simone/src/features/dashboard/dashboardV2.dart';
import 'package:simone/src/features/navbar/navbar.dart';
import 'package:simone/src/features/premiumcalculator/premiumcalculator.dart';
import 'package:simone/src/features/profile/profile.dart';
import 'package:simone/src/features/undermaintenance/undermaintenance.dart';
import 'package:simone/src/utils/colorpalette.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  int currentIndex = 0;

  List<Widget> screen = [
    const Dashboard(),
    const PremiumCalculator(),
    // const Search(),
    // const Search(),
    const Profile()
  ];

  List<PersistentTabConfig> _tabs() => [
        PersistentTabConfig(
          screen: const Dashboard(),
          item: ItemConfig(
            activeForegroundColor: ColorPalette.primaryColor,
            icon: const Icon(Icons.home),
            title: "Home",
          ),
        ),
        PersistentTabConfig(
          screen: const PremiumCalculator(),
          item: ItemConfig(
            activeForegroundColor: ColorPalette.primaryColor,
            icon: const Icon(Icons.calculate),
            title: "Calculator",
          ),
        ),
        // PersistentTabConfig(
        //   screen: const Search(),
        //   item: ItemConfig(
        //     activeForegroundColor: ColorPalette.primaryColor,
        //     icon: const Icon(Icons.search),
        //     title: "Search",
        //   ),
        // ),
        // PersistentTabConfig(
        //   screen: const Search(),
        //   item: ItemConfig(
        //     activeForegroundColor: ColorPalette.primaryColor,
        //     icon: const Icon(Icons.checklist),
        //     title: "To Do",
        //   ),
        // ),
        PersistentTabConfig(
          screen: const Profile(),
          item: ItemConfig(
            activeForegroundColor: ColorPalette.primaryColor,
            icon: const Icon(Icons.person),
            title: "Profile",
          ),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: const NavBar(),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 251, 245, 242),
          title: Image.asset(
            'assets/EZHUB Icon.png',
            height: 40,
          ),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              onPressed: () => Get.to(() => const UnderMaintenanceScreen()),
              icon: const Icon(Icons.notifications),
              iconSize: 30,
            )
          ],
        ),
        body: PersistentTabView(
          tabs: _tabs(),
          navBarHeight: 65,
          onTabChanged: (value) {
            setState(() {
              currentIndex = value;
            });
          },
          navBarBuilder: (navBarConfig) => Style4BottomNavBar(
            navBarConfig: navBarConfig,
            navBarDecoration: NavBarDecoration(
              boxShadow: [
                BoxShadow(
                  blurRadius: 3,
                  offset: const Offset(1, 1),
                  spreadRadius: 2,
                  color: Colors.grey[300]!,
                )
              ],
            ),
          ),
        ),
        // body: screen[_currentIndex],
        // bottomNavigationBar: BottomNavigationBar(
        //   showUnselectedLabels: true,
        //   iconSize: 30,
        //   currentIndex: _currentIndex,
        //   items: const [
        //     BottomNavigationBarItem(
        //         icon: Icon(
        //           Icons.home,
        //           //     color: Color.fromARGB(255, 255, 255, 255),
        //         ),
        //         label: ('Home'),
        //         backgroundColor: Color(0xfffe5000)),
        //     BottomNavigationBarItem(
        //         icon: Icon(Icons.calculate),
        //         label: ('Calculator'),
        //         backgroundColor: Color(0xfffe5000)),
        //     BottomNavigationBarItem(
        //         icon: Icon(Icons.search),
        //         label: ('Search'),
        //         backgroundColor: Color(0xfffe5000)),
        //     BottomNavigationBarItem(
        //         icon: Icon(Icons.checklist),
        //         label: ('To Do'),
        //         backgroundColor: Color(0xfffe5000)),
        //     BottomNavigationBarItem(
        //         icon: Icon(Icons.person),
        //         label: ('Profile'),
        //         backgroundColor: Color(0xfffe5000)),
        //   ],
        //   onTap: (index) {
        //     setState(() {
        //       _currentIndex = index;
        //     });
        //   },
        // ),
      ),
    );
  }
}
