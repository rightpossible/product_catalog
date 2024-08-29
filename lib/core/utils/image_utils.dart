import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class ImageUtils {
  static Future<String> downloadAndSaveImage(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));
    final documentDirectory = await getApplicationDocumentsDirectory();
    final fileName = imageUrl.split('/').last;
    final filePath = '${documentDirectory.path}/$fileName';
    
    File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    
    return filePath;
  }
}