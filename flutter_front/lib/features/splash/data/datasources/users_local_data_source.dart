import 'package:hive/hive.dart';

abstract class UsersLocalDataSource {
  Future<void> initializeBox();
  Future<void> addUser(String username);
  Future<void> removeUser(String username);
  Future<List<String>> getUsers();
}

class UsersLocalDataSourceImpl implements UsersLocalDataSource {
  Box? _box;

  Future<Box> get box async {
    if (_box == null || !_box!.isOpen) {
      _box = await Hive.openBox('users');
    }
    return _box!;
  }

  @override
  Future<void> initializeBox() async {
    if (_box != null && _box!.isOpen) {
      await _box!.close();
    }
    _box = await Hive.openBox('users');
  }

  @override
  Future<void> addUser(String username) async {
    final openedBox = await box;
    List<String> users = await getUsers();
    if (!users.contains(username)) {
      users.add(username);
      await openedBox.put('users', users);
    }
  }

  @override
  Future<void> removeUser(String username) async {
    final openedBox = await box;
    List<String> users = await getUsers();
    users.remove(username);
    await openedBox.put('users', users);
  }

  @override
  Future<List<String>> getUsers() async {
    final openedBox = await box;
    final u = openedBox.get('users', defaultValue: <String>[]) as List<String>;
    return u;
  }
}