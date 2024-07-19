import 'package:flutter/cupertino.dart';

class Validation {
  static bool isValidImageUrl(String url) {
    bool startsWithHttp = url.toLowerCase().startsWith('http://');
    bool startsWithHttps = url.toLowerCase().startsWith('https://');

    // bool endsWithPng = url.toLowerCase().endsWith('.png');
    // bool endsWithJpg = url.toLowerCase().endsWith('.jpg');
    // bool endsWithJpeg = url.toLowerCase().endsWith('.jpeg');

    // return (startsWithHttp || startsWithHttps) &&
    //     (endsWithPng || endsWithJpg || endsWithJpeg);
    return (startsWithHttp || startsWithHttps);
  }

  static String? nameValidation(String? string) {
    if (string == null || string.trim().isEmpty) {
      return 'Fill in this field.';
    }
    if (string.trim().length < 3) {
      return 'The name must have at least 3 letters.';
    }
    return null;
  }

  static String? amountValidation(String? string) {
    if (string == null || string.trim().isEmpty) {
      return 'Fill in this field.';
    }
    if (int.tryParse(string.trim()) == null) {
      return 'Enter a valid quantity.';
    }
    return null;
  }

  static String? imgSrcValidation(String? string) {
    if (string == null || string.trim().isEmpty) {
      return 'Fill in this field.';
    }
    if (!isValidImageUrl(string.trim())) {
      return 'Enter a valid URL.';
    }
    return null;
  }

  static void validateForm(GlobalKey<FormState> key) {
    bool isValid = key.currentState!.validate();
    if (!isValid) {
      return;
    }
  }
}
