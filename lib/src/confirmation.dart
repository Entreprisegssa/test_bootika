
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:login_package/src/constants_variables.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Confirmation extends StatefulWidget {
  const Confirmation({super.key, required this.phoneNumber, required this.userUId});
  final String phoneNumber ;
  final String userUId;

  @override
  State<Confirmation> createState() => _ConfirmationState();
}

class _ConfirmationState extends State<Confirmation> {

  List<TextEditingController> otpDigitControllers =  List.generate(4, (_) => TextEditingController());
  List<FocusNode> focusNodeList = List.generate(4, (_) => FocusNode());
  List<Color?> borderColor = List.generate(4, (_) => null);
  bool done = false;
  String _verificationId = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _verifyPhoneNumber();
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
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(FontAwesomeIcons.xmark, size: 16,),
                ),
              ],
            ),
            Column(
              children: [
                SizedBox(height: screenHeight * 0.12,),
                Container(
                  width: screenWidth,
                  height: screenHeight * 0.8,
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
                        const SizedBox(height: 90,),
                        const Text(
                          'Confirmation du N°',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: primaryTextFont, color: textColor,
                              fontSize: 24,
                              letterSpacing: 0.5
                          ),),
                        const SizedBox(height: 15,),
                        const Text(
                          'Veuillez entrer le code reçu au',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: greyColor,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Text(
                          '(+225) ${widget.phoneNumber}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w400, 
                              color: greyColor, 
                              fontSize: 14
                          ),
                        ),
                        const SizedBox(height: 4,),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01, vertical: 40),
                          child: Row(
                            children: [
                          Container(
                          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(color: textFieldBackground,
                            borderRadius: BorderRadius.circular(15.0),
                            border: Border.all(width: 1, color: borderColor[0] == null ? Colors.transparent : borderColor[0]!),
                          ),
                          child: Center(
                            child: CupertinoTextField(
                              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                              focusNode: focusNodeList[0],
                              maxLength: 1,
                              cursorColor: primaryGreenColor,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(
                                fontSize: 20,
                                fontFamily: primaryTextFont,
                                color: textColor,
                                fontWeight: FontWeight.w600,
                              ),
                              decoration: const BoxDecoration(
                                color: Colors.transparent,

                              ),
                              controller: otpDigitControllers[0],
                              onChanged: (String value) {
                                if(value.isNotEmpty) {
                                  focusNodeList[1].requestFocus();
                                 setState(() {
                                   borderColor[0] = primaryGreenColor;
                                 });
                                } else {
                                  setState(() {
                                    borderColor[0] = null;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                              SizedBox(width: screenWidth * 0.03,),
                              Container(
                                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                    color: textFieldBackground,
                                    borderRadius: BorderRadius.circular(15.0),
                                  border: Border.all(width: 1, color: borderColor[1] == null ? Colors.transparent : borderColor[1]!),
                                ),
                                child: Center(
                                  child: CupertinoTextField(
                                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                                    focusNode: focusNodeList[1],
                                    maxLength: 1,
                                    cursorColor: primaryGreenColor,
                                    keyboardType: TextInputType.number,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontFamily: primaryTextFont,
                                      color: textColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    decoration: const BoxDecoration(
                                      color: Colors.transparent,

                                    ),
                                    controller: otpDigitControllers[1],
                                    onChanged: (String value) {
                                      if(value.isNotEmpty) {
                                        focusNodeList[2].requestFocus();
                                        setState(() {
                                          borderColor[1] = primaryGreenColor;
                                        });
                                      } else {
                                        setState(() {
                                          borderColor[1] = null;
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(width: screenWidth * 0.03,),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: screenWidth * 0.03, horizontal: 15.0),
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                    color: textFieldBackground,
                                    borderRadius: BorderRadius.circular(15.0),
                                  border: Border.all(width: 1, color: borderColor[2] == null ? Colors.transparent : borderColor[2]!),
                                ),
                                child: Center(
                                  child: CupertinoTextField(
                                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                                    focusNode: focusNodeList[2],
                                    maxLength: 1,
                                    cursorColor: primaryGreenColor,
                                    keyboardType: TextInputType.number,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontFamily: primaryTextFont,
                                      color: textColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    decoration: const BoxDecoration(
                                      color: Colors.transparent,

                                    ),
                                    controller: otpDigitControllers[2],
                                    onChanged: (String value) {
                                      if(value.isNotEmpty) {
                                        focusNodeList[3].requestFocus();
                                        setState(() {
                                          borderColor[2] = primaryGreenColor;
                                        });
                                      } else {
                                        setState(() {
                                          borderColor[2] = null;
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(width: screenWidth * 0.03,),
                              Container(
                                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                    color: textFieldBackground,
                                    borderRadius: BorderRadius.circular(15.0),
                                  border: Border.all(width: 1, color: borderColor[3] == null ? Colors.transparent : borderColor[3]!),
                                ),
                                child: Center(
                                  child: CupertinoTextField(
                                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                                    focusNode: focusNodeList[3],
                                    maxLength: 1,
                                    cursorColor: primaryGreenColor,
                                    keyboardType: TextInputType.number,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontFamily: primaryTextFont,
                                      color: textColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    decoration: const BoxDecoration(
                                      color: Colors.transparent,

                                    ),
                                    controller: otpDigitControllers[3],
                                    onChanged: (String value) {
                                      if(value.isNotEmpty) {
                                        focusNodeList[3].unfocus();
                                        borderColor[3] = primaryGreenColor;
                                      } else {
                                        setState(() {
                                          borderColor[3] = null;
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          text: const TextSpan(
                              text: "Je n'ai pas reçu le code.",
                              style: TextStyle(color: textColor, fontFamily: primaryTextFont),
                              children: [
                                TextSpan(
                                    text: ' Renvoyer le code',
                                    style: TextStyle(
                                        color: primaryGreenColor,
                                        fontFamily: primaryTextFont
                                    )
                                )
                              ]
                          ),
                        ),
                        const Spacer(),
                        done ? LoadingAnimationWidget.staggeredDotsWave(
                          color: primaryGreenColor,
                          size: 53,
                        ) : Container(
                          width: screenWidth * 0.82,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: primaryGreenColor
                          ),
                          child: TextButton(
                              onPressed: () async{
                                int i = 0;
                                bool err = false;
                                while(i < otpDigitControllers.length) {
                                  if(otpDigitControllers[i].text.isEmpty) {
                                    err = true;
                                    break;
                                  }
                                  i ++;
                                }
                                if(i == otpDigitControllers.length) {
                                  setState(() {
                                    done = true;
                                  });

                                  _submitVerificationCode();

                                } else if(err) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Veuillez entrer le code reçu par sms',
                                          style: TextStyle(
                                              color: Colors.white),),
                                        backgroundColor: Colors.red,
                                      )
                                  );
                                }

                              },
                            child: const Text(
                              'CONTINUER',
                              style: TextStyle(
                                  letterSpacing: 0.5,
                                  fontSize: 16,
                                  fontFamily: primaryTextFont,
                                  color: Colors.white
                              ),
                            )
                          ),
                        ),
                        const SizedBox(height: 20,),
                        const Text(
                          'En vous connectant, vous acceptez',
                          style: TextStyle(
                            fontFamily: primaryTextFont,
                            color: greyColor,
                          ),
                        ),
                        const SizedBox(height: 5,),
                        InkWell(
                          onTap: () {},
                          child: const Text(
                            'Notre politique de confidentialité',
                            style: TextStyle(
                              fontFamily: primaryTextFont,
                              color: primaryGreenColor,
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

  void _verifyPhoneNumber() async {
    await _auth.verifyPhoneNumber(
      phoneNumber: '+225 ${widget.phoneNumber}',
      verificationCompleted: (PhoneAuthCredential credential) async {},
      verificationFailed: (FirebaseAuthException e) {
        if (kDebugMode) {
          print('Verification Failed: ${e.message}');
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Handle timeout if needed
      },
    );
  }

  void _submitVerificationCode() {
    String smsCode = otpDigitControllers.join();
    PhoneAuthCredential credential =
    PhoneAuthProvider.credential(verificationId: _verificationId, smsCode: smsCode);
    if (kDebugMode) {
      print('Access token : ${credential.accessToken}');
    }
  }


}