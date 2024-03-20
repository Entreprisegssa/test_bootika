import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyABkox-4yt470c3d5y2R8nSegJ5-lxTmO4",
        authDomain: "test-bootika.firebaseapp.com",
        databaseURL: "https://test-bootika-default-rtdb.firebaseio.com",
        projectId: "test-bootika",
        storageBucket: "test-bootika.appspot.com",
        messagingSenderId: "472345561643",
        appId: "1:472345561643:web:09fb7e15227e62bfb0386e",
        measurementId: "G-CW83YM9HTH"
      ),
    );
  }
  await FirebaseAppCheck.instance.activate(
    // You can also use a `ReCaptchaEnterpriseProvider` provider instance as an
    // argument for `webProvider`
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    // Default provider for Android is the Play Integrity provider. You can use the "AndroidProvider" enum to choose
    // your preferred provider. Choose from:
    // 1. Debug provider
    // 2. Safety Net provider
    // 3. Play Integrity provider
    androidProvider: AndroidProvider.debug,
    // Default provider for iOS/macOS is the Device Check provider. You can use the "AppleProvider" enum to choose
        // your preferred provider. Choose from:
        // 1. Debug provider
        // 2. Device Check provider
        // 3. App Attest provider
        // 4. App Attest provider with fallback to Device Check provider (App Attest provider is only available on iOS 14.0+, macOS 14.0+)
    appleProvider: AppleProvider.appAttest,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _repeatPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Bootika',
            style: TextStyle(
              fontFamily: 'MaShanZheng',
              fontSize: 60,
              fontWeight: FontWeight.w600,
              color: Colors.orange,
            ),
          ),
          const Text(
            'Remplissez les informations',
            style: TextStyle(
              color: Colors.black,
              fontSize: 17,
            ),
          ),
          const SizedBox(height: 10),
          Form(
            key: _formKey,
            child: Container(
              margin: const EdgeInsets.all(10),
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: "Email"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "L'email est obligatoire";
                      }
                      if (!RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~-]+@[a-zA-Z0-9-]+\.[a-zA-Z]+")
                          .hasMatch(value)) {
                        return "L'email n'est pas valide";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: "Mot de passe"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Le mot de passe est obligatoire";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _repeatPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: "Répéter le mot de passe"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Veuillez répéter le mot de passe";
                      }
                      if (value != _passwordController.text) {
                        return "Les mots de passe ne correspondent pas";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Envoyer les données à Firebase
                        final database = FirebaseDatabase.instance;
                        final data = {
                          "email": _emailController.text,
                          "mdp" : _passwordController.text,
                          // Vous pouvez ajouter d'autres champs ici si nécessaire
                        };
                        database
                            .ref()
                            .child("utilisateurs")
                            .push()
                            .set(data)
                            .then((_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Données envoyées avec succès !")),
                          );
                        }).catchError((error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text("Une erreur est survenue : " +
                                    error.toString())),
                          );
                        });
                      }
                    },
                    child: const Text("S'inscrire"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
