import 'package:alphabet_list_scroll_view/alphabet_list_scroll_view.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

// Created a class
// Much better if this class is separated
// like creating a folder path <project>/lib/models/<name of the model>.dart
class User {
  final String name;
  final String company;

  User(this.name, this.company);
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<User> userList = [];
  List<Widget> normalList = [];
  List<String> strList = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadJson();
    });
    super.initState();
  }

  loadJson() async {
    var jsonResult;

    // Getting the file path of the JSON and Decoding the file into String
    String data = await rootBundle.loadString('assets/sample.json');
    jsonResult = json.decode(data.toString());

    // OUTPUT : [{name: Jan Salvador Sebastian, company: mclinica}, {name: Harvey sison, company: ateneo}, {name: Juan Dela Cruz, company: null universty}]
    print(jsonResult);

    // We created a loop for adding the `name` and `company` to the USER class
    for (int i = 0; i < jsonResult.length; i++) {
      userList.add(User(jsonResult[i]['name'], jsonResult[i]['company']));
    }

    // Sorting Area
    userList
        .sort((x, y) => x.name.toLowerCase().compareTo(y.name.toLowerCase()));

    // Called the Filter
    filter();
  }

  filter() {
    List<User> users = [];
    normalList = [];

    // We added all the userList to the users. for the passing/getting the specific value.
    users.addAll(userList);

    // Loop
    users.forEach((user) {
      // Since, normalList is an WidgetArray = []
      // Here is the adding of Widget that depends on the lenght of the Array in  `users`
      normalList.add(
        Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          secondaryActions: <Widget>[
            IconSlideAction(
              iconWidget: Icon(Icons.star),
              onTap: () {},
            ),
            IconSlideAction(
              iconWidget: Icon(Icons.more_horiz),
              onTap: () {},
            ),
          ],
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage:
                  NetworkImage("http://placeimg.com/200/200/people"),
            ),
            title: Text(user.name),
            subtitle: Text(user.company),
          ),
        ),
      );
      strList.add(user.name);
      print(strList);
    });

    // SetState to change the Value every time is triggers
    setState(() {
      normalList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: AlphabetListScrollView(
        strList: strList,
        showPreview: true,
        itemBuilder: (context, index) {
          return normalList[index];
        },
        indexedHeight: (i) {
          return 80;
        },
      ),
    );
  }
}
