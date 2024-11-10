import 'package:hive/hive.dart';

abstract class UsersLocalDataSource {
  Future<void> initializeBox();
  Future<void> addUser(String username);
  Future<void> removeUser(String username);
  Future<List<String>> getUsers();
}

class UsersLocalDataSourceImpl implements UsersLocalDataSource {
  late Box box;

  @override
  Future<void> initializeBox() async {
    box = await Hive.openBox('users');
  }

  @override
  Future<void> addUser(String username) async {
    List<String> users = await getUsers();
    if (!users.contains(username)) {
      users.add(username);
      await box.put('users', users);
    }
  }

  @override
  Future<void> removeUser(String username) async {
    List<String> users = await getUsers();
    users.remove(username);
    await box.put('users', users);
  }

  @override
  Future<List<String>> getUsers() async {
    final u = box.get('users', defaultValue: <String>[]) as List<String>;
    return u;
  }
}