import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turtle_box/main.dart';
import 'package:turtle_phone/phone_app.dart';
import 'package:turtle_box/di/box_di.dart' as dibox;
import 'package:turtle_phone/di/phone_di.dart' as phone_di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Connected turtle',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final int installedBoxType = 1;
  final int installedPhoneType = 2;
  bool needUser = false;
  @override
  void initState() {
    _checkInstall();
    super.initState();
  }

  Future<void> _checkInstall() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int? installType = sharedPreferences.getInt("install_type");
    if (installType == null) {
      setState(() {
        needUser = true;
      });
    } else if (installType == installedBoxType) {
      await dibox.init();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const BoxApp()));
    } else if (installType == installedPhoneType) {
      await phone_di.init();
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => PhoneApp()));
    }
  }

  Future<void> _saveAndGo(int installType) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setInt("install_type", installType);
    if (installType == installedBoxType) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const BoxApp()));
    } else if (installType == installedPhoneType) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => PhoneApp()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: needUser
            ? Column(
                children: [
                  Text("Do you install it on phone ?"),
                  const SizedBox(height: 15),
                  OutlinedButton(
                      onPressed: () => _saveAndGo(installedBoxType),
                      child: Text("No")),
                  OutlinedButton(
                      onPressed: () => _saveAndGo(installedPhoneType),
                      child: Text("Yes"))
                ],
              )
            : null);
  }
}
