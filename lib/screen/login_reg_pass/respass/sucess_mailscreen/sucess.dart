import 'package:flutter/material.dart';

// pub dev
import 'package:google_fonts/google_fonts.dart';
import 'package:kartal/kartal.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

// routers page
import '../res_pass.dart';
import 'package:blog/screen/login_reg_pass/login/login.dart';
import 'package:blog/theme/theme.dart';

// ignore: camel_case_types
class resSucessLoadingRootScreen extends StatefulWidget {
  const resSucessLoadingRootScreen({super.key});

  @override
  State<resSucessLoadingRootScreen> createState() =>
      _resSucessLoadingRootScreenState();
}

// ignore: camel_case_types
class _resSucessLoadingRootScreenState
    extends State<resSucessLoadingRootScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const resPassSucessScreen(),
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
class resPassSucessScreen extends StatefulWidget {
  const resPassSucessScreen({super.key});

  @override
  State<resPassSucessScreen> createState() => _resPassSucessScreenState();
}

// ignore: camel_case_types
class _resPassSucessScreenState extends State<resPassSucessScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "E-mail Gönderildi",
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
              child: Image.asset("assets/image/successful/icons8-ok-96.png"),
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Text(
                  "Yenileme E-mail Gönderildi!",
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
                  "Girmiş Olduğunuz E-mail Adresinize Sıfırlama Mail'i gönderildi, şifrenizi yenileyebilirsiniz",
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
                      "Giriş Yap",
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
