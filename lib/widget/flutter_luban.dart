import 'dart:io';

import 'dart:async';
import 'dart:isolate';

import 'package:flutter/foundation.dart';

class Luban {
  Luban._();

  static Future<String> compressImage(CompressObject object) async {
    return compute(_lubanCompress, object);
  }

  static Future<dynamic> compressImageQueue(CompressObject object) async {
    final response = ReceivePort();
    await Isolate.spawn(_lubanCompressQueue, response.sendPort);
    final sendPort = await response.first;
    final answer = ReceivePort();
    sendPort.send([answer.sendPort, object]);
    return answer.first;
  }

  static Future<List<String>> compressImageList(
      List<CompressObject> objects) async {
    return compute(_lubanCompressList as ComputeCallback<List<CompressObject>, List<String>>, objects);
  }

  static void _lubanCompressQueue(SendPort port) {
    final rPort = ReceivePort();
    port.send(rPort.sendPort);
    rPort.listen((message) {
      final send = message[0] as SendPort;
      final object = message[1] as CompressObject;
      send.send(_lubanCompress(object));
    });
  }

  static List _lubanCompressList(List<CompressObject> objects) {
    var results = [];
    objects.forEach((_o) {
      results.add(_lubanCompress(_o));
    });
    return results;
  }

  static String _lubanCompress(CompressObject object) {
    return object.imageFile!.path;
  }
}

enum CompressMode {
  SMALL2LARGE,
  LARGE2SMALL,
  AUTO,
}

class CompressObject {
  final File? imageFile;
  final String? path;
  final CompressMode mode;
  final int quality;
  final int step;

  ///If you are not sure whether the image detail property is correct, set true, otherwise the compressed ratio may be incorrect
  final bool autoRatio;

  CompressObject({
    this.imageFile,
    this.path,
    this.mode: CompressMode.AUTO,
    this.quality: 80,
    this.step: 6,
    this.autoRatio = true,
  });
}
