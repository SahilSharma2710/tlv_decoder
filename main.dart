import 'dart:typed_data';

import 'tlv_parser.dart';

void main() {
  Uint8List encodedData = Uint8List.fromList([
    /* */
    0x01, // data of type 0x01 represents CardHolder's Name
    0x09, // length of data is 9 means there will be 9 byte of data
    // 9 bytes of data type 0x01
    0x47, 0x65, 0x65, 0x6b, 0x79, 0x41, 0x6e, 0x74, 0x73, // GeekyAnts
    /* */
    0x02, // data of type 0x02 represents Card Number
    0x0c, // length of data is 12 means there will be 12 byte of data\``
    // 12 bytes of data type 0x02
    0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x01, 0x02, 0x03
    // 123456789123
  ]);

  final parsedTLV = TLVParser.parse(encodedData);

  for (TLV tlv in parsedTLV) {
    switch (tlv.tag) {
      case 0x01:
        var cardholderName = String.fromCharCodes(tlv.value);
        print("Cardholder's name: $cardholderName");
        break;
      case 0x02:
        var cardNumber = int.parse(tlv.value.join(''));
        print("Card number: $cardNumber");
        break;
    }
  }
}
