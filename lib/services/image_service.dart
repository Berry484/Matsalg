import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mat_salg/my_ip.dart';
import 'dart:async'; // Import this to use Future and TimeoutException
import 'package:mat_salg/helper_components/flutter_flow/flutter_flow_util.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mat_salg/logging.dart';

class ApiMultiplePics {
  static const String baseUrl = ApiConstants.baseUrl; // Your base URL

//---------------------------------------------------------------------------------------------------------------
//--------------------Uploads multiple pictures at the same time to the backend using a multipart request--------
//---------------------------------------------------------------------------------------------------------------
  Future<List<String>?> uploadPictures({
    required String? token,
    required List<Uint8List?> filesData, // Accept a list of Uint8List
    String fileType = 'jpeg',
  }) async {
    try {
      // Check if filesData is empty
      if (filesData.isEmpty) {
        logger.e('Filedata is empty');
        return null;
      }

      // Create a multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/files/rrh/flere_bilder'),
      );

      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      // Iterate over each file and add it to the request under the key "files"
      for (int i = 0; i < filesData.length; i++) {
        if (filesData[i] != null) {
          request.files.add(
            http.MultipartFile.fromBytes(
              'files',
              filesData[i]!,
              contentType: MediaType('image', fileType),
              filename:
                  'file_$i.$fileType', // Create a unique filename for each file
            ),
          );
        } else {}
      }

      // Send the request and wait for the response
      var response = await request.send();

      var responseString = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        List<dynamic> responseJson = jsonDecode(responseString.body);

        List<String> fileLinks = responseJson.map((file) {
          return file['fileLink'] as String;
        }).toList();
        return fileLinks;
      } else {
        logger.e('Error getting the filelinks or something else');
        return null;
      }
    } on SocketException {
      throw const SocketException('');
    } catch (e) {
      throw Exception;
    }
  }
}
