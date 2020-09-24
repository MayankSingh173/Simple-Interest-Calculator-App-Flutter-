import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Simple Interest Calculator App",
      home: SIForm(),
      theme: ThemeData(
//        brightness: Brightness.dark,
        primaryColor: Colors.indigo,
        accentColor: Colors.indigo,
      ),
    ));

class SIForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SIFormState();
  }
}

class _SIFormState extends State<SIForm> {
  var _formKey = GlobalKey<FormState>();
  var _currencies = ['Rupees', 'Dollars', 'Pounds'];
  var _currentCurrency = 'Rupees';
  var displayResults = '';

  TextEditingController principalController = TextEditingController();
  TextEditingController roiController = TextEditingController();
  TextEditingController termController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;

    return Scaffold(
        appBar: AppBar(
          title: Text('Simple Interest Calculator'),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: ListView(
              children: <Widget>[
                getImageAsset(),
                Padding(
                    padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      style: textStyle,
                      controller: principalController,
                      validator: (String value){
                        if(value.isEmpty){
                          return 'Please enter principal amount';
                        }
                      },
                      decoration: InputDecoration(
                          labelText: 'Principal',
                          labelStyle: textStyle,
                          hintText: 'Enter Principal e.g. 12000',
                          fillColor: Colors.blue,
                          errorStyle: TextStyle(
                            color: Colors.yellowAccent,
                            fontSize: 15.0
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          )),
                    )),
                Padding(
                  padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    style: textStyle,
                    validator: (String value){
                      if(value.isEmpty){
                        return 'Please enter rate of Interest';
                      }
                    },
                    controller: roiController,
                    decoration: InputDecoration(
                        labelText: 'Rate of Interest',
                        labelStyle: textStyle,
                        errorStyle: TextStyle(
                          color: Colors.yellowAccent,
                          fontSize: 15.0
                        ),
                        hintText: 'In percent',
                        fillColor: Colors.blue,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        )),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                        child: Padding(
                            padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                            child: TextFormField(
                              style: textStyle,
                              controller: termController,
                              keyboardType: TextInputType.number,
                              validator: (String value){
                                if(value.isEmpty){
                                  return 'Please enter term';
                                }
                              },
                              decoration: InputDecoration(
                                  labelText: 'Term',
                                  labelStyle: textStyle,
                                  errorStyle: TextStyle(
                                      color: Colors.yellowAccent,
                                      fontSize: 15.0
                                  ),
                                  hintText: 'Time in years ',
                                  fillColor: Colors.blue,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  )),
                            ))),
                    Container(
                      width: 25.0,
                    ),
                    Expanded(
                        child: DropdownButton<String>(
                      items: _currencies.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      value: _currentCurrency,
                      style: textStyle,
                      onChanged: (String newValueSelected) {
                        _onDropDownCurrencySelected(newValueSelected);
                      },
                    )),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: RaisedButton(
                        elevation: 10.0,
                        color: Colors.green,
                        child: Text(
                          'Calculate',
                          style: textStyle,
                        ),
                        onPressed: () {
                          setState(() {
                            if(_formKey.currentState.validate()){
                              this.displayResults = _calculateTotalReturn();
                            }
                          });
                        },
                      )),
                      Container(
                        width: 10.0,
                      ),
                      Expanded(
                          child: RaisedButton(
                        elevation: 10.0,
                        color: Colors.red,
                        child: Text(
                          'Reset',
                          style: textStyle,
                        ),
                        onPressed: () {
                          setState(() {
                            _reset();
                          });
                        },
                      )),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20.0, bottom: 5.0),
                  child: Text(
                    this.displayResults,
                    textAlign: TextAlign.center,
                    style: textStyle,
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Widget getImageAsset() {
    AssetImage assetImage = AssetImage('images/SimpleInterest.png');
    Image image = Image(
      image: assetImage,
      width: 100.0,
      height: 150.0,
    );

    return Padding(
        padding: EdgeInsets.only(bottom: 15.0),
        child: Container(
          width: 10.0,
          child: image,
          margin: EdgeInsets.only(left: 10.0, top: 25.0),
        ));
  }

  void _onDropDownCurrencySelected(String newValueSelected) {
    setState(() {
      this._currentCurrency = newValueSelected;
    });
  }

  String _calculateTotalReturn() {
    double principal = double.parse(principalController.text);
    double roi = double.parse(roiController.text);
    int term = int.parse(termController.text);

    double totalAmountPayble = principal + (principal * roi * term) / 100;

    String results =
        'After $term years, your investment will be worth $totalAmountPayble ${this._currentCurrency}';
    return results;
  }

  void _reset() {
    principalController.text = '';
    roiController.text = '';
    termController.text = '';
    displayResults = '';
    _currentCurrency = _currencies[0];
  }
}
