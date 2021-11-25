class DataModelFilter {
  String projectType;
  String projectGenre;
  String created;

  DataModelFilter({this.projectType, this.projectGenre, this.created});

  DataModelFilter.fromJson(Map<String, dynamic> json) {
    projectType = json['projectType'];
    projectGenre = json['projectGenre'];
    created = json['created__icontains'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['projectType'] = this.projectType;
    data['projectGenre'] = this.projectGenre;
    data['created__icontains'] = this.created;
    return data;
  }
}
