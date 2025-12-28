import 'package:path_provider/path_provider.dart';

abstract class GetPath {
  static Future<String> getPathForAudio() async {
    final dir = await getApplicationDocumentsDirectory();
    final filePath = '${dir.path}/${DateTime.now().millisecond}.m4a';
    return filePath;
  }
}
