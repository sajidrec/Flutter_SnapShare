class NotificationModel {
  String? photoUrl;
  String? notificationMessage;
  String? name;

  NotificationModel({this.photoUrl, this.notificationMessage, this.name});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    photoUrl = json['photoUrl'];
    notificationMessage = json['notificationMessage'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['photoUrl'] = photoUrl;
    data['notificationMessage'] = notificationMessage;
    data['name'] = name;
    return data;
  }
}
