import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:turtle_package/data/remote/app_write/app_write_config.dart';
import 'package:turtle_package/data/remote/remote_device_users_datasource.dart';
import 'package:turtle_package/domain/repository/request_result.dart';
import 'package:turtle_package/model/device_user.dart';

class AppWriteDeviceUsers extends RemoteDeviceUsersDataSource {
  final Teams teams;
  final Realtime realtime;
  final Account account;
  AppWriteDeviceUsers(
      {required this.teams, required this.realtime, required this.account});

  @override
  Future<void> addUserToEmergency(
      DeviceUser turtleUser, String idDevice) async {
    MembershipList listMembers = await teams.listMemberships(teamId: idDevice);
    var member = listMembers.memberships
        .firstWhere((element) => element.$id == turtleUser.id);
    List<String> roles = List<String>.from(member.roles);
    roles.add(UserRole.emergency.name);
    await teams.updateMembershipRoles(
        teamId: idDevice, membershipId: member.$id, roles: roles);
  }

  @override
  Future<ResultRequest> changeAdmin(idUser, idDevice) {
    // TODO: implement changeAdmin
    throw UnimplementedError();
  }

  @override
  Future<void> createInvitation(
      String email, String idDevice, String nameForDevice) async {
    await teams.createMembership(
        teamId: idDevice,
        roles: [UserRole.normal.name],
        url: PROJECT_URL,
        email: email);
  }

  @override

  /// 1 users
  /// 2 invited users
  /// 3 emergency users
  Stream<
      (
        List<DeviceUser>,
        List<DeviceUser>,
        List<DeviceUser>,
      )> getDeviceUsers(String idDevice) {
    /**final subscription = realtime.subscribe(['teams.$idDevice.memberships.*']);
    return subscription.stream.map((response) {
      // Log when a new file is uploaded
      print(response);
      return ([], [], [], []);
    });**/

    return teams.listMemberships(teamId: idDevice).asStream().map((event) {
      List<Membership> users = event.memberships;
      print(users);
      var invitedUsers = users.where((user) => user.joined.isEmpty);

      var usersDevices = users.where(
          (user) => user.confirm && !user.roles.contains(UserRole.box.name));
      var emergencyUsers =
          users.where((user) => user.roles.contains(UserRole.emergency.name));

      return (
        usersDevices
            .map((e) => DeviceUser(
                    id: e.$id,
                    name: e.userName,
                    lastName: e.userName,
                    birthDate: DateTime.now(),
                    turtlesInfo: [
                      UserTurtleInfo(
                        nameUserForDevice: e.userName,
                        userRole: e.roles
                            .map((e) => UserRole.values.byName(e))
                            .toList(),
                        idTurle: idDevice,
                        nameTurtle: "",
                      )
                    ]))
            .toList(),
        invitedUsers
            .map((e) => DeviceUser(
                    id: e.$id,
                    name: e.userName,
                    lastName: e.userName,
                    birthDate: DateTime.now(),
                    turtlesInfo: [
                      UserTurtleInfo(
                        nameUserForDevice: e.userName,
                        userRole: e.roles
                            .map((e) => UserRole.values.byName(e))
                            .toList(),
                        idTurle: idDevice,
                        nameTurtle: "",
                      )
                    ]))
            .toList(),
        emergencyUsers
            .map((e) => DeviceUser(
                    id: e.$id,
                    name: e.userName,
                    lastName: e.userName,
                    birthDate: DateTime.now(),
                    turtlesInfo: [
                      UserTurtleInfo(
                        nameUserForDevice: e.userName,
                        userRole: e.roles
                            .map((e) => UserRole.values.byName(e))
                            .toList(),
                        idTurle: idDevice,
                        nameTurtle: "",
                      )
                    ]))
            .toList()
      );
    });
  }

  @override
  Future<void> removeUserEmergency(
      DeviceUser turtleUser, String idDevice) async {
    MembershipList listMembers = await teams.listMemberships(teamId: idDevice);
    var member = listMembers.memberships
        .firstWhere((element) => element.$id == turtleUser.id);
    List<String> roles = List<String>.from(member.roles);
    roles.remove(UserRole.emergency.name);
    await teams.updateMembershipRoles(
        teamId: idDevice, membershipId: member.$id, roles: roles);
  }

  @override
  Future<void> removeUserOfDevice(
      DeviceUser turtleUser, String idDevice) async {
    MembershipList listMembers = await teams.listMemberships(teamId: idDevice);
    var member = listMembers.memberships
        .firstWhere((element) => element.$id == turtleUser.id);
    teams.deleteMembership(teamId: idDevice, membershipId: member.$id);
  }

  @override
  Future<void> acceptInvitation(
      String idUser, Map<String, dynamic> invitationParams) async {
    await teams.updateMembershipStatus(
        secret: invitationParams['password'],
        userId: idUser,
        membershipId: invitationParams['membershipId'],
        teamId: invitationParams['turtleId']);
  }

  @override
  Future<DeviceUser> getUser(String idUser) async {
    User user = await account.get();
    var teamsUser = await teams.list();
    List<UserTurtleInfo> turtlesInfo = [];
    for (Team team in teamsUser.teams) {
      var memberships = await teams.listMemberships(teamId: team.$id);
      var userTurtleInfo = memberships.memberships
          .firstWhere((element) => element.userId == idUser);
      turtlesInfo.add(UserTurtleInfo(
          idTurle: team.$id,
          nameTurtle: team.name,
          nameUserForDevice: userTurtleInfo.userName,
          userRole: userTurtleInfo.roles
              .map((e) => UserRole.values.byName(e))
              .toList()));
    }
    return DeviceUser(
        id: idUser,
        name: user.name,
        lastName: user.prefs.data['lN'] ?? "",
        turtlesInfo: turtlesInfo,
        birthDate: user.prefs.data['BD'] != null
            ? DateTime.parse(user.prefs.data['BD'])
            : DateTime.now());
  }

  @override
  Future<void> refuseInvitation(idUser, idDevice) async {
    await teams.deleteMembership(teamId: idDevice, membershipId: idUser);
  }

  @override
  Future<DeviceUser> updateUser(DeviceUser user) async {
    await account.updatePrefs(
        prefs: {'lN': user.lastName, 'BD': user.birthDate.toString()});
    return user;
  }
}
