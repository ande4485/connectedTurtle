import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:turtle_package/model/device_user.dart';

import '../../../../generated/l10n.dart';
import '../../../bloc/device_users_bloc.dart';
import '../../../bloc/device_users_state.dart';
import '../../design/color.dart';
import '../../widget/dialog.dart';

class DeviceListUsers extends StatefulWidget {
  final List<DeviceUser> deviceUsers;
  final String idDevice;

  const DeviceListUsers(
      {super.key, required this.idDevice, required this.deviceUsers});

  @override
  State<StatefulWidget> createState() => DeviceListUsersState();
}

class DeviceListUsersState extends State<DeviceListUsers> {
  late DeviceUsersBloc _deviceBloc;
  bool isWorking = false;

  _removeUserOfDevice(
      List<DeviceUser> turtleUsers, DeviceUser turtleUser) async {
    _deviceBloc.removeUserOfDevice(turtleUser, widget.idDevice);
  }

  _changeAdmin(DeviceUser deviceUser) async {
    continueCallBack() async {
      context.pop();

      _deviceBloc.changeAdmin(deviceUser.id, widget.idDevice);
    }

    DialogWarning alert = DialogWarning(
        title: S.current.warning,
        content: S.current.admin_warning(deviceUser.name),
        continueCallBack: continueCallBack);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget _showMenuForDeviceUser(List<DeviceUser> deviceUsers, int position) =>
      PopupMenuButton<int>(
        onSelected: (int result) {
          switch (result) {
            case 0:
              {
                _removeUserOfDevice(deviceUsers, deviceUsers[position]);
                break;
              }
            case 1:
              {
                _changeAdmin(deviceUsers[position]);
                break;
              }
            case 2:
              {
                _deviceBloc.addUserToEmergency(
                    deviceUsers[position], widget.idDevice);
                break;
              }
          }
        },
        itemBuilder: (BuildContext context) {
          return [
            PopupMenuItem<int>(
              value: 0,
              child: Text(S.current.remove),
            ),
            PopupMenuItem<int>(
              value: 1,
              child: Text(S.current.admin),
            ),
            PopupMenuItem<int>(
              value: 2,
              child: Text(S.current.emergency),
            ),
          ];
        },
        icon: const Icon(Icons.more_vert),
      );

  @override
  void initState() {
    _deviceBloc = BlocProvider.of<DeviceUsersBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      ListView.builder(
        shrinkWrap: true,
        itemBuilder: (context, position) {
          return SizedBox(
              height: 80,
              child: Card(
                  child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              widget.deviceUsers[position].name,
                            ),
                            const Spacer(),
                            _showMenuForDeviceUser(
                                widget.deviceUsers, position),
                          ]))));
        },
        itemCount: widget.deviceUsers.length,
        //)
      ),
      BlocConsumer<DeviceUsersBloc, DeviceUsersState>(
          buildWhen: (oldState, newState) =>
              newState is DeviceUsersProcessing || newState is DeviceUsersDone,
          builder: (context, state) {
            if (state is DeviceUsersProcessing) {
              return const CircularProgressIndicator();
            } else {
              return const SizedBox();
            }
          },
          listenWhen: (oldState, newState) => newState is DeviceUserError,
          listener: (context, state) {}),
    ]);
  }
}
