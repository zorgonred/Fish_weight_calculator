import 'package:fin_grading/widgets/custom_drawer.dart';
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
  //this to retrieve the value entered in a field NB! diffent to bagWeight
  TextEditingController bagWeightt = TextEditingController();

  var _selectedCurrency;

//this is the variable that stores the selected value from dropdown list
  String sharkSpecies;

  //the number entered
  double bagWeight;

  //count
  int _count = 0;

  //count function

  void _add(int add) {
    setState(() {
      _count += add;
    });
  }

  crudMethods crudObj = new crudMethods();

// This uniquely identifies the Form, and allows validation of the form in a later step.
  final GlobalKey<FormState> _formKeyValue = new GlobalKey<FormState>();

  //this is a function to refresh fields using Textcontroller
  void _refresh() {
    bagWeightt.text = " ";

    setState(() {
      _selectedCurrency = "Choose the species";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: CustomDrawer(),
      appBar: AppBar(
        iconTheme: new IconThemeData(color: Colors.blue),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Container(
          alignment: Alignment.center,
          child: Text("MARISCO CALCULATOR",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.refresh,
              size: 20.0,
              color: Colors.black,
            ),
            //onpressed of button , calls functions
            onPressed: () {
              _refresh();
            },
          ),
        ],
      ),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 5.0,
              ),
            ],
            borderRadius: new BorderRadius.circular(10.0),
            color: Colors.white,
            border: Border.all(color: Colors.grey),
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
                //link text controller
                new TextField(
                  controller: bagWeightt,
                  decoration: const InputDecoration(
                    hintText: 'Enter the bags weight',
                    border: OutlineInputBorder(),
                    labelText: 'Enter the bags weight',
                  ),
                  //makes a number pad arise
                  keyboardType: TextInputType.number,
                  //the number that is entered is value
                  onChanged: (value) {
                    //the value that is entered goes into "bagWeight"
                    this.bagWeight = double.parse(value);
                  },
                ),
                SizedBox(height: 40.0),
                StreamBuilder<QuerySnapshot>(
                    //this is the stream where data is pulled in firestore DB
                    stream: Firestore.instance
                        .collection("sharkspecies")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData)
                        const Text("Loading.....");
                      else {
                        List<DropdownMenuItem> currencyItems = [];
                        for (int i = 0;
                            i < snapshot.data.documents.length;
                            i++) {
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
                                //species that is chosen on dropdown
                                this.sharkSpecies = (currencyValue);

                                final snackBar = SnackBar(
                                  content: Text(
                                    'Selected species $currencyValue',
                                    style: TextStyle(color: Colors.amber),
                                  ),
                                );
                                Scaffold.of(context).showSnackBar(snackBar);
                                setState(() {
                                  //changes the dispalyed to selected
                                  _selectedCurrency = currencyValue;
                                });
                              },
                              value: _selectedCurrency,
                              isExpanded: false,
                              hint: new Text(
                                "Choose the species",
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
                        onPressed: () {
                          Navigator.of(context);
                          _add(1);
                          crudObj.addData(bagWeight, sharkSpecies, _count);
                        },
                        child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text("Submit",
                                    style: TextStyle(fontSize: 20.0)),
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
      ),
    );
  }
}
