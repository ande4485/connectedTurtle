import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turtle_package/presentation/bloc/download_files_bloc.dart';
import 'package:turtle_package/presentation/widget/image_widget.dart';
import 'package:turtle_phone/di/phone_di.dart';

import '../../design/color.dart';
import 'full_photo.dart';

class ImageMessageView extends StatelessWidget {
  final List<String> photos;
  final String message;

  const ImageMessageView({
    super.key,
    required this.photos,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return ImageMessageViewScreen(
      photos: photos,
      message: message,
    );
  }
}

class ImageMessageViewScreen extends StatefulWidget {
  final List<String> photos;
  final String message;

  const ImageMessageViewScreen({
    super.key,
    required this.photos,
    required this.message,
  });

  @override
  State createState() => ImageMessageViewScreenState();
}

class ImageMessageViewScreenState extends State<ImageMessageViewScreen> {
  Widget _createChildren() {
    if (widget.photos.length == 1) {
      return _onePhoto(0);
    } else if (widget.photos.length == 2) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [_onePhoto(0), _onePhoto(1)],
      );
    } else if (widget.photos.length <= 4) {
      return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: widget.photos.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
          ),
          itemBuilder: (context, index) {
            return _onePhoto(index);
          }
          //)
          );
    } else {
      return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: 4,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
          ),
          itemBuilder: (context, index) {
            if (index == 3) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: _onePhoto(index),
                  ),
                  Align(
                      alignment: Alignment.center,
                      child: Text("+${widget.photos.length - 4}"))
                ],
              );
            } else {
              return _onePhoto(index);
            }
          }
          //)
          );
    }
  }

  Widget _onePhoto(int index) {
    //TODO change it
    var cachedImage = BlocProvider<DownloadBloc>(
        create: (_) => iD<DownloadBloc>(param1: widget.photos[index]),
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
            )));

    return GestureDetector(
        child: cachedImage,
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => FullPhoto(photos: widget.photos)));
        });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _createChildren();
  }
}
