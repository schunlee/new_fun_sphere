import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:install_plugin/install_plugin.dart';
import 'package:path_provider/path_provider.dart';

Future<void> installAPK(String url, String filename) async {
  var dir = (await getApplicationDocumentsDirectory()).path;
  var _progressValue = 0.0;
  String savePath = "$dir/$filename";
  try {
    await Dio().download(
      url,
      savePath,
      onReceiveProgress: (count, total) {
        final value = count / total;
        debugPrint('count >> $count');
        debugPrint('value >> $value');
        if (_progressValue != value) {
          debugPrint((_progressValue * 100).toStringAsFixed(0) + "%");
        }
      },
    );
  } catch (e) {
    debugPrint(e.toString());
  }

  try {
    final result = await InstallPlugin.install(savePath);
    debugPrint('OpenFilex result: ${result.message}');
  } catch (e) {
    debugPrint('Error opening file: $e');
  }
}

Future<File> downloadFile(String url, String filename) async {
  var dir = (await getApplicationDocumentsDirectory()).path;

  var req = await http.Client().get(Uri.parse(url));
  var file = File('$dir/$filename');
  return file.writeAsBytes(req.bodyBytes);
}

Future<bool> _hasToDownloadFile(String filename, String dir) async {
  var file = File('$dir/$filename');
  return !(await file.exists());
}

String getFileName(String url) {
  int lastSlashIndex = url.lastIndexOf('/');
  String fileName =
      lastSlashIndex != -1 ? url.substring(lastSlashIndex + 1) : url;
  return fileName;
}

