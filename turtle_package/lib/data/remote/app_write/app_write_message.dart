import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:turtle_package/data/remote/remote_message_datasource.dart';
import 'package:turtle_package/model/device_user.dart';
import 'package:turtle_package/model/message.dart';

import 'app_write_config.dart';

class AppWriteMessage extends RemoteMessageDataSource {
  final Databases appWriteDatabase;
  final Realtime realtime;
  RealtimeSubscription? _subscription;
  final StreamController<MessageModified> messageController =
      StreamController<MessageModified>();
  AppWriteMessage({required this.appWriteDatabase, required this.realtime});

  @override
  Stream<List<Message>> deviceMessages(String idTurtle) {
    return appWriteDatabase
        .listDocuments(
            databaseId: DEVICE_DATABASE_ID,
            collectionId: MESSAGE_COLLECTION_ID,
            queries: [
              Query.equal('to', idTurtle),
              Query.equal('r', false),
              Query.orderAsc('d'),
            ])
        .asStream()
        .map((event) => event.documents.map((element) {
              return Message.fromJson(element.data, element.$id);
            }).toList());
  }

  @override
  Future<List<Message>> getMessages(String idDevice, String idUser) async {
    var result = await appWriteDatabase.listDocuments(
        databaseId: DEVICE_DATABASE_ID,
        collectionId: MESSAGE_COLLECTION_ID,
        queries: [
          Query.equal('to', [idDevice, idUser]),
          Query.orderAsc('d'),
          Query.limit(20)
        ]);

    List<Message> messages = [];

    for (Document document in result.documents) {
      messages.add(Message.fromJson(document.data, document.$id));
    }
    return messages;
  }

  @override
  Future<List<Message>> getMoreMessages(String idDevice, String idUser,
      {String? lastIndex}) async {
    List<String> queries = [
      Query.equal('to', [idDevice, idUser]),
      Query.orderAsc('d'),
      Query.limit(20),
    ];
    if (lastIndex != null) queries.add(Query.cursorAfter(lastIndex));

    var result = await appWriteDatabase.listDocuments(
        databaseId: DEVICE_DATABASE_ID,
        collectionId: MESSAGE_COLLECTION_ID,
        queries: queries);

    List<Message> messages = [];

    for (Document document in result.documents) {
      messages.add(Message.fromJson(document.data, document.$id));
    }
    return messages;
  }

  @override
  Stream<MessageModified?> listenMessage(String idDevice, String idUser) {
    _subscription = realtime.subscribe([
      'databases.$DEVICE_DATABASE_ID.collections.$MESSAGE_COLLECTION_ID.documents'
    ]);

    //return messageController.stream;

    return _subscription!.stream.asyncMap<MessageModified?>((event) async {
      // Log when a new file is uploaded
      String eventFirst = event.events.first;
      if (eventFirst.contains(".create")) {
        //parse event to get all info

        var eventsArgs = eventFirst.split('.');
        var doc = await appWriteDatabase.getDocument(
            databaseId: eventsArgs[1],
            collectionId: eventsArgs[3],
            documentId: eventsArgs[5]);
        return MessageModified(
            typeChange: MessageTypeChange.Added,
            message: Message.fromJson(doc.data, doc.$id));
      } else if (eventFirst.contains(".update")) {
        var eventsArgs = eventFirst.split('.');
        var doc = await appWriteDatabase.getDocument(
            databaseId: eventsArgs[1],
            collectionId: eventsArgs[3],
            documentId: eventsArgs[5]);
        return MessageModified(
            typeChange: MessageTypeChange.Updated,
            message: Message.fromJson(doc.data, doc.$id));
      } else if (eventFirst.contains(".delete")) {
        var eventsArgs = eventFirst.split('.');
        var docId = eventsArgs[5];
        var message = Message(
            id: docId,
            fromId: "",
            fromStr: "",
            to: "",
            date: DateTime.now(),
            type: MessageType.image);
        return MessageModified(
            typeChange: MessageTypeChange.Deleted, message: message);
      }
    });
  }

  @override
  Future<void> sendMessage(Message message, String turtleId) async {
    List<String> permissions = [];
    if (message.type != MessageType.emergency) {
      permissions.add(Permission.write(Role.team(turtleId)));
      permissions.add(Permission.read(Role.team(turtleId)));
      permissions.add(Permission.update(Role.team(turtleId)));
    } else {
      permissions.add(Permission.write(Role.team(turtleId, UserRole.box.name)));

      permissions.add(Permission.read(Role.team(turtleId)));
      permissions.add(Permission.read(Role.team(turtleId)));
    }
    await appWriteDatabase.createDocument(
        databaseId: DEVICE_DATABASE_ID,
        collectionId: MESSAGE_COLLECTION_ID,
        documentId: ID.unique(),
        permissions: permissions,
        data: message.toJson());
  }

  @override
  Future<void> setMessageRead(String idTurtle, Message message) async {
    await appWriteDatabase.updateDocument(
        databaseId: DEVICE_DATABASE_ID,
        collectionId: MESSAGE_COLLECTION_ID,
        documentId: message.id,
        data: {"r": true});
  }

  @override
  Future<void> stopListeningDeviceMessage(String idTurtle) async {
    if (_subscription != null) await _subscription!.close();
    await messageController.close();
  }

  @override
  Future<List<Message>> getFamilyMessages(String idDevice) async {
    //TODO find a way to get random messages
    var result = await appWriteDatabase.listDocuments(
        databaseId: DEVICE_DATABASE_ID,
        collectionId: MESSAGE_COLLECTION_ID,
        queries: [
          Query.equal('to', idDevice),
          Query.equal('r', true),
          Query.equal('isF', true),
          Query.limit(10)
        ]);

    List<Message> messages = [];

    for (Document document in result.documents) {
      messages.add(Message.fromJson(document.data, document.$id));
    }
    return messages;
  }

  @override
  Future<List<Message>> getLastMessages(String idDevice) async {
    var result = await appWriteDatabase.listDocuments(
        databaseId: DEVICE_DATABASE_ID,
        collectionId: MESSAGE_COLLECTION_ID,
        queries: [
          Query.equal('to', idDevice),
          Query.orderAsc('d'),
          Query.equal('r', true),
          Query.limit(10)
        ]);

    List<Message> messages = [];

    for (Document document in result.documents) {
      messages.add(Message.fromJson(document.data, document.$id));
    }
    return messages;
  }

  @override
  Future<List<Message>> getNewMessages(String idDevice) async {
    var result = await appWriteDatabase.listDocuments(
        databaseId: DEVICE_DATABASE_ID,
        collectionId: MESSAGE_COLLECTION_ID,
        queries: [
          Query.equal('to', idDevice),
          Query.orderAsc('d'),
          Query.equal('r', true),
          Query.limit(10)
        ]);

    List<Message> messages = [];

    for (Document document in result.documents) {
      messages.add(Message.fromJson(document.data, document.$id));
    }
    return messages;
  }
}
