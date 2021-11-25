class SendInviteRequest {
  RoleCall roleCall;
  String message;

  SendInviteRequest({this.roleCall, this.message});

  SendInviteRequest.fromJson(Map<String, dynamic> json) {
    roleCall = json['role_call'] != null
        ? new RoleCall.fromJson(json['role_call'])
        : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.roleCall != null) {
      data['role_call'] = this.roleCall.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class RoleCall {
  String type;
  int id;

  RoleCall({this.type, this.id});

  RoleCall.fromJson(Map<String, dynamic> json) {
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
