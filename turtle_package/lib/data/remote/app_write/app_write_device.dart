import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:turtle_package/data/remote/app_write/app_write_config.dart';

import 'package:turtle_package/data/remote/remote_device_datasource.dart';
import 'package:turtle_package/model/config_devices.dart';
import 'package:turtle_package/model/device.dart';
import 'package:turtle_package/model/device_user.dart';

class AppWriteDevice extends RemoteDeviceDataSource {
  final Teams teams;
  final Databases appDatabase;
  AppWriteDevice({required this.teams, required this.appDatabase});

  @override
  Future<Device> createDevice(ConfigDevices configDevices, String idBox) async {
    var idDevice = ID.unique();

    var device;
    //create a team // add an admin to turtle
    if (configDevices is ConfigTurtle) {
      var team = await teams.create(
          teamId: idDevice,
          name: configDevices.nameForTurtle,
          roles: [UserRole.admin.name]);
      /**await teams.updatePrefs(teamId: team.$id, prefs: {
        'fontSize': 10,
        'showInfo': false,
      });**/
      await teams.createMembership(
          teamId: team.$id,
          roles: [UserRole.box.name],
          url: PROJECT_URL,
          userId: idBox);
      await appDatabase.createDocument(
          databaseId: DEVICE_DATABASE_ID,
          collectionId: TURTLE_COLLECTION_ID,
          documentId: team.$id,
          data: {
            'fontSize': 10,
            'showInfo': false,
            'messageBeforeEnd': ""
          },
          permissions: [
            Permission.write(Role.team(team.$id, UserRole.admin.name)),
            Permission.update(Role.team(team.$id, UserRole.admin.name)),
            Permission.read(Role.team(team.$id, UserRole.admin.name))
          ]);

      device = Turtle(
          id: idDevice,
          nameDevice: configDevices.nameForTurtle,
          fontSize: 10,
          showInfo: false,
          messageBeforeEnd: "",
          users: []);
    } else if (configDevices is ConfigEmergency) {
      var emergencyDoc = await appDatabase.createDocument(
          databaseId: DEVICE_DATABASE_ID,
          collectionId: EMERGENCY_COLLECTION_ID,
          documentId: ID.unique(),
          data: {
            'idTurtle': configDevices.turtleId,
            'message': configDevices.message,
          },
          permissions: [
            Permission.write(
                Role.team(configDevices.turtleId, UserRole.admin.name)),
            Permission.update(
                Role.team(configDevices.turtleId, UserRole.admin.name)),
            Permission.read(
                Role.team(configDevices.turtleId, UserRole.admin.name))
          ]);
      return Emergency(
          id: emergencyDoc.$id,
          message: configDevices.message,
          turtleId: configDevices.turtleId);
    }
    return device;
  }

  @override
  Future<void> deleteDevice(String idDevice, DeviceType deviceType) async {
    if (deviceType == DeviceType.turtle) {
      await teams.delete(teamId: idDevice);
      await appDatabase.deleteDocument(
        databaseId: DEVICE_DATABASE_ID,
        collectionId: TURTLE_COLLECTION_ID,
        documentId: idDevice,
      );
    }
  }

  @override
  Future<Device?> getDeviceSettings(idDevice, DeviceType deviceType) async {
    if (deviceType == DeviceType.turtle) {
      var result = await appDatabase.getDocument(
        databaseId: DEVICE_DATABASE_ID,
        collectionId: TURTLE_COLLECTION_ID,
        documentId: idDevice,
      );

      return Turtle(
          id: idDevice,
          nameDevice: "",
          users: [],
          fontSize: result.data['fontSize'],
          showInfo: result.data['showInfo'],
          messageBeforeEnd: result.data['messageBeforeEnd']);
    } else if (deviceType == DeviceType.emergency) {
      var result = await appDatabase.getDocument(
        databaseId: DEVICE_DATABASE_ID,
        collectionId: EMERGENCY_COLLECTION_ID,
        documentId: idDevice,
      );
      return Emergency(
          id: idDevice,
          turtleId: result.data['idTurtle'],
          message: result.data['message']);
    } else {
      return null;
    }
  }

  @override
  Stream<Device?> listenDevice(idDevice) {
    // TODO: implement listenDevice
    throw UnimplementedError();
  }

  @override
  Future<void> updateDeviceSettings(Device device) async {
    if (device is Turtle) {
      await appDatabase.updateDocument(
          databaseId: DEVICE_DATABASE_ID,
          collectionId: TURTLE_COLLECTION_ID,
          documentId: device.id,
          data: {
            'fontSize': device.id,
            'showInfo': device.showInfo,
            'messageBeforeEnd': device.messageBeforeEnd
          });
      /**
       * Because Github bug
       * teams.updatePrefs(
          teamId: device.id,
          prefs: {'fontSize': device.fontSize, 'showInfo': device.showInfo});**/
    } else if (device is Emergency) {
      await appDatabase.updateDocument(
          databaseId: DEVICE_DATABASE_ID,
          collectionId: EMERGENCY_COLLECTION_ID,
          documentId: device.id,
          data: {
            'message': device.message,
          });
    }
  }

  @override
  Future<List<Device>> getDevicesByUser(idUser, deviceType) async {
    if (deviceType == DeviceType.turtle) {
      TeamList teamsList = await teams.list();
      List<Turtle> turtles = [];
      for (Team team in teamsList.teams) {
        //var prefs = team.prefs;
        Turtle turtle = await _getTurtle(team);
        turtles.add(turtle);
      }

      return turtles;
    } else if (deviceType == DeviceType.emergency) {
      //TODO
      return [];
    } else
      return [];
  }

  Future<Turtle> _getTurtle(Team team) async {
    var settings = await appDatabase.getDocument(
        databaseId: DEVICE_DATABASE_ID,
        collectionId: TURTLE_COLLECTION_ID,
        documentId: team.$id);
    var teamMemberships = await teams.listMemberships(teamId: team.$id);
    var usersDevices = teamMemberships.memberships.where(
        (user) => user.confirm && !user.roles.contains(UserRole.box.name));
    return Turtle(
        id: team.$id,
        nameDevice: team.name,
        fontSize: settings.data['fontSize'] ?? "10",
        showInfo: settings.data['showInfo'] ?? false,
        messageBeforeEnd: settings.data['messageBeforeEnd'],
        users: usersDevices
            .map((e) => SimpleDeviceUser(id: e.$id, name: e.teamName))
            .toList());
  }

  @override
  Future<bool> deviceExist(String deviceId, DeviceType deviceType) async {
    if (deviceType == DeviceType.turtle) {
      try {
        await teams.get(teamId: deviceId);
        return true;
      } catch (e) {
        return false;
      }
    } else {
      return false;
    }
  }

  @override
  Future<Device?> getDevice(String deviceId, DeviceType deviceType) async {
    if (deviceType == DeviceType.turtle) {
      try {
        var team = await teams.get(teamId: deviceId);
        return await _getTurtle(team);
      } catch (e) {
        return null;
      }
    } else if (deviceType == DeviceType.emergency) {
      var result = await appDatabase.getDocument(
        databaseId: DEVICE_DATABASE_ID,
        collectionId: EMERGENCY_COLLECTION_ID,
        documentId: deviceId,
      );
      return Emergency(
          id: deviceId,
          turtleId: result.data['idTurtle'],
          message: result.data['message']);
    } else {
      return null;
    }
  }
}
