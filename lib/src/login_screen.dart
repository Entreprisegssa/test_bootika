

import 'dart:developer';

import 'package:login_package/src//confirmation.dart';
import 'package:login_package/src/selection_magasin.dart';
import 'package:login_package/src//transition_left_to_right.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:gssa_simple_register/gssa_simple_register.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'constants_variables.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'next_page.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.nextPage});
  final Widget nextPage;
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  late TextEditingController phoneTextFieldController;
  late TextEditingController pwdTextFieldController;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Widget? phoneFieldSuffix;

  @override
  void initState() {
    phoneTextFieldController = TextEditingController();
    pwdTextFieldController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    phoneTextFieldController.dispose();
    pwdTextFieldController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryBackground,
        leading: const Icon(FontAwesomeIcons.xmark, color: Colors.transparent,),
      ),
      backgroundColor: primaryBackground,
      body: SingleChildScrollView(
        // --Custom comment-- we use Stack here because we want
        // to freely move the avatar
        child: Stack(
          children: [
            Column(
              children: [
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [

                      TextButton(
                        onPressed: () {

                        },
                        child: const Text('Mot de passe oublié ?', style: TextStyle(
                          fontFamily: primaryTextFont,
                          color: textColor
                        ),),
                      )
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.068,),
                Container(
                  width: screenWidth,
                  height: screenHeight * 0.83,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40)
                      )
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 60,),
                        const Text(
                          'Connexion',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: primaryTextFont, color: textColor,
                              fontSize: 24,
                              letterSpacing: 0.5
                          ),),
                        const SizedBox(height: 15,),
                        const Text(
                          'Veuillez renseignez vos informations',
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: primaryGreenColor
                          ),
                        ),
                        const SizedBox(height: 45,),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Numéro de téléphone',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: greyColor,
                                    fontSize: 14
                                ),
                              ),
                              const SizedBox(height: 10,),
                              SizedBox(
                                height: 55,
                                child: CupertinoTextField(
                                  onChanged: (value) {
                                    setState(() {
                                      if(value.length >= 2 && RegExp(r'^(01|05|07)[0-9]{8}$').hasMatch(value)) {
                                        phoneFieldSuffix = const SizedBox();
                                      } else {
                                        phoneFieldSuffix = null;
                                      }
                                    });
                                  },
                                  controller: phoneTextFieldController,
                                  prefix:  const Row(
                                    children: [
                                      SizedBox(width: 10,),
                                      Icon(Icons.phone_android_outlined),
                                      SizedBox(width: 10,),
                                      Text('(+225)', style: TextStyle(color: textColor,
                                          fontFamily: primaryTextFont, fontSize: 14),),
                                      SizedBox(width: 5,)
                                    ],
                                  ),
                                  placeholder: 'numéro de téléphone',
                                  keyboardType: TextInputType.phone,
                                  decoration: BoxDecoration(
                                      color: textFieldBackground,
                                      borderRadius: BorderRadius.circular(15)
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.03,),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Mot de passe',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: greyColor,
                                    fontSize: 14
                                ),
                              ),
                              const SizedBox(height: 10,),
                              SizedBox(
                                height: 55,
                                child: CupertinoTextField(
                                  obscureText: true,
                                  controller: pwdTextFieldController,
                                  prefix:  const Row(
                                    children: [
                                      SizedBox(width: 10,),
                                      Icon(Icons.lock_outline_rounded),
                                      SizedBox(width: 20,)
                                    ],
                                  ),
                                  placeholder: 'Indiquez votre mot de passe',
                                  keyboardType: TextInputType.text,
                                  decoration: BoxDecoration(
                                      color: textFieldBackground,
                                      borderRadius: BorderRadius.circular(15)
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Container(
                          width: screenWidth * 0.82,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: primaryGreenColor
                          ),
                          child: TextButton(
                            onPressed: () {
                              bool err = false;
                              String errorCause = '';
                              if (phoneFieldSuffix == null) {
                                err = true;
                                errorCause = 'Téléphone';

                              } else if(pwdTextFieldController.text.isEmpty) {
                                err = true;
                                errorCause = 'Mot de passe';
                              }

                              if (err) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Veuillez bien renseigner le champs $errorCause',
                                        style: const TextStyle(
                                            color: Colors.white),),
                                      backgroundColor: Colors.red,
                                    )
                                );
                              } else {
                                signin(phoneTextFieldController.text,
                                    pwdTextFieldController.text);
                              }
                            },
                            child: const Text(
                              'CONNEXION',
                              style: TextStyle(
                                  letterSpacing: 0.5,
                                  fontSize: 16,
                                  fontFamily: primaryTextFont,
                                  color: Colors.white
                              ),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(context, SlideRightPageRoute(page:
                            GssaSimpleRegisteringForm(
                              fields: [
                                {
                                  'id': 'name',
                                  'icon' : FontAwesomeIcons.user,
                                  'label' : 'Votre nom',
                                  'type'  : 'text',
                                  'inputType' : TextInputType.text,
                                  'placeholder': 'Entrerz votre nom ici',
                                  'controlFunction' : (String value) {
                                    if(value.length >= 3) {
                                      return true;
                                    } else {
                                      return false;
                                    }
                                  },
                                },

                                {
                                  'id': 'phone',
                                  'login' : true,
                                  'icon' : FontAwesomeIcons.phone,
                                  'label' : 'Votre Telephone',
                                  'type'  : 'phone',
                                  'inputType' : TextInputType.phone,
                                  'placeholder': 'Votre numero de telephone',
                                  'controlFunction' : (String value) {
                                    if(value.length >= 2 && RegExp(r'^(01|05|07)[0-9]{8}$').hasMatch(value)) {
                                      return true;
                                    } else {
                                      return false;
                                    }
                                  },
                                },

                                {
                                  'id' : 'password',
                                  'pwd' : true,
                                  'icon' : FontAwesomeIcons.lock,
                                  'label' : 'Mot de passe',
                                  'type'  : 'password',
                                  'inputType' : TextInputType.text,
                                  'placeholder': 'Entrez un mot de passe',
                                  'controlFunction' : (String value) {
                                    if(value.length >= 8) {
                                      return true;
                                    } else {
                                      return false;
                                    }
                                  },
                                }
                              ],
                              primaryColor: primaryCircleAvatarColor,
                              db: db,
                              auth: auth,
                              collection: 'users',
                              nextPage: const LoginScreen(nextPage: NextPage(),),
                            )));
                          },
                          child: const Text(
                            'Créer un compte',
                            style: TextStyle(
                              fontFamily: primaryTextFont,
                              color: textColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 50,),
                      ],
                    ),
                  ),
                )
              ],
            ),
            Positioned(
              width: 80,
              height: 80,
              left: screenWidth * 0.39,
              top: screenHeight * 0.074,
              child: const CircleAvatar(
                backgroundColor: primaryCircleAvatarColor,
                child: Icon(FontAwesomeIcons.user, size: 50,),
              ),

            ),
          ],
        ),
      ),
    );
  }

  Future<void> signin(String phone, String password) async{
    try {
      UserCredential credential = await auth.signInWithEmailAndPassword(
          email: '$phone@gmail.com', password: password);

      Widget pageToGo;

      DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore.instance.collection('users')
          .doc(credential.user!.uid)
          .get();

      pageToGo = doc.data()!.containsKey('creePar') ?
          const SelectionnerMagasin() :
          widget.nextPage;

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Connexion reussie',
              style: TextStyle(
                  color: Colors.white),),
            backgroundColor: Colors.green,
          )
      );
      Navigator.pushReplacement(context, SlideRightPageRoute(page: pageToGo));

    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Cet compte n\'exise pas',
                style: TextStyle(
                    color: Colors.white),),
              backgroundColor: Colors.red,
            )
        );
      } else if (e.code == 'wrong-password') {
        if (kDebugMode) {
          print('Wrong password provided for that user.');
        }
      }
    }
  }

}