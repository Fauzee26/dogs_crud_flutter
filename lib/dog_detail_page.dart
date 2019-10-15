import 'package:flutter/material.dart';

import 'dog_model.dart';

class DogDetailPage extends StatefulWidget {
  final Dog dog;

  DogDetailPage(this.dog);

  @override
  _DogDetailPageState createState() => _DogDetailPageState();
}

class _DogDetailPageState extends State<DogDetailPage> {
  // Arbitrary size choice for styles
  final double dogAvatarSize = 150.0;
final double dogAvatarSize = 150.0;
  double _sliderValue = 10.0;

  Widget get dogImage {
    // Containers define the size of its children.
    return Hero(
      // The same code, except the Dog property lives on the widget in this file.
      tag: widget.dog,
      child: Container(
        height: dogAvatarSize,
      width: dogAvatarSize,
      // Use Box Decoration to make the image a circle
      // and add an arbitrary shadow for styling.
      decoration: BoxDecoration(
        shape: BoxShape.circle,
       boxShadow: [
          const BoxShadow(
              offset: const Offset(1.0, 2.0),
              blurRadius: 2.0,
              spreadRadius: -1.0,
              color: const Color(0x33000000)),
          const BoxShadow(
              offset: const Offset(2.0, 1.0),
              blurRadius: 3.0,
              spreadRadius: 0.0,
              color: const Color(0x24000000)),
          const BoxShadow(
              offset: const Offset(3.0, 1.0),
              blurRadius: 4.0,
              spreadRadius: 2.0,
              color: const Color(0x1F000000)),
        ],
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(widget.dog.imageUrl),
        ),
      ),
    );
  }

  // The rating section that says ★ 10/10.
  Widget get rating {
    // Use a row to lay out widgets horizontally.
    return Row(
      // Center the widgets on the main-axis
      // which is the horizontal axis in a row.
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.star,
          size: 40.0,
        ),
        Text(' ${widget.dog.rating} / 10',
            style: Theme.of(context).textTheme.display2),
      ],
    );
  }

  // The widget that displays the image, rating and dog info.
  Widget get dogProfile {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 32.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: [0.1, 0.5, 0.7, 0.9],
          colors: [
            Colors.indigo[800],
            Colors.indigo[700],
            Colors.indigo[600],
            Colors.indigo[400],
          ],
        ),
      ),
      // The Dog Profile information.
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          dogImage,
          Text(
            '${widget.dog.name}  🎾',
            style: TextStyle(fontSize: 32.0),
          ),
          Text(
            widget.dog.location,
            style: TextStyle(fontSize: 20.0),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
            child: Text(widget.dog.description),
          ),
          rating
        ],
      ),
    );
  }

Widget get addYourRating {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 16.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                flex: 1,
                child: Slider(
                  activeColor: Colors.indigoAccent,
                  min: 0.0,
                  max: 15.0,
                  onChanged: (newRating) {
                    setState(() => _sliderValue = newRating);
                  },
                  value: _sliderValue,
                ),
              ),

              // This is the part that displays the value of the slider.
              Container(
                width: 50.0,
                alignment: Alignment.center,
                child: Text('${_sliderValue.toInt()}',
                    style: Theme.of(context).textTheme.display1),
              ),
            ],
          ),
        ),
        submitRatingButton,
      ],
    );
  }

void updateRating() {
  if (_sliderValue < 10) {
    _ratingErrorDialog();
  } else {
    setState(() => widget.dog.rating = _sliderValue.toInt());
  }
}

  Future<Null> _ratingErrorDialog() async {
    // showDialog is a built-in Flutter method.
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error!'),
          content: Text("They're good dogs, Brant."),
          // This action uses the Navigator to dismiss the dialog.
          // This is where you could return information if you wanted to.
          actions: [
            FlatButton(
              child: Text('Try Again'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      },
    );
  }
  // A simple Raised Button that as of now doesn't do anything yet.
  Widget get submitRatingButton {
    return RaisedButton(
      onPressed: () => updateRating,
      child: Text('Submit'),
      color: Colors.indigoAccent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text('Meet ${widget.dog.name}'),
      ),
      // Make the body a ListView that displays
      // both the profile and the rating form.
      body: ListView(
        children: <Widget>[dogProfile, addYourRating],
      ),
    );
  }
}