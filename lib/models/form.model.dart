import 'field.model.dart';

class FormModel {
  final String name;
  final String submitButton;
  final String resetButton;
  final List<FieldModel> fields;

  FormModel({
    this.name,
    this.submitButton,
    this.resetButton = '',
    this.fields,
  });
}
