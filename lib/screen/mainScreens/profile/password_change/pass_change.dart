import 'package:flutter/material.dart';

// pub dev
import 'package:google_fonts/google_fonts.dart';
import 'package:kartal/kartal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

// routers page
import '../../../../theme/theme.dart';
import 'package:blog/screen/mainScreens/profile/password_change/error_mailscreen/error.dart';
import 'package:blog/screen/mainScreens/profile/password_change/sucess_mailscreen/sucess.dart';
import 'package:blog/screen/mainScreens/profile/profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    const MaterialApp(
      home: passChangeScreen(),
    ),
  );
}

// ignore: camel_case_types
class passChangeScreen extends StatefulWidget {
  const passChangeScreen({super.key});

  @override
  State<passChangeScreen> createState() => _passChangeScreenState();
}

// ignore: camel_case_types
class _passChangeScreenState extends State<passChangeScreen> {
  // form key
  final _formUploadKey = GlobalKey<FormState>();

  // controller
  final TextEditingController userMail = TextEditingController();

  // validator
  String? userMailVal(String? userMail) {
    if (userMail == null || userMail.isEmpty) {
      return "* Zorunlu Alan";
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(userMail)) {
      return "* Geçersiz Email Adresi";
    } else {
      return null;
    }
  }

  // change reset pass class
  // ignore: unused_field
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  Future<void> postChangePass() async {
    FirebaseAuth.instance
        .sendPasswordResetEmail(
      email: userMail.text.toString(),
    )
        .then((value) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const resSucessLoadingRootScreen(),
          ),
          (Route<dynamic> route) => false);
    }).catchError((error) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const resErrorLoadingRootScreen(),
          ),
          (Route<dynamic> route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const profileScreen(),
              ),
            );
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: themeMainColorData.colorScheme.background,
            size: 21,
          ),
        ),
        title: Text(
          "Şifre Güncelle",
          style: GoogleFonts.nunito(
            textStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: themeMainColorData.colorScheme.background,
                ),
          ),
        ),
      ),
      body: Form(
        key: _formUploadKey,
        child: Column(
          children: <Widget>[
            // body
            Expanded(
              flex: 7,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 15,
                      ),
                      // title
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          "Kullanıcı Şifresi Güncelle",
                          style: GoogleFonts.nunito(
                            textStyle: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      // sub title
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          "Kayıtlı E-mail Adresiniz ile Şifrenizi Güncelleyebilirsiniz",
                          style: GoogleFonts.nunito(
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: Colors.black54,
                                ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      // ınput
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 5, bottom: 5),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 0.5),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(4),
                            ),
                          ),
                          child: TextFormField(
                            controller: userMail,
                            validator: userMailVal,
                            style: GoogleFonts.nunito(
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color: Colors.black,
                                  ),
                            ),
                            decoration: InputDecoration(
                              icon: const Icon(
                                Icons.mail,
                                color: Colors.grey,
                                size: 20,
                              ),
                              hintText: "E-mail Adresiniz",
                              hintStyle: GoogleFonts.nunito(
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: Colors.grey,
                                    ),
                              ),
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // change button
            Flexible(
              fit: FlexFit.tight,
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 15, right: 15, top: 10, bottom: 10),
                child: GestureDetector(
                  onTap: () {
                    if (_formUploadKey.currentState!.validate()) {
                      postChangePass();
                    }
                  },
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: context.dynamicHeight(0.1),
                    child: Container(
                      decoration: BoxDecoration(
                        color: themeMainColorData.colorScheme.background,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(4),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "Güncelle",
                        style: GoogleFonts.nunito(
                          textStyle:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
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
