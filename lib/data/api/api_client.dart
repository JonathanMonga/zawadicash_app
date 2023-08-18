import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zawadicash_app/data/api/api_checker.dart';
import 'package:zawadicash_app/data/model/response/error_response.dart';
import 'package:zawadicash_app/util/app_constants.dart';

class ApiClient extends GetxService {
  String appBaseUrl = AppConstants.BASE_URL;
  late final SharedPreferences sharedPreferences;
  final String noInternetMessage =
      'Connection to API server failed due to internet connection';
  final int timeoutInSeconds = 30;
  late BaseDeviceInfo deiceInfo;
  late final String uniqueId;
  late String token;
  late Map<String, String> _mainHeaders;

  ApiClient({
    required this.appBaseUrl,
    required this.sharedPreferences,
    required this.deiceInfo,
    required this.uniqueId,
  }) {
    debugPrint(" token.............................................$token");

    _mainHeaders = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };

    if (('${deiceInfo.data['isPhysicalDevice']}' == 'true') ||
        AppConstants.DEMO) {
      debugPrint('=========-----${deiceInfo.data.toString()}------=========');
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

    if (('${deiceInfo.data['isPhysicalDevice']}' == 'true') ||
        AppConstants.DEMO) {
      _mainHeaders.addAll({
        'device-id': uniqueId,
        'os': GetPlatform.isAndroid ? 'android' : 'ios',
        'device-model':
            '${GetPlatform.isAndroid ? '${deiceInfo.data['brand']} ${deiceInfo.data['device-model']}' : ''} ${deiceInfo.data['model']}'
      });
    }
  }

  Future<Response> getData(String uri,
      {Map<String, dynamic>? query, Map<String, String>? headers}) async {
    if (await ApiChecker.isVpnActive()) {
      return const Response(statusCode: -1, statusText: 'you are using vpn');
    } else {
      try {
        debugPrint('====> API Call: $uri\nHeader: $_mainHeaders');
        http.Response _response = await http.get(
          Uri.parse(appBaseUrl + uri),
          headers: headers ?? _mainHeaders,
        ).timeout(Duration(seconds: timeoutInSeconds));
        return handleResponse(_response, uri);
      } catch (e) {
        return Response(statusCode: 1, statusText: noInternetMessage);
      }
    }
  }

  Future<Response> postData(String uri, dynamic body,
      {Map<String, String>? headers}) async {
    if (await ApiChecker.isVpnActive()) {
      return const Response(statusCode: -1, statusText: 'you are using vpn');
    }
    {
      try {
        if (foundation.kDebugMode) {
          debugPrint('====> GetX Base URL: $appBaseUrl');
          debugPrint('====> GetX Call: $uri');
          debugPrint('====> GetX Body: $body');
        }
        http.Response _response = await http.post(
          Uri.parse(appBaseUrl + uri),
          body: jsonEncode(body),
          headers: headers ?? _mainHeaders,
        ).timeout(Duration(seconds: timeoutInSeconds));
        debugPrint("++++++++++++>>>=====");
        Response response = handleResponse(_response, uri);

        if (foundation.kDebugMode) {
          debugPrint(
              '====> API Response: [${response.statusCode}] $uri\n${response.body}');
        }
        return response;
      } catch (e) {
        return Response(statusCode: 1, statusText: noInternetMessage);
      }
    }
  }

  Future<Response> postMultipartData(
      String uri, Map<String, String> body, List<MultipartBody> multipartBody,
      {Map<String, String>? headers}) async {
    if (await ApiChecker.isVpnActive()) {
      return const Response(statusCode: -1, statusText: 'you are using vpn');
    }
    {
      try {
        if (foundation.kDebugMode) {
          debugPrint('====> API Call: $uri\nToken: $token');
          debugPrint(
              '====> API Body: $body with ${multipartBody.length} image ');
        }
        http.MultipartRequest _request =
            http.MultipartRequest('POST', Uri.parse(appBaseUrl + uri));
        _request.headers.addAll(headers ?? _mainHeaders);
        for (MultipartBody multipart in multipartBody) {
          if (foundation.kIsWeb) {
            Uint8List _list = await multipart.file.readAsBytes();
            http.MultipartFile _part = http.MultipartFile(
              multipart.key,
              multipart.file.readAsBytes().asStream(),
              _list.length,
              filename: basename(multipart.file.path),
              contentType: MediaType('image', 'jpg'),
            );
            _request.files.add(_part);
          } else {
            File _file = File(multipart.file.path);
            _request.files.add(http.MultipartFile(
              multipart.key,
              _file.readAsBytes().asStream(),
              _file.lengthSync(),
              filename: _file.path.split('/').last,
            ));
          }
        }
        _request.fields.addAll(body);
        http.Response _response =
            await http.Response.fromStream(await _request.send());
        Response response = handleResponse(_response, uri);
        if (foundation.kDebugMode) {
          debugPrint(
              '====> API Response: [${response.statusCode}] $uri\n${response.body}');
        }
        return response;
      } catch (e) {
        return Response(statusCode: 1, statusText: noInternetMessage);
      }
    }
  }

