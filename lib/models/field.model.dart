import 'package:flutter/material.dart';
import 'package:smart_forms/models/fieldOptions.model.dart';

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
  final int maxLength;
  final String maxLengthMessage;
  final int minLength;
  final String minLengthMessage;
  final bool password;
  final bool readOnly;
  final String dateTimeFormat;
  final DateTypes dateType;
  final List<FieldOptionsModel> options;
  final dynamic value;
  final double padding;
  final Color readOnlyColor;

  FieldModel({
    @required this.label,
    this.padding,
    this.name = '',
    this.sameTo = '',
    this.sameToError = '',
    this.type = Types.text,
    this.errorMessage = '',
    this.mandatory = false,
    this.action = InputActions.auto,
    this.hint = '',
    this.vallidate = false,
    this.maxLength = 0,
    this.maxLengthMessage = '',
    this.minLength = 0,
    this.minLengthMessage = '',
    this.password = false,
    this.readOnly = false,
    this.options = const [],
    this.dateTimeFormat = 'MM/dd/yyyy',
    this.dateType = DateTypes.eighteenYearsBefore,
    this.readOnlyColor = const Color(0xFFE9EAEE),
    this.value,
  }) {
    if (this.name.isEmpty) {
      this.name = this.label;
    }
    if (this.type == Types.dropdown && this.options.isEmpty) {
      throw Exception('You need to set items for a dropdown');
    }
  }
}
