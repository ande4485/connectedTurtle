class Message {
  String id;

  String fromId;

  String fromStr;

  String to;

  final DateTime date;

  final MessageType type;

  Message({
    required this.id,
    required this.fromId,
    required this.fromStr,
    required this.to,
    required this.date,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      // 'id': id,
      'from': fromId,
      'fStr': fromStr,
      'to': to,
      'd': date.toIso8601String(),
      't': type.index
    };
  }

  factory Message.fromJson(Map<String, dynamic> values, String id) {
    var type = values['t'];
    if (type == MessageType.text.index) {
      return TextMessage(
          id: id,
          fromId: values['from'],
          fromStr: values['fStr'],
          to: values['to'],
          date: DateTime.parse(values['d']),
          message: values['m'],
          needVocalAnswer: values['nva'],
          read: values['r']);
    } else if (type == MessageType.image.index) {
      return ImageMessage(
          id: id,
          fromId: values['from'],
          fromStr: values['fStr'],
          to: values['to'],
          date: DateTime.parse(values['d']),
          message: values['m'],
          link: List<String>.from(values['l']),
          needVocalAnswer: values['nva'],
          read: values['r'],
          isFamily: values['iF']);
    } else if (type == MessageType.video.index) {
      return VideoMessage(
          id: id,
          fromId: values['from'],
          fromStr: values['fStr'],
          to: values['to'],
          date: DateTime.parse(values['d']),
          message: values['m'],
          link: List<String>.from(values['l']),
          needVocalAnswer: values['nva'],
          read: values['r'],
          isFamily: values['iF']);
    } else if (type == MessageType.vocal.index) {
      return VocalMessage(
          id: id,
          fromId: values['from'],
          fromStr: values['fStr'],
          to: values['to'],
          date: DateTime.parse(values['d']),
          link: List<String>.from(values['l']));
    } else if (type == MessageType.youtubeVideo.index) {
      return YoutubeMessage(
          id: id,
          fromId: values['from'],
          fromStr: values['fStr'],
          to: values['to'],
          date: DateTime.parse(values['d']),
          message: values['m'],
          link: List<String>.from(values['l']).first,
          needVocalAnswer: values['nva'],
          read: values['r']);
    } else {
      return EmergencyMessage(
          id: id,
          fromId: values['from'],
          fromStr: values['fStr'],
          to: values['to'],
          date: DateTime.parse(values['d']),
          message: values['m']);
    }
  }
}

class MessageWithText extends Message {
  final String message;

  final bool needVocalAnswer;

  bool read;

  MessageWithText(
      {required super.fromId,
      required super.fromStr,
      required super.to,
      required this.message,
      required super.date,
      required super.type,
      required this.needVocalAnswer,
      required this.read,
      required super.id});
}

class TextMessage extends MessageWithText {
  TextMessage(
      {required super.id,
      required super.fromId,
      required super.fromStr,
      required super.to,
      required super.date,
      required super.message,
      required super.needVocalAnswer,
      super.read = false})
      : super(
          type: MessageType.text,
        );

  @override
  toJson() {
    var json = super.toJson();

    json.addAll({'nva': needVocalAnswer, 'r': read, 'm': message});
    return json;
  }
}

class ImageMessage extends MessageWithText {
  List<String> link;

  bool isFamily;

  ImageMessage(
      {required super.id,
      required super.fromId,
      required super.fromStr,
      required super.to,
      required super.date,
      required super.message,
      required this.link,
      required super.needVocalAnswer,
      required super.read,
      required this.isFamily})
      : super(
          type: MessageType.image,
        );

  @override
  toJson() {
    var json = super.toJson();

    json.addAll({
      'nva': needVocalAnswer,
      'r': read,
      'm': message,
      'iF': isFamily,
      'l': link
    });
    return json;
  }
}

class VideoMessage extends MessageWithText {
  List<String> link;

  bool isFamily;

  VideoMessage(
      {required super.id,
      required super.fromId,
      required super.fromStr,
      required super.to,
      required super.date,
      required super.message,
      required this.link,
      required super.needVocalAnswer,
      required super.read,
      required this.isFamily})
      : super(
          type: MessageType.video,
        );

  @override
  toJson() {
    var json = super.toJson();

    json.addAll({
      'nva': needVocalAnswer,
      'r': read,
      'm': message,
      'iF': isFamily,
      'l': link
    });
    return json;
  }
}

class YoutubeMessage extends MessageWithText {
  String link;

  YoutubeMessage(
      {required super.id,
      required super.fromId,
      required super.fromStr,
      required super.to,
      required super.date,
      required super.message,
      required this.link,
      required super.needVocalAnswer,
      required super.read})
      : super(
          type: MessageType.youtubeVideo,
        );
  @override
  toJson() {
    var json = super.toJson();

    json.addAll({
      'nva': needVocalAnswer,
      'r': read,
      'm': message,
      'l': [link]
    });
    return json;
  }
}

class VocalMessage extends Message {
  List<String> link;

  VocalMessage(
      {required super.id,
      required super.fromId,
      required super.fromStr,
      required super.to,
      required super.date,
      required this.link})
      : super(type: MessageType.vocal);

  @override
  toJson() {
    var json = super.toJson();

    json.addAll({
      'l': [link]
    });
    return json;
  }
}

class EmergencyMessage extends Message {
  final String message;

  EmergencyMessage(
      {required super.fromId,
      required super.fromStr,
      required super.to,
      required super.date,
      required super.id,
      required this.message})
      : super(type: MessageType.emergency);

  @override
  toJson() {
    var json = super.toJson();

    json.addAll({'m': message});
    return json;
  }
}

enum MessageType {
  text,
  image,
  video,
  youtubeVideo,
  vocal,
  videoCall,
  emergency
}

class MessageModified {
  final MessageTypeChange typeChange;
  final Message message;

  MessageModified({required this.typeChange, required this.message});
}

enum MessageTypeChange { Added, Updated, Deleted }
