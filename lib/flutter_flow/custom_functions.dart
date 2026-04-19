import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/supabase/supabase.dart';
import '/auth/supabase_auth/auth_util.dart';

double? multiplicacaoPor100(double valor1) {
  return valor1 * 100;
}

int pontoEvirgula(String valor) {
  String valorTextField = valor; //Valor inserido no Textfield

  //Substituir vírgulas por pontos
  String valorComPonto = valorTextField.replaceAll(',', '.');

  //Transformar a string em double
  double valorDouble = double.parse(valorComPonto);

  //Multiplicar o double por 100
  double resultado = valorDouble * 100;

  //Transformar o resultado em um valor inteiro
  int resultadoString = resultado.toInt();

  return resultadoString;
}

double mudarVirgulaPorPonto(String valorTextField) {
  //return valorTextfield changing , to .
  String valorComPonto = valorTextField.replaceAll(',', '.');
  double valorDouble = double.parse(valorComPonto);
  return valorDouble;
}

double stringToDouble(String valor) {
  return double.parse(
      (valor).replaceAll(RegExp('[^\\d,]'), '').replaceAll(',', '.'));
}

int convertStringInteger(String valor) {
  // converter string em numero inteiro
  return int.parse(valor);
}

double? subTotaiProduto(
  int qtd,
  double valorUnit,
) {
  return qtd * valorUnit;
}

int concatenarComplementos(
  String? state,
  String? complementoRef,
) {
  // concatenate items from the page state and return the number of items
  List<String?> items = [state, complementoRef];
  String result = items.join();
  return result.length;
}

DateTime criarData(DateTime dataTexto) {
  // convert string format 2024-02-08T00:00:00+00:00 for  Output: 2024-02-08
  return DateTime(dataTexto.year, dataTexto.month, dataTexto.day);
}

DateTime convertCurrentTime(DateTime dataZerada) {
  // convert 2024-02-06 18:36:17.941 to 2024-02-06 00:00:00.000
  return DateTime(dataZerada.year, dataZerada.month, dataZerada.day);
}

double somaAppStateCart(List<double> valor) {
  // sum a list of values ​​and return the result
  double sum = 0;
  for (double value in valor) {
    sum += value;
  }
  return sum;
}

DateTime convertCurrentTimeFor23h59(DateTime horavintetres) {
  // convert 2024-02-06 18:36:17.941 to 2024-02-06 23:59:59.999
  return DateTime(horavintetres.year, horavintetres.month, horavintetres.day,
      23, 59, 59, 999);
}

LatLng convertStringToLatlng(String latlngstring) {
  // converter string em latlng
  final latLngList = latlngstring.split(',');
  final latitude = double.parse(latLngList[0]);
  final longitude = double.parse(latLngList[1]);
  return LatLng(latitude, longitude);
}

double somaFinalCart(
  double totalProdutos,
  double? cupom,
  double? costentrega,
) {
  // totalProdutos - cupom + costentrega
  double somaFinal = totalProdutos;
  if (cupom != null) {
    somaFinal -= cupom;
  }
  if (costentrega != null) {
    somaFinal += costentrega;
  }
  return somaFinal;
}

dynamic excluiFotoArray(
  List<String> fotos,
  int indice,
) {
  List<dynamic> novaLista =
      List.from(fotos); // Criando uma cópia da lista original
  novaLista.removeAt(indice); // Removendo o elemento no índice especificado
  return novaLista;
}

String convertDubleToString(double valor) {
  // convert duble to string
  return valor.toString();
}

List<String> concatenaImages(
  List<String> listaImagesProduto,
  List<String> listaImageLocal,
) {
  // concatenar duas lista de string
  List<String> concatenatedList = [];
  concatenatedList.addAll(listaImagesProduto);
  concatenatedList.addAll(listaImageLocal);
  return concatenatedList;
}

String splitUrl(String urlCompleta) {
  // split url exemplo https://taigotei.com.br/supermercadolopes o resultado deve ser supermercadolopes
  final List<String> urlParts = urlCompleta.split('/');
  return urlParts.last;
}

String clearUrl(String urlCompleta) {
  // convert url de https://taigotei.com.br/supermercadolopes para https://taigotei.com.br
  return urlCompleta.replaceAll(RegExp(r'/\w+$'), '');
}
