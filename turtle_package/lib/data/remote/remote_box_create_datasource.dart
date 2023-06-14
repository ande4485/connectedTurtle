abstract class RemoteBoxCreateDataSource {
  Future<(String email, String password, String idBox)> create();
}
