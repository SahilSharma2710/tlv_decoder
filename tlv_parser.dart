import 'dart:typed_data';

class TLVParser {
  static List<TLV> parse(Uint8List tlv) {
    final tlvList = <TLV>[];
    getTLVList(tlv, tlvList);
    return tlvList;
  }

  static void getTLVList(Uint8List data, List<TLV> tlvList) {
    var index = 0;

    while (index < data.length) {
      Uint8List tag;
      Uint8List length;
      Uint8List value;
      TLV? tlv;

      tag = Uint8List(1);
      tag[0] = data[index];
      ++index;

      length = Uint8List(1);
      length[0] = data[index];
      ++index;

      final n = getLengthInt(length);

      value = Uint8List.sublistView(data, index, index + n);
      index += value.length;

      tlv = TLV();
      tlv.tag = tag[0];
      tlv.length = toHexString(length);
      tlv.value = value;
      tlvList.add(tlv);
    }
  }

  static int getLengthInt(Uint8List data) {
    if ((data[0] & 0x80) == 0x80) {
      final n = data[0] & 0x7F;
      var length = 0;
      for (var i = 1; i < n + 1; ++i) {
        length <<= 8;
        length |= (data[i] & 0xFF);
      }
      return length;
    } else {
      return data[0] & 0xFF;
    }
  }
}

String toHexString(Uint8List data) {
  return data.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
}

class TLV {
  late int tag;
  late String length;
  late Uint8List value;

  @override
  String toString() {
    return 'Tag: $tag, Length: $length, Value: $value';
  }
}
