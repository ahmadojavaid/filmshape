class GameSearchListRequest {
  String search;
  List<int> categoriesId;
  double minPrice;
  double maxPrice;

  GameSearchListRequest(
      {this.search, this.categoriesId, this.minPrice, this.maxPrice});

  GameSearchListRequest.fromJson(Map<String, dynamic> json) {
    search = json['search'];
    categoriesId = json['categories_id'].cast<int>();
    minPrice = json['min_price'];
    maxPrice = json['max_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['search'] = this.search;
    data['categories_id'] = this.categoriesId;
    data['min_price'] = this.minPrice;
    data['max_price'] = this.maxPrice;
    return data;
  }
}
