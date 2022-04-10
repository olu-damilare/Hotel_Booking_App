import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../amadeus.dart';

class HotelBookingScreen extends StatefulWidget {
  const HotelBookingScreen({Key? key}) : super(key: key);

  @override
  _HotelBookingScreenState createState() => _HotelBookingScreenState();
}

class _HotelBookingScreenState extends State<HotelBookingScreen> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _numberOfAdultsController = TextEditingController();
  final FocusNode _nameNode = FocusNode();
  final FocusNode _emailNode = FocusNode();
  final FocusNode _numberOfAdultsNode = FocusNode();
  DateTime? _checkInDate;
  DateTime? _checkOutDate;

  Future<DateTime?> _displayDatePicker() async{
   DateTime? value = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2023)
    );

     if (value == null) return null;
     print('value --> $value');
     return value;

  }

  String formatDateForAPI(DateTime? dateTime){
    String month = '';
    String day = '';
    if(dateTime!.month < 10) {
      month  = '0${dateTime.month}';
    }else {
      dateTime.month.toString();
    }

    if(dateTime.day < 10) {
      day  = '0${dateTime.day}';
    }else {
      day = dateTime.day.toString();
    }

    return '${dateTime.year}-$month-$day';

  }



  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(28.0),
      child: Center(
        child: Form(
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Name'
                ),
                textInputAction: TextInputAction.next,
                controller: _nameController,
                onFieldSubmitted: (_){
                  FocusScope.of(context).requestFocus(_nameNode);
                },
                validator: (value){
                  if((value as String).isEmpty){
                    return 'Please provide a value';
                  }
                  return null;
                },
              ),
              TextFormField(

                decoration: InputDecoration(
                    labelText: 'Email'
                ),
                textInputAction: TextInputAction.next,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                focusNode: _emailNode,
                validator: (value){
                  if((value as String).isEmpty){
                    return 'Please provide a price';
                  }
                  if(double.tryParse(value) == null){
                    return 'Please provide a valid number';
                  }
                  if(double.parse(value) <= 0){
                    return 'Please provide a number greater than zero';
                  }
                  return null;
                },
              ),

              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Number of Adults'
                ),
                keyboardType: TextInputType.number,
                controller: _numberOfAdultsController,
                focusNode: _numberOfAdultsNode,
                validator: (value){
                  if((value as String).isEmpty){
                    return 'Please provide a price';
                  }
                  if(double.tryParse(value) == null){
                    return 'Please provide a valid number';
                  }
                  if(double.parse(value) <= 0){
                    return 'Please provide a number greater than zero';
                  }
                  return null;
                },
              ),

              SizedBox(
                height: 70,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                          _checkInDate == null ?
                          'No Date selected' :
                          'Check-In Date: ${DateFormat.yMd().format(_checkInDate!)}'
                      ),
                    ),
                    FlatButton(
                        onPressed: ()async{
                          _checkInDate = await _displayDatePicker();
                          setState(()  {

                          });
                        },
                        textColor: Theme.of(context).primaryColor,
                        child: const Text('Select check in date', style: TextStyle(fontWeight: FontWeight.bold),)),
                  ],
                ),
              ),

              SizedBox(
                height: 70,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                          _checkOutDate == null ?
                          'No Date selected' :
                          'Check-Out Date: ${DateFormat.yMd().format(_checkOutDate!)}'
                      ),
                    ),
                    FlatButton(
                        onPressed: () async{
                          _checkOutDate = await _displayDatePicker();
                          setState(()  {


                          });
                        },
                        textColor: Theme.of(context).primaryColor,
                        child: const Text('Select check out date', style: TextStyle(fontWeight: FontWeight.bold),)),
                  ],
                ),
              ),
              Container(
                width: 280,
                height: 50,
                child: RaisedButton(
                  child: Text("Submit",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  onPressed: () async{
                    String formattedCheckInDate = formatDateForAPI(_checkInDate);
                    String formattedCheckOutDate = formatDateForAPI(_checkOutDate);
                    print(await Amadeus().isAvailable('', formattedCheckInDate, formattedCheckOutDate));
                  },
                  color: Colors.amber,
                ),
              )

            ],


          ),),
      ),
    );
  }
}
