import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app/api/data_news_api.dart';
import 'package:flutter_app/model/news_api_model.dart';
import 'package:flutter_app/screen/details_news.dart';
import 'package:flutter_app/utilities/extenion.dart';

class WhatsNew extends StatefulWidget {
  @override
  _WhatsNewState createState() => _WhatsNewState();
}

class _WhatsNewState extends State<WhatsNew> {
  DataNewsApi newsApi = DataNewsApi();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.grey.shade100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildTopStories(),
            _buildRecentUpdate(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.25,
      child: FutureBuilder(
        future: newsApi.fetchAllDataTopStories(country: 'us'),
        // ignore: missing_return
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return connectionError();
            case ConnectionState.waiting:
              return loading();
            case ConnectionState.active:
              return loading();
            case ConnectionState.done:
              if (snapshot.hasError) {
                return errorInData(snapshot.error);
              } else {
                if (snapshot.hasData) {
                  List<NewsTopHeadlinesModel> topModel = snapshot.data;
                  NewsTopHeadlinesModel model =
                      topModel[Random.secure().nextInt(topModel.length)];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return DetailsNews(model);
                          },
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(model.urlToImage),
                        ),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 64, right: 64),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                model.title,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                model.description,
                                style: TextStyle(
                                  color: Colors.lime,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 3,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  noData();
                }
              }
          }
        },
      ),
    );
  }

  Widget _buildTopStories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 20,
            top: 8,
          ),
          child: Text(
            'Top Stories',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
              fontSize: 14,
            ),
          ),
        ),
        Card(
          margin: EdgeInsets.all(8),
          elevation: 5,
          child: FutureBuilder(
            future: newsApi.fetchAllDataTopStories(country: 'us'),
            // ignore: missing_return
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return connectionError();
                  break;
                case ConnectionState.waiting:
                  return loading();
                  break;
                case ConnectionState.active:
                  return loading();
                  break;
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    return errorInData(snapshot.error);
                  } else {
                    if (snapshot.hasData) {
                      List<NewsTopHeadlinesModel> model = snapshot.data;
                      // NewsTopHeadlinesModel data1 =
                      //     model[Random.secure().nextInt(model.length)];
                      // NewsTopHeadlinesModel data2 =
                      //     model[Random.secure().nextInt(model.length)];
                      // NewsTopHeadlinesModel data3 =
                      //     model[Random.secure().nextInt(model.length)];
                      if (model.length >= 5) {
                        return Column(
                          children: [
                            _topStoriesItem(model[2]),
                            _buildDivider(),
                            _topStoriesItem(model[5]),
                            _buildDivider(),
                            _topStoriesItem(model[4]),
                          ],
                        );
                      }
                    } else {
                      return noData();
                    }
                  }
                  break;
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _topStoriesItem(NewsTopHeadlinesModel model) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return DetailsNews(model);
            },
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.25,
                height: MediaQuery.of(context).size.height * 0.11,
                child: Image.network(
                  model.urlToImage,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.04,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          model.author.length <= 7
                              ? model.author
                              : model.author.substring(0, 7),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                          maxLines: 1,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              color: Colors.grey,
                              size: 14,
                            ),
                            Text(
                              '15 min',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: double.infinity,
      height: 1.5,
      color: Colors.grey.shade100,
    );
  }

  Widget _buildRecentUpdate() {
    return FutureBuilder(
      future: newsApi.fetchAllDataTopStories(country: 'us'),
      // ignore: missing_return
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return connectionError();
            break;
          case ConnectionState.waiting:
            return loading();
            break;
          case ConnectionState.active:
            return loading();
            break;
          case ConnectionState.done:
            if (snapshot.hasError) {
              return errorInData(snapshot.error);
            } else {
              if (snapshot.hasData) {
                List<NewsTopHeadlinesModel> model = snapshot.data;
                // NewsTopHeadlinesModel sources1 =
                //     model[Random.secure().nextInt(model.length)];
                // NewsTopHeadlinesModel sources2 =
                //     model[Random.secure().nextInt(model.length)];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        top: 20,
                      ),
                      child: Text(
                        'Recent Updates',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    _recentUpdateItem(model[0], Colors.deepOrange.shade700),
                    _recentUpdateItem(model[1], Colors.lime.shade700),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                );
              } else {
                return noData();
              }
            }
            break;
        }
      },
    );
  }

  Widget _recentUpdateItem(NewsTopHeadlinesModel topModel, Color color) {
    return Card(
      margin: EdgeInsets.all(8),
      elevation: 5,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return DetailsNews(topModel);
              },
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.20,
              child: Image(
                image: NetworkImage(topModel.urlToImage),
                fit: BoxFit.fill,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 8, left: 8),
              width: 75,
              height: 15,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(3),
              ),
              child: Text(
                topModel.author,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, top: 4),
              child: Text(
                topModel.title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, top: 4, bottom: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.access_time,
                    color: Colors.grey,
                    size: 14,
                  ),
                  Text(
                    '15 min',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
