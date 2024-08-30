class MessageInfoModel {
  MessageInfoModel({
    String? messageText,
    int? messageSentTime,
    String? senderName,
  }) {
    _messageText = messageText;
    _messageSentTime = messageSentTime;
    _senderName = senderName;
  }

  MessageInfoModel.fromJson(dynamic json) {
    _messageText = json['messageText'];
    _messageSentTime = json['messageSentTime'];
    _senderName = json['senderName'];
  }

  String? _messageText;
  int? _messageSentTime;
  String? _senderName;

  MessageInfoModel copyWith({
    String? messageText,
    int? messageSentTime,
    String? senderName,
  }) =>
      MessageInfoModel(
        messageText: messageText ?? _messageText,
        messageSentTime: messageSentTime ?? _messageSentTime,
        senderName: senderName ?? _senderName,
      );

  String? get messageText => _messageText;

  int? get messageSentTime => _messageSentTime;

  String? get senderName => _senderName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['messageText'] = _messageText;
    map['messageSentTime'] = _messageSentTime;
    map['senderName'] = _senderName;
    return map;
  }
}
