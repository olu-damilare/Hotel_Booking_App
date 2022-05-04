import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:hotel_booking_app/screens/hotel_overview_screen.dart';
import 'package:intl/intl.dart';

import '../amadeus.dart';

class HotelBookingScreen extends StatefulWidget {

  String offerId;
  String hotelId;
  HotelBookingScreen(this.offerId, this.hotelId);

  @override
  _HotelBookingScreenState createState() => _HotelBookingScreenState();
}

class _HotelBookingScreenState extends State<HotelBookingScreen> {

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _numberOfAdultsController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _countryCodeController = TextEditingController();
  final TextEditingController _roomQuantityController = TextEditingController();
  final FocusNode _firstNameNode = FocusNode();
  final FocusNode _lastNameNode = FocusNode();
  final FocusNode _emailNode = FocusNode();
  final FocusNode _numberOfAdultsNode = FocusNode();
  final FocusNode _roomQuantityNode = FocusNode();
  final FocusNode _titleNode = FocusNode();
  final FocusNode _phoneNumberNode = FocusNode();
  final FocusNode _countryCodeNode = FocusNode();
  DateTime? _checkInDate;
  DateTime? _checkOutDate;
  Amadeus amadeus = Amadeus();
  bool isLoading = false;

  // Displays the flutter date feature to select dates.
  Future<DateTime?> _displayDatePicker() async{
   DateTime? value = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2023)
    );

     if (value == null) return null;
     return value;

  }


  // This method formats the check in and check out dates for the hotel booking API request.
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

  void _showTopFlash({FlashBehavior style = FlashBehavior.fixed, required String message, required Color backgroundColor}) {
    showFlash(
      context: context,
      duration: const Duration(seconds: 4),
      persistent: true,
      builder: (_, controller) {
        return Flash(
          controller: controller,
          backgroundColor: backgroundColor,
          brightness: Brightness.light,
          barrierColor: Colors.black38,
          barrierDismissible: true,
          behavior: style,
          position: FlashPosition.top,
          child: FlashBar(
            content: Text(
              message,
              style: TextStyle(
                  color: Colors.white
              ),
            ),
            primaryAction: TextButton(
              onPressed: () {},
              child: Text('Dismiss',
                  style: TextStyle(color: Colors.blue)),
            ),
          ),
        );
      },
    );
  }




@override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purpleAccent,
        title: Text('Book Room'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Center(
          child: Form(
            child: ListView(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Title'
                  ),
                  textInputAction: TextInputAction.next,
                  controller: _titleController,
                  onFieldSubmitted: (_){
                    FocusScope.of(context).requestFocus(_titleNode);
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
                      labelText: 'First Name'
                  ),
                  textInputAction: TextInputAction.next,
                  controller: _firstNameController,
                  onFieldSubmitted: (_){
                    FocusScope.of(context).requestFocus(_firstNameNode);
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
                      labelText: 'Last Name'
                  ),
                  textInputAction: TextInputAction.next,
                  controller: _lastNameController,
                  onFieldSubmitted: (_){
                    FocusScope.of(context).requestFocus(_lastNameNode);
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
                      return 'Please provide a number of adults.';
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
                      labelText: 'Room quantity'
                  ),
                  keyboardType: TextInputType.number,
                  controller: _roomQuantityController,
                  focusNode: _roomQuantityNode,
                  validator: (value){
                    if((value as String).isEmpty){
                      return 'Please provide the quantity of rooms to book.';
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
                      labelText: 'Country code'
                  ),
                  keyboardType: TextInputType.number,
                  controller: _countryCodeController,
                  focusNode: _countryCodeNode,
                  validator: (value){
                    if((value as String).isEmpty){
                      return 'Please provide a country code';
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
                      labelText: 'Phone number'
                  ),
                  keyboardType: TextInputType.number,
                  controller: _phoneNumberController,
                  focusNode: _phoneNumberNode,
                  validator: (value){
                    if((value as String).isEmpty){
                      return 'Please provide phone number';
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
                            'Check-In Date: ${DateFormat.yMd().format(_checkInDate!)}',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500
                          ),
                        ),
                      ),
                      FlatButton(
                          onPressed: ()async{
                            _checkInDate = await _displayDatePicker();
                            setState(()  {

                            });
                          },
                          textColor: Theme.of(context).primaryColor,
                          child: const Text('Select check-in date', style: TextStyle(fontWeight: FontWeight.bold),)),
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
                            'Check-Out Date: ${DateFormat.yMd().format(_checkOutDate!)}',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                      ),
                      FlatButton(
                          onPressed: () async{
                            _checkOutDate = await _displayDatePicker();
                            setState(()  {
                            });
                          },
                          textColor: Theme.of(context).primaryColor,
                          child: const Text('Select check-out date', style: TextStyle(fontWeight: FontWeight.bold),)),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  width: 280,
                  height: 50,
                  child: RaisedButton(
                    child: isLoading ? CircularProgressIndicator() : Text("Submit",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    onPressed: () async{
                      setState(() {
                        isLoading = true;
                      });
                      String formattedCheckInDate = formatDateForAPI(_checkInDate);
                      String formattedCheckOutDate = formatDateForAPI(_checkOutDate);

                      bool isAvailable = await amadeus.isAvailable(widget.hotelId, _numberOfAdultsController.text, formattedCheckInDate, formattedCheckOutDate, _roomQuantityController.text);

                      if(!isAvailable){
                        _showTopFlash(message: 'Room is currently unavailable for the selected dates.', backgroundColor: Colors.red);
                      }else{
                        String phoneNumber = '+${_countryCodeController.text}${_phoneNumberController.text}';
                        await amadeus.bookRoom(offerId: widget.offerId, title: _titleController.text, firstName: _firstNameController.text, lastName: _lastNameController.text, phoneNumber: phoneNumber, email: _emailController.text);
                        Navigator.of(context).pushReplacementNamed(HotelOverviewScreen.routeName);
                        _showTopFlash(message: 'Successfully booked room.', backgroundColor: Colors.green);
                      }
                    },
                    color: Colors.amber,
                  ),
                )
              ],
            ),),
        ),
      ),
    );
  }
}
