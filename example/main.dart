import 'package:deep_inside/deep_inside.dart';

void main() async {
  // Initialize the library
  await DeepInside.init();

  // Example usage
  await DeepInside.saveToken('example_token');
  print('Saved Token: ${DeepInside.getToken()}');

  await DeepInside.saveLocale('en_US');
  print('Locale: ${DeepInside.getLocale()}');

  final user = {'id': 1, 'name': 'John Doe'};
  await DeepInside.saveUser(user);
  print('User: ${DeepInside.getUser()}');
}
