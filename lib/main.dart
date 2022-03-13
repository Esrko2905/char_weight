import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WeightCount(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WeightCount extends StatefulWidget {
  const WeightCount({Key? key}) : super(key: key);

  @override
  State<WeightCount> createState() => _WeightCountState();
}

class _WeightCountState extends State<WeightCount> {
  final TextEditingController _leftSideTextController = TextEditingController();
  final TextEditingController _rightSideTextController =
      TextEditingController();

  double angleValue = 0.0;
  int subtractionValue = 0;

  int leftLength = 0;
  int rightLength = 0;

  int leftdata = 0;
  int rightdata = 0;

  int check = 1;
  removeweight() async {
    await FirebaseFirestore.instance
        .collection('Weight')
        .doc('TextCount')
        .set({'left': 0, 'right': 0}).then((value) {
      setState(() {
        check = 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    check == 1 ? removeweight() : 0;

    var loader = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Center(child: CircularProgressIndicator()),
        SizedBox(
          width: 15,
        ),
        Text('Loading...')
      ],
    );

    dynamic streamvalue = StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Weight').snapshots(),
        builder: (BuildContext context, Snapvalue) {
          leftdata = Snapvalue.data!.docs[0]['left'];
          rightdata = Snapvalue.data!.docs[0]['right'];
          rightLength = rightdata;
          leftLength = leftdata;
          if (Snapvalue.connectionState == ConnectionState.waiting) {
            return loader;
          }
          final List<DocumentSnapshot> docvalue = Snapvalue.data!.docs;

          return Container();
        });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: const Text(
          'Weight Count',
          style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
        ),
        centerTitle: true,
      ),
      body: check == 0
          ? GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              border: Border.all(
                                  color: const Color.fromARGB(255, 0, 0, 0)),
                            ),
                            height: 280,
                            child: Padding(
                              padding: const EdgeInsets.all(2.5),
                              child: TextFormField(
                                inputFormatters: [UpperCaseTextFormatter()],
                                controller: _leftSideTextController,
                                textCapitalization:
                                    TextCapitalization.characters,
                                onChanged: (_) async {
                                  setState(() {
                                    leftLength =
                                        _leftSideTextController.text.length * 2;
                                  });

                                  await FirebaseFirestore.instance
                                      .collection('Weight')
                                      .doc('TextCount')
                                      .update({
                                    'left': _leftSideTextController.text.length,
                                  }).then((value) {
                                    streamvalue;
                                  }).then((value) async {
                                    subtractionValue = leftLength - rightLength;

                                    if (angleValue < -78.5) {
                                      _leftSideTextController.clear();
                                      _rightSideTextController.clear();
                                      setState(() {
                                        subtractionValue = 0;

                                        angleValue = 0.0;
                                        leftLength = 0;
                                        rightLength = 0;
                                      });
                                    } else {
                                      setState(
                                        () {
                                          if (subtractionValue > 0) {
                                            angleValue =
                                                -(subtractionValue.toDouble() /
                                                    2);
                                          } else {
                                            if (leftLength < rightLength) {
                                              angleValue = -(subtractionValue
                                                      .toDouble() /
                                                  2);
                                            } else {
                                              angleValue =
                                                  (subtractionValue.toDouble() /
                                                      2);
                                            }
                                          }
                                        },
                                      );
                                    }
                                  });
                                },
                                maxLines: 12,
                                cursorHeight: 25,
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "TYPE HERE..!"),
                              ),
                            ),
                            width: MediaQuery.of(context).size.width / 2),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              border: Border.all(
                                  color: const Color.fromARGB(255, 0, 0, 0)),
                            ),
                            height: 280,
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: TextFormField(
                                controller: _rightSideTextController,
                                inputFormatters: [UpperCaseTextFormatter()],
                                onChanged: (_) async {
                                  setState(() {
                                    rightLength =
                                        _rightSideTextController.text.length *
                                            2;
                                  });

                                  await FirebaseFirestore.instance
                                      .collection('Weight')
                                      .doc('TextCount')
                                      .update({
                                    'right':
                                        _rightSideTextController.text.length,
                                  }).then((value) async {
                                    streamvalue;
                                    subtractionValue = leftLength - rightLength;

                                    if (angleValue > 78.5) {
                                      _leftSideTextController.clear();
                                      _rightSideTextController.clear();
                                      setState(() {
                                        subtractionValue = 0;

                                        angleValue = 0.0;
                                        leftLength = 0;
                                        rightLength = 0;
                                      });

                                      await FirebaseFirestore.instance
                                          .collection('Weight')
                                          .doc('TextCount')
                                          .set({'left': 0, 'right': 0});
                                    } else {
                                      setState(
                                        () {
                                          if (subtractionValue > 0) {
                                            if (leftLength < rightLength) {
                                              angleValue =
                                                  (subtractionValue.toDouble() /
                                                      2);
                                            } else {
                                              angleValue = -(subtractionValue
                                                      .toDouble() /
                                                  2);
                                            }
                                          } else {
                                            angleValue =
                                                -(subtractionValue.toDouble() /
                                                    2);
                                          }
                                        },
                                      );
                                    }
                                  });
                                },
                                maxLines: 12,
                                cursorHeight: 25,
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "TYPE HERE..!"),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 80),
                    Center(
                      child: Transform(
                          child: Container(
                              color: Colors.lightBlueAccent,
                              height: 50,
                              width: 300,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      height: 30,
                                      width: 60,
                                      child: Center(
                                        child:
                                            Text((leftLength ~/ 2).toString()),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      height: 30,
                                      width: 60,
                                      child: Center(
                                        child:
                                            Text((rightLength ~/ 2).toString()),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                          alignment: FractionalOffset.center,
                          transform: Matrix4.identity()
                            ..rotateZ(angleValue / 50)),
                    ),
                  ],
                ),
              ),
            )
          : loader,
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
        text: newValue.text.toUpperCase(), selection: newValue.selection);
  }
}
