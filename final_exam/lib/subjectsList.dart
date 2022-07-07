import 'dart:convert';
import '../models/subjects.dart';
import '../models/user.dart';
import '../models/cart.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:ndialog/ndialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'models/subjects.dart';
import 'package:lab_assignment_2/cartScreen.dart';
import 'package:lab_assignment_2/constants.dart';

class subjectsList extends StatefulWidget {
  final User user;
  const subjectsList({Key? key, required this.user}) : super(key: key);

  @override
  State<subjectsList> createState() => _subjectsListState();
}

class _subjectsListState extends State<subjectsList> {
  List<Subjects> subjectList = <Subjects>[];
  var numofpage, curpage = 1;
  var _tapPosition;
  var color;
  TextEditingController searchController = TextEditingController();
  String search = "";
  String titlecenter = "Loading...";
  late double screenHeight, screenWidth, resWidth;
  int cart = 0;

  @override
  void initState() {
    super.initState();
    loadSubjects(1, search);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
      //rowcount=2;
    } else {
      resWidth = screenWidth * 0.75;
      //rowcount=3;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Subjects'),
        actions: [
          IconButton(
            onPressed: () {
              _loadSearchDialog();
            },
            icon: const Icon(Icons.search),
          ),
          TextButton.icon(
            onPressed: () async {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (content) => cartScreen(
                            user: widget.user,
                          )));
              loadSubjects(1, search);
              _loadMyCart();
            },
            icon: const Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
            label: Text(widget.user.cart.toString(),
                style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: subjectList.isEmpty
          ? Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Column(
                children: [
                  Center(
                      child: Text(titlecenter,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold))),
                ],
              ),
            )
          : Column(children: [
              Expanded(
                  child: GridView.count(
                      crossAxisCount: 1,
                      childAspectRatio: (1 / 1),
                      children: List.generate(subjectList.length, (index) {
                        return InkWell(
                          splashColor: Colors.amber,
                          onTap: () => {loadSubjectDetails(index)},
                          child: Card(
                            shadowColor: Color.fromARGB(255, 212, 130, 193),
                            elevation: 10,
                            color: Color.fromARGB(255, 225, 76, 53),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                Flexible(
                                  flex: 5,
                                  fit: FlexFit.loose,
                                  child: CachedNetworkImage(
                                    imageUrl: CONSTANTS.server +
                                        "/my_tutor/assets/courses/" +
                                        subjectList[index]
                                            .subject_id
                                            .toString() +
                                        '.png',
                                    height: screenHeight,
                                    width: resWidth,
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                                Flexible(
                                  flex: 5,
                                  child: Column(
                                    children: [
                                      Text(
                                        subjectList[index]
                                            .subject_name
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        subjectList[index]
                                            .subject_description
                                            .toString(),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      Text(
                                        "\n RM " +
                                            double.parse(subjectList[index]
                                                    .subject_price
                                                    .toString())
                                                .toStringAsFixed(2),
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      Text(
                                        subjectList[index]
                                                .subject_sessions
                                                .toString() +
                                            " sessions",
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      Text(
                                        "Rating: " +
                                            subjectList[index]
                                                .subject_rating
                                                .toString(),
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                    flex: 3,
                                    child: IconButton(
                                        onPressed: () {
                                          _addtocartDialog(index);
                                        },
                                        icon: const Icon(
                                          Icons.add_shopping_cart,
                                          color: Colors.white,
                                        ))),
                              ],
                            ),
                          ),
                        );
                      }))),
              SizedBox(
                height: 30,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: numofpage,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    if ((curpage - 1) == index) {
                      color = Colors.red;
                    } else {
                      color = Colors.black;
                    }
                    return SizedBox(
                      width: 50,
                      child: TextButton(
                          onPressed: () => {loadSubjects(index + 1, "")},
                          child: Text(
                            (index + 1).toString(),
                            style: TextStyle(color: color),
                          )),
                    );
                  },
                ),
              ),
            ]),
    );
  }

  void loadSubjects(int pageno, String _search) {
    curpage = pageno;
    numofpage ?? 1;
    http.post(Uri.parse(CONSTANTS.server + "/my_tutor/php/subjects.php"),
        body: {
          'pageno': pageno.toString(),
          'search': _search,
        }).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    ).then((response) {
      var jsondata = jsonDecode(response.body);

      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        var extractdata = jsondata['data'];
        numofpage = int.parse(jsondata['numofpage']);

        if (extractdata['subjects'] != null) {
          subjectList = <Subjects>[];
          extractdata['subjects'].forEach((v) {
            subjectList.add(Subjects.fromJson(v));
          });
        } else {
          titlecenter = "No Product Available";
        }
        setState(() {});
      } else {
        //do something
      }
    });
  }

  loadSubjectDetails(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text(
              "Subject Details",
              style: TextStyle(),
            ),
            content: SingleChildScrollView(
                child: Column(
              children: [
                Text(
                  subjectList[index].subject_name.toString(),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text("Subject Description: ",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(subjectList[index].subject_description.toString()),
                  const Text("\nPrice: RM ",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(double.parse(subjectList[index].subject_price.toString())
                      .toStringAsFixed(2)),
                  const Text("\nSubject Rating: ",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(subjectList[index].subject_rating.toString() + " units"),
                  const Text("\nSubject Sessions: ",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(subjectList[index].subject_sessions.toString()),
                ])
              ],
            )),
            actions: [
              SizedBox(
                  width: screenWidth / 1,
                  child: ElevatedButton(
                      onPressed: () {
                        _addtocartDialog(index);
                      },
                      child: const Text("Add to cart"))),
              TextButton(
                child: const Text(
                  "Close",
                  style: TextStyle(),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void _loadSearchDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return AlertDialog(
              title: const Text(
                "Search ",
              ),
              content: SizedBox(
                height: screenHeight / 4,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                          labelText: 'Search',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        search = searchController.text;
                        Navigator.of(context).pop();
                        loadSubjects(1, search);
                      },
                      child: const Text("Search"),
                    )
                  ],
                ),
              ),
            );
          });
        });
  }

  void _loadMyCart() {
    http
        .post(Uri.parse(CONSTANTS.server + "/my_tutor/php/load_mycartqty.php"))
        .timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    ).then((response) {
      print(response.body);
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        print(jsondata['data']['carttotal'].toString());
        setState(() {});
      }
    });
  }

  void _addtocartDialog(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text(
              "Add to cart",
            ),
            content: const Text(
                "Are you sure you want to add the subject to your cart?"),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  "Yes",
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  _addtoCart(index);
                },
              ),
              TextButton(
                child: const Text(
                  "No",
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void _addtoCart(int index) {
    http.post(Uri.parse(CONSTANTS.server + "/my_tutor/php/insert_cart.php"),
        body: {
          "email": widget.user.email.toString(),
          "subject_id": subjectList[index].subject_id.toString(),
        }).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    ).then((response) {
      print(response.body);
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        print(jsondata['data']['carttotal'].toString());
        setState(() {
          widget.user.cart = jsondata['data']['carttotal'].toString();
        });
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      }
    });
  }
}
