/// uid : 1179
/// name : "Gupta"
/// number : 4545454555
/// date : "2020-02-24T20:52:02Z"

class StudDetails {
  StudDetails({
    this.name,
    this.number,
    this.date,
  });

  StudDetails.fromJson(String mId, dynamic json) {
    print(">>>>> $mId");
    uid = mId;
    name = json['name'];
    number = json['number'];
    date = json['date'];
  }
  String? uid;
  String? name;
  String? number;
  String? date;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['number'] = number;
    map['date'] = date;
    return map;
  }
}
