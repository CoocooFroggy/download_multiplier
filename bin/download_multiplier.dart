import 'dart:io';

import 'package:download_multiplier/download_multiplier.dart';

void main(List<String> arguments) {
  const numberOfChunks = 2;

  List<String> urls = [];
  for (int i = 1; i <= numberOfChunks; i++) {
    urls.add(Platform.environment['URL_$i']!);
  }
  superDownload(urls, numberOfChunks);
}
