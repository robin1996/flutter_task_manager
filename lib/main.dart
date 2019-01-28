import 'dart:async';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MainTabBar();
  }
}

// 🤯 Models 🤯

class ToDo {
  bool done = false;
  String label;

  ToDo(this.label);
}

// 👀 Views/Controllers 👀

class MainTabBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Up Next',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.inbox)),
                Tab(icon: Icon(Icons.check)),
              ],
            ),
            title: Text('Up Next'),
          ),
          body: TabBarView(
            children: [
              ToDoListPage(),
              Icon(Icons.directions_transit),
            ],
          ),
        ),
      ),
    );
  }
}

class ToDoListPage extends StatefulWidget {
  @override
  _ToDoListPageState createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {
  List<ToDo> toDos = [];
  final textEditController = TextEditingController();

  @override
  void dispose() {
    textEditController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            child: Container(
              child: Row(
                children: <Widget>[
                  Flexible(child: TextField(
                    cursorColor: Colors.black,
                    controller: textEditController,
                  )),
                  Container(
                    child: RaisedButton(
                      onPressed: _addToDo,
                      color: Colors.black,
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          Text(
                            "Add",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      splashColor: Colors.blueGrey.shade900,
                    ),
                    padding: EdgeInsets.only(left: 10.0),
                  ),
                ],
              ),
              padding: EdgeInsets.all(10.0),
              color: Colors.white,
            ),
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(50),
                blurRadius: 10.0,
              ),
            ]),
          ),
          Flexible(
            child: ListView.builder(
              itemCount: toDos.length,
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  value: toDos[index].done,
                  title: Text(toDos[index].label),
                  onChanged: (bool newValue) {
                    setState(() {
                      toDos[index].done = newValue;
                      Timer(Duration(seconds: 2), () {
                        _removeToDo(index);
                      });
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _addToDo() {
    setState(() {
      String text = textEditController.text;
      if (text.isNotEmpty) {
        toDos.add(ToDo(text));
        textEditController.clear();
      }
    });
  }

  void _removeToDo(int index) {
    setState(() {
      toDos.removeAt(index);
    });
  }
}
