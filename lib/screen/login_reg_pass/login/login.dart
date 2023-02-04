import 'dart:async';
import 'package:flutter/material.dart';

// pub dev
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:kartal/kartal.dart';
import 'package:cached_network_image_builder/cached_network_image_builder.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

// routers page
import 'package:blog/theme/theme.dart';
import 'package:blog/screen/login_reg_pass/register/register.dart';
import 'package:blog/screen/mainScreens/home/home.dart';
import 'package:blog/screen/login_reg_pass/respass/res_pass.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    const MaterialApp(
      home: login(),
    ),
  );
}

// ignore: camel_case_types
class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

// ignore: camel_case_types
class _loginState extends State<login> with loginForm {
  // remember me
  bool isCheckRemember = false;
  void _loadUserEmailPassword() async {
    try {
      // ignore: no_leading_underscores_for_local_identifiers
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      // ignore: no_leading_underscores_for_local_identifiers
      var _email = _prefs.getString("email") ?? "";
      // ignore: no_leading_underscores_for_local_identifiers
      var _password = _prefs.getString("password") ?? "";
      // ignore: no_leading_underscores_for_local_identifiers
      var _remeberMe = _prefs.getBool("remember_me") ?? false;

      // ignore: avoid_print
      print("Hatırlama: $_remeberMe");
      // ignore: avoid_print
      print("E-mail Adres: $_email");
      // ignore: avoid_print
      print("Şifre: $_password");
      if (_remeberMe) {
        setState(() {
          isCheckRemember = true;
        });
        email.text = _email;
        pass.text = _password;
        // ignore: use_build_context_synchronously
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const loadingRooterHomeScreen(),
            ),
            (Route<dynamic> route) => false);
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  // login control

  Future<void> login() async {
    try {
      // ignore: unused_local_variable
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email.text, password: pass.text);
      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const loadingRooterHomeScreen(),
          ),
          (Route<dynamic> route) => false);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        var alerAccountNotUserDialog = AlertDialog(
          content: SizedBox(
            height: context.dynamicHeight(0.35),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    width: 110,
                    height: 110,
                    child:
                        Image.asset("assets/image/info/icons8-no-user-96.png"),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "Kullanıcı Bulunamadı",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                      textStyle:
                          Theme.of(context).textTheme.titleMedium!.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Girmiş Olduğunuz E-mail Adına Hesap Kayıtlı değil, tekrar deneyiniz.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                      textStyle:
                          Theme.of(context).textTheme.bodyMedium!.copyWith(
                                color: Colors.black54,
                              ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        showDialog(
            context: context, builder: (context) => alerAccountNotUserDialog);
      } else if (e.code == 'wrong-password') {
        var alerAccountPassUserDialog = AlertDialog(
          content: SizedBox(
            height: context.dynamicHeight(0.35),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    width: 110,
                    height: 110,
                    child: Image.asset(
                        "assets/image/info/icons8-forgot-password-96.png"),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "Şifre Hatalı",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                      textStyle:
                          Theme.of(context).textTheme.titleMedium!.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Girmiş Olduğunuz Şİfre Hatalı, tekrar deneyiniz.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                      textStyle:
                          Theme.of(context).textTheme.bodyMedium!.copyWith(
                                color: Colors.black54,
                              ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        showDialog(
            context: context, builder: (context) => alerAccountPassUserDialog);
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  // connection control
  late StreamSubscription subscription;
  bool isControlDevice = false;
  bool isAlertMsg = false;

  @override
  void initState() {
    getControl();
    super.initState();
    _loadUserEmailPassword();
  }

  getControl() => subscription = Connectivity()
          .onConnectivityChanged
          .listen((ConnectivityResult result) async {
        isControlDevice = await InternetConnectionChecker().hasConnection;
        if (!isControlDevice && isAlertMsg == false) {
          showDialogBox();
          setState(() => isAlertMsg = true);
        }
      });

  showDialogBox() => showDialog<void>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: SizedBox(
            height: context.dynamicHeight(0.31),
            child: Column(
              children: <Widget>[
                SizedBox(
                  width: 90,
                  height: 90,
                  child: Image.asset(
                      "assets/image/no_connection/icons8-close-window-96.png"),
                ),
                Text(
                  "Bağlantı Yok",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    textStyle:
                        Theme.of(context).textTheme.titleMedium!.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "İnternet Bağlantınız Yok Lütfen Tekrar Deneyiniz!",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Colors.black54,
                        ),
                  ),
                ),
                Center(
                  child: TextButton(
                    onPressed: () async {
                      Navigator.pop(context, 'Kapat');
                      setState(() => isAlertMsg = false);
                      isControlDevice =
                          await InternetConnectionChecker().hasConnection;
                      if (!isControlDevice && isAlertMsg == false) {
                        showDialogBox();
                        setState(() => isAlertMsg = true);
                      }
                    },
                    child: Text(
                      'Tekrar Dene',
                      style: GoogleFonts.nunito(
                        textStyle: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(
                              color: themeMainColorData.colorScheme.background,
                            ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            // top image
            Flexible(
              fit: FlexFit.tight,
              flex: 1,
              // ignore: sort_child_properties_last
              child: CachedNetworkImageBuilder(
                url:
                    "https://firebasestorage.googleapis.com/v0/b/blogdb-6ac10.appspot.com/o/pexels-photo-3194523.jpg?alt=media&token=cb1c02d3-3331-4ec7-aea1-15e2146c5f1d",
                builder: (image) => Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.elliptical(550, 250),
                      bottomRight: Radius.elliptical(550, 250),
                    ),
                    image: DecorationImage(
                      image: FileImage(image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeHolder: LoadingAnimationWidget.beat(
                    color: themeMainColorData.colorScheme.background, size: 35),
                errorWidget: const CircularProgressIndicator(),
                imageExtensions: const ["jpg", "png"],
              ),
            ),
            Expanded(
              flex: 3,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: context.dynamicHeight(0.05),
                    ),
                    // title & sub title
                    Column(
                      children: <Widget>[
                        // title
                        Text(
                          "Blog'a Hoşgeldiniz",
                          style: GoogleFonts.nunito(
                            textStyle: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(
                                  color:
                                      themeMainColorData.colorScheme.background,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        // sub title
                        Text(
                          "Hesabınıza giriş yapınız",
                          style: GoogleFonts.nunito(
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: Colors.black54,
                                ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                    // input email
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Container(
                        margin: const EdgeInsets.only(left: 15, right: 15),
                        padding: const EdgeInsets.all(5),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 0.5),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(4),
                          ),
                        ),
                        child: TextFormField(
                          controller: email,
                          validator: userMailVal,
                          decoration: InputDecoration(
                            icon: const Icon(
                              Icons.mail,
                              color: Colors.grey,
                              size: 21,
                            ),
                            hintText: "E-mail adresiniz",
                            hintStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: Colors.grey,
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
                    const SizedBox(
                      height: 15,
                    ),
                    // input passsword
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Container(
                        margin: const EdgeInsets.only(left: 15, right: 15),
                        padding: const EdgeInsets.all(5),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 0.5),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(4),
                          ),
                        ),
                        child: TextFormField(
                          obscureText: true,
                          controller: pass,
                          validator: userPassVal,
                          decoration: InputDecoration(
                            icon: const Icon(
                              Icons.password,
                              color: Colors.grey,
                              size: 21,
                            ),
                            hintText: "Kullanıcı Şifreniz",
                            hintStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: Colors.grey,
                                ),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                          ),
                          keyboardType: TextInputType.visiblePassword,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    // remember me & password reset btn
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: <Widget>[
                          // remember me
                          Expanded(
                            child: Row(
                              children: <Widget>[
                                Checkbox(
                                  checkColor: Colors.white,
                                  activeColor:
                                      themeMainColorData.colorScheme.background,
                                  value: isCheckRemember,
                                  onChanged: (bool? value) {
                                    // ignore: avoid_print
                                    print("Handle Rember Me");
                                    isCheckRemember = value!;
                                    SharedPreferences.getInstance().then(
                                      (prefs) {
                                        prefs.setBool("remember_me", value);
                                        prefs.setString('email', email.text);
                                        prefs.setString('password', pass.text);
                                      },
                                    );
                                    setState(() {
                                      isCheckRemember = value;
                                    });
                                  },
                                ),
                                Text(
                                  "Beni Hatırla",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color: Colors.black54,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          // reset pass
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const resPassScreen(),
                                ),
                              );
                            },
                            child: Text(
                              "Şifremi Unuttum",
                              style: GoogleFonts.nunito(
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: themeMainColorData
                                          .colorScheme.background,
                                    ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    // login btn
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: GestureDetector(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            login();
                          }
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
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color: Colors.white,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Container(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              flex: 5,
                              child: Center(
                                child: Text(
                                  "Henüz hesabınız yokmu?",
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
                            ),
                            Expanded(
                              flex: 2,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const register(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Kayıt ol",
                                  style: GoogleFonts.nunito(
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          color: themeMainColorData
                                              .colorScheme.background,
                                        ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// form class
// ignore: camel_case_types
class loginForm {
  // controller
  final TextEditingController email = TextEditingController(); // email
  final TextEditingController pass = TextEditingController(); // password

  // form key
  final _formKey = GlobalKey<FormState>();

  // validator control

  // user email
  String? userMailVal(String? mailVal) {
    if (mailVal == null || mailVal.isEmpty) {
      return "* Zorunlu Alan";
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(mailVal)) {
      return "* Geçersiz Email Adresi";
    }
    return null;
  }

  // user password
  String? userPassVal(String? passVal) {
    if (passVal == null || passVal.isEmpty) {
      return "* Zorunlu Alan";
    } else if (passVal.length < 8) {
      return "* Şifreniz 8 Karakter Üstü Olmalı";
    } else if (!RegExp(
            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
        .hasMatch(passVal)) {
      return "* Şifrenizde (*,Büyük Harf,Sayı) Ekleyiniz";
    }
    return null;
  }
}

// ignore: camel_case_types
class loadingRooterHomeScreen extends StatefulWidget {
  const loadingRooterHomeScreen({super.key});

  @override
  State<loadingRooterHomeScreen> createState() =>
      _loadingRooterHomeScreenState();
}

// ignore: camel_case_types
class _loadingRooterHomeScreenState extends State<loadingRooterHomeScreen> {
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
            builder: (context) => const home(),
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
              "Giriş Yapılıyor",
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
