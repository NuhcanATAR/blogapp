import 'package:flutter/material.dart';

// pub dev
import 'package:google_fonts/google_fonts.dart';
import 'package:kartal/kartal.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cached_network_image_builder/cached_network_image_builder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// router pages
import '../../../../theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    const MaterialApp(
      home: tarimCategoryScreen(),
    ),
  );
}

// ignore: camel_case_types
class tarimCategoryScreen extends StatefulWidget {
  const tarimCategoryScreen({super.key});

  @override
  State<tarimCategoryScreen> createState() => _tarimCategoryScreenState();
}

// ignore: camel_case_types
class _tarimCategoryScreenState extends State<tarimCategoryScreen> {
  // doga category
  Query<Map<String, dynamic>> collectionReference = FirebaseFirestore.instance
      .collection("blogs")
      .where("category", isEqualTo: "Tarım");
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
          "Tarım Kategorisi",
          style: GoogleFonts.nunito(
            textStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: themeMainColorData.colorScheme.background,
                ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: collectionReference.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Hata Oluştu!');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingAnimationWidget.beat(
                color: themeMainColorData.colorScheme.background, size: 25);
          }
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
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
                                height: MediaQuery.of(context).size.height,
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
                                      data['title'].toString(),
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
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: context.dynamicHeight(0.35),
                                          child: CachedNetworkImageBuilder(
                                            url: data['lid'].toString(),
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
                                              left: 10, right: 10, top: 20),
                                          child: Column(
                                            children: <Widget>[
                                              // title
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: Text(
                                                  data['title'],
                                                  style: GoogleFonts.nunito(
                                                    textStyle: Theme.of(context)
                                                        .textTheme
                                                        .titleLarge!
                                                        .copyWith(
                                                          color: Colors.black,
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
                                                width: MediaQuery.of(context)
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
                                                      data['author'],
                                                      style: GoogleFonts.nunito(
                                                        textStyle:
                                                            Theme.of(context)
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
                                                      data['date'],
                                                      style: GoogleFonts.nunito(
                                                        textStyle:
                                                            Theme.of(context)
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
                                                  data['explanation']
                                                      .toString(),
                                                  textAlign: TextAlign.left,
                                                  style: GoogleFonts.nunito(
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
                          child: CachedNetworkImageBuilder(
                            url: data['lid'].toString(),
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
                            errorWidget: const CircularProgressIndicator(),
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
                                      width: MediaQuery.of(context).size.width,
                                      child: Text(
                                        data['category'].toString(),
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
                                      width: MediaQuery.of(context).size.width,
                                      child: GestureDetector(
                                        onTap: () {
                                          showModalBottomSheet<void>(
                                            enableDrag: false,
                                            isScrollControlled: true,
                                            backgroundColor: Colors.transparent,
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
                                                      Icons.arrow_back_ios_new,
                                                      color: Colors.white,
                                                      size: 22,
                                                    ),
                                                  ),
                                                  centerTitle: true,
                                                  title: Text(
                                                    data['title'].toString(),
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
                                                            color: Colors.black,
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
                                                          url: data['lid']
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
                                                              width:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                              child: Text(
                                                                data['title'],
                                                                style:
                                                                    GoogleFonts
                                                                        .nunito(
                                                                  textStyle: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .titleLarge!
                                                                      .copyWith(
                                                                        color: Colors
                                                                            .black,
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
                                                              width:
                                                                  MediaQuery.of(
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
                                                                    data[
                                                                        'author'],
                                                                    style: GoogleFonts
                                                                        .nunito(
                                                                      textStyle: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .bodyMedium!
                                                                          .copyWith(
                                                                            color:
                                                                                Colors.black54,
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
                                                                    data[
                                                                        'date'],
                                                                    style: GoogleFonts
                                                                        .nunito(
                                                                      textStyle: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .bodyMedium!
                                                                          .copyWith(
                                                                            color:
                                                                                Colors.black54,
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
                                                                data['explanation']
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
                                                                        color: Colors
                                                                            .black,
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
                                          data['title'].toString(),
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
                                            data['author'].toString(),
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
                                            data['date'].toString(),
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
    );
  }
}
