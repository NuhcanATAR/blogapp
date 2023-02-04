import 'package:flutter/material.dart';

// pub dev
import 'package:google_fonts/google_fonts.dart';
import 'package:kartal/kartal.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

// routers page
import 'package:blog/screen/login_reg_pass/login/login.dart';
import 'package:blog/theme/theme.dart';

// ignore: camel_case_types
class registerLoadingRouter extends StatefulWidget {
  const registerLoadingRouter({super.key});

  @override
  State<registerLoadingRouter> createState() => _registerLoadingRouterState();
}

// ignore: camel_case_types
class _registerLoadingRouterState extends State<registerLoadingRouter> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const registerEndMsg(),
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
                color: themeMainColorData.colorScheme.background, size: 55),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Hesap Oluşturuluyor",
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
class registerEndMsg extends StatefulWidget {
  const registerEndMsg({super.key});

  @override
  State<registerEndMsg> createState() => _registerEndMsgState();
}

// ignore: camel_case_types
class _registerEndMsgState extends State<registerEndMsg> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          "Kayıt Başarlı",
          style: GoogleFonts.nunito(
            textStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: themeMainColorData.colorScheme.background,
                ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // top image
              SizedBox(
                width: 120,
                height: 120,
                child: Image.asset("assets/image/successful/icons8-ok-96.png"),
              ),
              const SizedBox(height: 15),
              // title
              Text(
                "Hesabınız Oluşturuldu",
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  textStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              const SizedBox(height: 15),
              // sub title
              Text(
                "Kullanıcı Hesabınız Başarıyla Oluşturuldu, giriş yapabilirsiniz!",
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Colors.black54,
                      ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              // login btn
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const login(),
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
                        "Giriş yap",
                        style: GoogleFonts.nunito(
                          textStyle:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: Colors.white,
                                  ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
