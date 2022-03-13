import 'package:flutter_test/flutter_test.dart';
import 'package:wasteagram/models/food_waste_post.dart';

void main() {
  test('Expect created post should equal to the assigned value', () {
    const title = 'Hello World';
    final dateTime = DateTime.now();
    const imageURL = 'Dummy URL';
    const quantity = 1;
    const latitude = 1.0;
    const longitude = 2.0;

    final foodWastePost = FoodWastePost(
      title: title,
      imageURL: imageURL,
      quantity: quantity,
      longitude: longitude,
      latitude: latitude,
      dateTime: dateTime,
    );

    expect(foodWastePost.title, title);
    expect(foodWastePost.imageURL, imageURL);
    expect(foodWastePost.quantity, quantity);
    expect(foodWastePost.latitude, latitude);
    expect(foodWastePost.longitude, longitude);
    expect(foodWastePost.dateTime, dateTime);
    print("Finish Test 1");
  });

  test('Expect created post should not equal to the assigned value', () {
    const title = 'Oregon State University';
    final dateTime = DateTime.now();
    const imageURL = 'Dummy URL';
    const quantity = 100;
    const latitude = 5.0;
    const longitude = 3.0;

    final foodWastePost = FoodWastePost(
      title: title,
      imageURL: imageURL,
      quantity: quantity,
      longitude: longitude,
      latitude: latitude,
      dateTime: dateTime,
    );

    expect(foodWastePost.title, title);
    expect(foodWastePost.imageURL, isNot(imageURL.hashCode.toString()));
    expect(foodWastePost.quantity, quantity);
    expect(foodWastePost.latitude, latitude);
    expect(foodWastePost.longitude, longitude);
    expect(foodWastePost.dateTime, dateTime);
    print("Finish Test 2");
  });
}
