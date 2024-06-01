import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
class PredModel extends StatefulWidget {
  @override
  _PredModelState createState() => _PredModelState();
}
class _PredModelState extends State<PredModel> {
  var predValue = "";
  double? valuePred;
  final inputController = TextEditingController();
  @override
  void initState() {
    super.initState();
    predValue = "Click predict button";
  }
  //Function to format double value to 2 decimals
  String prettify(double d) =>
      d.toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '');

  Future<void> predData() async {
    var inputValue = double.tryParse(inputController.text);
    if (inputValue == null) {
      setState(() {
        predValue = "Invalid input";
        valuePred = null;
      });
      showAlertErrorDialog(context);
      return;
    }
    final interpreter =
    await Interpreter.fromAsset('assets/modelc2f.tflite');
    var input = [[inputValue]];
    var output = List.filled(1, 0).reshape([1, 1]);
    interpreter.run(input, output);
    setState(() {
      valuePred = double.tryParse(output[0][0].toString());
      predValue = prettify(valuePred!);
    });
    showAlertDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Cº to Fº Calculator", style: TextStyle(color: Colors.white),),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Enter value in Celsius:",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: TextFormField(
                controller: inputController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Celsius',
                  hintText: 'Enter a number',
                ),
              ),
            ),
            SizedBox(height: 20),
            MaterialButton(
              color: Colors.blue,
              child: Text(
                "Predict",
                style: TextStyle(fontSize: 25, color: Colors.white),
              ),
              onPressed: predData,
            ),
            SizedBox(height: 12),
          ],
        ),
      ),
    );
  }



  showAlertDialog(BuildContext context) {

    // set up the buttons
    Widget okButton = TextButton(
      child: Text("Ok"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Result"),
      content: Text("Expected value in Fahrenheit: $predValue"
      ),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertErrorDialog(BuildContext context) {

    // set up the AlertDialog
    AlertDialog alert = const AlertDialog(
      title: Text("Error"),
      content: Text("Expected value is number"
      ),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}