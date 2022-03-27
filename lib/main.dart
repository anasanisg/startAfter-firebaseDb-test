import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:test_fbrealtime_query/models/test_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
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
        home: const HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseDatabase fbDatabase = FirebaseDatabase.instance;
  bool isInit = false;
  List<TestModel> tests = [];
  int indexToFilter = 1;

  @override
  void initState() {
    if (!isInit) {
      getTests().then((value) {
        setState(() {
          tests = value;
        });
      });
      isInit = true;
    }
    super.initState();
  }

  Future<List<TestModel>> getTests() async {
    //startAfter on Android, pointer not moving after selected Index
    //startAfter not working on android platform, it's working as startAt
    //startAfter working correctly on iOS

    Query testsQ =
        fbDatabase.ref('tests').orderByChild('index').startAfter(indexToFilter);
    final res = await testsQ.get();

    List<TestModel> ret = [];

    for (var element in res.children) {
      Map<String, dynamic> elementMap =
          (element.value as Map).cast<String, dynamic>();

      print(elementMap['index']);

      ret.add(TestModel.fromJson(elementMap));
    }

    return ret;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('test'),
      ),
      body: Center(
          child: ListView.builder(
        itemCount: tests.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(tests[index].name),
            subtitle: Text('index : ${tests[index].index.toString()}'),
          );
        },
      )),
    );
  }
}
