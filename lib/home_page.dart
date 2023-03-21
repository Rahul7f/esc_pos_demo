
import 'dart:typed_data';

import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:flutter/services.dart';
import 'package:flutter_usb_printer/flutter_usb_printer.dart';
import 'package:image/src/image.dart';
// import 'dart:io';
// import 'package:image/image.dart' as img;
import 'package:image/image.dart' as img; // add a prefix to the image package



class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> devices = [];
  FlutterUsbPrinter flutterUsbPrinter = FlutterUsbPrinter();
  bool connected = false;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: ElevatedButton(onPressed: () async {
          const PaperSize paper = PaperSize.mm80;
          final profile = await CapabilityProfile.load();
          final printer = NetworkPrinter(paper, profile);

          final PosPrintResult res = await printer.connect('192.168.1.251', port: 9100);
          if (res == PosPrintResult.success) {
            testReceipt(printer);
            printer.disconnect();
          }
          print('Print result: ${res.msg}');

        }, child: const Text("Print")),
      ),
    );
  }

}

Future<void> testReceipt(NetworkPrinter printer) async {
  printer.text("text");
  // final ByteData data = await rootBundle.load('images/delete.png');
  // final Uint8List bytes = data.buffer.asUint8List();
  // final img.Image? image = img.decodeImage(bytes);
  // final img.Image resizedImage = img.copyResize(image!, width: image.width ~/ 2, height: image.height ~/ 2);
  // printer.image(resizedImage);
  printer.feed(2);
  printer.cut();
}
