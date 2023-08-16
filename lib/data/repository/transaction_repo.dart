import 'dart:convert';

import 'package:get/get_connect/http/src/response/response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zawadicash_app/data/api/api_client.dart';
import 'package:zawadicash_app/data/model/response/contact_model.dart';
import 'package:zawadicash_app/util/app_constants.dart';

class TransactionRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  TransactionRepo({required this.apiClient, required this.sharedPreferences});


  Future<Response>  getPurposeListApi() async {
    return await apiClient.getData(AppConstants.CUSTOMER_PURPOSE_URL );
  }

  Future<Response>  sendMoneyApi({required String phoneNumber, required double amount,required String purpose,required String pin }) async {
    return await apiClient.postData(AppConstants.CUSTOMER_SEND_MONEY,{'phone': phoneNumber, 'amount': amount, 'purpose':purpose, 'pin': pin});
  }

  Future<Response>  requestMoneyApi({required String phoneNumber, required double amount}) async {
    return await apiClient.postData(AppConstants.CUSTOMER_REQUEST_MONEY,  {'phone' : phoneNumber, 'amount' : amount});
  }
  Future<Response>  cashOutApi({required String phoneNumber, required double amount, required String pin}) async {
    return await apiClient.postData(AppConstants.CUSTOMER_CASH_OUT, {'phone' : phoneNumber, 'amount' : amount, 'pin' : pin});
  }

  Future<Response>  checkCustomerNumber({required String phoneNumber}) async {
    return await apiClient.postData(AppConstants.CHECK_CUSTOMER_URI, {'phone' : phoneNumber});
  }
  Future<Response>  checkAgentNumber({required String phoneNumber}) async {
    return await apiClient.postData(AppConstants.CHECK_AGENT_URI, {'phone' : phoneNumber});
  }


  List<ContactModel> getRecentList({required String type})  {
    String recent = '';
    String key = type == AppConstants.SEND_MONEY ?
      AppConstants.SEND_MONEY_SUGGEST_LIST : type == AppConstants.CASH_OUT ?
      AppConstants.RECENT_AGENT_LIST : AppConstants.REQUEST_MONEY_SUGGEST_LIST;

    if(sharedPreferences.containsKey(key)){
      try {
        recent =  sharedPreferences.get(key);
      }catch(error) {
        recent = '';
      }
    }
    if(recent != '' && recent != 'null'){
      return  contactModelFromJson(utf8.decode(base64Url.decode(recent.replaceAll(' ', '+'))));
    }
    return null;

  }

  void addToSuggestList(List<ContactModel> contactModelList,{required String type}) async {
    String suggests = base64Url.encode(utf8.encode(contactModelToJson(contactModelList)));
    if(type == 'send_money') {
     await sharedPreferences.setString(AppConstants.SEND_MONEY_SUGGEST_LIST, suggests);
    }
    else if(type == 'request_money'){
     await sharedPreferences.setString(AppConstants.REQUEST_MONEY_SUGGEST_LIST, suggests);
    }
    else if(type == "cash_out"){
     await sharedPreferences.setString(AppConstants.RECENT_AGENT_LIST, suggests);
    }
  }

  Future<Response> getWithdrawMethods() async {
    return await apiClient.getData(AppConstants.WITHDRAW_METHOD_LIST);
  }

  Future<Response>  withdrawRequest({required Map<String, String> placeBody}) async {
    return await apiClient.postData(AppConstants.WITHDRAW_REQUEST, placeBody);
  }




}