import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turtle_package/model/device_user.dart';

import '../../../bloc/device_users_bloc.dart';
import '../../../bloc/device_users_state.dart';
import '../../design/color.dart';

class EmergencyUsers extends StatefulWidget {
  final String idDevice;
  final List<DeviceUser> deviceEmergencyUsers;

  const EmergencyUsers(
      {super.key, required this.idDevice, required this.deviceEmergencyUsers});

  @override
  State<StatefulWidget> createState() => EmergencyUsersState();
}

class EmergencyUsersState extends State<EmergencyUsers> {
  Future<void> removeUserEmergency(
      List<DeviceUser> deviceEmergencyUsers, int position) async {
    BlocProvider.of<DeviceUsersBloc>(context)
        .removeUserEmergency(deviceEmergencyUsers[position], widget.idDevice);
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
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              widget.deviceEmergencyUsers[position].name,
                            ),
                            const Spacer(),
                            IconButton(
                                color: Theme.of(context).primaryColor,
                                icon: const Icon(
                                  Icons.delete,
                                ),
                                onPressed: () => removeUserEmergency(
                                    widget.deviceEmergencyUsers, position)),
                          ]))));
        },
        itemCount: widget.deviceEmergencyUsers.length,
      ),
      BlocConsumer<DeviceUsersBloc, DeviceUsersState>(
        buildWhen: (oldState, newState) =>
            newState is DeviceUserEmergencyProcessing ||
            newState is DeviceUsersEmergencyDone,
        builder: (context, state) {
          if (state is DeviceUserEmergencyProcessing) {
            return const CircularProgressIndicator();
          } else {
            return const SizedBox();
          }
        },
        listener: (context, state) {},
      )
    ]);
  }
}
