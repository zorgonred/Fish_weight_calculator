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

  Future<void> addData(double bagWeight, String sharkSpecies) async {
    if (isLoggedIn()) {

      if (sharkSpecies=='BT'){


            DocumentSnapshot CurrentData = await Firestore.instance.collection('sharkspecies').document('BT').get();
            double currentWeight = CurrentData.data['bagWeight'];

            //carData is
            Firestore.instance.collection('sharkspecies').document('BT').updateData({'bagWeight': currentWeight + bagWeight.toDouble()  });
          }
          else if (sharkSpecies=='BD')

        // code block
          {
            DocumentSnapshot CurrentData = await Firestore.instance.collection('sharkspecies').document('BD').get();
            double currentWeight = CurrentData.data['bagWeight'];

            //carData is
            Firestore.instance.collection('sharkspecies').document('BD').updateData({'bagWeight': currentWeight + bagWeight.toDouble()  });
          }
        // code block



    } else {
      print('You need to be logged in');
    }
  }
}