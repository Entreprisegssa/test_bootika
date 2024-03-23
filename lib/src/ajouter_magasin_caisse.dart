

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AjouterMagasinCaisse extends StatefulWidget {
  const AjouterMagasinCaisse({super.key, required this.adminId,
    this.magasinName = '', this.magasinAddr = '', this.caisses = const[],
    this.isMagasinAlive = true, this.caissesAvailabilities = const{},
    this.magasinDocId = '', this.caissesDocIds = const{}, required this.db});

  final FirebaseFirestore db;
  final String adminId;
  final String magasinName;
  final String magasinAddr;
  final List<String> caisses;
  final bool isMagasinAlive;
  final String magasinDocId;
  final Map<String, String> caissesDocIds;
  final Map<String, bool> caissesAvailabilities;

  @override
  State<AjouterMagasinCaisse> createState() => _AjouterMagasinCaisseState();
}

class _AjouterMagasinCaisseState extends State<AjouterMagasinCaisse> {

  List<String> listCaisses = [];
  late TextEditingController newCaisseController;
  late TextEditingController magasinNameController;
  late TextEditingController magasinAddrController;
  final List<String> caisseToDelete = [];

  Future<void> saveInfosToDataBase() async {
    Map<String, dynamic> resume = {
      'id_admin' : widget.adminId,
      'nom' : magasinNameController.text,
      'adresse' : magasinAddrController.text,
      'alive' : widget.isMagasinAlive,
    };

    // add new `magasin` ..
    if(widget.magasinName.isEmpty) {
      widget.db.collection('magasin')
          .add(resume).then((DocumentReference doc) {
        for(String caisse in listCaisses) {
          doc.collection('caisses').add({
            'nom' : caisse,
            'actif' : false
          });
        }
      });
      // .. or update existing one
    } else {
     widget.db.collection('magasin')
         .doc(widget.magasinDocId).update(resume).then((value) {
       for(int i = 0; i < listCaisses.length; i++) {
         if(widget.caissesDocIds.containsKey(listCaisses[i])) {
           widget.db.collection('magasin').doc(widget.magasinDocId)
               .collection('caisses').doc(widget.caissesDocIds[listCaisses[i]]).update({
             'nom' : listCaisses[i],
             'actif' : widget.caissesAvailabilities[listCaisses[i]]
           });
         } else {
           widget.db.collection('magasin').doc(widget.magasinDocId)
               .collection('caisses').doc().set({
             'nom' : listCaisses[i],
             'actif' : false
           });
         }
       }
       if(caisseToDelete.isNotEmpty) {
         for(String item in caisseToDelete) {
           widget.db.collection('magasin').doc(widget.magasinDocId)
               .collection('caisses').doc(item).delete();
         }
       }
     });
    }

  }

  @override
  void initState() {
    super.initState();
    newCaisseController = TextEditingController();
    magasinAddrController = TextEditingController();
    magasinNameController = TextEditingController();
    magasinNameController.text = widget.magasinName;
    magasinAddrController.text = widget.magasinAddr;
    listCaisses = [...widget.caisses];
  }

