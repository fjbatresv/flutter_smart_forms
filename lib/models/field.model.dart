import 'package:flutter/material.dart';

import '../utils/enums.dart';

class FieldModel {
  final String label;
  final Types type;
  final String errorMessage;
  final bool mandatory;
  final InputActions action;
  final String hint;
  final bool vallidate;
  final int maxLenght;
  final bool password;
  final bool readOnly;

  FieldModel({
    @required this.label,
    this.type = Types.text,
    this.errorMessage = '',
    this.mandatory = false,
    this.action = InputActions.auto,
    this.hint = '',
    this.vallidate = false,
    this.maxLenght = 0,
    this.password = false,
    this.readOnly = false,
  });
}
