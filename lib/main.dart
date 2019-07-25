import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';

/// In the method you need to await any async method
/// Only debug stop when yield in the try and finally;
/// Debug stop in last `if else`
/// Also debug stop if you have 1 `if`
/// Also debug stop in the las `else`

void main() => runApp(MyApp());

enum MyEvent { exception1, exception2, exception3 }

class MyBloc extends Bloc<MyEvent, int> {
  final UserRepository userRepository;

  MyBloc(this.userRepository);

  @override
  int get initialState => 0;

  @override
  Stream<int> mapEventToState(
    MyEvent event,
  ) async* {
    try {
      // Only debug stop when yield in the try and finally;
      yield currentState + 1;
      if (event == MyEvent.exception1) {
        await userRepository.signIn();
      } else if (event == MyEvent.exception2) {
        await userRepository.signIn();
      } else {
        // here debug stop
        await userRepository.signIn();
      }
    } on MyException catch (e) {
      // yield currentState + 1;
      print('catch');
    } finally {
      // Only debug stop when yield in the try and finally;
      yield currentState + 1;
      print('finally');
    }
  }
}

class MyException implements Exception {}

class UserRepository {
  Future<void> signIn() async {
    // In the method you need to await any async method
    await Future.delayed(Duration(milliseconds: 10));
    throw MyException();
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  MyBloc _myBloc;

  @override
  void initState() {
    super.initState();
    _myBloc = MyBloc(UserRepository());
  }

  @override
  void dispose() {
    _myBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text('Throw exception in first if '),
              onPressed: () => _myBloc.dispatch(MyEvent.exception1),
            ),
            RaisedButton(
              child: Text('Throw exception in first if else'),
              onPressed: () => _myBloc.dispatch(MyEvent.exception2),
            ),
            RaisedButton(
              child: Text('Throw exception in last if else ()'),
              onPressed: () => _myBloc.dispatch(MyEvent.exception3),
            )
          ],
        ),
      ),
    );
  }
}
