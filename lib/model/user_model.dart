// @dart=2.9
class User_Model {
  String firestName;
  String lastName;
  String phone;
  String uid;

  User_Model({this.firestName, this.lastName, this.phone, this.uid});

  User_Model.fromJson(Map<String, dynamic> json) {
    firestName = json['firstName'];
    lastName = json['lastName'];
    phone = json['phone'];
    //  uid = json['uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstname'] = this.firestName;
    data['lastname'] = this.lastName;
    data['phone'] = this.phone;
    //  data['uid'] = this.uid;
    return data;
  }
}
