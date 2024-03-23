

import 'dart:developer';

import 'package:magasin_et_caisse/src/transition_left_to_right.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ajouter_magasin_caisse.dart';

class MagasinSearchPage extends StatefulWidget {
  const MagasinSearchPage({super.key, required this.adminId});
  final String adminId;
  @override
  State<MagasinSearchPage> createState() => _MagasinSearchPageState();
}

class _MagasinSearchPageState extends State<MagasinSearchPage> {

  String searchPattern = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: ListView(
          children: [
            CupertinoSearchTextField(
              placeholder: 'Quel magasin cerchez-vous ?',
              onChanged: (String value) {
               if(value.isEmpty) {
                 setState(() {
                   searchPattern = value;
                 });
               }
              },
              onSubmitted: (String value) {
                setState(() {
                  searchPattern = value;
                });
              },
            ),
            const SizedBox(height: 30.0,),
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection('magasin')
                  .where('id_admin', isEqualTo: widget.adminId).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if(snapshot.hasError) {
                  log("Error while fetching `magasin` data");
                  return const SizedBox();
                }
                if(!snapshot.hasData) {
                  return const Center(
                    child: Text(
                      "Vous n'avez pas encore ajouter de magasin",
                      style: TextStyle(
                          color: Colors.grey
                      ),
                    ),
                  );
                }

                List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = [];
                if(searchPattern.isNotEmpty) {
                  docs = snapshot.data!.docs.where((element) =>
                      RegExp(r'^' + searchPattern.toLowerCase())
                          .hasMatch((element['nom'] as String).toLowerCase())).toList();
                }

                return Column(
                    children: List.generate(
                        docs.length, (index) {
                      return StreamBuilder(
                          stream: FirebaseFirestore.instance.collection('magasin')
                              .doc(docs[index].id).collection('caisses').snapshots(),
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> caisseDocs) {
                            if(caisseDocs.connectionState == ConnectionState.waiting) {
                              return const SizedBox();
                            }
                            if(!caisseDocs.hasData) {
                              log("Error while fetching `caisse` data");
                              return const SizedBox();
                            }
                            final int size = caisseDocs.data!.size;
                            return Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                      color: const Color(0xFF003566),
                                      borderRadius: BorderRadius.circular(10.0)
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        docs[index]['nom'],
                                        style: const TextStyle(
                                            fontSize: 20,
                                            color: Colors.white
                                        ),
                                      ),
                                      const SizedBox(height: 15.0,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "$size",
                                            style: const TextStyle(
                                                fontSize: 20,
                                                color: Color(0xFFFCA311),
                                                fontWeight: FontWeight.w600
                                            ),
                                          ),
                                          const SizedBox(width: 15,),
                                          const Text(
                                            "Caisses enrégistrées",
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.white
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        final String magasinDocId = docs[index].id;
                                        final List<String> caissesNames = caisseDocs.data!.docs.map((e) => e['nom'] as String).toList();
                                        final Map<String, String> caissesDocsIds = {};
                                        final Map<String, bool> caissesAvailabilities = {};
                                        for (var item in caisseDocs.data!.docs) {
                                          caissesAvailabilities[item['nom'] as String] = item['actif'] as bool;
                                          caissesDocsIds[item['nom'] as String] = item.id;
                                        }

                                        Navigator.push(context, SlideRightPageRoute(page: AjouterMagasinCaisse(
                                          adminId: widget.adminId,
                                          magasinName: docs[index]['nom'],
                                          magasinAddr: docs[index]['adresse'],
                                          caisses: caissesNames,
                                          isMagasinAlive: docs[index]['alive'],
                                          caissesAvailabilities: caissesAvailabilities,
                                          magasinDocId: magasinDocId,
                                          caissesDocIds: caissesDocsIds,
                                        )));

                                      },
                                      child: const Text(
                                        'Modifier',
                                        style: TextStyle(
                                            color: Color(0xFF2FD270)
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 20,
                                      width: 2,
                                      decoration: const BoxDecoration(
                                          color: Color(0xFF003566)
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        final bool state = !docs[index]['alive'];
                                        FirebaseFirestore.instance.collection('magasin')
                                            .doc(docs[index].id).update({'alive' : state});
                                      },
                                      child: Text(
                                        docs[index]['alive'] ? 'Désactiver' : 'Activer',
                                        style: const TextStyle(
                                            color: Color(0xFFD22F2F)
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            );
                          }
                      );
                    }
                    )
                );
              },
            )
          ],
        ),
      ),
    );
  }
}