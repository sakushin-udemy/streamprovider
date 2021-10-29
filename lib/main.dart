import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:streamprovider/repository/MessageDao.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/message.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ProviderScope(
      child: const MyApp(),
    ),
  );
}

var EMPTY = Message(name: '', message: '', dateTime: DateTime(1));

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  MessageDao _messageDao = MessageDao();

  late StreamProvider streamProvider;

  @override
  void initState() {
    streamProvider = StreamProvider<List<Message>>((ref) {
      return _messageDao
          .getSnapshots()
          .map((e) => e.docs.map((msg) => convert(msg.data())).toList());
    });
  }

  Message convert(Object? obj) {
    if (obj == null) {
      return EMPTY;
    }

    var map = obj as Map<String, dynamic>;
    return Message.fromJson(map);
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });

    Message message = Message(
      name: 'name',
      message: _counter.toString(),
      dateTime: DateTime.now(),
    );
    _messageDao.saveMessage(message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headline4,
              ),
              Consumer(
                builder: (context, ref, child) {
                  final provider = ref.watch(streamProvider);
                  return provider.when(
                      data: (messages) {
                        return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              Message item = messages[index];
                              return Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: ListTile(
                                  title: Text('${item.dateTime}'),
                                  trailing: Text(item.message),
                                  tileColor: Colors.lightBlueAccent,
                                ),
                              );
                            });
                      },
                      error: (error, stack, data) => Text('Error: $error'),
                      loading: (data) => const CircularProgressIndicator());
                },
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
