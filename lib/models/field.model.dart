import 'package:smart_forms/utils/enums.dart';

class FieldModel {
  final String label;
  final Types type;
  final String errorMessage;
  final bool required;
  final Actions action;
  final String hint;
  final bool vallidate;
  final int maxLenght;
  final bool password;
  final bool readOnly;

  FieldModel({
    this.label,
    this.type = Types.text,
    this.errorMessage = '',
    this.required = false,
    this.action = Actions.auto,
    this.hint = '',
    this.vallidate = false,
    this.maxLenght = 0,
    this.password = false,
    this.readOnly = false,
  });
}
