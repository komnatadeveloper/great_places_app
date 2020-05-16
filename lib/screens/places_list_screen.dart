import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/great_places.dart';

import './add_place_screen.dart';


class PlacesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Places'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(
                AddPlaceScreen.routeName
              );
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<GreatPlaces>(context, listen: false).fetchAndSetPlaces(),
        builder: (ctx, snapShot) =>
          snapShot.connectionState == ConnectionState.waiting
           ? Center(
             child: CircularProgressIndicator(),
           )
           : Consumer<GreatPlaces>(
              child: Center(
                child: const Text('Got no places yet, start adding some!'),
              ),
              builder: (ctx, greatPlaces, child) => greatPlaces.items.length <= 0 
                ? child
                : ListView.builder(
                  itemCount: greatPlaces.items.length,
                  itemBuilder: (ctx, index) => ListTile(
                    leading: CircleAvatar(
                      backgroundImage: FileImage(
                        greatPlaces.items[index].image
                      ),
                    ),
                    title: Text(greatPlaces.items[index].title),
                    onTap: () {
                      // go to detail page
                    },
                  ) ,
                ),
            ),
         
      )
    );
  }
}