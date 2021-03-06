import 'dart:io';

import 'package:GuideMe/commons/itinerary.dart';
import 'package:GuideMe/utils/utils.dart';
import 'package:GuideMe/widgets/explore_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FavouritesFragment extends StatefulWidget {
  @override
  _FavouritesFragmentState createState() => _FavouritesFragmentState();
}

class _FavouritesFragmentState extends State<FavouritesFragment> {
  @override
  Widget build(BuildContext context) {
    List<Itinerary> data = favouriteItineraries;

    if (data.length == 0) {
      return SafeArea(
          child: CustomScrollView(slivers: <Widget>[
        Platform.isIOS
            ? CupertinoSliverNavigationBar(
                backgroundColor: isDarkTheme(context) ?
                            Colors.grey[850] : Colors.grey[50],
                  largeTitle: Text("Favorites",
                  style: TextStyle(color: isDarkTheme(context) ?
                  Colors.white : Colors.black)),
                  
              )
            : SliverList(
                delegate: SliverChildBuilderDelegate((_, i) {
                  return Text("");
                }, childCount: 0),
              ),
        SliverFillRemaining(
            child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.all(40),
            child: Text(
                "It seems that you haven't added any itinerary to the favorites. You can do it by selecting it from the Explore section.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18)),
          ),
        ))
      ]));
    }

    return SafeArea(
        child: Platform.isIOS
            ? CustomScrollView(slivers: <Widget>[
                CupertinoSliverNavigationBar(
                  largeTitle: Text("Favorites"),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return ExploreCard(
                        itinerary: data[index], pageTitle: "Favorites");
                  }, childCount: data.length),
                )
              ])
            : ListView.builder(
                itemCount: data.length,
                itemBuilder: (_, index) => Container(
                    // Add padding to the last item of the list
                    padding: index == data.length - 1
                        ? EdgeInsets.only(bottom: 10, top: index == 0 ? 10 : 0)
                        : EdgeInsets.only(bottom: 4, top: index == 0 ? 10 : 0),
                    // Form a new card from the current itinerary information
                    child: ExploreCard(
                        itinerary: data[index], pageTitle: "Favorites")),
              ));
  }
}
