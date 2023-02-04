import 'package:flutter/material.dart';

// pub dev
import 'package:google_fonts/google_fonts.dart';
import 'package:kartal/kartal.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cached_network_image_builder/cached_network_image_builder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// routers page
import 'package:blog/theme/theme.dart';
import 'namesurname_change/namesurname_change.dart';
import 'password_change/pass_change.dart';
import 'package:blog/screen/login_reg_pass/login/login.dart';
import 'package:blog/screen/mainScreens/home/home.dart';
import 'package:blog/screen/mainScreens/profile/profile_change/profil_img_change.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    const MaterialApp(
      home: profileScreen(),
    ),
  );
}

// ignore: camel_case_types
class profileScreen extends StatefulWidget {
  const profileScreen({super.key});

  @override
  State<profileScreen> createState() => _profileScreenState();
}

// ignore: camel_case_types
class _profileScreenState extends State<profileScreen> {
  // profile information
  final _usersStream = FirebaseFirestore.instance
      .collection('registers')
      .where("userid", isEqualTo: FirebaseAuth.instance.currentUser!.uid);
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
                builder: (context) => const home(),
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
          "Profil",
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                StreamBuilder<QuerySnapshot>(
                  stream: _usersStream.snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Hata Oluştu!');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return LoadingAnimationWidget.beat(
                          color: themeMainColorData.colorScheme.background,
                          size: 25);
                    }

                    return Column(
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        return Column(
                          children: <Widget>[
                            // profile image
                            SizedBox(
                              width: context.dynamicWidth(0.33),
                              height: context.dynamicHeight(0.17),
                              child: CachedNetworkImageBuilder(
                                url: data['profileimg'].toString(),
                                builder: (image) => Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: FileImage(image),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(125),
                                    ),
                                  ),
                                ),
                                placeHolder: LoadingAnimationWidget.beat(
                                    color: themeMainColorData
                                        .colorScheme.background,
                                    size: 35),
                                errorWidget: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(125),
                                    ),
                                  ),
                                  child: Image.asset(
                                      "assets/image/user/icons8-user-90.png"),
                                ),
                                imageExtensions: const ["jpg", "png"],
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            // user name
                            Text(
                              data['username'].toString(),
                              textAlign: TextAlign.center,
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
                            const SizedBox(
                              height: 5,
                            ),
                            // user mail
                            Text(
                              data['usermail'].toString(),
                              textAlign: TextAlign.center,
                              style: GoogleFonts.nunito(
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: Colors.black54,
                                    ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    );
                  },
                ),

                const SizedBox(
                  height: 25,
                ),
                // menu content
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      // user profil image change
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: context.dynamicHeight(0.08),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const profilimgChangeScreen(),
                              ),
                            );
                          },
                          child: Row(
                            children: <Widget>[
                              // icon
                              Icon(
                                Icons.add_a_photo,
                                color:
                                    themeMainColorData.colorScheme.background,
                                size: 22,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              // menu text
                              Expanded(
                                child: Text(
                                  "Profil Resmini Güncelle",
                                  style: GoogleFonts.nunito(
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                          color: Colors.black,
                                        ),
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color:
                                    themeMainColorData.colorScheme.background,
                                size: 22,
                              ),
                            ],
                          ),
                        ),
                      ),
                      // user name & surname change
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: context.dynamicHeight(0.08),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const nameSurnameChangeScreen(),
                              ),
                            );
                          },
                          child: Row(
                            children: <Widget>[
                              // icon
                              Icon(
                                Icons.edit,
                                color:
                                    themeMainColorData.colorScheme.background,
                                size: 22,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              // menu text
                              Expanded(
                                child: Text(
                                  "Ad Soyad Güncelle",
                                  style: GoogleFonts.nunito(
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                          color: Colors.black,
                                        ),
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color:
                                    themeMainColorData.colorScheme.background,
                                size: 22,
                              ),
                            ],
                          ),
                        ),
                      ),
                      // user password change
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: context.dynamicHeight(0.08),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const passChangeScreen(),
                              ),
                            );
                          },
                          child: Row(
                            children: <Widget>[
                              // icon
                              Icon(
                                Icons.password,
                                color:
                                    themeMainColorData.colorScheme.background,
                                size: 22,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              // menu text
                              Expanded(
                                child: Text(
                                  "Şifre Güncelle",
                                  style: GoogleFonts.nunito(
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                          color: Colors.black,
                                        ),
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color:
                                    themeMainColorData.colorScheme.background,
                                size: 22,
                              ),
                            ],
                          ),
                        ),
                      ),
                      // user quit account
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: context.dynamicHeight(0.08),
                        child: GestureDetector(
                          onTap: () async {
                            FirebaseAuth.instance.signOut();
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const login(),
                                ),
                                (Route<dynamic> route) => false);
                          },
                          child: Row(
                            children: <Widget>[
                              // icon
                              const Icon(
                                Icons.exit_to_app,
                                color: Colors.redAccent,
                                size: 22,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              // menu text
                              Expanded(
                                child: Text(
                                  "Çıkış Yap",
                                  style: GoogleFonts.nunito(
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                          color: Colors.black,
                                        ),
                                  ),
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.redAccent,
                                size: 22,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
