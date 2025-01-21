import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:mat_salg/my_ip.dart';
import 'dart:async'; // Import this to use Future and TimeoutException
import 'package:mat_salg/helper_components/flutter_flow/flutter_flow_util.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mat_salg/logging.dart';
import 'package:image/image.dart' as img;

class ApiMultiplePics {
  static const String baseUrl = ApiConstants.baseUrl;

//---------------------------------------------------------------------------------------------------------------
//--------------------Uploads multiple pictures at the same time to the backend using a multipart request--------
//---------------------------------------------------------------------------------------------------------------
  Future<List<String>?> uploadPictures({
    required String? token,
    required List<Uint8List?> filesData,
    String fileType = 'jpeg',
  }) async {
    try {
      if (filesData.isEmpty) {
        logger.e('Filedata is empty');
        return null;
      }

      // Compress images in parallel using isolates
      List<Uint8List?> compressedFiles = await Future.wait(
        filesData.map((fileData) async {
          if (fileData != null) {
            return await compute(compressImage, fileData);
          }
          return null;
        }).toList(),
      );

      // Create a multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/files/rrh/flere_bilder'),
      );

      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      // Add compressed files to the request
      for (int i = 0; i < compressedFiles.length; i++) {
        if (compressedFiles[i] != null) {
          request.files.add(
            http.MultipartFile.fromBytes(
              'files',
              compressedFiles[i]!,
              contentType: MediaType('image', fileType),
              filename: 'file_$i.$fileType',
            ),
          );
        }
      }

      // Send the request
      var response = await request.send();
      var responseString = await http.Response.fromStream(response);
      logger.d('Uploaded images ${response.statusCode}');
      if (response.statusCode == 200) {
        List<dynamic> responseJson = jsonDecode(responseString.body);
        List<String> fileLinks = responseJson.map((file) {
          return file['fileLink'] as String;
        }).toList();
        return fileLinks;
      } else {
        logger.e(
            'Error getting the filelinks or something else: ${response.statusCode}');
        return null;
      }
    } on SocketException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

// Function to compress an image (runs in a separate isolate)
  Uint8List? compressImage(Uint8List fileData) {
    final img.Image? originalImage = img.decodeImage(fileData);
    if (originalImage != null) {
      // Compress the image without resizing
      return Uint8List.fromList(img.encodeJpg(originalImage, quality: 85));
    }
    return null;
  }

//
}
