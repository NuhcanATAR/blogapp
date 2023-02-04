import 'dart:io';
import 'package:flutter/material.dart';

// pub dev
import 'package:google_fonts/google_fonts.dart';
import 'package:kartal/kartal.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

// routers page
import '../../../../theme/theme.dart';

// ignore: camel_case_types
class profilimgChangeScreen extends StatefulWidget {
  const profilimgChangeScreen({super.key});

  @override
  State<profilimgChangeScreen> createState() => _profilimgChangeScreenState();
}

// ignore: camel_case_types
class _profilimgChangeScreenState extends State<profilimgChangeScreen> {
  final ImagePicker _picker = ImagePicker();
  // ignore: prefer_typing_uninitialized_variables
  var _profileimg;
  String mountainsUpdateRefurl = "";

  Future postImage() async {
    final XFile? profileimg =
        await _picker.pickImage(source: ImageSource.gallery);
    if (profileimg == null) return null;

    final imageTemprary = File(profileimg.path);

    setState(() {
      _profileimg = imageTemprary;
    });
  }

  // database

  CollectionReference users =
      FirebaseFirestore.instance.collection('registers');

  Future<void> postUploadimg() async {
    if (_profileimg == null) {
      mountainsUpdateRefurl = " ";
    } else {
      final storageRef = FirebaseStorage.instance.ref();
      final mountainsRef =
          storageRef.child(_profileimg.toString()).putFile(_profileimg);
      mountainsUpdateRefurl = await (await mountainsRef).ref.getDownloadURL();

      users.doc(FirebaseAuth.instance.currentUser!.uid).update({
        'profileimg': mountainsUpdateRefurl.toString(),
      }).then((value) {
        var alerAccountUploadDialog = AlertDialog(
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
                    "Profil Resmi Güncellendi",
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
                    "Kullanıcı Profil resminiz başarıyla güncellendi.",
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
            context: context, builder: (context) => alerAccountUploadDialog);
      }).catchError((error) {
        var alerAccountErrorDialog = AlertDialog(
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
                    "Profil Resmi Güncellenemedi",
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
                    "Lütfen Tekrar Deneyiniz!",
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
            context: context, builder: (context) => alerAccountErrorDialog);
      });
    }
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
          "Profil Resmi Güncelle",
          style: GoogleFonts.nunito(
            textStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: themeMainColorData.colorScheme.background,
                ),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          // body
          Expanded(
            flex: 7,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 35,
                  ),
                  // text
                  Text(
                    "Profil Resminizi \nYükleyiniz!",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                      textStyle:
                          Theme.of(context).textTheme.titleLarge!.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  // image
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: _profileimg == null
                        ? Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.3),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(125),
                              ),
                            ),
                            child: Center(
                              child: IconButton(
                                onPressed: () {
                                  postImage();
                                },
                                icon: const Icon(
                                  Icons.add_photo_alternate,
                                  color: Colors.black54,
                                  size: 30,
                                ),
                              ),
                            ),
                          )
                        : Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.6),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(125),
                              ),
                              image: DecorationImage(
                                image: FileImage(_profileimg!),
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
                                  postImage();
                                },
                              ),
                            )),
                  ),
                ],
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
                  postUploadimg();
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
    );
  }
}
