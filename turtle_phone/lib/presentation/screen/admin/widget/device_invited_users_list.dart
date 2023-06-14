import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:turtle_package/model/device_user.dart';

import '../../../../generated/l10n.dart';
import '../../../bloc/device_users_bloc.dart';
import '../../../bloc/device_users_state.dart';
import '../../design/color.dart';
import '../../design/limitations.dart';
import '../../widget/dialog.dart';

class DeviceInvitedListUsers extends StatefulWidget {
  final String idDevice;
  final String nameDevice;
  final List<DeviceUser> invitedUsers;

  const DeviceInvitedListUsers({
    super.key,
    required this.idDevice,
    required this.nameDevice,
    required this.invitedUsers,
  });

  @override
  State<StatefulWidget> createState() => DeviceInvitedListUsersState();
}

class DeviceInvitedListUsersState extends State<DeviceInvitedListUsers> {
  final TextEditingController textEditingController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  final ScrollController listScrollController = ScrollController();

  _onSendInvitation(List<DeviceUser> invitedTurtleUsers, String email) async {
    continueCallBack() {
      context.pop();

      BlocProvider.of<DeviceUsersBloc>(context)
          .createInvitUser(email, widget.idDevice, widget.nameDevice);

      textEditingController.clear();
    }

    DialogWarning alert = DialogWarning(
        title: S.current.title_warning,
        content: S.current.warning_invit_user(email),
        continueCallBack: continueCallBack);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(clipBehavior: Clip.antiAlias, children: [
      Column(children: [
        Padding(
            padding: const EdgeInsets.all(0.0),
            child: Align(
                alignment: Alignment.topCenter,
                heightFactor: 1,
                //widthFactor: 0,
                child: Card(
                    child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(children: <Widget>[
                          Flexible(
                            child: TextField(
                              keyboardType: TextInputType.emailAddress,
                              minLines: 1,
                              maxLines: 2,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(
                                    maxEmailAddress),
                              ],
                              controller: textEditingController,
                              decoration: InputDecoration.collapsed(
                                hintText: S.current.type_email_address,
                                hintStyle: const TextStyle(color: grey_color),
                              ),
                              focusNode: focusNode,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: () {
                              String text = textEditingController.text.trim();
                              if (text.isEmpty || !text.contains("@")) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content:
                                      Text(S.current.email_address_not_valid),
                                  duration: const Duration(seconds: 3),
                                  backgroundColor: Colors.redAccent,
                                ));
                              } else {
                                _onSendInvitation(widget.invitedUsers, text);
                              }
                            },
                          ),
                        ]))))),
        Expanded(
            child: SingleChildScrollView(
                child: Column(children: [
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
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
                                  widget.invitedUsers[position].name,
                                ),
                              ]))));
            },
            itemCount: widget.invitedUsers.length,
          ),
        ])))
      ]),
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
          listener: (context, state) {
            if (state is DeviceCreateInvitUserNotFound) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(S.current.unknown_user),
                duration: const Duration(seconds: 3),
                backgroundColor: Theme.of(context).colorScheme.error,
              ));
            } else if (state is DeviceInvitUserAlreadyExist) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(S.current.user_exist),
                duration: const Duration(seconds: 3),
                backgroundColor: Theme.of(context).colorScheme.error,
              ));
            }
          }),
    ]);
  }
}
