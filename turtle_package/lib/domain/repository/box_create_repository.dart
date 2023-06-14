abstract class BoxCreateRepository {
  Future<(String email, String password, String idBox)> create();
}
