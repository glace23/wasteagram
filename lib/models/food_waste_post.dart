class FoodWastePost {
  String? title;
  String? imageURL;
  int? quantity;
  double? longitude;
  double? latitude;
  DateTime? dateTime;
  String? id;

  FoodWastePost(
      {this.title,
      this.imageURL,
      this.quantity,
      this.longitude,
      this.latitude,
      this.dateTime});

  @override
  String toString() {
    return 'Title: $title, ImageURL: $imageURL, Quantity: $quantity, Longitude: $longitude, '
        'Latitude: $latitude Datetime: $dateTime';
  }
}
