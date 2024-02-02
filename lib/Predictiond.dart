import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:http/http.dart' as http;
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'ProfilePage.dart';
import 'WelcomeScreen.dart';
import 'UserScreen.dart';

class Predictiond extends StatefulWidget {
  Predictiond(this.step_count, this.mood, this.calories_burned, this.hours_of_sleep, this.weight_kg);

  final String step_count;
  final String mood;
  final String calories_burned;
  final String hours_of_sleep;
  final String weight_kg;

  @override
  State<Predictiond> createState() => _PredictiondState();
}

class _PredictiondState extends State<Predictiond> {
  TextEditingController step_count = TextEditingController();
  TextEditingController mood = TextEditingController();
  TextEditingController calories_burned = TextEditingController();
  TextEditingController hours_of_sleep = TextEditingController();
  TextEditingController weight_kg = TextEditingController();

  int? z;

  Future<int> MLdata(
      String step_count, String mood, String calories_burned, String hours_of_sleep, String weight_kg) async {
    final response = await http.post(
      Uri.parse('https://dietai-uk82.onrender.com/api/fitness-prediction/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "step_count" : step_count,
        "mood": mood,
        "calories_burned": calories_burned,
        "hours_of_sleep": hours_of_sleep,
        "weight_kg": weight_kg
     }),
    );

    if (response.statusCode == 200) {
      var input_data = jsonDecode(response.body);
      return input_data['prediction'][0];
    } else {
      throw Exception('Failed to fetch ML Data.');
    }
  }

  bool editingEnabled = true;

  @override
  void initState() {
    step_count.text = widget.step_count.toString();
    mood.text = widget.mood.toString();
    calories_burned.text = widget.calories_burned.toString();
    hours_of_sleep.text = widget.hours_of_sleep.toString();
    weight_kg.text = widget.weight_kg.toString();
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
              TextsField("step (last 1 min)", '', step_count, false),
              TextsField("mood (last 1 min)", '', mood, false),
              TextsField("calo (last 1 min)", '', calories_burned, false),
              TextsField("sleep", '', hours_of_sleep, false),
              TextsField("wei", '', weight_kg, false),
              SizedBox(height: 20),
              Container(
                height: 250,
                child: z != null
                    ? CircularPercentIndicator(
                  radius: 100.0,
                  lineWidth: 13.0,
                  animation: true,
                  animationDuration: 600,
                  percent: z == 0 ? 0.2 : z == 1 ? 0.4 : z == 2 ? 0.6 : z == 3 ? 0.8 : 1.0,
                  center: z == 0
                      ? Text('Low Stress')
                      : z == 1
                      ? Text('Medium Stress')
                      : z == 2
                      ? Text('Good Stress')
                      : z == 3
                      ? Text('High Stress')
                      : Text('Very High Stress'),
                  circularStrokeCap: CircularStrokeCap.round,
                  progressColor: z == 0
                      ? Colors.green
                      : z == 1
                      ? Colors.yellow
                      : z == 2
                      ? Colors.blue
                      : z == 3
                      ? Colors.orange
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
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                  child: MaterialButton(
                    elevation: 10.00,
                    minWidth: width / 1.2,
                    height: height / 11.5,
                    onPressed: () async {
                      int input_data = await MLdata(
                        widget.step_count as String,
                        widget.mood as String,
                        widget.calories_burned as String,
                        widget.hours_of_sleep as String,
                          widget.weight_kg as String
                      );
                      setState(() {
                        editingEnabled = !editingEnabled;
                        z = input_data;
                      });
                    },
                    child: Text(
                      'Predict',
                      style: TextStyle(color: Colors.white, fontSize: 20.00),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TextsField extends StatelessWidget {
  TextsField(this.label, this.hintText, this.controller, this.editingEnabled);

  final String label;
  final String hintText;
  final TextEditingController controller;
  final bool editingEnabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: TextFormField(
        enabled: editingEnabled,
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
