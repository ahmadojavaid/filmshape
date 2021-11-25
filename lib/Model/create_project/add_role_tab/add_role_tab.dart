class AddRoleTabResponse {
  String type;
  int id;

  AddRoleTabResponse(
      {this.type,
      this.id,
     });

  AddRoleTabResponse.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if(this.type!=null)
    data['type'] = this.type;
    if(this.id!=null)
    data['id'] = this.id;

    return data;
  }
}

