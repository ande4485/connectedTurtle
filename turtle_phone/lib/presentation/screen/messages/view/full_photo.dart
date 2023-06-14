import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:turtle_package/presentation/bloc/download_files_bloc.dart';
import 'package:turtle_package/presentation/widget/image_widget.dart';
import 'package:turtle_phone/di/phone_di.dart';

import '../../design/color.dart';

class FullPhoto extends StatelessWidget {
  final List<String> photos;

  const FullPhoto({super.key, required this.photos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SafeArea(
            child: Stack(
          children: <Widget>[
            ListView.separated(
                itemBuilder: (BuildContext context, int index) =>
                    BlocProvider<DownloadBloc>(
                        create: (_) => iD<DownloadBloc>(param1: photos[index]),
                        child: Container(
                            height: 100,
                            width: 100,
                            decoration: const BoxDecoration(
                              color: grey_color,
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                            ),
                            child: ImageWidget(
                              errorWidget: const Icon(Icons.close),
                              waitingWidget: const CircularProgressIndicator(),
                            ))),
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(height: 5),
                itemCount: photos.length),
            Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    context.pop();
                  },
                ))
          ],
        )));
  }
}
