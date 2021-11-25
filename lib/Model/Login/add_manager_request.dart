class AddManagerRequest {
  List<RolesManager> managers;

  AddManagerRequest({
    this.managers,
  });

  AddManagerRequest.fromJson(Map<String, dynamic> json) {
    if (json['managers'] != null) {
      managers = new List<RolesManager>();
      json['managers'].forEach((v) {
        managers.add(new RolesManager.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.managers != null) {
      data['managers'] = this.managers.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class RolesManager {
  String type;
  int id;

  RolesManager({this.type, this.id});

  RolesManager.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['id'] = this.id;
    return data;
  }
}
