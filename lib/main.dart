import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: QuiteApp(),
    );
  }
}

class QuiteApp extends StatelessWidget {
  const QuiteApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CatModel>(
        create: (BuildContext context) => CatModel(),
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Cat Images"),
            actions: [
              Consumer<CatModel>(
                builder: (context, val, child) {
                  return IconButton(
                      onPressed: () {
                        val.fetchdata();
                        print(val.imgurl);
                      },
                      icon: const Icon(Icons.refresh_rounded));
                },
              )
            ],
          ),
          body: Column(
            children: [
              Container(
                  padding: EdgeInsets.all(10),
                  margin: const EdgeInsets.all(8),
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: Consumer<CatModel>(
                    builder: (context, val, child) {
                      return val.imgurl.isEmpty
                          ? Image.network(
                              "https://cdn2.thecatapi.com/images/4g2.gif")
                          : Image.network(val.imgurl);
                    },
                  )),
              SizedBox(
                height: 10,
              ),
              Consumer<CatModel>(builder: (context, val, child) {
                return val.res?.data[0]['id'].toString == null
                    ? Text("Image id: 4g2")
                    : Text("Image id: ${val.res?.data[0]['id']}");
              }),
              SizedBox(
                height: 10,
              ),
              Consumer<CatModel>(builder: (context, val, child) {
                return val.res?.data[0]['id'].toString == null
                    ? Text("Image height: 400")
                    : Text("Image height: ${val.res?.data[0]['height']}");
              }),
              SizedBox(
                height: 10,
              ),
              Consumer<CatModel>(builder: (context, val, child) {
                return val.res?.data[0]['id'].toString == null
                    ? Text("Image width: 600")
                    : Text("Image width: ${val.res?.data[0]['width']}");
              }),
            ],
          ),
        ));
  }
}

class CatModel with ChangeNotifier {
  String imgurl = "";
  var res;
  Future<void> fetchdata() async {
    var dio = Dio();
    try {
      var response =
          await dio.get("https://api.thecatapi.com/v1/images/search");
      imgurl = response.data[0]['url'];
      res = response;
      notifyListeners();
      print(response);
    } catch (err) {
      print(err);
    }
  }
}
