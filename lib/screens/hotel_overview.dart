import 'package:flutter/material.dart';
import 'package:hotel_booking_app/amadeus.dart';

import 'package:hotel_booking_app/model/hotel.dart';

import 'hotel_details_screen.dart';


class HotelOverviewScreen extends StatefulWidget {
  static const routeName = "/hotels-overview";

  @override
  _HotelOverviewScreenState createState() => _HotelOverviewScreenState();
}

class _HotelOverviewScreenState extends State<HotelOverviewScreen> {

  final FocusNode focusKeyword = FocusNode();

  final TextEditingController keywordController = TextEditingController();

  List<Hotel> searchedHotels = [];

  bool isLoading = false;

  Future<void> fetchHotels(String name) async {
    isLoading = true;
    setState(() {

    });
    var temp = await Amadeus().fetchHotels(name);
    setState(() {
      searchedHotels = temp;
      isLoading = false;
    });

  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purpleAccent,
          centerTitle: true,
          title: const Text("Hotel Booking App"),
        ),
        body: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
        Container(
        decoration: const BoxDecoration(
        image: DecorationImage(image: NetworkImage("https://images.unsplash.com/photo-1562133567-b6a0a9c7e6eb?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80"), fit: BoxFit.cover,),
    ),

    ),
        Form(child: ListView(
            children: <Widget>[

        Padding(
          padding: const EdgeInsets.fromLTRB(8, 20, 8, 0),
          child: TextFormField(
            controller: keywordController,
            style: const TextStyle(
              color: Colors.white
            ),
          decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(10),
            border: OutlineInputBorder(),
              prefixIcon: Icon(
                Icons.apartment,
                color: Colors.white,
              ),

              labelText: 'Hotel Name',
            labelStyle: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold
            )

          ),
              textInputAction: TextInputAction.next,
              focusNode: focusKeyword,

          ),
        ),
         const SizedBox(
           height: 20,
         ),
         Center(
           child: SizedBox(
             width: 200,
             height: 50,
             child: RaisedButton(
                color: Colors.amber,
               child: const Text(
                   "Search",
                 style: TextStyle(
                   fontWeight: FontWeight.bold,
                   fontSize: 20,
                   color: Colors.white
                 ),
               ),
               onPressed: () => fetchHotels(keywordController.text),
             ),
           ),
         )
        ]
    )
        ),
         isLoading ? Center(child: CircularProgressIndicator(
           color: Colors.white,
         ))
          : searchedHotels.isEmpty ? Center(
            child: Container(
              color: Colors.black54,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text(
                    "Input your desired hotel name in the search bar to see a list of available hotels.",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 25
                    ),
                ),
              ),
            ),
          )
          : Container(
            height: 500,
              child: ListView.builder(
            itemCount: searchedHotels.length,
            itemBuilder: (ctx, i) => Card(margin: EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 4,
            ),
              child: Padding(
                  padding: EdgeInsets.all(8),
                  child: ListTile(
                    onTap: () => Navigator.of(context).pushNamed(HotelDetailsScreen.routeName, arguments: {'hotelId': searchedHotels[i].hotelId, 'hotelName': searchedHotels[i].name}),
                    title: Text(searchedHotels[i].name as String),
                    subtitle: Row(
                      children: <Widget>[
                        Icon(Icons.location_on),
                        Text("${searchedHotels[i].cityName}, ${searchedHotels[i].countryCode}")

                      ],
                    ),
                  )
              ),
            ),
          )
          )


    ]
        )


    );
  }



}




