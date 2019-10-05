import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class crudMethods {
  bool isLoggedIn() {
    if (FirebaseAuth.instance.currentUser() != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> addData(double bagWeight, String sharkSpecies, int _count) async {
    if (isLoggedIn()) {
//      if (sharkSpecies=='BT'){
//        print("hello");

      DocumentSnapshot CurrentData = await Firestore.instance
          .collection('sharkspecies')
      //pull from the document the entered sharkspecies in dropdown eg BT
          .document(sharkSpecies)
          .get();
      //pull from the document the entered sharkspecies in dropdown eg BT, hen BT field
      double currentWeight = CurrentData.data[sharkSpecies] ??0.0;
//                ?? 1.1;

      //if the bagWeight is null then the value we assume is 0

      print(currentWeight);
      print(bagWeight);
      print(sharkSpecies);
      print(_count);

      //carData is
      Firestore.instance
          .collection('sharkspecies')
          .document(sharkSpecies)
          .updateData({"amount": currentWeight + bagWeight.toDouble()});

      Firestore.instance
          .collection('sharkspecies')
          .document(sharkSpecies)
          .updateData({"count": _count});
//          }
//          else if (sharkSpecies=='BD')
//
//        // code block
//          {
//            DocumentSnapshot CurrentData = await Firestore.instance.collection('sharkspecies').document('BD').get();
//            double currentWeight = CurrentData.data['bagWeight'];
//
//            //carData is
//            Firestore.instance.collection('sharkspecies').document('BD').updateData({'bagWeight': currentWeight + bagWeight.toDouble()  });
//          }
      // code block

    } else {
      print('You need to be logged in');
    }
  }

  getData() async {
    return await Firestore.instance.collection('sharkspecies').getDocuments();
  }
}
