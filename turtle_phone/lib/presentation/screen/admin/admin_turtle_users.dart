import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turtle_phone/presentation/screen/admin/widget/device_invited_users_list.dart';
import 'package:turtle_phone/presentation/screen/admin/widget/device_users_list.dart';
import 'package:turtle_phone/presentation/screen/admin/widget/emergency_users.dart';

import '../../../generated/l10n.dart';
import '../../bloc/device_users_bloc.dart';
import '../../bloc/device_users_state.dart';
import '../design/limitations.dart';
import '../design/style.dart';
import '../widget/loading.dart';
import '../widget/turtle_error.dart';

class AdminDeviceUsersScreen extends StatelessWidget {
  final String idDevice;
  final String nameDevice;

  const AdminDeviceUsersScreen(
      {super.key, required this.idDevice, required this.nameDevice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(S.current.users_management),
        ),
        body: AdminDeviceUsers(
          idDevice: idDevice,
          nameDevice: nameDevice,
        ));
  }
}

class AdminDeviceUsers extends StatefulWidget {
  final String idDevice;
  final String nameDevice;

  const AdminDeviceUsers(
      {super.key, required this.idDevice, required this.nameDevice});

  @override
  State<StatefulWidget> createState() => AdminDeviceUsersState();
}

class AdminDeviceUsersState extends State<AdminDeviceUsers>
    with TickerProviderStateMixin {
  late DeviceUsersBloc _deviceUsersBloc;
  late TabController _controller;

  @override
  void dispose() {
    _deviceUsersBloc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _controller = TabController(length: 3, vsync: this);
    _deviceUsersBloc = BlocProvider.of<DeviceUsersBloc>(context);
    _deviceUsersBloc.getDeviceUsers(widget.idDevice);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeviceUsersBloc, DeviceUsersState>(
        buildWhen: (oldState, newState) =>
            newState is DeviceUsers ||
            newState is DeviceGetListUsers ||
            newState is DeviceGetListError,
        builder: (context, state) {
          if (state is DeviceUsers) {
            return Padding(
                padding: const EdgeInsets.all(general_padding),
                child: Column(children: [
                  TabBar(
                    controller: _controller,
                    isScrollable: true,
                    tabs: [
                      Tab(text: S.current.turtle_users),
                      Tab(text: S.current.invited_users),
                      Tab(text: S.current.emergency_users),
                    ],
                  ),
                  spaceBetweenField,
                  Expanded(
                    child: TabBarView(controller: _controller, children: [
                      DeviceListUsers(
                          deviceUsers: state.deviceUsers,
                          idDevice: widget.idDevice),
                      DeviceInvitedListUsers(
                        idDevice: widget.idDevice,
                        nameDevice: widget.nameDevice,
                        invitedUsers: state.invitedUsersList,
                      ),
                      EmergencyUsers(
                          idDevice: widget.idDevice,
                          deviceEmergencyUsers: state.deviceEmergencyUsers)
                    ]),
                  )
                ]));
          } else if (state is DeviceGetListUsers) {
            return const Loading();
          } else {
            return const TurtleError();
          }
        });
  }
}
