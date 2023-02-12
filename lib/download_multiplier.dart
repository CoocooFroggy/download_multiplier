import 'dart:io';

import 'package:download_multiplier/objects/pre_data.dart';

Future<void> superDownload(List<String> urls, int chunks) async {
  final preData = await fetchPreData(urls[0]);

  List<String> rangeHeaders = [];
  final chunkLength = preData.contentLength ~/ chunks;
  int currentBound = 0;
  // Divide the file into x "chunks"
  for (int i = 1; i <= chunks; i++) {
    // If last iteration
    if (i == chunks) {
      rangeHeaders.add('bytes=$currentBound-${preData.contentLength}');
      continue;
    }
    rangeHeaders.add('bytes=$currentBound-${i * chunkLength}');
    currentBound = i * chunkLength;
  }
  print(rangeHeaders);

  List<Future<File>> futures = [];
  for (int i = 0; i < chunks; i++) {
    final url = urls[i];
    futures.add(downloadChunk(url, preData, i, rangeHeaders[i]));
  }
  // Wait for them all to finish downloading
  final files = await Future.wait(futures);
  // Concatenate into one file
  for (var file in files) {
    await file.openRead().pipe(File(preData.filename).openWrite());
  }
  print('Done!');
}

Future<File> downloadChunk(String url,
    PreData preData,
    int currentChunk,
    String rangeHeader,) async {
  final uri = Uri.parse(url);
  final request = await HttpClient().getUrl(uri);

  request.headers.add('range', rangeHeader);

  final response = await request.close();

  int current = 0;
  final total = response.contentLength;

  final file = File('${preData.filename}.$currentChunk');

  // Basically response.listen but synchronous
  await for (List<int> bytes in response) {
    current += bytes.length;
    print('[$currentChunk] $current / $total');
    file.writeAsBytesSync(bytes, mode: FileMode.append);
  }

  return file;
}

Future<PreData> fetchPreData(String url) async {
  final uri = Uri.parse(url);
  // I would use a head request, but many sites don't have it implemented
  final request = await HttpClient().getUrl(uri);
  final response = await request.close();

  String filename;
  final cdHeader = response.headers['content-disposition'];
  filename = uri.pathSegments.last;
  if (cdHeader != null) {
    final match = RegExp(r'filename="(.*?)"').firstMatch(cdHeader.first);
    if (match != null) {
      filename = match.group(1)!;
    }
  }

  return PreData(
      filename: filename, contentLength: response.headers.contentLength);
}
