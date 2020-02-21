import 'dart:io';

import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'calendar_utils.dart';

class FileManager {
  static Future<File> getImageFromSource(ImageSource source,
      {fromTempDir = false}) async {
    final File image = await ImagePicker.pickImage(source: source);
    if (image == null) return null;
//    final directory = await getApplicationDocumentsDirectory();
//    Directory tempDir = await getTemporaryDirectory();
    Directory appDocDir = Platform.isIOS
        ? await getApplicationSupportDirectory()
        : await getExternalStorageDirectory();
    final File newImage = await image
        .copy('${appDocDir.path}/${CalendarUtils.getTimeIdBasedSeconds()}.png');
    return newImage;
  }

  static Future<File> getLocalFileFromAsset(String fileName, String assetPath) async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File tempFile = File('$tempPath/$fileName');
    ByteData bd = await rootBundle.load('$assetPath/$fileName');
    await tempFile.writeAsBytes(bd.buffer.asUint8List(), flush: true);
    return tempFile;
  }
}
