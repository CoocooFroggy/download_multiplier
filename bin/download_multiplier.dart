import 'dart:io';

import 'package:download_multiplier/download_multiplier.dart';

void main(List<String> arguments) {
  superDownload(Platform.environment['URL']!, 4);
}
