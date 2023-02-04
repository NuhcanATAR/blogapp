import 'package:flutter/material.dart';

// pub dev
import 'package:google_fonts/google_fonts.dart';
import 'package:kartal/kartal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// routers page
import '../../../../theme/theme.dart';

// ignore: camel_case_types
class nameSurnameChangeScreen extends StatefulWidget {
  const nameSurnameChangeScreen({super.key});

  @override
  State<nameSurnameChangeScreen> createState() =>
      _nameSurnameChangeScreenState();
}

// ignore: camel_case_types
class _nameSurnameChangeScreenState extends State<nameSurnameChangeScreen> {
  // form key
  final _formUploadKey = GlobalKey<FormState>();

  // controller
  final TextEditingController nameSurname = TextEditingController();

  // validator
  String? nameSurnameVal(String? nameVal) {
    if (nameVal == null || nameVal.isEmpty) {
      return "* Zorunlu Alan";
    } else {
      return null;
    }
  }

  // change database class

  CollectionReference users =
      FirebaseFirestore.instance.collection('registers');

  Future<void> postChangeNameSurname() async {
    users.doc(FirebaseAuth.instance.currentUser!.uid).update({
      "username": nameSurname.text.toString(),
    }).then(
      (value) {
        var alerAccountNameUploadDialog = AlertDialog(
          content: SizedBox(
            height: context.dynamicHeight(0.35),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    width: 110,
                    height: 110,
                    child:
                        Image.asset("assets/image/successful/icons8-ok-96.png"),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "Ad Soyad Güncellendi",
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
                    "Ad Soyad Bilgisi güncellendi!",
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
            context: context,
            builder: (context) => alerAccountNameUploadDialog);
      },
    ).catchError((error) {
      var alerAccountNameErrorUploadDialog = AlertDialog(
        content: SizedBox(
          height: context.dynamicHeight(0.35),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  width: 110,
                  height: 110,
                  child: Image.asset(
                      "assets/image/no_connection/icons8-close-window-96.png"),
                ),
                const SizedBox(height: 15),
                Text(
                  "Güncelleme Başarısız",
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
                  "Hata Oluştu, Tekrar Deneyiniz!",
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
        ),
      );
      showDialog(
          context: context,
          builder: (context) => alerAccountNameErrorUploadDialog);
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
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: themeMainColorData.colorScheme.background,
            size: 21,
          ),
        ),
        title: Text(
          "Ad Soyad Güncelle",
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
                          "Ad Soyad Güncelle",
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
                          "Kullanıcı Adı olarakda bilinen Ad Soyad Bilginizi Güncelleyebilirsiniz.",
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
                            controller: nameSurname,
                            validator: nameSurnameVal,
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
                                Icons.account_box,
                                color: Colors.grey,
                                size: 20,
                              ),
                              hintText: "Ad Soyad",
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
                      postChangeNameSurname();
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
