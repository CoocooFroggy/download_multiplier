/// This is data we'll scrape from the "HEAD" request to use later
class PreData {
  final String filename;
  final int contentLength;

  PreData({required this.filename, required this.contentLength});
}
