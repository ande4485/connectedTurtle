import 'package:turtle_package/data/remote/remote_box_create_datasource.dart';
import 'package:turtle_package/domain/repository/box_create_repository.dart';

class BoxCreateRepositoryImpl extends BoxCreateRepository {
  final RemoteBoxCreateDataSource remoteBoxCreateDataSource;
  BoxCreateRepositoryImpl({required this.remoteBoxCreateDataSource});

  @override
  Future<(String email, String password, String idBox)> create() {
    return remoteBoxCreateDataSource.create();
  }
}
