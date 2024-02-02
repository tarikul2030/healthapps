import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:http/http.dart' as http;
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'ProfilePage.dart';
import 'WelcomeScreen.dart';
import 'UserScreen.dart';

class Predictiondi extends StatefulWidget {
  Predictiondi(this.age, this.sex, this.fami, this.hibp, this.phy, this.bmi, this.smo, this.alc,  this.slp, this.sslp, this.reg, this.jf, this.stg, this.bpl, this.preg, this.predi, this.uri);
  final String age;
  final String sex;
  final String fami;
  final String hibp;
  final String phy;
  final String bmi;
  final String smo;
  final String alc;
  final String slp;
  final String sslp;
  final String reg;
  final String jf;
  final String stg;
  final String bpl;
  final String preg;
  final String predi;
  final String uri;


  @override
  State<Predictiondi> createState() => _PredictiondiState();
}

class _PredictiondiState extends State<Predictiondi> {
  TextEditingController age = TextEditingController();
  TextEditingController sex = TextEditingController();
  TextEditingController fami = TextEditingController();
  TextEditingController hibp = TextEditingController();
  TextEditingController phy = TextEditingController();
  TextEditingController bmi = TextEditingController();
  TextEditingController smo = TextEditingController();
  TextEditingController alc = TextEditingController();
  TextEditingController slp = TextEditingController();
  TextEditingController sslp = TextEditingController();
  TextEditingController reg = TextEditingController();
  TextEditingController jf = TextEditingController();
  TextEditingController stg = TextEditingController();
  TextEditingController bpl = TextEditingController();
  TextEditingController preg = TextEditingController();
  TextEditingController predi = TextEditingController();
  TextEditingController uri = TextEditingController();




  int? z;
  Future<int> MLdata(String age, String sex, String fami, String hibp, String phy, String bmi, String smo, String alc, String slp, String sslp, String reg, String jf, String stg, String bpl, String preg, String predi, String uri ) async {
    final response = await http.post(
      Uri.parse('https://diabeticai.onrender.com/predict'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode([
        {"age": age, "sex": sex, "fami": fami, "hibp": hibp, "phy":phy, "bmi" : bmi, "smo": smo, "alc": alc, "slp": slp, "sslp": sslp, "reg": reg, "jf": jf, "stg":stg, "bpl":bpl, "preg":preg, "predi":predi, "uri":uri }
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
    fami.text = widget.fami.toString();
    hibp.text = widget.hibp.toString();
    phy.text = widget.phy.toString();
    bmi.text = widget.bmi.toString();
    smo.text = widget.smo.toString();
    alc.text = widget.alc.toString();
    slp.text = widget.slp.toString();
    sslp.text = widget.sslp.toString();
    reg.text = widget.reg.toString();
    jf.text = widget.jf.toString();
    stg.text = widget.stg.toString();
    bpl.text = widget.bpl.toString();
    preg.text = widget.preg.toString();
    predi.text = widget.predi.toString();
    uri.text = widget.uri.toString();

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
              TextsField("fami (last 1 min)", '', fami, false),
              TextsField("Blood pressure (centigrade)", '', hibp, false),
              TextsField("phy (last 1 min)", '', phy, false),
              TextsField("bmi (last 1 min)", '', bmi, false),
              TextsField("smo (last 1 min)", '', smo, false),
              TextsField("alc (last 1 min)", '', alc, false),
              TextsField("slp (last 1 min)", '', slp, false),
              TextsField("sslp (last 1 min)", '', sslp, false),
              TextsField("reg (last 1 min)", '', reg, false),
              TextsField("jf (last 1 min)", '', jf, false),
              TextsField("stg (last 1 min)", '', stg, false),
              TextsField("bpl (last 1 min)", '', bpl, false),
              TextsField("preg (last 1 min)", '', preg, false),
              TextsField("predi (last 1 min)", '', predi, false),
              TextsField("uri (last 1 min)", '', uri, false),



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
                          widget.age as String, widget.sex as String, widget.fami as String,
                           widget.hibp as String, widget.phy as String, widget.bmi as String,
                           widget.smo as String, widget.alc as String, widget.slp as String, widget.sslp as String,widget.reg as String, widget.jf as String, widget.stg as String,
                          widget.bpl as String, widget.preg as String, widget.predi as String, widget.uri as String);
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
