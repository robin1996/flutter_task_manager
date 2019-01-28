import 'dart:async';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UpNext',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: ToDoListPage(title: 'Up Next!'),
    );
  }
}

// 🤯 Models 🤯

class ToDo {
  bool done = false;
  String label;

  ToDo(this.label);
}

// 👀 Views/Controllers 👀

class ToDoListPage extends StatefulWidget {
  final String title;

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  ToDoListPage({Key key, this.title}) : super(key: key);

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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(text: "Up Next!"),
              Tab(text: "Archive")
            ],
          ),
        ),
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
