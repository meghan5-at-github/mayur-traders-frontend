import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'api_urls.dart';

class ApiService {
  static Future<bool> checkNetwork() async {
    dynamic result, condition;
    print("checkNetwork >>>>>");
    try {
      (kIsWeb)
          ? result = true
          : result = await InternetAddress.lookup('example.com',
              type: InternetAddressType.any);
      print("kisWeb $kIsWeb");

      condition = (kIsWeb)
          ? true
          : result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      print("condition  $condition");
      return condition;
    } catch (e) {
      //Fluttertoast.showToast(msg: e.toString());
    }
    return false;
  }

  static Uri buildUrl(String urlString) {
    print("url====>   ${urlString}");
    return Uri.parse(urlString);
    /*  if (method == "put") {
      print("url put ====>   $urlString/${ApiUrls.userId}");
      return Uri.parse("$urlString/${ApiUrls.userId}");
    } else {
      print("url====>   ${urlString}");
      return Uri.parse(urlString);
    }*/
  }

  static Future<String> postMethod(dynamic request, String url) async {
    print("profileToken :: ${ApiUrls.profileToken}");
    try {
      if (await checkNetwork()) {
        print("request post $request \n url :: $url");
        var response =
            await http.post(buildUrl(url), body: request, headers: headers());
        print('response.statusCode ${response.body}');
        print('response.statusCode ${response.statusCode}');
        switch (response.statusCode) {
          case 200:
            ApiUrls.loaderOnBtn = false;
            return response.body;
          case 201:
            ApiUrls.loaderOnBtn = false;
            return response.body;
          case 400:
            ApiUrls.loaderOnBtn = false;
            return response.body;
          default:
            ApiUrls.loaderOnBtn = false;
            throw Exception(response.reasonPhrase);
        }
      } else {
        ApiUrls.loaderOnBtn = false;
        throw Exception("No internet");
      }
    } on SocketException catch (_) {
      ApiUrls.loaderOnBtn = false;
      rethrow;
    }
  }

  static Future<String> putMethod(dynamic request, String url) async {
    print("ApiUrls.profileToken  putMethod ${ApiUrls.profileToken}");
    ApiUrls.loaderOnBtn = true;
    try {
      if (await checkNetwork()) {
        print("request put $request");
        var response =
            await http.put(buildUrl(url), body: request, headers: headers());

        print(
            "response ${response.statusCode}  : response body :: ${response.body}");
        switch (response.statusCode) {
          case 200:
            ApiUrls.loaderOnBtn = false;
            return response.body;
          case 201:
            ApiUrls.loaderOnBtn = false;
            return response.body;
          case 500:
            ApiUrls.loaderOnBtn = false;
            return response.body;
          default:
            ApiUrls.loaderOnBtn = false;
            throw Exception(response.reasonPhrase);
        }
      } else {
        ApiUrls.loaderOnBtn = false;
        throw Exception("No internet");
      }
    } on SocketException catch (_) {
      ApiUrls.loaderOnBtn = false;
      rethrow;
    }
  }

  static Future<String> getMethod(String url) async {
    print("token :: ${ApiUrls.profileToken}");
    ApiUrls.loaderOnBtn = true;
    try {
      if (await checkNetwork()) {
        print("http.get :: ${http.get}");
        var response = await http.get(buildUrl(url), headers: headers());
        print("response :: $response");
        print("response :: ${response.statusCode}");
        switch (response.statusCode) {
          case 200:
            ApiUrls.loaderOnBtn = false;
            print("response.body : ${response.body}");
            return response.body;
          case 201:
            ApiUrls.loaderOnBtn = false;
            print("response.body : ${response.body}");
            return response.body;
          default:
            ApiUrls.loaderOnBtn = false;
            throw Exception(response.reasonPhrase);
        }
      } else {
        print("Exception  :: ");
        ApiUrls.loaderOnBtn = false;
        throw Exception("No internet");
      }
    } on SocketException catch (_) {
      print("socketException :: ");
      ApiUrls.loaderOnBtn = false;
      rethrow;
    }
  }

  static Map<String, String> headers() {
    return {
      "Content-Type": "application/json",
      "Access-Control-Allow-Origin": "*",
      "authorization": ApiUrls.profileToken
    };
  }

  static Future<String> uploadProfileImageAPi(requestFiles, uri) async {
    ApiUrls.loaderOnBtn = true;

    var request = http.MultipartRequest('PUT', buildUrl(uri));
    request.files.add(await http.MultipartFile.fromPath('file', requestFiles));
    print("image file : ${request.files}");
    print("image file 1st : ${request.files.first}");
    try {
      if (await checkNetwork()) {
        var response = await request.send();
        switch (response.statusCode) {
          case 200:
            ApiUrls.loaderOnBtn = false;
            var responseData = await response.stream.toBytes();
            var result = String.fromCharCodes(responseData);
            print(result);
            return result;
          case 201:
            ApiUrls.loaderOnBtn = false;
            var responseData = await response.stream.toBytes();
            var result = String.fromCharCodes(responseData);
            print(result);
            return result;
          default:
            ApiUrls.loaderOnBtn = false;
            throw Exception(response.reasonPhrase);
        }
      } else {
        ApiUrls.loaderOnBtn = false;
        throw Exception("No Internet!");
      }
    } on SocketException catch (_) {
      ApiUrls.loaderOnBtn = false;
      rethrow;
    }
  }

  static Future<String> uploadImageAPi(requestFields, requestFiles, uri) async {
    ApiUrls.loaderOnBtn = true;
    var request = http.MultipartRequest('POST', buildUrl(uri));
    request.fields.addAll(requestFields);
    if (requestFiles.length != 0) {
      for (var i = 0; i < requestFiles.length; i++) {
        request.files.add(requestFiles[i]);
      }
    }
    try {
      if (await checkNetwork()) {
        var response = await request.send();
        switch (response.statusCode) {
          case 200:
            ApiUrls.loaderOnBtn = false;
            var responseData = await response.stream.toBytes();
            var result = String.fromCharCodes(responseData);
            return result;
          case 201:
            ApiUrls.loaderOnBtn = false;
            var responseData = await response.stream.toBytes();
            var result = String.fromCharCodes(responseData);
            return result;
          default:
            ApiUrls.loaderOnBtn = false;
            throw Exception(response.reasonPhrase);
        }
      } else {
        ApiUrls.loaderOnBtn = false;
        throw Exception("No Internet!");
      }
    } on SocketException catch (_) {
      ApiUrls.loaderOnBtn = false;
      rethrow;
    }
  }

  static Future<String> deleteMethod(String url) async {
    try {
      if (await checkNetwork()) {
        final response = await http.delete(buildUrl(url), headers: headers());
        print("response :: $response");
        print("response :: ${response.statusCode}");
        switch (response.statusCode) {
          case 200:
            ApiUrls.loaderOnBtn = false;
            print("response.body : ${response.body}");
            return response.body;
          case 201:
            ApiUrls.loaderOnBtn = false;
            print("response.body : ${response.body}");
            return response.body;
          default:
            ApiUrls.loaderOnBtn = false;
            throw Exception(response.reasonPhrase);
        }
      } else {
        print("Exception  :: ");
        ApiUrls.loaderOnBtn = false;
        throw Exception("No internet");
      }
    } on SocketException catch (_) {
      print("socketException :: ");
      ApiUrls.loaderOnBtn = false;
      rethrow;
    }
  }
}
