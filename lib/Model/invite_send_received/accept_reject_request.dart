class AcceptRejectInvitation {
  bool accepted;
  bool declined;
  bool revoked;

  AcceptRejectInvitation({this.accepted, this.declined, this.revoked});

  AcceptRejectInvitation.fromJson(Map<String, dynamic> json) {
    accepted = json['accepted'];
    declined = json['declined'];
    declined = json['revoked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['accepted'] = this.accepted;
    data['declined'] = this.declined;
    data['revoked'] = this.revoked;
    return data;
  }
}
