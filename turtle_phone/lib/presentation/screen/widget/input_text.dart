import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';
import '../design/color.dart';

class InputText extends StatefulWidget {
  final Widget? attachFileWidget;
  final Function(String value, bool isFamily, bool needVocalAnswer)
      onPressedFunction;
  final bool isFamily;
  final bool needVocalAnswer;
  final String initialValue;

  const InputText(
      {super.key,
      required this.isFamily,
      required this.needVocalAnswer,
      this.initialValue = "",
      this.attachFileWidget,
      required this.onPressedFunction});

  @override
  State<StatefulWidget> createState() => InputTextState();
}

class InputTextState extends State<InputText>
    with SingleTickerProviderStateMixin {
  final FocusNode focusNode = FocusNode();
  final TextEditingController _textEditingController = TextEditingController();
  late AnimationController _animationController;
  late Tween<Offset> tween;
  late CurvedAnimation curvedAnimation;

  bool isFamilySwitch = false;
  bool needVocalAnswerSwitch = false;

  @override
  void initState() {
    _textEditingController.text = widget.initialValue;
    if (widget.attachFileWidget != null) {
      _animationController = AnimationController(
        duration: const Duration(milliseconds: 500),
        reverseDuration: const Duration(milliseconds: 200),
        vsync: this,
      );
      curvedAnimation = CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticInOut,
      );
      tween = Tween(begin: const Offset(0.0, 1.0), end: Offset.zero);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(5),
        child: Container(
            //height: 150,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: const BorderRadius.all(
                Radius.circular(15.0),
              ),
            ),
            child: Padding(
                padding: const EdgeInsets.all(5),
                child: Column(children: [
                  widget.isFamily
                      ? SwitchListTile(
                          dense: true,
                          visualDensity: VisualDensity.compact,
                          title: Text(
                            S.current.family_moment,
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                          value: isFamilySwitch,
                          onChanged: (bool newValue) => setState(() {
                                isFamilySwitch = newValue;
                              }))
                      : const SizedBox(),
                  widget.needVocalAnswer
                      ? SwitchListTile(
                          dense: true,
                          visualDensity: VisualDensity.compact,
                          title: Text(S.current.vocal_answer,
                              style: Theme.of(context).textTheme.labelSmall),
                          value: needVocalAnswerSwitch,
                          onChanged: (bool newValue) => setState(() {
                                needVocalAnswerSwitch = newValue;
                              }))
                      : const SizedBox(),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(15.0),
                      ),
                    ),
                    child: Row(
                      children: <Widget>[
                        // Button send image
                        widget.attachFileWidget != null
                            ? Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 1.0),
                                child: IconButton(
                                  icon: const Icon(Icons.attach_file),
                                  onPressed: () {
                                    showModalBottomSheet<void>(
                                        isScrollControlled: true,
                                        useRootNavigator: true,
                                        context: context,
                                        transitionAnimationController:
                                            _animationController,
                                        builder: (BuildContext context) {
                                          return SlideTransition(
                                            position:
                                                tween.animate(curvedAnimation),
                                            child: Wrap(children: [
                                              widget.attachFileWidget!
                                            ]),
                                          );
                                        });
                                  },
                                ),
                              )
                            : const SizedBox(),

                        // Edit text
                        Flexible(
                          child: Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: TextField(
                                onSubmitted: (value) {
                                  widget.onPressedFunction(
                                      _textEditingController.text,
                                      isFamilySwitch,
                                      needVocalAnswerSwitch);
                                  _textEditingController.clear();
                                },
                                controller: _textEditingController,
                                decoration: InputDecoration.collapsed(
                                  hintText: S.of(context).your_message,
                                  hintStyle: const TextStyle(color: grey_color),
                                ),
                                minLines: 1,
                                maxLines: 6,
                              )),
                        ),

                        // Button send message

                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: () {
                              widget.onPressedFunction(
                                  _textEditingController.text,
                                  isFamilySwitch,
                                  needVocalAnswerSwitch);
                              _textEditingController.clear();
                            },
                          ),
                        ),
                        //color: Colors.white,
                      ],
                    ),
                  )
                ]))));
  }
}