  @override
  void dispose() {
    magasinNameController.dispose();
    magasinAddrController.dispose();
    newCaisseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Nouveau magasin',
          style: TextStyle(
              fontSize: 20,
              color: Color(0xFF003566),
              fontWeight: FontWeight.w600
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: ListView(
          children: [
            const SizedBox(height: 40.0,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Nom du magasin',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                      fontSize: 15,
                  ),
                ),
                const SizedBox(height: 10,),
                SizedBox(
                  height: 55,
                  child: CupertinoTextField(
                    prefix:  const Row(
                      children: [
                        SizedBox(width: 10,),
                        Icon(Icons.label),
                        SizedBox(width: 20,)
                      ],
                    ),
                    placeholder: 'nom du magasin',
                    controller: magasinNameController,
                    keyboardType: TextInputType.text,
                    decoration: BoxDecoration(
                        color: const Color(0xFFf4f5f7),
                        borderRadius: BorderRadius.circular(15)
                    ),
                  ),
                ),
                const SizedBox(height: 20.0,),
                const Text(
                  'Adresse',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 10,),
                SizedBox(
                  height: 55,
                  child: CupertinoTextField(
                    prefix:  const Row(
                      children: [
                        SizedBox(width: 10,),
                        Icon(Icons.location_city),
                        SizedBox(width: 20,)
                      ],
                    ),
                    placeholder: 'adresse du magasin',
                    controller: magasinAddrController,
                    keyboardType: TextInputType.text,
                    decoration: BoxDecoration(
                        color: const Color(0xFFf4f5f7),
                        borderRadius: BorderRadius.circular(15)
                    ),
                  ),
                ),
                const SizedBox(height: 20.0,),
                Text(
                  'Nombre de caisses : ${listCaisses.length}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 10,),
                Row(
                  children: [
                    SizedBox(
                      height: 55,
                      width: screenWidth * 0.6,
                      child: CupertinoTextField(
                        prefix:  const Row(
                          children: [
                            SizedBox(width: 10,),
                            Icon(Icons.money),
                            SizedBox(width: 20,)
                          ],
                        ),
                        placeholder: 'Nouvelle caisse',
                        controller: newCaisseController,
                        keyboardType: TextInputType.text,
                        decoration: BoxDecoration(
                            color: const Color(0xFFf4f5f7),
                            borderRadius: BorderRadius.circular(15)
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      decoration: BoxDecoration(
                          color: const Color(0xFF003566),
                          borderRadius: BorderRadius.circular(10.0)
                      ),
                      child: TextButton.icon(
                        onPressed: () {
                          if(listCaisses.contains(newCaisseController.text)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text('Vous avez déjà ajouté cette caisse'),
                                )
                            );
                          }  else if(newCaisseController.text.isNotEmpty) {
                            setState(() {
                              listCaisses.add(newCaisseController.text);
                              newCaisseController.text = '';
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.green,
                                content: Text('Caisse ajoutée'),
                              )
                            );
                          }
                        },
                        icon: const Icon(Icons.add, color: Colors.white,),
                        label: const Text("Ajouter", style: TextStyle(color: Colors.white),),
                      ),
                    )
                  ],
                )
              ],
            ),
            const SizedBox(height: 40,),
            const Text(
              'Liste des caisses ajoutées',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 30,),
            Column(
              children: List.generate(listCaisses.length, (index) {
                return  Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                          color: const Color(0xFF003566),
                          borderRadius: BorderRadius.circular(10.0)
                      ),
                      child: Text(listCaisses[index], style: const TextStyle(color: Colors.white)),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          // IMPORTANT ! : l'ordre de suppression ci-dessous est important
                          caisseToDelete.add(widget.caissesDocIds[listCaisses[index]]!);
                          widget.caissesDocIds.remove(listCaisses[index]);
                          listCaisses.remove(listCaisses[index]);

                        });
                      },
                      icon: const Icon(Icons.delete, size: 30,),
                    ),
                  ],
                );
              }),
            ),
            const SizedBox(height: 50.0,),
            Container(
              decoration: BoxDecoration(
                  color: const Color(0xFF003566),
                  borderRadius: BorderRadius.circular(5.0)
              ),
              child: TextButton(
                onPressed: () {
                  if(magasinNameController.text.isEmpty ||
                      magasinAddrController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.red,
                          content: Text('Veuillez renseigner les informations du nouveau magasin'),
                        )
                    );
                  } else if(listCaisses.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.red,
                          content: Text('Veuillez enregistrer au moins une caisse'),
                        )
                    );
                  } else if(magasinNameController.text.isNotEmpty &&
                      magasinAddrController.text.isNotEmpty) {
                    saveInfosToDataBase() .then((value) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.green,
                            content: Text('Magasin crée avec succès'),
                          )
                      );
                    });
                  }
                },
                child: const Text("Enregistrer",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      letterSpacing: 1.5
                  ),),
              ),
            ),
            const SizedBox(height: 25.0,),
          ],
        ),
      ),
    );
  }

}