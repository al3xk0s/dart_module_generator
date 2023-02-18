import '../address.dart';
import 'view.dart';

class AddressView extends View {
  final Address address;

  AddressView(this.address);

  @override
  Iterable<String> build() {
    return [
      '${address.streat}, ${address.homeNumber}'
    ];
  }
}