import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:turtle_package/model/message.dart';
import 'package:turtle_phone/presentation/bloc/phone_message_bloc.dart';

import '../../../../generated/l10n.dart';

import '../../widget/input_text.dart';

class ImageMessageCreationScreen extends StatefulWidget {
  const ImageMessageCreationScreen({super.key, required this.textInput});
  final String textInput;

  @override
  State<StatefulWidget> createState() => ImageSelectionScreenState();
}

class ImageSelectionScreenState extends State<ImageMessageCreationScreen> {
  final List<File> images = [];

  Future getImage(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          allowMultiple: true,
          type: FileType.custom,
          allowedExtensions: ['jpg', 'jpeg', 'png']);
      if (result != null && result.files.isNotEmpty) {
        images.addAll(result.files.map((e) => File(e.path!)));
        setState(() {});
      }
    } on Exception {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(S.of(context).error_during_selection),
        duration: const Duration(seconds: 1),
      ));
    }
  }

  @override
  void initState() {
    getImage(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(child: buildImages()),
        Align(
          alignment: Alignment.bottomCenter,
          child: InputText(
              initialValue: widget.textInput,
              needVocalAnswer: true,
              isFamily: true,
              onPressedFunction: (content, isFamily, needVocalAnswer) {
                if (content.trim().isNotEmpty) {
                  var message = ImageMessage(
                      message: content,
                      link: [],
                      needVocalAnswer: needVocalAnswer,
                      isFamily: isFamily,
                      date: DateTime.now(),
                      fromId: '',
                      fromStr: '',
                      id: '',
                      read: false,
                      to: '');
                  BlocProvider.of<PhoneMessageBloc>(context)
                      .sendMessageWithFiles(message, images);
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(S.current.nothing_to_send),
                    duration: const Duration(seconds: 1),
                  ));
                }
              }),
        ),
      ],
    );
  }

  Widget buildImages() {
    if (images.length == 1) {
      return Image.file(images.first);
    } else {
      return GridView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: images.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
          ),
          itemBuilder: (context, index) {
            return Image.file(
              images[index],
              fit: BoxFit.contain,
            );
          });
    }
  }
}
