import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:http/http.dart' as http;
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'ProfilePage.dart';
import 'WelcomeScreen.dart';
import 'UserScreen.dart';

class Prediction extends StatefulWidget {
  Prediction(this.age, this.sex, this.cp, this.rbp, this.lip, this.fs, this.ec, this.spo2,  this.ex, this.ol, this.slo, this.ca, this.thl);
  final String age;
  final String sex;
  final String cp;
  final HealthValue rbp;
  final String lip;
  final String fs;
  final String ec;
  final HealthValue spo2;
  final String ex;
  final String ol;
  final String slo;
  final String ca;
  final String thl;


  @override
  State<Prediction> createState() => _PredictionState();
}

class _PredictionState extends State<Prediction> {
  TextEditingController age = TextEditingController();
  TextEditingController sex = TextEditingController();
  TextEditingController cp = TextEditingController();
  TextEditingController rbp = TextEditingController();
  TextEditingController lip = TextEditingController();
  TextEditingController fs = TextEditingController();
  TextEditingController ec = TextEditingController();
  TextEditingController spo2 = TextEditingController();
  TextEditingController ex = TextEditingController();
  TextEditingController ol = TextEditingController();
  TextEditingController slo = TextEditingController();
  TextEditingController ca = TextEditingController();
  TextEditingController thl = TextEditingController();




  int? z;
  Future<int> MLdata(String age, String sex, String cp, double rbp, String lip, String fs, String ec, double spo2, String ex, String ol, String slo, String ca, String thl ) async {
    final response = await http.post(
      Uri.parse('https://aiheart-e26m.onrender.com/predict'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode([
        {"age": age, "sex": sex, "chestPain": cp, "rbp": rbp, "lipid":lip, "Fbs" : fs, "Ecg": ec, "spo2": spo2, "Exercise": ex, "oldpeak": ol, "slope": slo, "ca": ca, "thal":thl }
      ]),
    );

    if (response.statusCode == 200) {
      var x = jsonDecode(response.body);
      return x['prediction'][0];
    } else {
      throw Exception('Failed to fetch ML Data.');
    }
  }

  bool editingEnabled = true;

  @override
  void initState() {
    // TODO: implement initState
    age.text = widget.age.toString();
    sex.text = widget.sex.toString();
    cp.text = widget.cp.toString();
    rbp.text = widget.rbp.toString();
    lip.text = widget.lip.toString();
    fs.text = widget.fs.toString();
    ec.text = widget.ec.toString();
    spo2.text = widget.spo2.toString();
    ex.text = widget.ex.toString();
    ol.text = widget.ol.toString();
    slo.text = widget.slo.toString();
    ca.text = widget.ca.toString();
    thl.text = widget.thl.toString();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Smart Stress Prediction'),
        centerTitle: true,
        backgroundColor: Colors.redAccent.withOpacity(0.8),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextsField("age (last 1 min)", '', age, false),
              TextsField("sex (last 1 min)", '', sex, false),
              TextsField("Cp (last 1 min)", '', cp, false),
              TextsField("Blood pressure (centigrade)", '', rbp, false),
              TextsField("lip (last 1 min)", '', lip, false),
              TextsField("Fbs (last 1 min)", '', fs, false),
              TextsField("Ecg (last 1 min)", '', ec, false),
              TextsField("Spo2 (last 1 min)", '', spo2, false),
              TextsField("Exercise (last 1 min)", '', ex, false),
              TextsField("ol (last 1 min)", '', ol, false),
              TextsField("slo (last 1 min)", '', slo, false),
              TextsField("ca (last 1 min)", '', ca, false),
              TextsField("thl (last 1 min)", '', thl, false),



              SizedBox(height: 20),
              Container(
                height: 250,
                child: z != null
                    ? CircularPercentIndicator(
                  radius: 100.0,
                  lineWidth: 13.0,
                  animation: true,
                  animationDuration: 600,
                  percent: z == 0
                      ? 0.3  // Low Stress
                      : 0.9,  // High Stress
                  center: z == 0
                      ? Text('Low Stress')
                      : Text('High Stress'),
                  circularStrokeCap: CircularStrokeCap.round,
                  progressColor: z == 0
                      ? Colors.green
                      : Colors.red,
                )
                    : Container(
                  height: 250,
                  padding: EdgeInsets.all(20),
                  child: Image(
                    image: AssetImage('assets/robo.gif'),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(
                    width / 15, height / 20, width / 15, height / 20),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      color: Colors.redAccent.withOpacity(0.8),
                      borderRadius: BorderRadius.all(Radius.circular(15.0))),
                  child: MaterialButton(
                      elevation: 10.00,
                      minWidth: width / 1.2,
                      height: height / 11.5,
                      onPressed: () async {
                        int x = await MLdata(
                          widget.age as String, widget.sex as String, widget.cp as String,
                          double.parse(widget.rbp.toString()), widget.lip as String, widget.ec as String, widget.fs as String,
                          double.parse(widget.spo2.toString()), widget.ex as String, widget.ol as String, widget.slo as String, widget.ca as String,widget.thl as String,);
                        setState(() {
                          editingEnabled = !editingEnabled;
                          z = x;
                        });
                      },
                      child: Text(
                        'Predict',
                        style: TextStyle(color: Colors.white, fontSize: 20.00),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
