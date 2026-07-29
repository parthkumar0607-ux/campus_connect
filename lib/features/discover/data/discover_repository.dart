import '../models/discover_user_model.dart';
import 'discover_remote_datasource.dart';

class DiscoverRepository {
  final DiscoverRemoteDataSource _remote =
      DiscoverRemoteDataSource();

  Future<List<DiscoverUser>> getUsers() {
    return _remote.getUsers();
  }
}