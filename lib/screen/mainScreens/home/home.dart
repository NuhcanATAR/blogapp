import 'package:flutter/material.dart';

// pub dev
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kartal/kartal.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:cached_network_image_builder/cached_network_image_builder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// routers page
import 'package:blog/theme/theme.dart';
import 'package:blog/screen/mainScreens/categorys/do%C4%9Fa/doga.dart';
import 'package:blog/screen/mainScreens/categorys/futbol/futbol.dart';
import 'package:blog/screen/mainScreens/categorys/spor/spor.dart';
import 'package:blog/screen/mainScreens/categorys/tar%C4%B1m/tarim.dart';
import 'package:blog/screen/mainScreens/categorys/yapi/yapi.dart';
import 'package:blog/screen/mainScreens/categorys/yaris/yaris.dart';
import 'package:blog/screen/mainScreens/profile/profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    const MaterialApp(
      home: home(),
    ),
  );
}

// ignore: camel_case_types
class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

// ignore: camel_case_types
class _homeState extends State<home> {
  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    final _usersStream = FirebaseFirestore.instance
        .collection('registers')
        .where("userid", isEqualTo: FirebaseAuth.instance.currentUser!.uid);
    // ignore: no_leading_underscores_for_local_identifiers
    final Stream<QuerySnapshot> _blogs =
        FirebaseFirestore.instance.collection('blogs').snapshots();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: StreamBuilder<QuerySnapshot>(
          stream: _usersStream.snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Hata Oluştu!');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadingAnimationWidget.beat(
                  color: themeMainColorData.colorScheme.background, size: 25);
            }

            return Row(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const profileScreen(),
                          ),
                        );
                      },
                      child: SizedBox(
                          width: 45,
                          height: 45,
                          child: CachedNetworkImageBuilder(
                            url: data['profileimg'],
                            builder: (image) => Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(4),
                                ),
                                image: DecorationImage(
                                  image: FileImage(image),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            placeHolder: LoadingAnimationWidget.beat(
                                color:
                                    themeMainColorData.colorScheme.background,
                                size: 25),
                            errorWidget: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(4),
                                ),
                              ),
                              child: Image.asset(
                                  "assets/image/user/icons8-user-90.png"),
                            ),
                            imageExtensions: const ["jpg", "png"],
                          )),
                    ),
                    const SizedBox(width: 5),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: context.dynamicWidth(0.55),
                          child: Text(
                            "Merhaba",
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
                        SizedBox(
                          width: context.dynamicWidth(0.55),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const profileScreen(),
                                ),
                              );
                            },
                            child: Text(
                              data['username'],
                              style: GoogleFonts.nunito(
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    //Image.network(data['profileimg'])
                  ],
                );
              }).toList(),
            );
          },
        ),
      ),
      body: ListView(
        children: <Widget>[
          const SizedBox(height: 15),
          // top slider
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: context.dynamicHeight(0.35),
            child: StreamBuilder<QuerySnapshot>(
              stream: _blogs,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Hata oluştu?');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return LoadingAnimationWidget.beat(
                      color: themeMainColorData.colorScheme.background,
                      size: 35);
                }

                return ListView(
                  scrollDirection: Axis.horizontal,
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> blogsData =
                        document.data()! as Map<String, dynamic>;
                    return Container(
                      margin: const EdgeInsets.only(left: 5),
                      child: Card(
                        child: SizedBox(
                          width: context.dynamicWidth(0.50),
                          height: context.dynamicHeight(0.35),
                          child: CachedNetworkImageBuilder(
                            url: blogsData['lid'].toString(),
                            builder: (image) => Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(4),
                                ),
                                image: DecorationImage(
                                  image: FileImage(image),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Container(
                                color: Colors.grey.withOpacity(0.2),
                                child: Column(
                                  children: <Widget>[
                                    const Spacer(
                                      flex: 2,
                                    ),
                                    // title
                                    Expanded(
                                      child: SingleChildScrollView(
                                        child: GestureDetector(
                                          onTap: () {
                                            showModalBottomSheet<void>(
                                              enableDrag: false,
                                              isScrollControlled: true,
                                              backgroundColor:
                                                  Colors.transparent,
                                              elevation: 0,
                                              context: context,
                                              builder: (context) => SizedBox(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .height,
                                                child: Scaffold(
                                                  extendBodyBehindAppBar: true,
                                                  appBar: AppBar(
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    shadowColor:
                                                        Colors.transparent,
                                                    elevation: 0,
                                                    toolbarHeight: 110,
                                                    leading: IconButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      icon: const Icon(
                                                        Icons
                                                            .arrow_back_ios_new,
                                                        color: Colors.white,
                                                        size: 22,
                                                      ),
                                                    ),
                                                    centerTitle: true,
                                                    title: Text(
                                                      blogsData['title']
                                                          .toString(),
                                                      style: GoogleFonts.nunito(
                                                        textStyle:
                                                            Theme.of(context)
                                                                .textTheme
                                                                .bodyMedium!
                                                                .copyWith(
                                                          color: Colors.white,
                                                          shadows: [
                                                            const Shadow(
                                                              blurRadius: 10.0,
                                                              color:
                                                                  Colors.black,
                                                              offset: Offset(
                                                                  2.0, 2.0),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  body: SingleChildScrollView(
                                                    child: Column(
                                                      children: <Widget>[
                                                        // top blog lid
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          height: context
                                                              .dynamicHeight(
                                                                  0.35),
                                                          child:
                                                              CachedNetworkImageBuilder(
                                                            url:
                                                                blogsData['lid']
                                                                    .toString(),
                                                            builder: (image) =>
                                                                Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                image:
                                                                    DecorationImage(
                                                                  image:
                                                                      FileImage(
                                                                          image),
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        // body
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 10,
                                                                  right: 10,
                                                                  top: 20),
                                                          child: Column(
                                                            children: <Widget>[
                                                              // title
                                                              SizedBox(
                                                                width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                                child: Text(
                                                                  blogsData[
                                                                      'title'],
                                                                  style:
                                                                      GoogleFonts
                                                                          .nunito(
                                                                    textStyle: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .titleLarge!
                                                                        .copyWith(
                                                                          color:
                                                                              Colors.black,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              // author & date
                                                              SizedBox(
                                                                width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                                child: Row(
                                                                  children: <
                                                                      Widget>[
                                                                    // author
                                                                    const Icon(
                                                                      Icons
                                                                          .account_box,
                                                                      color: Colors
                                                                          .grey,
                                                                      size: 19,
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 5,
                                                                    ),
                                                                    Text(
                                                                      blogsData[
                                                                          'author'],
                                                                      style: GoogleFonts
                                                                          .nunito(
                                                                        textStyle: Theme.of(context)
                                                                            .textTheme
                                                                            .bodyMedium!
                                                                            .copyWith(
                                                                              color: Colors.black54,
                                                                            ),
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 15,
                                                                    ),
                                                                    // date
                                                                    const Icon(
                                                                      Icons
                                                                          .date_range,
                                                                      color: Colors
                                                                          .grey,
                                                                      size: 19,
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 5,
                                                                    ),
                                                                    Text(
                                                                      blogsData[
                                                                          'date'],
                                                                      style: GoogleFonts
                                                                          .nunito(
                                                                        textStyle: Theme.of(context)
                                                                            .textTheme
                                                                            .bodyMedium!
                                                                            .copyWith(
                                                                              color: Colors.black54,
                                                                            ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 20,
                                                              ),
                                                              // explanation
                                                              SizedBox(
                                                                child: Text(
                                                                  blogsData[
                                                                          'explanation']
                                                                      .toString(),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style:
                                                                      GoogleFonts
                                                                          .nunito(
                                                                    textStyle: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .bodyMedium!
                                                                        .copyWith(
                                                                          color:
                                                                              Colors.black,
                                                                          height:
                                                                              2,
                                                                        ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                          child: Text(
                                            blogsData['title'],
                                            style: GoogleFonts.nunito(
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge!
                                                  .copyWith(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // author & date
                                    Expanded(
                                        child: Row(
                                      children: <Widget>[
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        SizedBox(
                                          width: 30,
                                          height: 30,
                                          child: Container(
                                            padding: const EdgeInsets.all(5),
                                            decoration: const BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(125),
                                              ),
                                            ),
                                            child: Image.asset(
                                                "assets/image/user/icons8-user-90.png"),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              // author
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: Text(
                                                  blogsData['author'],
                                                  style: GoogleFonts.nunito(
                                                    textStyle: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium!
                                                        .copyWith(
                                                          color: Colors.white,
                                                        ),
                                                    shadows: [
                                                      const Shadow(
                                                        blurRadius: 10.0,
                                                        color: Colors.black,
                                                        offset:
                                                            Offset(2.0, 2.0),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              // date
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: Text(
                                                  blogsData['date'],
                                                  style: GoogleFonts.nunito(
                                                    textStyle: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall!
                                                        .copyWith(
                                                          color: Colors.white,
                                                        ),
                                                    shadows: [
                                                      const Shadow(
                                                        blurRadius: 10.0,
                                                        color: Colors.black,
                                                        offset:
                                                            Offset(2.0, 2.0),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )),
                                  ],
                                ),
                              ),
                            ),
                            placeHolder: LoadingAnimationWidget.beat(
                                color:
                                    themeMainColorData.colorScheme.background,
                                size: 35),
                            errorWidget: const CircularProgressIndicator(),
                            imageExtensions: const ["jpg", "png"],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          const SizedBox(height: 35),
          // category
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: context.dynamicHeight(0.06),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const dogaCategorysScreen(),
                        ),
                      );
                    },
                    child: Text(
                      "Doğa",
                      style: GoogleFonts.nunito(
                        textStyle:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: Colors.black54,
                                ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const tarimCategoryScreen(),
                        ),
                      );
                    },
                    child: Text(
                      "Tarım",
                      style: GoogleFonts.nunito(
                        textStyle:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: Colors.black54,
                                ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const yapiCategorysScreen(),
                        ),
                      );
                    },
                    child: Text(
                      "Yapı",
                      style: GoogleFonts.nunito(
                        textStyle:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: Colors.black54,
                                ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const futbolCategorysScreen(),
                        ),
                      );
                    },
                    child: Text(
                      "Futbol",
                      style: GoogleFonts.nunito(
                        textStyle:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: Colors.black54,
                                ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const sporCategorysScreen(),
                        ),
                      );
                    },
                    child: Text(
                      "Spor",
                      style: GoogleFonts.nunito(
                        textStyle:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: Colors.black54,
                                ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const yarisCategorysScreen(),
                        ),
                      );
                    },
                    child: Text(
                      "Yarış",
                      style: GoogleFonts.nunito(
                        textStyle:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: Colors.black54,
                                ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // blog list
          Padding(
            padding: const EdgeInsets.all(5),
            child: StreamBuilder<QuerySnapshot>(
              stream: _blogs,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text("Hata Oluştu!");
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return LoadingAnimationWidget.beat(
                      color: themeMainColorData.colorScheme.background,
                      size: 35);
                }

                return Column(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> blogsMainData =
                        document.data()! as Map<String, dynamic>;

                    return Card(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: context.dynamicHeight(0.20),
                        child: Row(
                          children: <Widget>[
                            const SizedBox(
                              width: 5,
                            ),
                            // blog lid image
                            SizedBox(
                              width: 100,
                              height: 100,
                              child: GestureDetector(
                                onTap: () {
                                  showModalBottomSheet<void>(
                                    enableDrag: false,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    elevation: 0,
                                    context: context,
                                    builder: (context) => SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height,
                                      child: Scaffold(
                                        extendBodyBehindAppBar: true,
                                        appBar: AppBar(
                                          backgroundColor: Colors.transparent,
                                          shadowColor: Colors.transparent,
                                          elevation: 0,
                                          toolbarHeight: 110,
                                          leading: IconButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            icon: const Icon(
                                              Icons.arrow_back_ios_new,
                                              color: Colors.white,
                                              size: 22,
                                            ),
                                          ),
                                          centerTitle: true,
                                          title: Text(
                                            blogsMainData['title'].toString(),
                                            style: GoogleFonts.nunito(
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                color: Colors.white,
                                                shadows: [
                                                  const Shadow(
                                                    blurRadius: 10.0,
                                                    color: Colors.black,
                                                    offset: Offset(2.0, 2.0),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        body: SingleChildScrollView(
                                          child: Column(
                                            children: <Widget>[
                                              // top blog lid
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height:
                                                    context.dynamicHeight(0.35),
                                                child:
                                                    CachedNetworkImageBuilder(
                                                  url: blogsMainData['lid']
                                                      .toString(),
                                                  builder: (image) => Container(
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: FileImage(image),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              // body
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10,
                                                    right: 10,
                                                    top: 20),
                                                child: Column(
                                                  children: <Widget>[
                                                    // title
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      child: Text(
                                                        blogsMainData['title'],
                                                        style:
                                                            GoogleFonts.nunito(
                                                          textStyle:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .titleLarge!
                                                                  .copyWith(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    // author & date
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      child: Row(
                                                        children: <Widget>[
                                                          // author
                                                          const Icon(
                                                            Icons.account_box,
                                                            color: Colors.grey,
                                                            size: 19,
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            blogsMainData[
                                                                'author'],
                                                            style: GoogleFonts
                                                                .nunito(
                                                              textStyle: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyMedium!
                                                                  .copyWith(
                                                                    color: Colors
                                                                        .black54,
                                                                  ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 15,
                                                          ),
                                                          // date
                                                          const Icon(
                                                            Icons.date_range,
                                                            color: Colors.grey,
                                                            size: 19,
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            blogsMainData[
                                                                'date'],
                                                            style: GoogleFonts
                                                                .nunito(
                                                              textStyle: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyMedium!
                                                                  .copyWith(
                                                                    color: Colors
                                                                        .black54,
                                                                  ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 20,
                                                    ),
                                                    // explanation
                                                    SizedBox(
                                                      child: Text(
                                                        blogsMainData[
                                                                'explanation']
                                                            .toString(),
                                                        textAlign:
                                                            TextAlign.left,
                                                        style:
                                                            GoogleFonts.nunito(
                                                          textStyle:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyMedium!
                                                                  .copyWith(
                                                                    color: Colors
                                                                        .black,
                                                                    height: 2,
                                                                  ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                child: CachedNetworkImageBuilder(
                                  url: blogsMainData['lid'].toString(),
                                  builder: (image) => Container(
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(4),
                                      ),
                                      image: DecorationImage(
                                        image: FileImage(image),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  placeHolder: LoadingAnimationWidget.beat(
                                      color: themeMainColorData
                                          .colorScheme.background,
                                      size: 25),
                                  errorWidget:
                                      const CircularProgressIndicator(),
                                  imageExtensions: const ["jpg", "png"],
                                ),
                              ),
                            ),
                            // blog details info content
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 15, right: 10, top: 15, bottom: 10),
                                child: Column(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        children: <Widget>[
                                          // category
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Text(
                                              blogsMainData['category']
                                                  .toString(),
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
                                          // title
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: GestureDetector(
                                              onTap: () {
                                                showModalBottomSheet<void>(
                                                  enableDrag: false,
                                                  isScrollControlled: true,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  elevation: 0,
                                                  context: context,
                                                  builder: (context) =>
                                                      SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    height:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .height,
                                                    child: Scaffold(
                                                      extendBodyBehindAppBar:
                                                          true,
                                                      appBar: AppBar(
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        shadowColor:
                                                            Colors.transparent,
                                                        elevation: 0,
                                                        toolbarHeight: 110,
                                                        leading: IconButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          icon: const Icon(
                                                            Icons
                                                                .arrow_back_ios_new,
                                                            color: Colors.white,
                                                            size: 22,
                                                          ),
                                                        ),
                                                        centerTitle: true,
                                                        title: Text(
                                                          blogsMainData['title']
                                                              .toString(),
                                                          style: GoogleFonts
                                                              .nunito(
                                                            textStyle: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyMedium!
                                                                .copyWith(
                                                              color:
                                                                  Colors.white,
                                                              shadows: [
                                                                const Shadow(
                                                                  blurRadius:
                                                                      10.0,
                                                                  color: Colors
                                                                      .black,
                                                                  offset:
                                                                      Offset(
                                                                          2.0,
                                                                          2.0),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      body:
                                                          SingleChildScrollView(
                                                        child: Column(
                                                          children: <Widget>[
                                                            // top blog lid
                                                            SizedBox(
                                                              width:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                              height: context
                                                                  .dynamicHeight(
                                                                      0.35),
                                                              child:
                                                                  CachedNetworkImageBuilder(
                                                                url: blogsMainData[
                                                                        'lid']
                                                                    .toString(),
                                                                builder:
                                                                    (image) =>
                                                                        Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    image:
                                                                        DecorationImage(
                                                                      image: FileImage(
                                                                          image),
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            // body
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 10,
                                                                      right: 10,
                                                                      top: 20),
                                                              child: Column(
                                                                children: <
                                                                    Widget>[
                                                                  // title
                                                                  SizedBox(
                                                                    width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width,
                                                                    child: Text(
                                                                      blogsMainData[
                                                                          'title'],
                                                                      style: GoogleFonts
                                                                          .nunito(
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
                                                                    height: 10,
                                                                  ),
                                                                  // author & date
                                                                  SizedBox(
                                                                    width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width,
                                                                    child: Row(
                                                                      children: <
                                                                          Widget>[
                                                                        // author
                                                                        const Icon(
                                                                          Icons
                                                                              .account_box,
                                                                          color:
                                                                              Colors.grey,
                                                                          size:
                                                                              19,
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              5,
                                                                        ),
                                                                        Text(
                                                                          blogsMainData[
                                                                              'author'],
                                                                          style:
                                                                              GoogleFonts.nunito(
                                                                            textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                                                                  color: Colors.black54,
                                                                                ),
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              15,
                                                                        ),
                                                                        // date
                                                                        const Icon(
                                                                          Icons
                                                                              .date_range,
                                                                          color:
                                                                              Colors.grey,
                                                                          size:
                                                                              19,
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              5,
                                                                        ),
                                                                        Text(
                                                                          blogsMainData[
                                                                              'date'],
                                                                          style:
                                                                              GoogleFonts.nunito(
                                                                            textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                                                                  color: Colors.black54,
                                                                                ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 20,
                                                                  ),
                                                                  // explanation
                                                                  SizedBox(
                                                                    child: Text(
                                                                      blogsMainData[
                                                                              'explanation']
                                                                          .toString(),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left,
                                                                      style: GoogleFonts
                                                                          .nunito(
                                                                        textStyle: Theme.of(context)
                                                                            .textTheme
                                                                            .bodyMedium!
                                                                            .copyWith(
                                                                              color: Colors.black,
                                                                              height: 2,
                                                                            ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Text(
                                                blogsMainData['title']
                                                    .toString(),
                                                style: GoogleFonts.nunito(
                                                  textStyle: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium!
                                                      .copyWith(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(
                                      height: 15,
                                    ),
                                    // author & date
                                    Expanded(
                                      child: Row(
                                        children: <Widget>[
                                          // author
                                          Flexible(
                                            fit: FlexFit.tight,
                                            flex: 1,
                                            child: Row(
                                              children: <Widget>[
                                                const Icon(
                                                  Icons.account_box,
                                                  color: Colors.grey,
                                                  size: 21,
                                                ),
                                                Text(
                                                  blogsMainData['author']
                                                      .toString(),
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
                                            ),
                                          ),
                                          // date
                                          Flexible(
                                            fit: FlexFit.tight,
                                            flex: 1,
                                            child: Row(
                                              children: <Widget>[
                                                const Icon(
                                                  Icons.date_range,
                                                  color: Colors.grey,
                                                  size: 21,
                                                ),
                                                Text(
                                                  blogsMainData['date']
                                                      .toString(),
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
                                            ),
                                          ),
                                        ],
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
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
