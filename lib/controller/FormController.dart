import 'package:flutter/material.dart';

class FormController {
  // VALIDATES
  // ...

  // FUNÇÕES GERAIS
  int intParse(TextEditingController input){ // controle de int's
    return int.parse(string(input));
  }
  double doubleParse(TextEditingController input){ // controle de double's
    return double.parse(string(input));
  }
  String string(TextEditingController input){ // controle de string's
    return input.text.trim();
  }

  void dispose(List<TextEditingController> inputs){ // dar dispose em lista de inputs
    for (var i = 0; i < inputs.length; i++) {
      inputs[i].dispose();
    }
  }
  void clear(List<TextEditingController> inputs){ // dar clear em lista de inputs
    for (var i = 0; i < inputs.length; i++) {
      inputs[i].clear();
    }
  }
}
