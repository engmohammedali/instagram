import 'package:flutter/foundation.dart';
import 'package:instagram/Firebase_servse/Auth/Auth.dart';
import 'package:instagram/model/User.dart';

class UserProvider with ChangeNotifier {
  UserData? _UserData;
  UserData? get getUser => _UserData;

  refreshUser() async {
    UserData userData = await FirebaseFunction().getUserDetails();
    _UserData = userData;
    notifyListeners();
  }
}
