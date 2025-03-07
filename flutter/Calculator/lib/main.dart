import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() => runApp(MaterialApp(
      home: Design(),
      debugShowCheckedModeBanner: false,
    ));

class Design extends StatefulWidget {
  @override
  State<Design> createState() => _DesignState();
}

class _DesignState extends State<Design> {
  String equation = '0'; 
  String result = '0'; 
  String expression = ''; 

  Widget calcButton(BuildContext context, String label, double span) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.1,
      width: MediaQuery.of(context).size.width * 0.25 * span,
      child: FloatingActionButton(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        onPressed: () {
          setState(() {
            if (label == 'C') {
              equation = '0';  
              result = '0';    
            } else if (label == '⌫') {            
              equation = equation.isNotEmpty
                  ? equation.substring(0, equation.length - 1)
                  : '0';
            } else if (label == '=') {
              expression = equation;
              try {
                Parser p = Parser();
                Expression exp = p.parse(expression); 

                ContextModel cm = ContextModel();

                result = '${exp.evaluate(EvaluationType.REAL, cm)}';
              } catch (e) {
                result = 'Error!'; 
              }
            } else {
              if (equation == '0') {
                equation = label;  
              } else {
                equation += label;  
              }
            }
          });
        },
        child: Text(label),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 69, 69, 69),
      appBar: AppBar(
        title: Text(
          'Calculator',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 50, 49, 49),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            alignment: Alignment.topRight,
            padding: EdgeInsets.fromLTRB(10, 15, 10, 0),
            child: Text(
              equation,  
              style: TextStyle(
                color: Colors.black,
                fontSize: 25,
              ),
            ),
          ),
          Padding(padding: EdgeInsets.fromLTRB(0, 15, 0, 0)),
          Container(
            color: Colors.white,
            alignment: Alignment.topRight,
            padding: EdgeInsets.fromLTRB(10, 15, 10, 0),
            child: Text(
              result, 
              style: TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    calcButton(context, 'C', 1),
                    calcButton(context, '⌫', 1),
                    calcButton(context, '.', 1),
                    calcButton(context, '+', 1),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    calcButton(context, '1', 1),
                    calcButton(context, '2', 1),
                    calcButton(context, '3', 1),
                    calcButton(context, '-', 1),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    calcButton(context, '4', 1),
                    calcButton(context, '5', 1),
                    calcButton(context, '6', 1),
                    calcButton(context, '*', 1),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    calcButton(context, '7', 1),
                    calcButton(context, '8', 1),
                    calcButton(context, '9', 1),
                    calcButton(context, '/', 1),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    calcButton(context, '0', 1),
                    calcButton(context, '00', 1),
                    calcButton(context, '=', 2), 
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
