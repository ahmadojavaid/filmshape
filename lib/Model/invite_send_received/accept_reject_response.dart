class AcceptRejectInvitationResponse {
  bool accepted;
  bool declined;
  int id;

  AcceptRejectInvitationResponse({this.accepted, this.declined, this.id});

  AcceptRejectInvitationResponse.fromJson(Map<String, dynamic> json) {
    accepted = json['accepted'];
    declined = json['declined'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['accepted'] = this.accepted;
    data['declined'] = this.declined;
    data['id'] = this.id;
    return data;
  }
}

