import 'package:flutter/material.dart';
import 'package:zawadicash_app/data/model/response/language_model.dart';
import 'package:zawadicash_app/util/app_constants.dart';

class LanguageRepo {
  List<LanguageModel> getAllLanguages({BuildContext? context}) {
    return AppConstants.languages;
  }
}
