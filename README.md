# DeepInside

`DeepInside` is a lightweight, secure, and user-friendly Flutter library for managing local storage. Designed with performance and security in mind, it supports encrypted storage for sensitive data like API tokens, user profiles, and more.

---

## Features
- 🔒 **Encrypted Storage**: AES encryption with CBC mode and PKCS7 padding ensures data security.
- 🗂 **Flexible Data Handling**: Store strings, maps, lists, and other types effortlessly.
- 🌍 **Localization Support**: Save and retrieve locale settings with ease.
- 👤 **User Management**: Securely store and manage user data.
- 🚀 **High Performance**: Optimized for speed and minimal dependency overhead.

---

## Installation

Add `deep_inside` to your `pubspec.yaml`:
```yaml
dependencies:
  deep_inside: ^1.0.0


Install it using:

Run this command:  flutter pub get

Usage

1. Initialize the Library
Initialize the library in your app's entry point:

    void main() async {
      WidgetsFlutterBinding.ensureInitialized();
      await DeepInside.init();
      runApp(MyApp());
    }


2. Save and Retrieve Data
Save and Retrieve a Token

    await DeepInside.saveToken('your_secure_token');
    print(DeepInside.getToken()); // Outputs: your_secure_token

Save and Retrieve Locale Settings

    await DeepInside.saveLocale('en_US');
    print(DeepInside.getLocale()); // Outputs: en_US
    
Save and Retrieve User Data

    await DeepInside.saveUser({'id': 1, 'name': 'John Doe'});
    print(DeepInside.getUser()); // Outputs: {id: 1, name: John Doe}

Generic Key-Value Storage

    await DeepInside.setValue('example_key', 'example_value');
    print(DeepInside.getValue<String>('example_key')); // Outputs: example_value

3. Clear or Remove Data
Remove a Key
    await DeepInside.remove('example_key');

Clear All Data

    await DeepInside.clear();

