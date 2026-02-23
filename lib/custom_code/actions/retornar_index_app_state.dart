// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<int> retornarIndexAppState(
  String idproduto,
  List<CarrinhoProdutoStruct> appstate,
) async {
  // find the index of a product by its idproduto in appstate
  for (int i = 0; i < appstate.length; i++) {
    if (appstate[i].idproduto == idproduto) {
      return i;
    }
  }
  return -1;
}
