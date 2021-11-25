class AddAccountRequest {
  String title;
  String description;
  double price;
  int gameId;
  dynamic attributes;
  int deliverySpeedId;
  String email;
  String password;
  List<String> post_image;

  AddAccountRequest(
      {this.title,
      this.description,
      this.price,
      this.gameId,
      this.attributes,
      this.deliverySpeedId,
      this.email,
      this.password,
      this.post_image});

  AddAccountRequest.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    price = json['price'];
    gameId = json['game_id'];
    attributes = json['attributes'];
    deliverySpeedId = json['delivery_speed_id'];
    email = json['email'];
    password = json['password'];
    post_image = json['images'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['description'] = this.description;
    data['price'] = this.price;
    data['game_id'] = this.gameId;
    data['attributes'] = this.attributes;
    data['delivery_speed_id'] = this.deliverySpeedId;
    data['email'] = this.email;
    data['password'] = this.password;
    data['images'] = this.post_image;
    return data;
  }
}
