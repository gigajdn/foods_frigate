import 'package:flutter/cupertino.dart';

class Validation {
  static bool isValidImageUrl(String url) {
    bool startsWithHttp = url.toLowerCase().startsWith('http://');
    bool startsWithHttps = url.toLowerCase().startsWith('https://');

    bool endsWithPng = url.toLowerCase().endsWith('.png');
    bool endsWithJpg = url.toLowerCase().endsWith('.jpg');
    bool endsWithJpeg = url.toLowerCase().endsWith('.jpeg');

    return (startsWithHttp || startsWithHttps) &&
        (endsWithPng || endsWithJpg || endsWithJpeg);
  }

  static String? nameValidation(String? string) {
    if (string == null || string.trim().isEmpty) {
      return 'Preencha este campo.';
    }
    if (string.trim().length < 3) {
      return 'O nome deve ter no mínimo 3 letras.';
    }
    return null;
  }

  static String? amountValidation(String? string) {
    if (string == null || string.trim().isEmpty) {
      return 'Preencha este campo.';
    }
    if (int.tryParse(string.trim()) == null) {
      return 'Informe uma quantidade válida.';
    }
    return null;
  }

  static String? imgSrcValidation(String? string) {
    if (string == null || string.trim().isEmpty) {
      return 'Preencha este campo.';
    }
    if (!isValidImageUrl(string.trim())) {
      return 'Informe uma URL válida.';
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
