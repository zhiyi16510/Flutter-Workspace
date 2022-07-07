import 'dart:convert';
import '../models/tutors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:lab_assignment_2/constants.dart';
import 'package:ndialog/ndialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'models/tutors.dart';

class tutorsList extends StatefulWidget {
  const tutorsList({Key? key}) : super(key: key);

  @override
  State<tutorsList> createState() => _tutorsListState();
}

class _tutorsListState extends State<tutorsList> {
  List<Tutors> tutorList = <Tutors>[];
  var numofpage, curpage = 1;
  var _tapPosition;
  var color;
  String titlecenter = "Loading...";
  String search = "";
  late double screenHeight, screenWidth, resWidth;

  @override
  void initState() {
    super.initState();
    loadTutors(1, search);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth * 0.75;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tutors'),
      ),
      body: tutorList.isEmpty
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
                      children: List.generate(tutorList.length, (index) {
                        return InkWell(
                          splashColor: Colors.amber,
                          onTap: () => {loadTutorsDetails(index)},
                          child: Card(
                              shadowColor: Color.fromARGB(255, 108, 203, 177),
                              elevation: 10,
                              color: Color.fromARGB(255, 65, 149, 54),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Flexible(
                                    flex: 5,
                                    child: CachedNetworkImage(
                                      imageUrl: CONSTANTS.server +
                                          "/my_tutor/assets/tutors/" +
                                          tutorList[index].tutor_id.toString() +
                                          '.jpg',
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
                                            tutorList[index]
                                                .tutor_name
                                                .toString(),
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "\n" +
                                                tutorList[index]
                                                    .tutor_description
                                                    .toString(),
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          Text(
                                            tutorList[index]
                                                .tutor_phone
                                                .toString(),
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          Text(
                                            tutorList[index]
                                                .tutor_email
                                                .toString(),
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ],
                                      ))
                                ],
                              )),
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
                      width: 40,
                      child: TextButton(
                          onPressed: () => {loadTutors(index + 1, "")},
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

  void loadTutors(int pageno, String _search) {
    curpage = pageno;
    numofpage ?? 1;
    http.post(Uri.parse(CONSTANTS.server + "/my_tutor/php/tutors.php"), body: {
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

        if (extractdata['tutors'] != null) {
          tutorList = <Tutors>[];
          extractdata['tutors'].forEach((v) {
            tutorList.add(Tutors.fromJson(v));
          });
        } else {
          titlecenter = "No Tutor Available";
        }
        setState(() {});
      } else {
        //do something
      }
    });
  }

  loadTutorsDetails(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text(
              "Tutor's Details",
              style: TextStyle(),
            ),
            content: SingleChildScrollView(
                child: Column(
              children: [
                Text(
                  tutorList[index].tutor_name.toString(),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text("Tutor Description: ",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(tutorList[index].tutor_description.toString()),
                  const Text("\nPhone Number: ",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(tutorList[index].tutor_phone.toString()),
                  const Text("\nEmail Address: ",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(tutorList[index].tutor_email.toString()),
                  const Text("\nAvailable Course: ",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(tutorList[index].tutor_course.toString()),
                ])
              ],
            )),
            actions: [
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
}
