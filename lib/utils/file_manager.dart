import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_blur_dialog.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_cupertino_dialog_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'calendar_utils.dart';

class FileManager {
  static Future<File> getImageFromSource(
      BuildContext context, ImageSource source) async {
    try {
      final File image = await ImagePicker.pickImage(source: source);

      if (image == null) {
        if (source == ImageSource.gallery &&
            !await Permission.storage.isGranted) {
          _showPermissionRequired(
              context: context, content: R.string.galleryPermissionContent);
        } else if (source == ImageSource.camera &&
            !await Permission.camera.isGranted) {
          _showPermissionRequired(
              context: context, content: R.string.cameraPermissionContent);
        }
        return image;
      }
      String fileName = "${CalendarUtils.getTimeIdBasedSeconds()}.png";
      String rootDir = await getRootFilesDir();
      File file = await image.copy("$rootDir/$fileName");

      return Future.value(file);
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

  static _showWarningDialog(
    BuildContext context, {
    String title,
    String content,
    ValueChanged<bool> okAction,
  }) {
    return showBlurDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: R.color.dialog_background,
            title: TXTextWidget(
              text: title,
              maxLines: 2,
              textAlign: TextAlign.start,
              fontWeight: FontWeight.bold,
            ),
            content: TXTextWidget(
              text: content,
              textAlign: TextAlign.start,
              color: R.color.gray_dark,
              textOverflow: TextOverflow.visible,
            ),
            actions: <Widget>[
              FlatButton(
                child: TXTextWidget(
                  text: R.string.ok,
                  fontWeight: FontWeight.bold,
                  color: R.color.primary_color,
                ),
                onPressed: () {
                  okAction(true);
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: TXTextWidget(
                  text: R.string.cancel,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
