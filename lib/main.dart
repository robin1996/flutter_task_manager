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
  String description = "";
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
      resizeToAvoidBottomPadding: false,
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
                  ToDo toDo = ToDoList().open[(index / 2).round()];
                  return ListTile(
                    title: Text(toDo.label),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ToDoViewPage(toDo: toDo)),
                      );
                    },
                    trailing: Checkbox(
                      value: toDo.done,
                      onChanged: (bool newValue) {
                        setState(() {
                          toDo.done = newValue;
                        });
                        _cleanList();
                      },
                    ),
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

class ToDoViewPage extends StatefulWidget {
  ToDoViewPage({Key key, this.toDo}) : super(key: key);

  final toDo;

  @override
  _ToDoViewPageState createState() => _ToDoViewPageState();
}

class _ToDoViewPageState extends State<ToDoViewPage> {

  final labelEditController = TextEditingController();
  final descriptionEditController = TextEditingController();

  @override
  void dispose() {
    labelEditController.dispose();
    descriptionEditController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    labelEditController.text = widget.toDo.label;
    descriptionEditController.text = widget.toDo.description;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.toDo.label),
      ),
      body: Column(children: <Widget>[
        Container(
          child: TextField(
            controller: labelEditController,
            cursorColor: Colors.black,
          ),
          padding: EdgeInsets.all(15.0),
        ),
        Flexible(
          child: Container(
            padding: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
            child: TextField(
              cursorColor: Colors.black,
              controller: descriptionEditController,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                labelText: "Description",
              ),
            ),
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            widget.toDo.label = labelEditController.text;
            widget.toDo.description = descriptionEditController.text;
          });
          Navigator.pop(context);
        },
        child: Icon(Icons.save)
      ),
    );
  }
}
