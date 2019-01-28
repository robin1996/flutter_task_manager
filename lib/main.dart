import 'dart:async';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainTabBar();
  }
}

// 🤯 Models 🤯

class ToDo {
  String label;
  bool done = false;

  ToDo(this.label);
}

class ToDoList {
  static final ToDoList _toDoList = ToDoList._internal();
  List<ToDo> open = [];
  List<ToDo> closed = [];

  factory ToDoList() {
    return _toDoList;
  }

  ToDoList._internal();

  void newToDo(ToDo toDo) {
    open.add(toDo);
  }

  void moveToDosToClosed() {
    closed.addAll(open.where((toDo) => toDo.done).toList());
    open = open.where((toDo) => !toDo.done).toList();
  }
}

// 👀 Views/Controllers 👀

class MainTabBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Up Next',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: 'VarelaRound',
      ),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.inbox)),
                Tab(icon: Icon(Icons.done_all)),
              ],
            ),
            title: Text('Up Next'),
          ),
          body: TabBarView(
            children: [
              ToDoListPage(),
              ClosedListPage(),
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
  final textEditController = TextEditingController();
  var cleanStarted = DateTime.now();

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
                  Flexible(
                      child: TextField(
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
              itemCount: ToDoList().open.length * 2,
              itemBuilder: (context, index) {
                if (index.isEven) {
                  return CheckboxListTile(
                    value: ToDoList().open[(index / 2).round()].done,
                    title: Text(ToDoList().open[(index / 2).round()].label),
                    onChanged: (bool newValue) {
                      setState(() {
                        ToDoList().open[(index / 2).round()].done = newValue;
                      });
                      _cleanList();
                    },
                  );
                } else {
                  return Divider();
                }
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
        ToDoList().newToDo(ToDo(text));
        textEditController.clear();
      }
    });
  }

  void _cleanList() {
    final startTime = DateTime.now();
    cleanStarted = startTime;
    Timer(Duration(seconds: 2), () {
      if (startTime == cleanStarted) {
        setState(() {
          ToDoList().moveToDosToClosed();
        });
      }
    });
  }
}

class ClosedListPage extends StatefulWidget {
  @override
  _ClosedListPageState createState() => _ClosedListPageState();
}

class _ClosedListPageState extends State<ClosedListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: ToDoList().closed.length * 2,
        itemBuilder: (context, index) {
          if (index.isEven) {
            return ListTile(
              title: Text(ToDoList().closed[(index / 2).round()].label),
              leading: Icon(Icons.done),
            );
          } else {
            return Divider();
          }
        },
      ),
    );
  }
}
