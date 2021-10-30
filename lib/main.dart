import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streamprovider/repository/count_data_dao.dart';

import 'data/count_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ProviderScope(child: const MyApp()));
}

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
  CountDataDao _countDataDao = CountDataDao();
  late StreamProvider _streamProvider;

  @override
  void initState() {
    _streamProvider = StreamProvider<List<CountData>>((ref) => _countDataDao
        .getSnapshots()
        .map((e) => e.docs.map((data) => _convert(data.data())).toList()));
  }

  CountData _convert(Object? obj) {
    if (obj == null) {
      return CountData(dateTime: DateTime.now(), count: -1);
    }

    var map = obj as Map<String, dynamic>;
    return CountData.fromJson(map);
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });

    CountData countData = CountData(
      dateTime: DateTime.now(),
      count: _counter,
    );
    _countDataDao.saveCountData(countData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
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
            Consumer(builder: (context, ref, child) {
              final provider = ref.watch(_streamProvider);
              return provider.when(
                  loading: (data) => const CircularProgressIndicator(),
                  error: (error, stack, data) => Text('Error: $error'),
                  data: (data) {
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          CountData countData = data[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: Text('${countData.dateTime}'),
                              trailing: Text('${countData.count}'),
                              tileColor: Colors.lightBlueAccent,
                            ),
                          );
                        });
                  });
            }),
          ],
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
