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
      return Future.value(image);
    } catch (ex) {
      if (ex is PlatformException) {
        if (ex.code == "photo_access_denied" ||
            ex.code == "camera_access_denied") {
          _showPermissionRequired(context: context, content: ex.code == "photo_access_denied"
              ? "Se requiere permiso para acceder a sus fotos"
              : "Se requiere permiso para acceder a la cámara");
          return null;
        }
      }
      return null;
    }
  }

  static void _showPermissionRequired({BuildContext context, String content}) {
    showCupertinoDialog<String>(
      context: context,
      builder: (BuildContext context) => TXCupertinoDialogWidget(
        title: "Permisio requerido",
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
