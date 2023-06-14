import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

import 'design/constant.dart';

class WrapTextWidget extends StatelessWidget {
  final String message;
  final double fontSize;

  const WrapTextWidget({super.key, required this.message, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    // https://stackoverflow.com/questions/51114778/how-to-check-if-flutter-text-widget-was-overflowed
    return LayoutBuilder(builder: (context, size) {
      // Build the textspan
      var span = TextSpan(
        text: message,
        style: TextStyle(fontSize: fontSize),
      );

      // Use a textpainter to determine if it will exceed max lines
      var tp = TextPainter(
        maxLines: 1,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr,
        text: span,
      );

      // trigger it to layout
      tp.layout(maxWidth: size.maxWidth);

      // whether the text overflowed or not
      var exceeded = tp.didExceedMaxLines;
      if (!exceeded) {
        return Text(message, style: TextStyle(fontSize: fontSize));
      } else {
        return Marquee(
          text: message,
          style: TextStyle(color: Colors.white, fontSize: fontSize),
          blankSpace: 40.0,
          pauseAfterRound: durationMarquee,
          velocity: velocityMarquee,
        );
      }
    });
  }
}
/**
    class WrapTextWidgetState extends State<WrapTextWidget>{

    final String widget.message;
    final double fontSize;

    WrapTextWidgetState({required this.widget.message, required this.fontSize});

    @override
    Widget build(BuildContext context) {
    // https://stackoverflow.com/questions/51114778/how-to-check-if-flutter-text-widget-was-overflowed
    return LayoutBuilder(builder: (context, size) {
    // Build the textspan
    var span = TextSpan(
    text: widget.message,
    style: TextStyle(fontSize: fontSize),
    );

    // Use a textpainter to determine if it will exceed max lines
    var tp = TextPainter(
    maxLines: 1,
    textAlign: TextAlign.left,
    textDirection: TextDirection.ltr,
    text: span,
    );

    // trigger it to layout
    tp.layout(maxWidth: size.maxWidth);

    // whether the text overflowed or not
    var exceeded = tp.didExceedMaxLines;
    if(!exceeded){
    return Text(widget.message,style: TextStyle(fontSize: fontSize));
    }
    else{
    return Expanded(
    child:
    Marquee(text:widget.message,
    style: TextStyle(color:Colors.white, fontSize: fontSize),
    blankSpace: 40.0,
    pauseAfterRound: Duration(seconds: 2)
    )
    );
    }

    });
    }

    }**/
