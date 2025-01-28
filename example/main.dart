import 'package:deep_inside/deep_inside.dart';

void main() async {
  // Initialize the library
  await DeepInside.init();

  // Example usage
  await DeepInside.saveToken('example_token');

  await DeepInside.saveLocale('en_US');

  final user = {'id': 1, 'name': 'John Doe'};
  await DeepInside.saveUser(user);
}
