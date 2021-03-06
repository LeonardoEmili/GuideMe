import 'dart:io';

import 'package:GuideMe/commons/itinerary.dart';
import 'package:GuideMe/utils/data.dart';
import 'package:GuideMe/utils/utils.dart';
import 'package:GuideMe/widgets/confirmation_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Star {
  final Color color;
  final Function onTap;

  Star({this.color, this.onTap});
}

class FeedbackFragment extends StatefulWidget {
  final Itinerary itinerary;
  final List<String> msgs = [
    "Tap a star to review",
    "Horrible",
    "Poor",
    "Medium",
    "Good",
    "Excellent",
  ];

  FeedbackFragment({Key key, @required this.itinerary}) : super(key: key);

  static Function instance =
      ({Key key, Itinerary itinerary}) => new FeedbackFragment(
            key: key,
            itinerary: itinerary,
          );

  @override
  State<StatefulWidget> createState() => FeedbackFragmentState();
}

class FeedbackFragmentState extends State<FeedbackFragment> {
  int _currentStars = -1;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _requireRating = false;
  bool _validateTitle = false, _validateDescription = false;
  List<File> images = [null];

  _getStars() {
    List<Star> stars = [];

    for (var i = 0; i < RATING_STARS; i++) {
      stars.add(new Star(
        color: (i <= _currentStars)
            ? isDarkTheme(context) ? Colors.white : Colors.yellow
            : isDarkTheme(context) ? Colors.grey[700] : Colors.grey[300],
        onTap: () => setState(() {
          _requireRating = false;
          _currentStars = i;
        }),
      ));
    }

    return Container(
      margin: EdgeInsets.only(top: 5, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: stars.map((star) {
          return Flexible(
            child: GestureDetector(
                onTap: star.onTap,
                child: Icon(
                  Icons.star,
                  size: 54,
                  color: star.color,
                )),
          );
        }).toList(),
      ),
    );
  }

  Future _getImage(int index) async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 120, maxWidth: 80);
    images.add(null);
    setState(() {
      images[index] = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: Platform.isIOS
          ? CupertinoNavigationBar(
              backgroundColor:
                  isDarkTheme(context)
                      ? CupertinoColors.systemGrey5
                      : CupertinoColors.white,
              middle: Text(
                widget.itinerary.title,
                style: TextStyle(
                    color: MediaQuery.of(context).platformBrightness ==
                            Brightness.dark
                        ? Colors.white
                        : Colors.black),
              ),
              previousPageTitle: "Visited",
              trailing: FlatButton(
                child: Text(
                  "Publish",
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
                onPressed: () => _handleReviewButton(context),
              ),
            )
          : AppBar(
              title: Text(widget.itinerary.title),
            ),
      body: GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  _requireRating
                      ? widget.msgs[0]
                      : widget.msgs[_currentStars >= 0 && _currentStars <= 4
                          ? _currentStars + 1
                          : 0],
                  style: TextStyle(
                      color: _requireRating ? Colors.red : Colors.grey),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: _getStars(),
              ),
              Divider(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 10),
                  Text(
                    "Title",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 10),
                  Container(
                    child: TextField(
                      controller: _titleController,
                      onChanged: (value) =>
                          setState(() => _validateTitle = value.isEmpty),
                      minLines: 2,
                      maxLines: 2,
                      maxLength: 50,
                      decoration: new InputDecoration(
                        errorText: _validateTitle
                            ? "This field cannot be left empty."
                            : null,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          borderSide: BorderSide(width: 1, color: Colors.grey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          borderSide: BorderSide(width: 1, color: Colors.grey),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide: BorderSide(
                              width: 1,
                            )),
                        hintText:
                            "The most important things you want to share.",
                        helperText:
                            "Your experience in no more than 50 characters.",
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 10),
                  Text(
                    "Description",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 10),
                  Container(
                    child: TextField(
                      controller: _descriptionController,
                      onChanged: (value) =>
                          setState(() => _validateDescription = value.isEmpty),
                      minLines: 4,
                      maxLines: 4,
                      maxLength: 300,
                      decoration: new InputDecoration(
                        errorText: _validateDescription
                            ? "This field cannot be left empty."
                            : null,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          borderSide: BorderSide(width: 1, color: Colors.grey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          borderSide: BorderSide(width: 1, color: Colors.grey),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide: BorderSide(
                              width: 1,
                            )),
                        hintText:
                            "What did you like about it and what did you not? To who would you recomend it?",
                        helperText:
                            "Your experience in no more than 300 characters.",
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                "Photo",
                style: TextStyle(fontSize: 20),
              ),
              _getGalleryPickers(),
            ],
          ),
        ),
      )),
      floatingActionButton: Platform.isIOS
          ? Text("")
          : Padding(
              padding: EdgeInsets.all(5),
              child: FloatingActionButton(
                child: Icon(Icons.send),
                onPressed: () => _handleReviewButton(context),
              )),
    );
  }

  void _handleReviewButton(BuildContext context) {
    if (_currentStars > -1 &&
        _titleController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty) {
      reviewItinerary(widget.itinerary);
      Navigator.of(context).pop();
      showDialog(
          context: context,
          builder: (BuildContext context) {
            Future.delayed(Duration(seconds: 1), () {
              Navigator.of(context).pop(true);
            });
            return ConfirmationDialog(text: "Your review has been sent!");
          });
    } else {
      _requireRating = (_currentStars == -1);
      _validateTitle = (_titleController.text.isEmpty);
      _validateDescription = (_descriptionController.text.isEmpty);
      setState(() {});
    }
  }

  Widget _getGalleryPickers() {
    return Container(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          if (images[index] == null) {
            return Padding(
                padding: EdgeInsets.only(
                  bottom: 20,
                ),
                child: InkWell(
                  child: Icon(
                    Icons.add_box,
                    size: 80,
                    color: Color(0xFF616161),
                  ),
                  onTap: () => _getImage(index),
                ));
          } else {
            return Padding(
              padding: EdgeInsets.only(top: 20, left: 8, right: 8),
              child: Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black26)),
                constraints: BoxConstraints(
                  maxWidth: 70,
                ),
                child: Stack(
                  children: <Widget>[
                    Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Image.file(images[index]),
                        Align(
                          child: IconButton(
                            icon: Icon(
                              Icons.cancel,
                              size: 32,
                              color: Colors.redAccent,
                            ),
                            onPressed: () =>
                                setState(() => images.removeAt(index)),
                          ),
                          alignment: Alignment.topRight,
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
