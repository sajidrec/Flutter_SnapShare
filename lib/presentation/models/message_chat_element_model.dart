class MessageChatElementModel {
  MessageChatElementModel({
    String? userPhoto,
    String? username,
    String? userFullName,
  }) {
    _userPhoto = userPhoto;
    _username = username;
    _userFullName = userFullName;
  }

  MessageChatElementModel.fromJson(dynamic json) {
    _userPhoto = json['userPhoto'];
    _username = json['username'];
    _userFullName = json['userFullName'];
  }

  String? _userPhoto;
  String? _username;
  String? _userFullName;

  MessageChatElementModel copyWith({
    String? userPhoto,
    String? username,
    String? userFullName,
  }) =>
      MessageChatElementModel(
        userPhoto: userPhoto ?? _userPhoto,
        username: username ?? _username,
        userFullName: userFullName ?? _userFullName,
      );

  String? get userPhoto => _userPhoto;

  String? get username => _username;

  String? get userFullName => _userFullName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userPhoto'] = _userPhoto;
    map['username'] = _username;
    map['userFullName'] = _userFullName;
    return map;
  }
}
