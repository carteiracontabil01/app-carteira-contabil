// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter/services.dart'; // Import para FilteringTextInputFormatter
import 'package:intl/intl.dart'; // Import para NumberFormat

class PromoReal extends StatefulWidget {
  const PromoReal({
    Key? key,
    this.width,
    this.height,
    required this.initialValue,
    required this.fontSize,
    required this.fillColor,
    required this.colorText,
    required this.focusColor,
    required this.primaryColor, // Nova propriedade para a cor primária
    this.labelText =
        'Digite o valor', // Parâmetro para alterar o texto do rótulo
  }) : super(key: key);

  final double? width;
  final double? height;
  final String initialValue;
  final double fontSize;
  final Color fillColor;
  final Color colorText;
  final Color focusColor;
  final Color primaryColor; // Nova propriedade para a cor primária
  final String labelText; // Parâmetro para o texto do rótulo

  @override
  _PromoRealState createState() => _PromoRealState();
}

class _PromoRealState extends State<PromoReal> {
  late TextEditingController _priceEditingController;
  final currencyFormat = NumberFormat("#,##0.00", "pt_BR");
  bool _isFocused = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _priceEditingController = TextEditingController(text: widget.initialValue);
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _priceEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color labelColor =
        _isFocused ? widget.primaryColor : widget.colorText; // Cor do rótulo

    return Container(
      width: widget.width,
      child: SizedBox(
        height: widget.height,
        child: TextField(
          controller: _priceEditingController,
          focusNode: _focusNode,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly, // Permite apenas dígitos
            TextInputFormatter.withFunction((oldValue, newValue) {
              final text = newValue.text;
              final selection = newValue.selection;
              if (text.isEmpty) {
                return TextEditingValue(text: '', selection: selection);
              } else if (text.length == 1) {
                final number = int.tryParse(text);
                if (number == null) {
                  return oldValue;
                } else {
                  final newText = '0.${number.toString()}';
                  return TextEditingValue(
                    text: newText,
                    selection: TextSelection.collapsed(offset: newText.length),
                  );
                }
              } else {
                final price = double.parse(text.replaceAll('.', '')) / 100;
                final newText = currencyFormat.format(price);
                FFAppState().update(() {
                  FFAppState().promoPrice = price;
                });
                final newSelectionIndex =
                    newText.length - (text.length - selection.end);
                return TextEditingValue(
                  text: newText,
                  selection: TextSelection.collapsed(offset: newSelectionIndex),
                );
              }
            })
          ],
          onChanged: (value) {},
          style: TextStyle(
            fontSize: widget.fontSize,
            fontWeight: FontWeight.w500, // Alterado para medium
            color: widget.colorText,
            fontFamily: 'Nunito', // Alterada a fonte padrão para 'Nunito'
            fontStyle: FontStyle
                .normal, // Adicionada para garantir a formatação correta da fonte
          ),
          decoration: InputDecoration(
            labelText:
                widget.labelText, // Usar o texto fornecido pelo parâmetro
            labelStyle: TextStyle(
              color: labelColor, // Usar a cor determinada dinamicamente
            ),
            prefixText: 'R\$ ', // Prefixo "R$" adicionado
            prefixStyle: TextStyle(
              color: Color.fromARGB(255, 118, 118, 118),
              fontSize: 15,
              fontWeight: FontWeight.w500,
              fontFamily: 'Nunito',
              fontStyle: FontStyle.normal,
            ),
            filled: true,
            fillColor: widget.fillColor,
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: _isFocused ? widget.focusColor : Colors.transparent,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: _isFocused ? widget.focusColor : Colors.transparent,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: widget.focusColor),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      ),
    );
  }
}
