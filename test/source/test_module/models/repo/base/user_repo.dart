import '../../../user.dart';

abstract class UserRepo {
  List<User> getUsers();
}