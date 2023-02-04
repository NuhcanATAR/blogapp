import 'package:flutter/material.dart';

// pub dev
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';

// routers page
import 'package:blog/screen/login_reg_pass/login/login.dart';
import 'package:blog/screen/login_reg_pass/register/register.dart';
import 'package:blog/screen/login_reg_pass/respass/res_pass.dart';
import 'package:blog/screen/mainScreens/categorys/do%C4%9Fa/doga.dart';
import 'package:blog/screen/mainScreens/categorys/futbol/futbol.dart';
import 'package:blog/screen/mainScreens/categorys/spor/spor.dart';
import 'package:blog/screen/mainScreens/categorys/tar%C4%B1m/tarim.dart';
import 'package:blog/screen/mainScreens/categorys/yapi/yapi.dart';
import 'package:blog/screen/mainScreens/categorys/yaris/yaris.dart';
import 'package:blog/screen/mainScreens/home/home.dart';
import 'package:blog/screen/mainScreens/profile/namesurname_change/namesurname_change.dart';
import 'package:blog/screen/mainScreens/profile/password_change/pass_change.dart';
import 'package:blog/screen/mainScreens/profile/profile.dart';
import 'package:blog/screen/mainScreens/profile/profile_change/profil_img_change.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    const buildMainRouteScreen(),
  );
}

// ignore: camel_case_types
class buildMainRouteScreen extends StatefulWidget {
  const buildMainRouteScreen({super.key});

  @override
  State<buildMainRouteScreen> createState() => _buildMainRouteScreenState();
}

// ignore: camel_case_types
class _buildMainRouteScreenState extends State<buildMainRouteScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/route",
      routes: {
        "/route": (context) => const buildRouteLoadingScreen(),
        "/login": (context) => const login(),
        "/register": (context) => const register(),
        "/resPass": (context) => const resPassScreen(),
        "/home": (context) => const home(),
        "/profile": (context) => const profileScreen(),
        "/imgUpload": (context) => const profilimgChangeScreen(),
        "/nameChange": (context) => const nameSurnameChangeScreen(),
        "/passChange": (context) => const passChangeScreen(),
        "/dogaCategory": (context) => const dogaCategorysScreen(),
        "/futbolCategory": (context) => const futbolCategorysScreen(),
        "/sporCategory": (context) => const sporCategorysScreen(),
        "/tarımCategory": (context) => const tarimCategoryScreen(),
        "/yapiCategory": (context) => const yapiCategorysScreen(),
        "/yarisCategory": (context) => const yarisCategorysScreen(),
      },
    );
  }
}

// ignore: camel_case_types
class buildRouteLoadingScreen extends StatefulWidget {
  const buildRouteLoadingScreen({super.key});

  @override
  State<buildRouteLoadingScreen> createState() =>
      _buildRouteLoadingScreenState();
}

// ignore: camel_case_types
class _buildRouteLoadingScreenState extends State<buildRouteLoadingScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
        const Duration(
          seconds: 3,
        ), () {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const login(),
          ),
          (Route<dynamic> route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 90,
              height: 90,
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        "assets/image/app_logo/gif/icons8-open-book.gif"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              "Blog Uygulaması",
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                textStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              "Lütfen Bekleyiniz...",
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Colors.black54,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
