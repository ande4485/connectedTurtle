import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:turtle_phone/presentation/bloc/phone_message_bloc.dart';
import 'package:turtle_phone/presentation/screen/widget/dialog.dart';

import '../../../generated/l10n.dart';

import '../messages/creation/image_message_creation.dart';
import '../messages/creation/video_message_creation.dart';
import '../messages/creation/youtube_message_creation.dart';

class BottomMessageSelector extends StatelessWidget {
  final String textInput;

  const BottomMessageSelector({super.key, required this.textInput});

  _getRoute(Widget child, BuildContext context, bool needAddAction) {
    var messageBloc = BlocProvider.of<PhoneMessageBloc>(context);
    return Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => BlocProvider(
                create: (_) => messageBloc,
                child: SafeArea(
                    child: Scaffold(
                        appBar: needAddAction
                            ? AppBar(actions: [
                                IconButton(
                                    onPressed: () => {},
                                    icon: const Icon(Icons.add_circle_outline))
                              ])
                            : null,
                        body: WillPopScope(
                          onWillPop: () async {
                            continueCallBack() async {
                              context.pop();
                              context.pop();
                            }

                            DialogWarning alert = DialogWarning(
                                title: S.current.warning,
                                content: S.current.warning_quit,
                                continueCallBack: continueCallBack);
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return alert;
                              },
                            );

                            return false;
                          },
                          child: child,
                        ))))));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              BottomMessageSelectorItem(
                  icon: Icons.image,
                  onTap: () => _getRoute(
                      ImageMessageCreationScreen(textInput: textInput),
                      context,
                      true),
                  itemName: S.current.image),
              BottomMessageSelectorItem(
                  icon: Icons.video_collection_sharp,
                  onTap: () => _getRoute(
                      VideoMessageCreationScreen(textInput: textInput),
                      context,
                      true),
                  itemName: S.current.video),
              BottomMessageSelectorItem(
                  icon: Icons.video_collection,
                  onTap: () => _getRoute(
                      YoutubeMessageCreationScreen(textInput: textInput),
                      context,
                      false),
                  itemName: 'Youtube'),
            ],
          ),
        ],
      ),
    );
  }
}

class BottomMessageSelectorItem extends StatelessWidget {
  final String itemName;
  final Function() onTap;
  final IconData icon;

  const BottomMessageSelectorItem(
      {super.key,
      required this.itemName,
      required this.icon,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.background,
              /**gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.green.shade900,
                      ],
                    )**/
            ),
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: IconButton(
                  icon: Icon(
                    icon,
                    size: 30.0,
                  ),
                  onPressed: onTap,
                ))),
        const SizedBox(
          height: 5,
        ),
        Text(
          itemName,
        )
      ],
      // ),
    );
  }
}
