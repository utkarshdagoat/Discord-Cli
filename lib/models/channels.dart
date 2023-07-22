enum channelType { text, voice, announcement }

class Channel {
  late int id;
  late String channelName;
  late channelType channeltype;

  Channel(int id, String cN, String cT) {
    this.id = id;
    channelName = cN;
    channeltype =
        channelType.values.firstWhere((element) => element.toString() == cT);
  }

  static Channel fromList(List<dynamic> list) =>
      Channel(list[0], list[1], list[2]);
}
