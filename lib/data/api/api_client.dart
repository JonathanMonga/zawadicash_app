import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart' as Foundation;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:http/http.dart' as Http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zawadicash_app/data/api/api_checker.dart';
import 'package:zawadicash_app/data/model/response/error_response.dart';
import 'package:zawadicash_app/util/app_constants.dart';

class ApiClient extends GetxService {
   String appBaseUrl = AppConstants.BASE_URL ;
  final SharedPreferences sharedPreferences;
  final String noInternetMessage = 'Connection to API server failed due to internet connection';
  final int timeoutInSeconds = 30;
  BaseDeviceInfo deiceInfo;
  final String uniqueId;
  String token;
  Map<String, String> _mainHeaders;

  ApiClient({
    @required this.appBaseUrl,
    @required this.sharedPreferences,
    @required this.deiceInfo,
    @required this.uniqueId,

  })
  {
    print(" token.............................................$token");

    _mainHeaders = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };

    if(('${deiceInfo.data['isPhysicalDevice']}' == 'true') || AppConstants.DEMO) {
      print('=========-----${deiceInfo.data.toString()}------=========');
      _mainHeaders.addAll({
        'device-id': uniqueId,
        'os': GetPlatform.isAndroid ? 'android' : 'ios',
        'device-model': '${deiceInfo.data['brand']} ${deiceInfo.data['model']}'
      });
    }
  }

   void updateHeader(String token) {
     _mainHeaders = {
       'Content-Type': 'application/json; charset=UTF-8',
       'Authorization': 'Bearer $token',
     };

     if(('${deiceInfo.data['isPhysicalDevice']}' == 'true') || AppConstants.DEMO) {
       _mainHeaders.addAll({
         'device-id': uniqueId,
         'os': GetPlatform.isAndroid ? 'android' : 'ios',
         'device-model': '${GetPlatform.isAndroid  ? '${deiceInfo.data['brand']} ${deiceInfo.data['device-model']}' : ''} ${deiceInfo.data['model']}'
       });
     }
   }



   Future<Response> getData(String uri, {Map<String, dynamic> query, Map<String, String> headers}) async {
    if(await ApiChecker.isVpnActive()) {
      return const Response(statusCode: -1, statusText: 'you are using vpn');
    }else{
      try {
        debugPrint('====> API Call: $uri\nHeader: $_mainHeaders');
        Http.Response response = await Http.get(
          Uri.parse(appBaseUrl+uri),
          headers: headers ?? _mainHeaders,
        ).timeout(Duration(seconds: timeoutInSeconds));
        return handleResponse(response, uri);
      } catch (e) {
        return Response(statusCode: 1, statusText: noInternetMessage);
      }

    }
   }

  Future<Response> postData(
      String uri, dynamic body, {Map<String, String> headers}) async {
    if(await ApiChecker.isVpnActive()) {
      return const Response(statusCode: -1, statusText: 'you are using vpn');
    }{
      try {
        if(Foundation.kDebugMode){
          print('====> GetX Base URL: $appBaseUrl');
          print('====> GetX Call: $uri');
          print('====> GetX Body: $body');
        }
        Http.Response response0 = await Http.post(
          Uri.parse(appBaseUrl+uri),
          body: jsonEncode(body),
          headers: headers ?? _mainHeaders,
        ).timeout(Duration(seconds: timeoutInSeconds));
        print("++++++++++++>>>=====");
        Response response = handleResponse(response0, uri);

        if(Foundation.kDebugMode) {
          print('====> API Response: [${response.statusCode}] $uri\n${response.body}');
        }
        return response;
      } catch (e) {
        return Response(statusCode: 1, statusText: noInternetMessage);
      }

    }
  }
   Future<Response> postMultipartData(String uri, Map<String, String> body, List<MultipartBody> multipartBody, {Map<String, String> headers}) async {

     if(await ApiChecker.isVpnActive()) {
       return const Response(statusCode: -1, statusText: 'you are using vpn');
     }{
       try {
         if(Foundation.kDebugMode) {
           print('====> API Call: $uri\nToken: $token');
           print('====> API Body: $body with ${multipartBody.length} image ');
         }
         Http.MultipartRequest request = Http.MultipartRequest('POST', Uri.parse(appBaseUrl+uri));
         request.headers.addAll(headers ?? _mainHeaders);
         for(MultipartBody multipart in multipartBody) {
           if(Foundation.kIsWeb) {
             Uint8List list = await multipart.file.readAsBytes();
             Http.MultipartFile part = Http.MultipartFile(
               multipart.key, multipart.file.readAsBytes().asStream(), list.length,
               filename: basename(multipart.file.path), contentType: MediaType('image', 'jpg'),
             );
             request.files.add(part);
           }else {
             File file = File(multipart.file.path);
             request.files.add(Http.MultipartFile(
               multipart.key, file.readAsBytes().asStream(), file.lengthSync(), filename: file.path.split('/').last,
             ));
           }
         }
         request.fields.addAll(body);
         Http.Response response0 = await Http.Response.fromStream(await request.send());
         Response response = handleResponse(response0, uri);
         if(Foundation.kDebugMode) {
           print('====> API Response: [${response.statusCode}] $uri\n${response.body}');
         }
         return response;
       } catch (e) {
         return Response(statusCode: 1, statusText: noInternetMessage);
       }
     }

   }


   Future<Response> putData(
    String uri,
    dynamic body, {
    Map<String, dynamic> query,
    String contentType,
    Map<String, String> headers,
    Function(dynamic) decoder,
    Function(double) uploadProgress
  }) async {
     if(await ApiChecker.isVpnActive()) {
       return const Response(statusCode: -1, statusText: 'you are using vpn');
     } {
       try {
         print('====> GetX Call: $uri');
         print('====> GetX Body: $body');
         Http.Response response0 = await Http.put(
           Uri.parse(appBaseUrl+uri),
           body: jsonEncode(body),
           headers: headers ?? _mainHeaders,
         ).timeout(Duration(seconds: timeoutInSeconds));
         Response response = handleResponse(response0, uri);
         if(Foundation.kDebugMode) {
           print('====> API Response: [${response.statusCode}] $uri\n${response.body}');
         }
         return response;

       } catch (e) {
         return Response(statusCode: 1, statusText: noInternetMessage);
       }

     }

   }
   Future<Response> putMultipartData(String uri, Map<String, String> body, List<MultipartBody> multipartBody, {Map<String, String> headers}) async {

     if(await ApiChecker.isVpnActive()) {
       return const Response(statusCode: -1, statusText: 'you are using vpn');
     } {
       try {
         if(Foundation.kDebugMode) {
           print('====> API Call: $uri\nToken: $token');
           print('====> API Body: $body');
         }
         Http.MultipartRequest request = Http.MultipartRequest('PUT', Uri.parse(appBaseUrl+uri));
         request.headers.addAll(headers ?? _mainHeaders);
         for(MultipartBody multipart in multipartBody) {
           if(Foundation.kIsWeb) {
             Uint8List list = await multipart.file.readAsBytes();
             Http.MultipartFile part = Http.MultipartFile(
               multipart.key, multipart.file.readAsBytes().asStream(), list.length,
               filename: basename(multipart.file.path), contentType: MediaType('image', 'jpg'),
             );
             request.files.add(part);
           }else {
             File file = File(multipart.file.path);
             request.files.add(Http.MultipartFile(
               multipart.key, file.readAsBytes().asStream(), file.lengthSync(), filename: file.path.split('/').last,
             ));
           }
         }
         request.fields.addAll(body);
         Http.Response response0 = await Http.Response.fromStream(await request.send());
         Response response = handleResponse(response0, uri);
         if(Foundation.kDebugMode) {
           print('====> API Response: [${response.statusCode}] $uri\n${response.body}');
         }
         return response;
       } catch (e) {
         return Response(statusCode: 1, statusText: noInternetMessage);
       }
     }

   }

   Future<Response> deleteData(String uri, {Map<String, String> headers}) async {
     if(await ApiChecker.isVpnActive()) {
       return const Response(statusCode: -1, statusText: 'you are using vpn');
     } {
       try {
         debugPrint('====> API Call: $uri\nHeader: $_mainHeaders');
         Http.Response response = await Http.delete(
           Uri.parse(appBaseUrl+uri),
           headers: headers ?? _mainHeaders,
         ).timeout(Duration(seconds: timeoutInSeconds));
         return handleResponse(response, uri);
       } catch (e) {
         return Response(statusCode: 1, statusText: noInternetMessage);
       }
     }

   }

   Response handleResponse(Http.Response response, String uri) {
     dynamic body;
     try {
       body = jsonDecode(response.body);
     }catch(e) {}
     Response response0 = Response(
       body: body ?? response.body, bodyString: response.body.toString(),
       request: Request(headers: response.request.headers, method: response.request.method, url: response.request.url),
       headers: response.headers, statusCode: response.statusCode, statusText: response.reasonPhrase,
     );
     if(response0.statusCode != 200 && response0.body != null && response0.body is !String) {
       if(response0.body.toString().startsWith('{errors: [{code:')) {
         ErrorResponse errorResponse = ErrorResponse.fromJson(response0.body);
         response0 = Response(statusCode: response0.statusCode, body: response0.body, statusText: errorResponse.errors[0].message);
       }else if(response0.body.toString().startsWith('{message')) {
         response0 = Response(statusCode: response0.statusCode, body: response0.body, statusText: response0.body['message']);
       }
     }else if(response0.statusCode != 200 && response0.body == null) {
       response0 = Response(statusCode: 0, statusText: noInternetMessage);
     }
     debugPrint('====> API Response: [${response0.statusCode}] $uri\n${response0.body}');
     return response0;
   }

 }
class MultipartBody {
  String key;
  File file;

  MultipartBody(this.key, this.file);
}
