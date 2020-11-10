library smart_forms;

import 'package:flutter/material.dart';
import './models/field.model.dart';
import './models/form.model.dart';
import './utils/enums.dart';

import 'smart_field.dart';

class SmartForms extends StatefulWidget {
  final FormModel form;
  final Function(Map<String, dynamic> result) callback;
  const SmartForms({
    Key key,
    @required this.form,
    this.callback,
  }) : super(key: key);

  @override
  SmartFormsState createState() {
    return SmartFormsState();
  }
}

class SmartFormsState extends State<SmartForms> {
  GlobalKey<FormState> _form = GlobalKey<FormState>();
  List<TextEditingController> _controllers = [];
  List<FocusNode> _focuses = [];

  List<Widget> _buildForms(BuildContext context) {
    List<Widget> widgets = [];
    int length = widget.form.fields.length;
    for (int i = 0; i < length; i++) {
      FieldModel field = widget.form.fields[i];
      widgets.add(_buildField(field, i, length));
    }
    List<Widget> buttons = [];
    if (widget.form.resetButton.isNotEmpty) {
      buttons.add(
        FlatButton(
          child: Text(widget.form.resetButton),
          onPressed: () => resetForm,
        ),
      );
    }
    if (widget.form.submitButton.isNotEmpty) {
      buttons.add(
        RaisedButton(
          child: Text(widget.form.submitButton),
          onPressed: _validateForm,
        ),
      );
    }
    if (buttons.length > 1) {
      widgets.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: buttons,
        ),
      );
      widgets.add(
        SizedBox(
          height: 20,
        ),
      );
    } else if (buttons.isNotEmpty) {
      widgets.add(buttons[0]);
      widgets.add(
        SizedBox(
          height: 20,
        ),
      );
    }
    return widgets;
  }

  Widget _buildField(FieldModel field, index, length) {
    TextEditingController sameToController;
    if (field.sameTo.isNotEmpty) {
      final int sameTo = widget.form.fields
          .indexWhere((FieldModel i) => i.name == field.sameTo);
      sameToController = sameTo != -1 ? _controllers[sameTo] : null;
    }
    return Padding(
      padding: EdgeInsets.only(
        bottom: index < length - 1 ? 10 : 60,
        top: index == 0 ? 20 : 0,
      ),
      child: SmartField(
        type: getInputType(field.type),
        focusNode: _focuses[index],
        controller: _controllers[index],
        nextFocus: index < length - 1 ? _focuses[index + 1] : null,
        label: field.label,
        password: field.password,
        mandatory: field.mandatory,
        readOnly: field.readOnly,
        sameTo: sameToController,
        sameToMessage: field.sameToError,
        hint: field.hint.isEmpty ? null : field.hint,
        maxLength: field.maxLength == 0 ? null : field.maxLength,
        maxLengthMessage: field.maxLengthMessage,
        minLength: field.minLength == 0 ? null : field.minLength,
        minLengthMessage: field.minLengthMessage,
        errorMessage: field.errorMessage,
        validate: field.vallidate,
        callback: _validateForm,
        action: getInputAction(field.action),
      ),
    );
  }

  _validateForm() {
    if (validateForm()) {
      widget.callback(responseToMap());
    }
  }

  bool validateForm() {
    return _form.currentState.validate();
  }

  resetForm() {
    _controllers.forEach((controller) => controller.clear());
  }

  Map<String, dynamic> responseToMap() {
    Map<String, dynamic> values = {};
    for (int i = 0; i < widget.form.fields.length; i++) {
      String key = widget.form.fields[i].name;
      values[key] = _controllers[i].text;
    }
    return {'form': widget.form.name, 'values': values};
  }

  @override
  void initState() {
    _controllers = widget.form.fields.map<TextEditingController>((field) {
      return TextEditingController();
    }).toList();
    _focuses = widget.form.fields.map<FocusNode>((field) {
      return FocusNode();
    }).toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: _form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: _buildForms(context),
        ),
      ),
    );
  }
}
