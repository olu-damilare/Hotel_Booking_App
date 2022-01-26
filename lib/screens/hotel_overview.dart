import 'package:flutter/material.dart';

import 'package:hotel_booking_app/model/hotel.dart';


class HotelOverviewScreen extends StatefulWidget {

  @override
  _HotelOverviewScreenState createState() => _HotelOverviewScreenState();
}

class _HotelOverviewScreenState extends State<HotelOverviewScreen> {

  @override
  Widget build(BuildContext context) {
    final FocusNode focusKeyword = FocusNode();
    final FocusNode focusLocation = FocusNode();

    final TextEditingController keywordController = TextEditingController();
    final TextEditingController locationController = TextEditingController();

    List<Hotel> searchedHotels = [];

    void fetchHotels(String name, String? location){

    }


    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purpleAccent,
          centerTitle: true,
          title: const Text("Hotel Booking App"),
        ),
        body: Form(child: ListView(
            children: <Widget>[
        TextFormField(
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(10),
          icon: Icon(Icons.text_fields),
            labelText: 'Hotel Name'
        ),
            textInputAction: TextInputAction.next,
            focusNode: focusKeyword,
            onFieldSubmitted: (_){
              FocusScope.of(context).requestFocus(focusLocation);
            }
        ),
        TextFormField(
          decoration: InputDecoration(
              contentPadding: EdgeInsets.all(10),
              icon: Icon(Icons.location_on),
              labelText: 'Location '
          ),
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.number,
          focusNode: focusLocation,
        ),
         SizedBox(
           height: 20,
         ),
         Center(
           child: Container(
             width: 200,
             height: 50,
             child: RaisedButton(
                color: Colors.amber,
               child: Text(
                   "Search",
                 style: TextStyle(
                   fontWeight: FontWeight.bold,
                   fontSize: 20,
                   color: Colors.white
                 ),
               ),
               onPressed: (){

               },
             ),
           ),
         )
        ]
    )
        )


        // GridView.builder(
        //   padding: const EdgeInsets.all(10),
        //   itemCount: selectedProducts.length,
        //   itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        //
        //     value: selectedProducts[i],
        //     child: ProductItem(
        //       // products[i].id,
        //       // products[i].title,
        //       // products[i].imageUrl
        //     ),
        //   ),
        //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //       crossAxisCount: 2,
        //       childAspectRatio: 3 / 2,
        //       crossAxisSpacing: 10,
        //       mainAxisSpacing: 20
        //   ),
        // )
    );
  }
}




