import 'package:currency_convert/drop_down.dart';
import 'package:flutter/material.dart';
import 'api_client.dart';
import 'drop_down.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency converter',
      home: MyHomePage(),
    );
  }
}
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ApiClient client = ApiClient();

  Color mainColor = Color(0xFF212936);
  Color secondColor = Colors.pink;

  List<String> currencies;
  String from;
  String to;

  double rate;
  String result = "";

  @override
  void initState(){

    super.initState();
    (() async{
      List<String> list = await client.getCurrencies();
      setState(() {
        currencies = list;
      });
    })();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 200.0,
                child: Text(
                  "Currency converter",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextField(
                      onSubmitted: (value) async{
                        rate = await client.getRate(from, to);
                        setState(() {
                          result = (rate * double.parse(value)).toStringAsFixed(3);
                        });
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: "Input value to convert",
                        labelStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          color: secondColor,
                        )
                      ),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        customDropDown(currencies, from, (val){
                          setState(() {
                            from = val;
                          });
                        }),
                        FloatingActionButton(
                          onPressed: (){
                            String temp = from;
                            setState(() {
                              from = to;
                              to = temp;
                            });
                          },child: Icon(Icons.swap_horiz),elevation: 0.00,backgroundColor: secondColor,),
                        customDropDown(currencies, to, (val){
                          setState(() {
                            to = val;
                          });
                        }),
                      ],
                    ),
                    SizedBox(height: 50.0,),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Column(
                        children: [
                          Text('Result',style: TextStyle(
                            color: Colors.black,
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                          ),),
                          Text(result,style:TextStyle(
                            color: secondColor,
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          )),
                        ],
                      ),
                    )
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}