  Future<Response> putData(String uri, dynamic body,
      {Map<String, dynamic>? query,
      String? contentType,
      Map<String, String>? headers,
      Function(dynamic)? decoder,
      Function(double)? uploadProgress}) async {
    if (await ApiChecker.isVpnActive()) {
      return const Response(statusCode: -1, statusText: 'you are using vpn');
    }
    {
      try {
        debugPrint('====> GetX Call: $uri');
        debugPrint('====> GetX Body: $body');
        http.Response _response = await http.put(
          Uri.parse(appBaseUrl + uri),
          body: jsonEncode(body),
          headers: headers ?? _mainHeaders,
        ).timeout(Duration(seconds: timeoutInSeconds));
        Response response = handleResponse(_response, uri);
        if (foundation.kDebugMode) {
          debugPrint(
              '====> API Response: [${response.statusCode}] $uri\n${response.body}');
        }
        return response;
      } catch (e) {
        return Response(statusCode: 1, statusText: noInternetMessage);
      }
    }
  }

  Future<Response> putMultipartData(
      String uri, Map<String, String> body, List<MultipartBody> multipartBody,
      {Map<String, String>? headers}) async {
    if (await ApiChecker.isVpnActive()) {
      return const Response(statusCode: -1, statusText: 'you are using vpn');
    }
    {
      try {
        if (foundation.kDebugMode) {
          debugPrint('====> API Call: $uri\nToken: $token');
          debugPrint('====> API Body: $body');
        }
        http.MultipartRequest _request =
            http.MultipartRequest('PUT', Uri.parse(appBaseUrl + uri));
        _request.headers.addAll(headers ?? _mainHeaders);
        for (MultipartBody multipart in multipartBody) {
          if (foundation.kIsWeb) {
            Uint8List _list = await multipart.file.readAsBytes();
            http.MultipartFile _part = http.MultipartFile(
              multipart.key,
              multipart.file.readAsBytes().asStream(),
              _list.length,
              filename: basename(multipart.file.path),
              contentType: MediaType('image', 'jpg'),
            );
            _request.files.add(_part);
          } else {
            File _file = File(multipart.file.path);
            _request.files.add(http.MultipartFile(
              multipart.key,
              _file.readAsBytes().asStream(),
              _file.lengthSync(),
              filename: _file.path.split('/').last,
            ));
          }
        }
        _request.fields.addAll(body);
        http.Response _response =
            await http.Response.fromStream(await _request.send());
        Response response = handleResponse(_response, uri);
        if (foundation.kDebugMode) {
          debugPrint(
              '====> API Response: [${response.statusCode}] $uri\n${response.body}');
        }
        return response;
      } catch (e) {
        return Response(statusCode: 1, statusText: noInternetMessage);
      }
    }
  }

  Future<Response> deleteData(String uri,
      {Map<String, String>? headers}) async {
    if (await ApiChecker.isVpnActive()) {
      return const Response(statusCode: -1, statusText: 'you are using vpn');
    }
    {
      try {
        debugPrint('====> API Call: $uri\nHeader: $_mainHeaders');
        http.Response _response = await http.delete(
          Uri.parse(appBaseUrl + uri),
          headers: headers ?? _mainHeaders,
        ).timeout(Duration(seconds: timeoutInSeconds));
        return handleResponse(_response, uri);
      } catch (e) {
        return Response(statusCode: 1, statusText: noInternetMessage);
      }
    }
  }

  Response handleResponse(http.Response response, String uri) {
    dynamic _body;
    try {
      _body = jsonDecode(response.body);
    } catch (e) {
      debugPrint(e.toString());
    }
    Response _response = Response(
      body: _body ?? response.body,
      bodyString: response.body.toString(),
      request: Request(
          headers: response.request!.headers,
          method: response.request!.method,
          url: response.request!.url),
      headers: response.headers,
      statusCode: response.statusCode,
      statusText: response.reasonPhrase,
    );
    if (_response.statusCode != 200 &&
        _response.body != null &&
        _response.body is! String) {
      if (_response.body.toString().startsWith('{errors: [{code:')) {
        ErrorResponse _errorResponse = ErrorResponse.fromJson(_response.body);
        _response = Response(
            statusCode: _response.statusCode,
            body: _response.body,
            statusText: _errorResponse.errors[0].message);
      } else if (_response.body.toString().startsWith('{message')) {
        _response = Response(
            statusCode: _response.statusCode,
            body: _response.body,
            statusText: _response.body['message']);
      }
    } else if (_response.statusCode != 200 && _response.body == null) {
      _response = Response(statusCode: 0, statusText: noInternetMessage);
    }
    debugPrint(
        '====> API Response: [${_response.statusCode}] $uri\n${_response.body}');
    return _response;
  }
}

class MultipartBody {
  String key;
  File file;

  MultipartBody(this.key, this.file);
}
