import 'dart:developer';

import 'package:login_package/src/constants_variables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class SelectionnerCaisse extends StatefulWidget{
  const SelectionnerCaisse({super.key, required this.magasinDocId});
  final String magasinDocId;

  @override
  State<SelectionnerCaisse> createState() => _SelectionnerCaisseState();
}

class _SelectionnerCaisseState extends State<SelectionnerCaisse> {

  List<Color> bgList = [];
  String caisseId = '';

  @override
  void initState() {
    super.initState();
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
              if(caisseId.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Veuillez choisir une caisse',
                        style: TextStyle(
                            color: Colors.white),),
                      backgroundColor: Colors.red,
                    )
                );
              } else {
                // TODO : send `magasin` doc id and `caisse` doc id to the next screen
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
                  'Selectionnez une caisse pour continuer',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection('magasin')
                  .doc(widget.magasinDocId).collection('caisses').snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox();
                }
                if(snapshot.hasError) {
                  log("[*] ERREUR : erreur lors de la recuperation des donnees des caisses");
                  return const SizedBox();
                }
                if(!snapshot.hasData) {
                  return const Center(
                    child: Text(
                      "Il n'y pas de caisses dans ce magasin pour le moment",
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
                         if(!docs[index]['actif']) {
                           for(int i = 0 ; i < bgList.length; i++) {
                             if(i != index) {
                               setState(() {
                                 bgList[i] = bootikaPrimaryColor;
                               });
                             }
                           }
                           setState(() {
                             bgList[index] = primaryCircleAvatarColor;
                             caisseId = docs[index].id;
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
                              docs[index]['actif'] ?
                              const Text(
                                'Occupé',
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

}