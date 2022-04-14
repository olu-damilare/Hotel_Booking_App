import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hotel_booking_app/model/hotel.dart';

import '../amadeus.dart';
import 'hotel_booking_screen.dart';

class HotelDetailsScreen extends StatefulWidget {

   HotelDetailsScreen(this.hotelId);

  String hotelId;

  static const routeName = "/hotel-details";

  @override
  _HotelDetailsScreenState createState() => _HotelDetailsScreenState();
}

class _HotelDetailsScreenState extends State<HotelDetailsScreen> {

  Hotel? hotel;
  bool isLoading = true;

  Future<void> fetchHotelDetails(String hotelId) async {

    hotel = await Amadeus().getHotelOffers(hotelId);
    if(hotel == null){
      SnackBar(
        backgroundColor: Colors.red,
        padding: EdgeInsets.all(10),
        duration: Duration(seconds: 3),
        content: Text('Failed to fetch Hotel details.'),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    fetchHotelDetails(widget.hotelId);
  }

  TextStyle keyStyle(){
    return TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: Colors.purple
    );
  }


  TextStyle valueStyle(){
    return TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
    );
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purpleAccent,
        centerTitle: true,
        title: isLoading ? Text("") : Text(
          hotel?.name as String
        ),
      ),
        body: hotel == null ? Center(
          child: CircularProgressIndicator(),
        ) : Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 50, 18, 0),
            child: Container(
              width: 350,
              child: Column(
                children: [
                  Text(hotel!.name as String,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20,),
                  Row(
                    children: [
                      Text("Location: ",
                      style: keyStyle(),
                      ),
                      Text(hotel!.location as String, style: valueStyle())
                    ],
                  ),
                  SizedBox(height: 20,),
                  Row(
                    children: [
                      Text("Room category: ", style: keyStyle(),),
                      Text(hotel!.roomCategory as String, style: valueStyle(),)
                    ],
                  ),
                  SizedBox(height: 20,),
                  Row(
                    children: [
                      Text("Beds: ",
                        style: keyStyle(),),
                      Text(hotel!.beds.toString(),
                      style: valueStyle(),)
                    ],
                  ),
                  SizedBox(height: 20,),
                  Row(
                    children: [
                      Text("Bed Type: ", style: keyStyle(),),
                      Text(hotel!.bedType as String,
                        style: valueStyle(),)
                    ],
                  ),
                  SizedBox(height: 20,),
                  Row(
                    children: [
                      Text("Description: ", style: keyStyle(),),
                      Container(
                        width: 230,
                          child: Text(hotel!.description as String,
                            style: valueStyle(),))
                    ],
                  ),
                  SizedBox(height: 20,),
                  Row(
                    children: [
                      Text("Price: ", style: keyStyle(),),
                      Text('${hotel!.currency} ${hotel!.price}',
                        style: valueStyle(),)
                    ],
                  ),
                  SizedBox(height: 55,),
                  Container(
                    width: 280,
                    height: 50,
                    child: RaisedButton(
                      child: Text("Book",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      onPressed: (){
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) =>
                                HotelBookingScreen(hotel!.offerId as String, hotel!.hotelId as String))
                        );
                      },
                      color: Colors.amber,
                    ),
                  )
                ],
              ),
            ),
          )
        ));
  }


}
