
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hotel_booking_app/screens/hotel_booking_screen.dart';
import 'package:hotel_booking_app/screens/hotel_details_screen.dart';
import 'package:hotel_booking_app/screens/hotel_overview.dart';

import 'amadeus.dart';

void main() async{
  await dotenv.load();
  runApp(const MyApp());
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.purpleAccent,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hotel Booking App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Hotel Booking App'),
      routes: {
        HotelDetailsScreen.routeName: (ctx) => HotelDetailsScreen(),

      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Amadeus amadeus = Amadeus();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      // appBar: AppBar(
      //
      //   title: Text(widget.title),
      // ),
      body: HotelBookingScreen()
    );
  }
}
