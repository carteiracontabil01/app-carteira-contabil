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

// Defina o nome da sua ação, defina seus argumentos e parâmetro de retorno,
// e depois adicione o código padrão usando o botão à direita!

// Defina uma função chamada reorderItems que retorna um Future de uma lista de strings.
// Recebe uma lista de strings, um índice antigo e um novo índice como parâmetros.
Future<List<String>> reorderItems(
  List<String> list,
  int oldIndex,
  int newIndex,
) async {
  //Se o item estiver sendo movido para uma posição mais abaixo na lista
  // (ou seja, para um índice mais alto), diminua o newIndex em 1.
  // Este ajuste é necessário porque a remoção de um item de seu original
  //posição mudará os índices de todos os itens subsequentes.
  if (oldIndex < newIndex) {
    newIndex -= 1;
  }

  //Remove o item de sua posição original na lista e armazena
  // na variável 'item'.
  final item = list.removeAt(oldIndex);

  //Insere o item removido em sua nova posição na lista.
  list.insert(newIndex, item);

  // Retorna a lista modificada.
  return list;
}
