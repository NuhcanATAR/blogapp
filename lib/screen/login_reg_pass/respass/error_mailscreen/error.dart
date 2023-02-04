import 'package:flutter/material.dart';

// pub dev

import 'package:google_fonts/google_fonts.dart';
import 'package:kartal/kartal.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

// routers page
import '../res_pass.dart';
import 'package:blog/theme/theme.dart';

// ignore: camel_case_types
class resErrorLoadingRootScreen extends StatefulWidget {
  const resErrorLoadingRootScreen({super.key});

  @override
  State<resErrorLoadingRootScreen> createState() =>
      _resErrorLoadingRootScreenState();
}

// ignore: camel_case_types
class _resErrorLoadingRootScreenState extends State<resErrorLoadingRootScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const resPassErrorScreen(),
          ),
          (Route<dynamic> route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            LoadingAnimationWidget.beat(
                color: themeMainColorData.colorScheme.background, size: 65),
            const SizedBox(
              height: 15,
            ),
            Text(
              "E-mail Kontrol Ediliyor",
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                textStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(
              height: 5,
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

// ignore: camel_case_types
class resPassErrorScreen extends StatefulWidget {
  const resPassErrorScreen({super.key});

  @override
  State<resPassErrorScreen> createState() => _resPassErrorScreenState();
}

// ignore: camel_case_types
class _resPassErrorScreenState extends State<resPassErrorScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const resPassScreen(),
          ),
          (Route<dynamic> route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Hatalı E-mail Adresi",
          style: GoogleFonts.nunito(
            textStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: themeMainColorData.colorScheme.background,
                ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView(
          children: <Widget>[
            SizedBox(
              width: 75,
              height: 75,
              child: Image.asset(
                  "assets/image/no_connection/icons8-close-window-96.png"),
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Text(
                  "E-mail Adresi Bulunamadı!",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                      textStyle: GoogleFonts.nunito(
                    textStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                  )),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Text(
                  "Girmiş Olduğunuz E-mail Adresi Bulunamadı Lütfen Girdiğiniz E-mail Adresiniz Kontrol Ediniz.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                      textStyle: GoogleFonts.nunito(
                    textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Colors.black54,
                        ),
                  )),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const resPassScreen(),
                      ),
                      (Route<dynamic> route) => false);
                },
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: context.dynamicHeight(0.08),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: themeMainColorData.colorScheme.background,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(4),
                      ),
                    ),
                    child: Text(
                      "Tekrar Dene",
                      style: GoogleFonts.nunito(
                        textStyle:
                            Theme.of(context).textTheme.bodyMedium!.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
