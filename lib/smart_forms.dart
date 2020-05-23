library smart_forms;

import 'package:flutter/material.dart';
import 'package:smart_forms/models/field.model.dart';
import 'package:smart_forms/models/form.model.dart';
import 'package:smart_forms/utils/enums.dart';

import 'smart_field.dart';

class SmartForms extends StatefulWidget {
  final FormModel form;
  final Function(Map<String, dynamic> result) callback;
  const SmartForms({
    Key key,
    this.form,
    this.callback,
  }) : super(key: key);

  @override
  _SmartForms createState() {
    return _SmartForms();
  }
}

class _SmartForms extends State<SmartForms> {
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
          onPressed: () => _form.currentState.reset(),
        ),
      );
    }
    buttons.add(
      RaisedButton(
        child: Text(widget.form.submitButton),
        onPressed: _validateForm,
      ),
    );
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
    return widgets;
  }

  Widget _buildField(field, index, length) {
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
        required: field.required,
        readOnly: field.readOnly,
        hint: field.hint.isEmpty ? null : field.hint,
        maxLength: field.maxLenght == 0 ? null : field.maxLenght,
        errorMessage: field.errorMessage,
        validate: field.vallidate,
        callback: _validateForm,
        action: getInputAction(field.action),
      ),
    );
  }

  _validateForm() {
    if (_form.currentState.validate()) {
      widget.callback(_responseToMap());
    }
  }

  Map<String, dynamic> _responseToMap() {
    Map<String, dynamic> values = {};
    for (int i = 0; i < widget.form.fields.length; i++) {
      values[widget.form.fields[i].label] = _controllers[i].text;
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
