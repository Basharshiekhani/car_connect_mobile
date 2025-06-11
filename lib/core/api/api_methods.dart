import 'dart:io';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:path/path.dart';

import '../storage/shared/shared_pref.dart';

class HttpMethods {
  Map<String, String> get _headers => {
    "Accept": "application/json",
    "Content-Type": "application/json",
    if (AppSharedPreferences.getToken().isNotEmpty)
      "Authorization": "Bearer ${AppSharedPreferences.getToken()}",
  };

  postMethod(String url, var body) async {
    try {
      print("Making POST request to: $url");
      print("Request body: $body");
      
      http.Response response = await http.post(
        Uri.parse(url),
        body: jsonEncode(body),
        headers: _headers,
      );
      
      print("Response status code: ${response.statusCode}");
      print("Response body: ${response.body}");
      
      return response;
    } catch (e) {
      print("Error in postMethod: $e");
      rethrow;
    }
  }

  getMethod(String url, Map<String, dynamic>? params) async {
    try {
      if (params != null && params.isNotEmpty) {
        Uri uri = Uri.parse(url).replace(queryParameters: params);
        url = uri.toString();
      }

      print("Making GET request to: $url");
      http.Response response = await http.get(
        Uri.parse(url),
        headers: _headers,
      );
      
      print("Response status code: ${response.statusCode}");
      print("Response body: ${response.body}");
      
      return response;
    } catch (e) {
      print("Error in getMethod: $e");
      rethrow;
    }
  }

  postWithMultiFile(
      String url, Map data, List<File> files, List<String> names) async {
    try {
      print("Making multipart POST request to: $url");
      print("Request data: $data");
      print("Files: $files");
      print("File names: $names");
      
      var multipartrequest = http.MultipartRequest('POST', Uri.parse(url));
      
      // Add headers
      multipartrequest.headers.addAll({
        "Accept": "application/json",
        if (AppSharedPreferences.getToken().isNotEmpty)
          "Authorization": "Bearer ${AppSharedPreferences.getToken()}",
      });

      for (int i = 0; i < files.length; i++) {
        var length = await files[i].length();
        var stream = http.ByteStream(files[i].openRead());
        var multipartfile = http.MultipartFile(names[i], stream, length,
            filename: basename(files[i].path));
        multipartrequest.files.add(multipartfile);
      }
      
      data.forEach((key, value) {
        multipartrequest.fields[key] = value.toString();
      });

      http.StreamedResponse sresponce = await multipartrequest.send();
      http.Response response = await http.Response.fromStream(sresponce);
      
      print("Response status code: ${response.statusCode}");
      print("Response body: ${response.body}");
      
      return response;
    } catch (e) {
      print("Error in postWithMultiFile: $e");
      rethrow;
    }
  }
}
  