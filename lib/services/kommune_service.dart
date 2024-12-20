import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mat_salg/MyIP.dart';
import 'dart:async';

class KommuneService {
  static const String baseUrl = ApiConstants.baseUrl;

//---------------------------------------------------------------------------------------------------------------
//--------------------Gets the kommune of two cordinates using the geoNorge api----------------------------------
//---------------------------------------------------------------------------------------------------------------
  Future<String> getKommune(
      String? token, double brukerLat, double brukerLng) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await http
          .get(
            Uri.parse(
                'https://ws.geonorge.no/adresser/v1/punktsok?lat=$brukerLat&lon=$brukerLng&radius=9999999999999&treffPerSide=1&side=1'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 5)); // Set timeout to 5 seconds

      if (response.statusCode == 200) {
        // Parse the JSON response
        final jsonResponse = json.decode(response.body);

        // Extract the first "adresser" element and get the "kommunenavn"
        final kommunenavn = jsonResponse['adresser'][0]['poststed'];
        return kommunenavn ?? 'Norge';
      } else {
        return 'Norge';
      }
    } on SocketException {
      throw const SocketException('');
    } catch (e) {
      throw Exception;
    }
  }
}
