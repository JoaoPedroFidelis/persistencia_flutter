import 'package:flutter/material.dart';

class FormController {
  // VALIDATES
  // ...

  // FUNÇÕES GERAIS
  int intParse(TextEditingController input){
    return int.parse(string(input));
  }
  double doubleParse(TextEditingController input){
    return double.parse(string(input));
  }
  String string(TextEditingController input){
    return input.text.trim();
  }

  void dispose(List<TextEditingController> inputs){
    for (var i = 0; i < inputs.length; i++) {
      inputs[i].dispose();
    }
  }
  void clear(List<TextEditingController> inputs){
    for (var i = 0; i < inputs.length; i++) {
      inputs[i].clear();
    }
  }
}
