import 'package:flutter/material.dart';

import 'dog_model.dart';
import 'dog_detail_page.dart';

class DogCard extends StatefulWidget {
  final Dog dog;

  DogCard(this.dog);

  @override
  _DogCardState createState() => _DogCardState(dog);
}

class _DogCardState extends State<DogCard> {
  Dog dog;
  String renderUrl;

  _DogCardState(this.dog);

  @override
  Widget build(BuildContext context) {
    // InkWell is a special Material widget that makes its children tappable
  // and adds Material Design ink ripple when tapped.
  return InkWell(
    // onTap is a callback that will be triggered when tapped.
    onTap: showDogDetailPage,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        height: 115.0,
        child: Stack(
          children: <Widget>[
            Positioned(
              left: 50.0,
              child: dogCard,
            ),
            Positioned(top: 7.5, child: dogImage),
          ],
        ),
      ),
    ),
  );

  Widget get dogImage {
  var dogAvatar = Hero(
    // Give your hero a tag.
    //
    // Flutter looks for two widgets on two different pages,
    // and if they have the same tag it animates between them.
    tag: dog,
    child: Container(
    width: 100.0,
    height: 100.0,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      image: DecorationImage(
        fit: BoxFit.cover,
        image: NetworkImage(renderUrl ?? ''),
      ),
    ),
  );

  // Placeholder is a static container the same size as the dog image.
  var placeholder = Container(
    width: 100.0,
    height: 100.0,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.black54, Colors.black, Colors.blueGrey[600]],
      ),
    ),
    alignment: Alignment.center,
    child: Text(
      'DOGGO',
      textAlign: TextAlign.center,
    ),
  );

  // This is an animated widget built into flutter.
  return AnimatedCrossFade(
    // You pass it the starting widget and the ending widget.
    firstChild: placeholder,
    secondChild: dogAvatar,
      // Then, you pass it a ternary that should be based on your state
      //
      // If renderUrl is null tell the widget to use the placeholder,
      // otherwise use the dogAvatar.
    crossFadeState: renderUrl == null
        ? CrossFadeState.showFirst
        : CrossFadeState.showSecond,
     // Finally, pass in the amount of time the fade should take.
    duration: Duration(milliseconds: 1000),
  );
}
}

// This is the builder method that creates a new page.
showDogDetailPage() {
  // Navigator.of(context) accesses the current app's navigator.
  // Navigators can 'push' new routes onto the stack,
  // as well as pop routes off the stack.
  //
  // This is the easiest way to build a new page on the fly
  // and pass that page some state from the current page.
  Navigator.of(context).push(
    MaterialPageRoute(
      // builder methods always take context!
      builder: (context) {
        return DogDetailPage(dog);
      },
    ),
  );
  }

  void initState() {
    super.initState();
    renderDogPic();
  }

  void renderDogPic() async {
    // this makes the service call
    await dog.getImageUrl();
    // setState tells Flutter to rerender anything that's been changed.
    // setState cannot be async, so we use a variable that can be overwritten
    if (mounted) {
      // Avoid calling `setState` if the widget is no longer in the widget tree.
      setState(() {
        renderUrl = dog.imageUrl;
      });
    }
  }

  Widget get dogImage {
    return Container(
      // You can explicitly set heights and widths on Containers.
      // Otherwise they take up as much space as their children.
      width: 100.0,
      height: 100.0,
      // Decoration is a property that lets you style the container.
      // It expects a BoxDecoration.
      decoration: BoxDecoration(
          image: NetworkImage(renderUrl ?? ''),
        ),
      ),
    );
  }
}
