import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:turtle_package/model/device.dart';

import 'package:turtle_package/model/device_user.dart';
import 'package:turtle_phone/di/phone_di.dart';
import 'package:turtle_phone/generated/l10n.dart';
import 'package:turtle_phone/presentation/bloc/device_bloc.dart';
import 'package:turtle_phone/presentation/bloc/device_users_bloc.dart';
import 'package:turtle_phone/presentation/bloc/device_users_state.dart';
import 'package:turtle_phone/presentation/bloc/phone_message_bloc.dart';

import 'package:turtle_phone/presentation/screen/widget/turtle_scaffold.dart';

import 'design/color.dart';
import 'discussion/device_discussion.dart';
import 'widget/loading.dart';

class NoDeviceScreen extends StatelessWidget {
  const NoDeviceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        S.current.no_device,
        style: Theme.of(context).primaryTextTheme.titleMedium!,
      ),
    );
  }
}

class DeviceSelectionScreen extends StatefulWidget {
  const DeviceSelectionScreen({super.key});

  @override
  State createState() => DeviceSelectionState();
}

class DeviceSelectionState extends State<DeviceSelectionScreen> {
  @override
  initState() {
    BlocProvider.of<DeviceUsersBloc>(context).getUser();
    super.initState();
  }

  Future<void> _addSelection(BuildContext parentContext) async {
    switch (await showDialog<String>(
        context: parentContext,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text(S.current.add_device,
                style: Theme.of(context).primaryTextTheme.titleLarge!),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 'Turtle');
                },
                child: Text('Turtle',
                    style: Theme.of(context).primaryTextTheme.titleLarge!),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 'Emergency');
                },
                child: Text('Emergency',
                    style: Theme.of(context)
                        .primaryTextTheme
                        .titleLarge!
                        .copyWith(color: Colors.red)),
              ),
            ],
          );
        })) {
      case 'Turtle':
        context.pushNamed('warningMessage',
            pathParameters: {'type': DeviceType.turtle.name});

        break;
      case 'Emergency':
        context.pushNamed('warningMessage',
            pathParameters: {'type': DeviceType.emergency.name});

        break;
      case null:
        // dialog dismissed
        break;
    }
  }

  Widget _showMenuForTurtle(UserTurtleInfo turtle) => PopupMenuButton<int>(
        onSelected: (int result) {
          switch (result) {
            case 0:
              {
                context.pushNamed("admindevices", pathParameters: {
                  'idTurtle': turtle.idTurle,
                  'nameDevice': turtle.nameTurtle
                });

                break;
              }
            case 1:
              {
                context.pushNamed("turtlesettings",
                    pathParameters: {'idTurtle': turtle.idTurle});

                break;
              }
            case 2:
              {
                BlocProvider.of<DeviceBloc>(context)
                    .deleteDevice(turtle.idTurle, DeviceType.turtle);
                break;
              }
          }
        },
        itemBuilder: (BuildContext context) {
          return [
            PopupMenuItem<int>(
                key: const Key("add_person"),
                value: 0,
                child: ListTile(
                  title: Text(S.current.turtle_users),
                )),
            PopupMenuItem<int>(
                key: const Key("turtle_settings"),
                value: 1,
                child: ListTile(
                  title: Text(S.current.settings),
                )),
            PopupMenuItem<int>(
                key: const Key("turtle_delete"),
                value: 2,
                child: ListTile(
                  title: Text(S.current.delete_turtle),
                )),
          ];
        },
        icon: const Icon(Icons.more_vert),
      );

  Widget turtleWidget(UserTurtleInfo turtle) {
    return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Scaffold(
                    appBar: AppBar(
                      title: Text(
                        turtle.nameTurtle,
                      ),
                    ),
                    body: BlocProvider(
                        create: (_) => iD<PhoneMessageBloc>(
                            param1: turtle.idTurle,
                            param2: turtle.nameUserForDevice),
                        child: const DeviceDiscussionScreen())),
              ));
        },
        child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(children: <Widget>[
              Expanded(
                  flex: 5,
                  child: Text(
                    turtle.nameTurtle,
                    overflow: TextOverflow.ellipsis,
                  )),
              const Spacer(
                flex: 1,
              ),
              turtle.userRole.contains(UserRole.admin)
                  ? _showMenuForTurtle(turtle)
                  : const SizedBox(),
            ])));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DeviceUsersBloc, DeviceUsersState>(
        builder: (context, state) {
          if (state is DeviceGetUser) {
            return TurtleScaffold(
                appBar: AppBar(
                    backgroundColor: Colors.lightGreen,
                    actions: <Widget>[
                      IconButton(
                          icon: const Icon(
                            Icons.person,
                            size: 35.0,
                          ),
                          onPressed: () => context.pushNamed('userinfo'))
                    ]),
                floatingActionButton: FloatingActionButton(
                  child: const Icon(
                    Icons.add,
                  ),
                  onPressed: () => _addSelection(context),
                ),
                body: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Turtles',
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.displayMedium!,
                      ),
                      const SizedBox(height: 15),
                      state.deviceUser.turtlesInfo.isNotEmpty
                          ? Expanded(
                              child: ListView.builder(
                              itemBuilder: (context, position) {
                                return SizedBox(
                                    height: 80,
                                    child: Card(
                                        child: turtleWidget(state.deviceUser
                                            .turtlesInfo[position])));
                              },
                              itemCount: state.deviceUser.turtlesInfo.length,
                            ))
                          : const Expanded(child: NoDeviceScreen())
                    ]));
          } else {
            return const Loading();
          }
        },
        listener: (context, state) {});
  }
}
