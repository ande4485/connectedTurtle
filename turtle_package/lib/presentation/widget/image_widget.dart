import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turtle_package/presentation/bloc/download_files_bloc.dart';
import 'package:turtle_package/presentation/bloc/download_state.dart';

class ImageWidget extends StatefulWidget {
  final Widget waitingWidget;
  final Widget errorWidget;

  ImageWidget({
    required this.errorWidget,
    required this.waitingWidget,
  });

  @override
  State<StatefulWidget> createState() => ImageWidgetState();
}

class ImageWidgetState extends State<ImageWidget> {
  @override
  void initState() {
    BlocProvider.of<DownloadBloc>(context).imageDownload();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DownloadBloc, DownloadState>(builder: (context, state) {
      if (state is DownloadingImage) {
        return widget.waitingWidget;
      } else if (state is DownloadedImage) {
        return Image.memory(state.data);
      } else {
        return widget.errorWidget;
      }
    });
  }
}
