import 'package:flutter/material.dart';

import '../utils/enums.dart';

class FieldModel {
  final String label;
  String name;
  final Types type;
  final String errorMessage;
  final bool mandatory;
  final InputActions action;
  final String hint;
  final bool vallidate;
  final String sameTo;
  final String sameToError;
  final int maxLenght;
  final bool password;
  final bool readOnly;

  FieldModel({
    @required this.label,
    this.name = '',
    this.sameTo = '',
    this.sameToError = '',
    this.type = Types.text,
    this.errorMessage = '',
    this.mandatory = false,
    this.action = InputActions.auto,
    this.hint = '',
    this.vallidate = false,
    this.maxLenght = 0,
    this.password = false,
    this.readOnly = false,
  }) {
    if (this.name.isEmpty) {
      this.name = this.label;
    }
  }
}
