import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/models/catergories_news_model.dart';
import 'package:news_app/models/news_channel_headline_model.dart';
import 'package:news_app/screens/categories_screen.dart';
import 'package:news_app/view_model/news_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum FiltersLits { bbcNews, aryNews, independentNews, reuters, cnn, alJazeera }

class _HomeScreenState extends State<HomeScreen> {
  NewsViewModel newsViewModel = NewsViewModel();
  FiltersLits? selectedMenu;
  final format = DateFormat("MMMM dd, yyyy");
  String name = "bbc-news";
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CategoriesScreen(),
              ),
            );
          },
          icon: Image.asset(
            "assets/images/category_icon.png",
            height: 30,
            width: 30,
          ),
        ),
        title: Text(
          "News",
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700),
        ),
        actions: [
          PopupMenuButton<FiltersLits>(
            onSelected: (FiltersLits item) {
              if (FiltersLits.bbcNews.name == item.name) {
                name = "bbc-news";
              }
              if (FiltersLits.aryNews.name == item.name) {
                name = "ary-news";
              }
              if (FiltersLits.independentNews.name == item.name) {
                name = "independent";
              }
              if (FiltersLits.reuters.name == item.name) {
                name = "reuters";
              }
              if (FiltersLits.cnn.name == item.name) {
                name = "ccn";
              }
              if (FiltersLits.alJazeera.name == item.name) {
                name = "al-jazeera-english";
              }
              setState(() {
                selectedMenu = item;
              });
            },
            icon: const Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
            initialValue: selectedMenu,
            itemBuilder: (context) => <PopupMenuEntry<FiltersLits>>[
              const PopupMenuItem<FiltersLits>(
                value: FiltersLits.bbcNews,
                child: Text("BBC News"),
              ),
              const PopupMenuItem<FiltersLits>(
                value: FiltersLits.independentNews,
                child: Text("Independent News"),
              ),
              const PopupMenuItem<FiltersLits>(
                value: FiltersLits.reuters,
                child: Text("Reuters News"),
              ),
              const PopupMenuItem<FiltersLits>(
                value: FiltersLits.cnn,
                child: Text("CNN News"),
              ),
              const PopupMenuItem<FiltersLits>(
                value: FiltersLits.alJazeera,
                child: Text("Al Jazeera News"),
              ),
              const PopupMenuItem<FiltersLits>(
                value: FiltersLits.aryNews,
                child: Text("Ary News"),
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: height * 0.5,
            width: width,
            child: FutureBuilder<NewsChannelHeadlineModel>(
              future: newsViewModel.fetchNewsHeadlines(name),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: SpinKitCircle(
                      size: 50,
                      color: Colors.blue,
                    ),
                  );
                } else {
                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.articles!.length,
                    itemBuilder: (context, index) {
                      DateTime dateTime = DateTime.parse(snapshot
                          .data!.articles![index].publishedAt
                          .toString());
                      return SizedBox(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: height * 0.02),
                              height: height * 0.6,
                              width: width * 0.9,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.network(
                                  snapshot.data!.articles![index].urlToImage
                                      .toString(),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 20,
                              child: Card(
                                elevation: 5,
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Container(
                                  alignment: Alignment.bottomCenter,
                                  padding: const EdgeInsets.all(15),
                                  height: height * 0.22,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: width * 0.7,
                                        child: Text(
                                          snapshot.data!.articles![index].title
                                              .toString(),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      const Spacer(),
                                      SizedBox(
                                        width: width * 0.7,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              snapshot.data!.articles![index]
                                                  .source!.name
                                                  .toString()
                                                  .toString(),
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              format.format(dateTime),
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: FutureBuilder<CatergoriesNewsModel>(
              future: newsViewModel.fetchCategoryNews("General"),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: SpinKitCircle(
                      size: 50,
                      color: Colors.blue,
                    ),
                  );
                } else {
                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: snapshot.data!.articles!.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      DateTime dateTime = DateTime.parse(snapshot
                          .data!.articles![index].publishedAt
                          .toString());
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.network(
                                snapshot.data!.articles![index].urlToImage
                                    .toString(),
                                fit: BoxFit.cover,
                                height: height * 0.18,
                                width: width * 0.3,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: height * 0.18,
                                padding: const EdgeInsets.only(left: 15),
                                child: Column(
                                  children: [
                                    Text(
                                      snapshot.data!.articles![index].title
                                          .toString(),
                                      maxLines: 3,
                                      style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    const Spacer(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          snapshot.data!.articles![index]
                                              .source!.name
                                              .toString(),
                                          style: GoogleFonts.poppins(
                                              fontSize: 13,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          format.format(dateTime),
                                          style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
