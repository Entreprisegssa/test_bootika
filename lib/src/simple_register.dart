import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gssa_simple_register/reUsable/constants_variables.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../reUsable/from_down_to_top.dart';


class GssaSimpleRegisteringForm extends StatefulWidget {
  const GssaSimpleRegisteringForm({super.key,
    required this.fields, required this.primaryColor,
    this.primaryIcon = FontAwesomeIcons.user,
    this.appBarBg = primaryBackground,
    this.scaffoldBg = primaryBackground,
    required this.db, required this.collection,
    required this.nextPage, required this.auth});

  final List<Map<String, dynamic>> fields;
  final Color primaryColor;
  final Color appBarBg;
  final Color scaffoldBg;
  final IconData primaryIcon;
  final FirebaseFirestore db;
  final String collection;
  final FirebaseAuth auth;
  final Widget nextPage;

  @override
  State<GssaSimpleRegisteringForm> createState() => _GssaSimpleRegisteringFormState();
}

class _GssaSimpleRegisteringFormState extends State<GssaSimpleRegisteringForm> {

  late List<TextEditingController> controllers;
  late List<Widget?> suffix;
  bool finished = false;

  bool isChecked = false;


  // fait un résumé des valeurs entrées et inscrit l'utilisateur
  Future<void> signupUser() async {
    String login = '';
    String pwd = '';
    Map<String, dynamic> resume = {};

    for(int i = 0; i < widget.fields.length; i ++) {

      // On ne stock pas le mot de passe dans la BD
      // donc quand il s'agit du mot de passe on le recupere
      // seulement pour inscrire l'utilisateur.
      if(widget.fields[i].containsKey('pwd') && widget.fields[i]['pwd']) {
        pwd = controllers[i].text;

      } else {
        // On recupere aussi le nom d'utiliateur
        // mais lui on le stock aussi dans la BD
        if(widget.fields[i].containsKey('login') && widget.fields[i]['login']) {
          login = controllers[i].text;
        }
        resume.addAll({
          widget.fields[i]['id'] : controllers[i].text
        });
      }

    }

    try {
      final credential = await widget.auth.createUserWithEmailAndPassword(
        email: RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$').hasMatch(login) ?
        login : '$login@bootika.com',
        password: pwd,
      );

      widget.db.collection(widget.collection).doc(credential.user?.uid).set(resume).then((value) {
        Navigator.pushReplacement(context, FromDownToUp(page: widget.nextPage));
      });

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        log('The password provided is too weak.');
        setState(() {
          finished = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Mot de passe doit être au moins de 8 caractères",
                style: TextStyle(color: Colors.white),),
              backgroundColor: Colors.red,
            )
        );
      } else if (e.code == 'email-already-in-use') {
        log('The account already exists for that email.');
        setState(() {
          finished = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Ce numéro de téléphone est déjà utilisé",
                style: TextStyle(color: Colors.white),),
              backgroundColor: Colors.red,
            )
        );
      }
    } catch (e) {
      if(kDebugMode) {
        print(e);
      }
    }

  }


  @override
  void initState() {
    controllers = [];
    suffix = [];
    for(var item in widget.fields) {
      controllers.add(TextEditingController());
      suffix.add(null);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: widget.appBarBg,
        leading: const Icon(FontAwesomeIcons.xmark, color: Colors.transparent,),
      ),
      backgroundColor: widget.scaffoldBg,
      body: SingleChildScrollView(
        // --Custom comment-- we use Stack here because we want
        // to freely move the avatar
        child: Stack(
          children: [
            Column(
              children: [
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: () {Navigator.pop(context);},
                          icon: const Icon(FontAwesomeIcons.xmark, size: 16,)),
                      SizedBox(width: screenWidth * 0.1,),
                      InkWell(
                        onTap: () {},
                        child: RichText(
                          text: TextSpan(
                              text: 'Vous avez déjà un compte ? ',
                              style: const TextStyle(
                                  color: textColor, fontSize: 14, fontFamily: primaryTextFont),
                              children: <TextSpan>[
                                TextSpan(text:'Connexion', style: TextStyle(
                                    fontWeight: FontWeight.w600, color: widget.primaryColor,
                                    fontSize: 14, fontFamily: primaryTextFont),
                                )
                              ]
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.06,),
                Container(
                  width: screenWidth,
                  height: screenHeight ,
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
                          'Inscription',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: primaryTextFont, color: textColor,
                              fontSize: 24,
                              letterSpacing: 0.5
                          ),),
                        const SizedBox(height: 15,),
                        const Text(
                          'Bienvenue, remplissez les champs suivant',
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: greyColor
                          ),
                        ),
                        const SizedBox(height: 45,),

                        for(int i = 0; i < widget.fields.length; i ++)
                          Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.fields[i]['label'],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: greyColor,
                                          fontSize: 14
                                      ),
                                    ),
                                    const SizedBox(height: 10,),
                                    SizedBox(
                                      height: 55,
                                      child: CupertinoTextField(
                                        obscureText: widget.fields[i]['type'] == 'password' ? true : false,
                                        onChanged: (String value) {
                                          if( widget.fields[i]['controlFunction'](value) ) {
                                            setState(() {
                                              suffix[i] = Row(
                                                children: [
                                                  Container(
                                                    width: 22,
                                                    height: 22,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(width: 2, color: primaryGreenColor)
                                                    ),
                                                    child: const Icon(Icons.check, color: primaryGreenColor, size: 15,),
                                                  ),
                                                  const SizedBox(width: 10,),
                                                ],
                                              );
                                            });
                                          } else {
                                            setState(() {
                                              suffix[i] = null;
                                            });
                                          }
                                        },
                                        controller: controllers[i],
                                        prefix: Row(
                                          children: [
                                            const SizedBox(width: 10,),
                                            Icon(widget.fields[i]['icon']),
                                            const SizedBox(width: 10,),

                                            if(widget.fields[i]['type'] == 'phone')
                                              const Text('(+225)', style: TextStyle(color: textColor,
                                                  fontFamily: primaryTextFont, fontSize: 14),),
                                            const SizedBox(width: 2,)
                                          ],
                                        ),
                                        suffix: suffix[i],
                                        placeholder: widget.fields[i]['placeholder'],
                                        keyboardType: widget.fields[i]['inputType'],
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
                            ],
                          ),
                        const SizedBox(height: 20,),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                          child: Row(
                            children: [
                              boxToCheck(),
                              const SizedBox(width: 20,),
                              SizedBox(
                                width: screenWidth * 0.7,
                                child: RichText(
                                  text: TextSpan(
                                      text: "En créant un compte, vous acceptez nos ",
                                      style: const TextStyle(
                                        fontFamily: primaryTextFont,
                                        color: Colors.grey,
                                      ),
                                      children: [
                                        TextSpan(
                                            text: "condition d'utilisation",
                                            style: TextStyle(
                                                color: widget.primaryColor,
                                                fontFamily: primaryTextFont
                                            )
                                        )
                                      ]
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        const Spacer(),
                        finished ?
                        LoadingAnimationWidget.staggeredDotsWave(
                          color: widget.primaryColor,
                          size: 53,
                        ) :
                        Container(
                          width: screenWidth * 0.82,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: widget.primaryColor
                          ),
                          child: TextButton(
                            onPressed: () async {
                              bool err = false;
                              String errorCause = '';

                              for(int i = 0; i < widget.fields.length; i ++) {
                                if(suffix[i] == null) {
                                  errorCause = "``${widget.fields[i]['label']}``";
                                  err = true;
                                  break;
                                }
                              }

                              if(err) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Veuillez bien renseigner le champs $errorCause',
                                        style: const TextStyle(color: Colors.white),),
                                      backgroundColor: Colors.red,
                                    )
                                );
                              } else if(!isChecked) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Veuillez accepter nos conditions d'utilisation avant de continuer",
                                        style: TextStyle(color: Colors.white),),
                                      backgroundColor: Colors.red,
                                    )
                                );
                              } else {
                                setState(() {
                                  finished = true;
                                });
                                signupUser();
                              }

                            },
                            child: const Text(
                              "S'INSCRIRE",
                              style: TextStyle(
                                  letterSpacing: 0.5,
                                  fontSize: 16,
                                  fontFamily: primaryTextFont,
                                  color: Colors.white
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 50,)
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
              child: CircleAvatar(
                backgroundColor: primaryCircleAvatarColor,
                child: Icon(widget.primaryIcon, size: 50,),
              ),

            ),
          ],
        ),
      ),
    );
  }


  // --custom comment-- checkbox widget
  Widget boxToCheck() {
    Color getColor(Set<MaterialState> states) {
      return Colors.transparent;
    }
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: widget.primaryColor),
      ),
      child: Checkbox(
        side: BorderSide.none,
        checkColor: widget.primaryColor,
        fillColor: MaterialStateProperty.resolveWith(getColor),
        value: isChecked,
        onChanged: (bool? value) {
          setState(() {
            isChecked = value!;
          });
        },
      ),
    );
  }

}