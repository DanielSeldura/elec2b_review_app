import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/src/screens/login/user_model.dart';

class AuthController with ChangeNotifier {
  final Box accountsCache = Hive.box('accounts');
  User? currentUser;
  List<User> users = [];
  AuthController() {
    List result = accountsCache.get('users', defaultValue: []);
    print(result);
    for (var entry in result) {
      print(entry);
      users.add(User.fromJson(Map<String, dynamic>.from(entry)));
    }
    notifyListeners();
  }

  String register(String username, String password) {
    if (userExists(username) != null) {
      return 'Error: the username is already taken';
    } else {
      users.add(User(username: username, password: password));
      saveDataToCache();
      return "User Successfully registered";
    }
  }

  bool login(String username, String password) {
    User? userSearchResult = userExists(username);
    if (userSearchResult != null) {
      bool result = userSearchResult.login(username, password);
      if (result) {
        currentUser = userSearchResult;
        notifyListeners();
      }
      return result;
    } else {
      return false;
    }
  }

  logout() {
    currentUser = null;
    notifyListeners();
  }

  User? userExists(String username) {
    for (User user in users) {
      if (user.exists(username)) return user;
    }
    return null;
  }

  saveDataToCache() {
    List<Map<String, dynamic>> dataToStore = [];
    for (User user in users) {
      dataToStore.add(user.toJson());
    }
    print(dataToStore);
    accountsCache.put('users', dataToStore);
    notifyListeners();
  }
}
