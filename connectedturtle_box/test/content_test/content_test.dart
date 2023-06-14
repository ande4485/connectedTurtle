import 'package:turtle_package/model/device.dart';

import 'package:turtle_package/model/device_user.dart';
import 'package:turtle_package/model/message.dart';

var turtle1 = Turtle(
  id: '1',
  nameDevice: "test_turtle",
  fontSize: 20,
  showInfo: true,
  messageBeforeEnd: null,
  users: [
    SimpleDeviceUser(
      id: '444',
      //email: "usertest@email.com",
      name: "testName",
    ),
    SimpleDeviceUser(
      id: '445',
      //email: "usertest1@email.com",
      name: "testName1",
    ),
  ],
);
var emergency1 = Emergency(id: '1', turtleId: '2');
var simpleTextMessage = TextMessage(
    id: '908',
    fromId: '444',
    fromStr: 'test',
    to: '1',
    date: DateTime.now(),
    message: 'test text',
    needVocalAnswer: false,
    read: false);

var simpleImageMessage = ImageMessage(
    id: '999',
    fromId: '444',
    fromStr: 'test',
    to: '1',
    date: DateTime.now(),
    message: 'test image',
    needVocalAnswer: false,
    read: false,
    isFamily: false,
    link: ['']);

var simpleVideoMessage = VideoMessage(
    id: '900',
    fromId: '444',
    fromStr: 'test',
    to: '1',
    date: DateTime.now(),
    message: 'test video',
    needVocalAnswer: false,
    read: false,
    link: [''],
    isFamily: false);
