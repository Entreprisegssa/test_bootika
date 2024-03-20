import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:test_bootika/Accueil/page_acceuil.dart';

class PageDeConnection extends StatelessWidget {
  const PageDeConnection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormBuilderState>();

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
            'Connectez-vous',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 20),
          FormBuilder(
            key: _formKey,
            autovalidateMode: AutovalidateMode.always,
            child: Container(
              margin: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Connexion', style: TextStyle(fontSize: 18.0)),
                  FormBuilderTextField(
                    name: 'numero',
                    decoration: InputDecoration(labelText: 'Numéro'),
                    validator: FormBuilderValidators.required(),
                  ),
                  FormBuilderTextField(
                    name: 'password',
                    decoration: InputDecoration(labelText: 'Mot de passe'),
                    obscureText: true,
                    validator: FormBuilderValidators.required(),
                  ),
                  SizedBox(height: 10.0),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.saveAndValidate()) {
                        // Vérifier l'authentification
                        print(_formKey.currentState!.value);

                         Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => PageAcceuil(),
                          ));
                      }
                    },
                    child: Text('Se connecter'),
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


//  Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => SignUpPage()),
//       );