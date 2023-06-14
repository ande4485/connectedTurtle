import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:turtle_box/presentation/bloc/box_bloc.dart';
import 'package:turtle_box/presentation/bloc/box_state.dart';
import 'package:turtle_box/presentation/bloc/sound_box_bloc.dart';
import 'package:turtle_box/presentation/screen/design/constant.dart';
import 'package:turtle_box/presentation/screen/design/style.dart';
import 'package:turtle_package/model/device.dart';
import 'package:turtle_package/presentation/bloc/auth_bloc.dart';

import 'di/box_di.dart' as dibox;
import 'di/box_di.dart';
import 'generated/l10n.dart';
import 'presentation/bloc/box_message_bloc.dart';
import 'presentation/screen/loading_message_screen.dart';
import 'presentation/screen/show_choices_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dibox.init();
  runApp(const BoxApp());
}

class BoxApp extends StatelessWidget {
  const BoxApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => iD<AuthBloc>()),
          BlocProvider(create: (_) => iD<BoxBloc>()),
          BlocProvider(create: (_) => iD<BoxMessageBloc>()),
          BlocProvider(create: (_) => iD<SoundBoxBloc>()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: boxTheme,
          home: const WelcomePage(),
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
        ));
  }
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int modeDisplay = 0;

  late Turtle currentDevice;

  @override
  void initState() {
    if (!kIsWeb) _requestPermission();
    super.initState();
  }

  void _requestPermission() async {
    await Permission.microphone.request().isGranted;
    await Permission.camera.request().isGranted;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BoxBloc, BoxState>(
      builder: (context, state) {
        print("state _WelcomeScreenState $state");
        if (state is BoxStart) {
          return SafeArea(
              child: Align(
                  alignment: Alignment.center,
                  child: Text(state.ip, key: const Key("ip_text"))));
        } else if (state is BoxSecurityWords) {
          return SafeArea(
              child: Center(
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.words[0]),
                  Text(state.words[1]),
                  Text(state.words[2]),
                  Text(state.words[3]),
                ]),
          ));
        } else if (state is BoxSecurityWordsGood) {
          return SafeArea(
              child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(S.current.accepted_phone),
                ]),
          ));
        } else if (state is BoxSecurityWordsFalse) {
          return SafeArea(
              child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(S.current.wrong_password),
                ]),
          ));
        } else if (state is BoxDiaporama) {
          currentDevice = state.actualDevice;
          return Center(
            child: Text(S.current.received_message,
                style: TextStyle(fontSize: currentDevice.fontSize.toDouble())),
          );
        } else {
          return const SizedBox();
        }
      },
      listenWhen: (oldState, newState) =>
          newState is BoxEventNext ||
          newState is BoxTimeOut ||
          newState is BoxTimeOutStop ||
          newState is BoxShowChoices,
      listener: (context, state) {
        if (state is BoxEventNext) {
          if (BlocProvider.of<BoxBloc>(context).getBoxState() is BoxDiaporama) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => LoadingMessageScreen(
                    typeDiapo: 0, currentDevice: currentDevice)));
          }
        } else if (state is BoxShowChoices) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) =>
                  ShowChoiceScreen(currentDevice: state.actualDevice)));
        } else if (state is BoxTimeOutStop) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        } else if (state is BoxTimeOut) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(S.current.press_turtle, key: const Key("timeout")),
            duration: snapBarDuration,
          ));
        }
      },
    );
  }
}
