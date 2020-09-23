import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_cupertino_dialog_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'calendar_utils.dart';

class FileManager {
  static Future<File> getImageFromSource(
      BuildContext context, ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.getImage(source: source);

      if (pickedFile.path?.isNotEmpty == true) {
        return File(pickedFile.path);
      }
      return null;
    } catch (ex) {
      if (ex is PlatformException) {
        if (ex.code == "photo_access_denied" ||
            ex.code == "camera_access_denied") {
          _showPermissionRequired(
              context: context,
              content: ex.code == "photo_access_denied"
                  ? R.string.galleryPermissionContent
                  : R.string.cameraPermissionContent);
          return null;
        }
      }
      return null;
    }
  }

  static Future<bool> deleteFile(String filePath) async {
    try {
      String rootDir = await getRootFilesDir();
      File f = File(filePath);
      if (f.existsSync()) f.deleteSync();
      return true;
    } catch (ex) {
      return false;
    }
  }

  static Future<String> getRootFilesDir() async {
    try {
      Directory appDocDir = Platform.isIOS
          ? await getApplicationDocumentsDirectory()
          : await getExternalStorageDirectory();
      return appDocDir.path;
    } catch (ex) {
      return '';
    }
  }

  static Future<Directory> getRootFilesDirectory() async {
    Directory appDocDir = Platform.isIOS
        ? await getApplicationDocumentsDirectory()
        : await getExternalStorageDirectory();
    return appDocDir;
  }

  static Future<File> compressAndGetFile(File file, String targetPath) async {
    final newFile = File(targetPath);
    if(await newFile.exists()){
      await newFile.delete();
    }
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path, targetPath,
      quality: 80,
    );
    return result;
  }

  static Future<void> retrieveLostData() async {
    final LostDataResponse response = await ImagePicker.retrieveLostData();
    if (response == null) {
      return;
    }
    if (response.file != null) {
//      setState(() {
//        if (response.type == RetrieveType.video) {
//          _handleVideo(response.file);
//        } else {
//          _handleImage(response.file);
//        }
//      });
    } else {
//      _handleError(response.exception);
    }
  }

  static void _showPermissionRequired({BuildContext context, String content}) {
    showCupertinoDialog<String>(
      context: context,
      builder: (BuildContext context) => TXCupertinoDialogWidget(
        title: R.string.deniedPermissionTitle,
        content: content,
        onOK: () {
          Navigator.pop(context, R.string.logout);
          openAppSettings();
        },
        onCancel: () {
          Navigator.pop(context, R.string.cancel);
        },
      ),
    );
  }

  static Future<File> getLocalFileFromAsset(
      String fileName, String assetPath) async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File tempFile = File('$tempPath/$fileName');
    ByteData bd = await rootBundle.load('$assetPath/$fileName');
    await tempFile.writeAsBytes(bd.buffer.asUint8List(), flush: true);
    return tempFile;
  }

//  static playVideo(String videoName) async {
//    Directory tempDir = await getTemporaryDirectory();
//    File tempFile = File('${tempDir.path}/$videoName');
//    final filePath = 'lib/res/assets/$videoName';
//    ByteData bd = await rootBundle.load(filePath);
//    await tempFile.writeAsBytes(bd.buffer.asUint8List(), flush: true);
//    OpenFile.open(tempFile.path);
//  }
}
