import 'dart:developer';

import 'package:login_package/src//constants_variables.dart';
import 'package:login_package/src//selectionner_caisse.dart';
import 'package:login_package/src//transition_left_to_right.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class SelectionnerMagasin extends StatefulWidget{
  const SelectionnerMagasin({super.key});

  @override
  State<SelectionnerMagasin> createState() => _SelectionnerMagasinState();
}

class _SelectionnerMagasinState extends State<SelectionnerMagasin> {

  String _userId = '';
  List<Color> bgList = [];
  String magasinId = '';

  @override
  void initState() {
    super.initState();
    getAdminDocId();
  }

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(),
      bottomSheet: Container(
       padding: const EdgeInsets.all(8.0),
        child: Container(
          width: screenWidth * 0.9,
          decoration: BoxDecoration(
              color: primaryCircleAvatarColor,
              borderRadius: BorderRadius.circular(5.0)
          ),
          child: TextButton(
            onPressed: () {
              if(magasinId.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Veuillez choisir un magasin',
                        style: TextStyle(
                            color: Colors.white),),
                      backgroundColor: Colors.red,
                    )
                );
              } else {
                Navigator.push(context, SlideRightPageRoute(page:
                  SelectionnerCaisse(magasinDocId: magasinId,)));
              }
            },
            child: const Text(
              "CONTINUER",
              style: TextStyle(
                color: Colors.white
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(3.0),
        child: ListView(
          children: [
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Bootika',
                  style: TextStyle(
                    fontFamily: 'MaShanZheng',
                    fontSize: 45,
                    color: bootikaPrimaryColor
                  ),
                ),
                Text(
                  'Selectionnez un magasin pour continuer',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection('magasin')
                  .where('id_admin', isEqualTo: _userId).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox();
                }
                if(snapshot.hasError) {
                  log("[*] ERREUR : erreur lors de la recuperation des donnees de magasin");
                  return const SizedBox();
                }
                if(!snapshot.hasData) {
                  return const Center(
                    child: Text(
                      "Il n'y pas de magasin pour le moment",
                      style: TextStyle(
                          color: Colors.grey
                      ),
                    ),
                  );
                }

                final docs = snapshot.data!.docs;

                return Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Wrap(
                    spacing: 10.0,
                    runSpacing: 10.0,
                    children: List.generate(docs.length, (index) {
                      bgList.add(bootikaPrimaryColor);
                      return InkWell(
                        onTap: () {
                         if(docs[index]['alive']) {
                           for(int i = 0 ; i < bgList.length; i++) {
                             if(i != index) {
                               setState(() {
                                 bgList[i] = bootikaPrimaryColor;
                               });
                             }
                           }
                           setState(() {
                             bgList[index] = primaryCircleAvatarColor;
                             magasinId = docs[index].id;
                           });
                         }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: bgList[index]
                          ),
                          child: Column(
                            children: [
                              Text(
                                '${docs[index]['nom']}',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600
                                ),
                              ),
                              !docs[index]['alive'] ?
                              const Text(
                                'Véroullé',
                                style: TextStyle(
                                    color: Colors.red
                                ),
                              ) : const SizedBox()
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                );
              },
            ),

          ],
        ),
      ),
    );
  }

  Future<void> getAdminDocId() async {
    final String userUid = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore.instance.collection('users')
        .doc(userUid)
        .get();
    if(doc.data()!.containsKey('creePar')) {
      setState(() {
        _userId = doc.data()!['creePar'];
      });
    } else {
      setState(() {
        _userId = userUid;
      });
    }

  }

}