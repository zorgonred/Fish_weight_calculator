import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'services/crud.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedCurrency;
  String sharkSpecies;
  double bagWeight;

  crudMethods crudObj = new crudMethods();


  final GlobalKey<FormState> _formKeyValue = new GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(
                FontAwesomeIcons.bars,
                color: Colors.white,
              ),
              onPressed: () {}),
          title: Container(
            alignment: Alignment.center,
            child: Text("Fin Grading",
                style: TextStyle(
                  color: Colors.white,
                )),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.refresh,
                size: 20.0,
                color: Colors.white,
              ),
              onPressed: null,
            ),
          ],
        ),
        body: Center(
          child: Container(
            decoration: BoxDecoration(borderRadius:new BorderRadius.circular(10.0),color: Colors.white,border: Border.all(color: Colors.amber),

            ),
            width: 320.0,
            height: 480.0,

            child: Form(
              key: _formKeyValue,
              autovalidate: true,
              child: new ListView(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                children: <Widget>[
                  SizedBox(height: 20.0),
                  new TextField(
                      decoration: const InputDecoration(
                        hintText: 'Enter the bags weight',
                        border: OutlineInputBorder(),
                        labelText: 'Bag weight',
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                      this.bagWeight = double.parse(value);
                    },
                  ),
                  SizedBox(height: 40.0),
                  StreamBuilder<QuerySnapshot>(
                      stream: Firestore.instance.collection("sharkspecies").snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          const Text("Loading.....");
                        else {
                          List<DropdownMenuItem> currencyItems = [];
                          for (int i = 0; i < snapshot.data.documents.length; i++) {
                            DocumentSnapshot snap = snapshot.data.documents[i];
                            currencyItems.add(
                              DropdownMenuItem(
                                child: Text(
                                  snap.documentID,
                                  style: TextStyle(color: Colors.black),
                                ),
                                value: "${snap.documentID}",
                              ),
                            );
                          }
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
//                        Icon(
//                        FontAwesomeIcons.fish,
//                        size: 25.0,
//                        color: Color(0xff11b719),
//                      ),
                              SizedBox(width: 50.0),
                              DropdownButton(
                                items: currencyItems,
                                onChanged: (currencyValue) {
                                  this.sharkSpecies = (currencyValue);

                                  final snackBar = SnackBar(
                                    content: Text(
                                      'Selected species $currencyValue',
                                      style: TextStyle(color: Colors.amber),
                                    ),
                                  );
                                  Scaffold.of(context).showSnackBar(snackBar);
                                  setState(() {
                                    selectedCurrency = currencyValue;
                                  });
                                },
                                value: selectedCurrency,
                                isExpanded: false,
                                hint: new Text(
                                  "Choose shark species",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ],
                          );
                        }
                      }),
                  SizedBox(
                    height: 150.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[

                      RaisedButton(
                          color: Colors.blue,
                          textColor: Colors.white,
                          elevation: 7.0,
                          onPressed: (){
                            Navigator.of(context);
                            crudObj.addData(bagWeight, sharkSpecies);
                          },
                          child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text("Submit", style: TextStyle(fontSize: 20.0)),
                                ],
                              )),
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(5.0))),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}