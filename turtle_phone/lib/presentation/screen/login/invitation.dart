import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turtle_phone/generated/l10n.dart';
import 'package:turtle_phone/presentation/bloc/device_users_bloc.dart';
import 'package:turtle_phone/presentation/bloc/device_users_state.dart';
import 'package:turtle_phone/presentation/screen/widget/loading.dart';

class Invitation extends StatefulWidget {
  final Map<String, dynamic> invitationParams;

  const Invitation({super.key, required this.invitationParams});

  @override
  State<StatefulWidget> createState() => InvitationState();
}

class InvitationState extends State<Invitation> {
  @override
  void initState() {
    BlocProvider.of<DeviceUsersBloc>(context)
        .acceptInvitation(widget.invitationParams);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeviceUsersBloc, DeviceUsersState>(
        builder: (context, state) {
      if (state is InvitedUsersDone) {
        return Text(S.current.invit_accepted);
      } else if (state is InvitedUsersError) {
        return Text(S.current.error_during_invitation);
      } else {
        return const Loading();
      }
    });
  }
}
