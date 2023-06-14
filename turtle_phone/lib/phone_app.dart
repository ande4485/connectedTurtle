import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:turtle_package/model/device.dart';
import 'package:turtle_phone/presentation/bloc/device_bloc.dart';
import 'package:turtle_phone/presentation/bloc/device_users_bloc.dart';
import 'package:turtle_phone/presentation/bloc/init_device_bloc.dart';
import 'package:turtle_phone/presentation/bloc/login_bloc.dart';
import 'package:turtle_phone/presentation/bloc/sound_phone_bloc.dart';
import 'package:turtle_phone/presentation/bloc/user_bloc.dart';
import 'package:turtle_phone/presentation/screen/adddevices/add_devices.dart';
import 'package:turtle_phone/presentation/screen/adddevices/end_init.dart';
import 'package:turtle_phone/presentation/screen/adddevices/no_device_found.dart';
import 'package:turtle_phone/presentation/screen/adddevices/warning_init_message.dart';
import 'package:turtle_phone/presentation/screen/admin/admin_device_settings.dart';
import 'package:turtle_phone/presentation/screen/admin/admin_turtle_users.dart';

import 'package:turtle_phone/presentation/screen/login/invitation.dart';
import 'package:turtle_phone/presentation/screen/login/login.dart';
import 'package:turtle_phone/presentation/screen/turtle_selection.dart';
import 'package:turtle_phone/presentation/screen/user_form.dart';

import 'di/phone_di.dart';
import 'generated/l10n.dart';

//void main() async {
//await di.init();

//runApp(MyApp());
//}

class PhoneApp extends StatelessWidget {
  PhoneApp({super.key});

  // This widget is the root of your application.

  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (_, __) => const Login(),
        routes: [
          GoRoute(
              name: 'devices',
              path: 'devices',
              builder: (BuildContext context, GoRouterState state) =>
                  const DeviceSelectionScreen()),
          GoRoute(
              name: 'userinfo',
              path: 'userinfo',
              builder: (BuildContext context, GoRouterState state) =>
                  const UserForm(isCreation: false)),
          GoRoute(
              name: 'admindevices',
              path: 'admindevices/:idTurtle&:nameDevice',
              builder: (BuildContext context, GoRouterState state) =>
                  AdminDeviceUsersScreen(
                    idDevice: state.pathParameters['idTurtle']!,
                    nameDevice: state.pathParameters['nameDevice']!,
                  )),
          GoRoute(
              name: 'turtlesettings',
              path: 'turtlesettings/:idTurtle',
              builder: (BuildContext context, GoRouterState state) =>
                  DeviceSettingsAdmin(
                    idDevice: state.pathParameters['idTurtle']!,
                  )),
          GoRoute(
            name: 'warningMessage',
            path: 'warningMessage/:type',
            builder: (context, state) => WarningInitMessage(
                deviceType: DeviceType.values.firstWhere((element) =>
                    element.name == state.pathParameters['type']!)),
          ),
          GoRoute(
              name: 'adddevice',
              path: 'adddevice:devicetype',
              builder: (context, state) => AddDevicesScreen(
                    deviceType: DeviceType.values.firstWhere((element) =>
                        element.name == state.pathParameters['devicetype']!),
                  )),
          GoRoute(
              name: 'endInit',
              path: 'endInit:devicetype',
              builder: (context, state) => EndInitScreen(
                    deviceType: DeviceType.values.firstWhere((element) =>
                        element.name == state.pathParameters['devicetype']!),
                  )),
          GoRoute(
              name: 'devicenotfound',
              path: 'devicenotfound:devicetype',
              builder: (context, state) => DevicesNotFound(
                    deviceType: DeviceType.values.firstWhere((element) =>
                        element.name == state.pathParameters['devicetype']!),
                  )),
          GoRoute(
              name: 'invit',
              path: 'invit/:secret',
              builder: (context, state) => Invitation(
                    invitationParams: {
                      'secret': state.pathParameters['secret']!,
                      'membershipId': state.pathParameters['membershipId'],
                      'turtleId': state.pathParameters['teamId']
                    },
                  )),
        ],
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => iD<LoginBloc>()),
          BlocProvider(create: (_) => iD<UserBloc>()),
          BlocProvider(create: (_) => iD<DeviceBloc>()),
          BlocProvider(create: (_) => iD<DeviceUsersBloc>()),
          BlocProvider(create: (_) => iD<InitDeviceBloc>()),
          BlocProvider(create: (_) => iD<SoundPhoneBloc>()),
        ],
        child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Connected turtle',
            theme: ThemeData(
                textTheme: const TextTheme(
                    displayMedium: TextStyle(color: Colors.white)),
                iconButtonTheme: const IconButtonThemeData(
                    style: ButtonStyle(
                        iconColor: MaterialStatePropertyAll(
                            Color.fromARGB(255, 55, 117, 56)))),
                useMaterial3: true,
                appBarTheme: const AppBarTheme(
                    centerTitle: true,
                    titleTextStyle:
                        TextStyle(color: Colors.white, fontSize: 20),
                    backgroundColor: Colors.transparent,
                    actionsIconTheme: IconThemeData(color: Colors.white)),
                colorScheme:
                    ColorScheme.fromSwatch(primarySwatch: Colors.lightGreen),
                switchTheme: SwitchThemeData(
                    trackOutlineColor: const MaterialStatePropertyAll(
                        Color.fromARGB(255, 55, 117, 56)),
                    thumbColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.disabled)) {
                        return const Color.fromARGB(255, 55, 117, 56)
                            .withOpacity(.48);
                      }
                      return const Color.fromARGB(255, 55, 117, 56);
                    }))),
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            routerConfig: router));
  }
}
