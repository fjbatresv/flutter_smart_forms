import 'package:flutter/material.dart';

import 'field.model.dart';

class FormModel {
  final String name;
  final String submitButton;
  final String resetButton;
  final List<FieldModel> fields;

  FormModel({
    @required this.name,
    this.submitButton = '',
    this.resetButton = '',
    @required this.fields,
  });
}
