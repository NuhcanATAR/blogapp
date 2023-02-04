import 'dart:io';
import 'package:flutter/material.dart';

// pub dev
import 'package:google_fonts/google_fonts.dart';
import 'package:kartal/kartal.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image_builder/cached_network_image_builder.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

// routers page
import '../../../theme/theme.dart';
import 'package:blog/screen/login_reg_pass/login/login.dart';
import 'package:blog/screen/login_reg_pass/register/register_msg.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MaterialApp(
    home: register(),
  ));
}

// ignore: camel_case_types
class register extends StatefulWidget {
  const register({super.key});

  @override
  State<register> createState() => _registerState();
}

// ignore: camel_case_types
class _registerState extends State<register> with registerForm {
  final ImagePicker _picker = ImagePicker();
  // ignore: prefer_typing_uninitialized_variables
  var _profileimage;
  String mountainsRefurl = "";

  Future<void> userRegister() async {
    //
    try {
      if (_profileimage == null) {
        mountainsRefurl = ' ';
      } else {
        final storageRef = FirebaseStorage.instance.ref();
        final mountainsRef =
            storageRef.child(_profileimage.toString()).putFile(_profileimage);
        mountainsRefurl = await (await mountainsRef).ref.getDownloadURL();
      }
      // ignore: unused_local_variable
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: regemail.text, password: regpass.value.text)
          .then((valueReg) async {
        throw FirebaseFirestore.instance
            .collection("registers")
            .doc(FirebaseAuth.instance.currentUser!.uid.toString())
            .set({
          "profileimg": mountainsRefurl.toString(),
          "username": regname.text,
          "usermail": regemail.text,
          "userpass": regpass.text,
          "userid": FirebaseAuth.instance.currentUser!.uid.toString(),
        }).whenComplete(() {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const registerLoadingRouter(),
              ),
              (Route<dynamic> route) => false);
        });
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        var alerAccountPassDialog = AlertDialog(
          content: SizedBox(
            height: context.dynamicHeight(0.35),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    width: 110,
                    height: 110,
                    child: Image.asset("assets/image/info/icons8-info-100.png"),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "Parolanız Çok Zayıf",
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
                    "Girmiş Olduğunuz Parola Zayıf, tekrar deneyiniz.",
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
            context: context, builder: (context) => alerAccountPassDialog);
      } else if (e.code == 'email-already-in-use') {
        var alerAccountMailDialog = AlertDialog(
          content: SizedBox(
            height: context.dynamicHeight(0.35),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    width: 110,
                    height: 110,
                    child: Image.asset("assets/image/info/icons8-info-100.png"),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "E-mail Adresi Kullanılıyor",
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
                    "Girmiş Olduğunuz E-mail Adresi Kullanımda, başka bir e-mail adresi giriniz.",
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
            context: context, builder: (context) => alerAccountMailDialog);
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  Future getImage() async {
    final XFile? resimage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (resimage == null) return null;

    final imageTemprary = File(resimage.path);

    setState(() {
      _profileimage = imageTemprary;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formRegKey,
        child: Column(
          children: <Widget>[
            // top image
            _buildTopContent,
            Expanded(
              flex: 3,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: context.dynamicHeight(0.12),
                    ),
                    // user name & surname
                    _buildUserName,
                    const SizedBox(
                      height: 15,
                    ),
                    // input email
                    _buildUserMail,
                    const SizedBox(
                      height: 15,
                    ),
                    // input passsword
                    _buildUserPassword,
                    const SizedBox(
                      height: 15,
                    ),
                    // register btn
                    _buildUserRegisterBtn,
                    const SizedBox(
                      height: 55,
                    ),
                    // login btn
                    _buildLoginBtn,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // top content
  Widget get _buildTopContent => Flexible(
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
            child: Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                Positioned(
                  bottom: -55,
                  left: 120,
                  right: 120,
                  child: SizedBox(
                    width: 120,
                    height: 120,
                    child: _profileimage == null
                        ? Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.9),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(125),
                              ),
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.photo,
                                color: Colors.white,
                                size: 26,
                              ),
                              onPressed: () {
                                getImage();
                              },
                            ),
                          )
                        : Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.9),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(125),
                              ),
                              image: DecorationImage(
                                image: FileImage(_profileimage!),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.3),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(125),
                                ),
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.photo,
                                  color: Colors.white,
                                  size: 26,
                                ),
                                onPressed: () {
                                  getImage();
                                },
                              ),
                            )),
                  ),
                )
              ],
            ),
          ),
          placeHolder: LoadingAnimationWidget.beat(
              color: themeMainColorData.colorScheme.background, size: 35),
          errorWidget: const CircularProgressIndicator(),
          imageExtensions: const ["jpg", "png"],
        ),
      );

  // user name & surname
  Widget get _buildUserName => SizedBox(
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
            controller: regname,
            validator: reguserNameVal,
            decoration: InputDecoration(
              icon: const Icon(
                Icons.account_circle,
                color: Colors.grey,
                size: 21,
              ),
              hintText: "Adınız Soyadınız",
              hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Colors.grey,
                  ),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
            ),
          ),
        ),
      );

  // user mail
  Widget get _buildUserMail => SizedBox(
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
            controller: regemail,
            validator: reguserMailVal,
            decoration: InputDecoration(
              icon: const Icon(
                Icons.mail,
                color: Colors.grey,
                size: 21,
              ),
              hintText: "E-mail adresiniz",
              hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
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
      );

  // user password
  Widget get _buildUserPassword => SizedBox(
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
            controller: regpass,
            validator: reguserPassVal,
            decoration: InputDecoration(
              icon: const Icon(
                Icons.password,
                color: Colors.grey,
                size: 21,
              ),
              hintText: "Kullanıcı Şifreniz",
              hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
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
      );

  // user register button
  Widget get _buildUserRegisterBtn => Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: GestureDetector(
          onTap: () {
            if (_formRegKey.currentState!.validate()) {
              userRegister();
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
                "Kayıt ol",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
          ),
        ),
      );

  // user route login screen button
  Widget get _buildLoginBtn => SizedBox(
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
                    "Hesabınız varmı?",
                    style: GoogleFonts.nunito(
                      textStyle:
                          Theme.of(context).textTheme.bodyMedium!.copyWith(
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
                        builder: (context) => const login(),
                      ),
                    );
                  },
                  child: Text(
                    "Giriş yap",
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
      );
}

// ignore: camel_case_types
class registerForm {
  // controller
  final TextEditingController regname = TextEditingController(); // email
  final TextEditingController regemail = TextEditingController(); // email
  final TextEditingController regpass = TextEditingController(); // password

  // form key
  // ignore: unused_field
  final _formRegKey = GlobalKey<FormState>();

  // validator control

  // user name & Surname
  String? reguserNameVal(String? regNameVal) {
    if (regNameVal == null || regNameVal.isEmpty) {
      return "* Zorunlu Alan";
    } else if (regNameVal.length > 15) {
      return "* 15 Karakterden Kısa Olmalı";
    }
    return null;
  }

  // user email
  String? reguserMailVal(String? regmailVal) {
    if (regmailVal == null || regmailVal.isEmpty) {
      return "* Zorunlu Alan";
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(regmailVal)) {
      return "* Geçersiz Email Adresi";
    }
    return null;
  }

  // user password
  String? reguserPassVal(String? regpassVal) {
    if (regpassVal == null || regpassVal.isEmpty) {
      return "* Zorunlu Alan";
    } else if (regpassVal.length < 8) {
      return "* Şifreniz 8 Karakter Üstü Olmalı";
    } else if (!RegExp(
            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
        .hasMatch(regpassVal)) {
      return "* Şifrenizde (*,Büyük Harf,Sayı) Ekleyiniz";
    }
    return null;
  }
}
