import '../user.dart';
import 'address_view.dart';
import 'view.dart';

class UserView extends View {
  final User user;

  UserView(this.user);

  @override
  Iterable<String> build() {
    return [
      'User: ${user.name}',
      'Address: ${AddressView(user.address)}',
    ];
  }
}