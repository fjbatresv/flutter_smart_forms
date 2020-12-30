library smart_forms;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_forms/smart_datepicker.dart';
import 'package:smart_forms/smart_dropdown.dart';
import './models/field.model.dart';
import './models/form.model.dart';
import './utils/enums.dart';

import 'smart_field.dart';

class SmartForms extends StatefulWidget {
  final FormModel form;
  final dynamic callback;
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
    double bottomPadding = 8;
    if (index == length - 1 && widget.form.submitButton.isNotEmpty) {
      bottomPadding = 16;
    } else if (index == length - 1 && widget.form.submitButton.isEmpty) {
      bottomPadding = 0;
    }
    return Padding(
      padding: EdgeInsets.only(
        bottom: bottomPadding,
        top: 0,
      ),
      child: Builder(
        builder: (BuildContext ctx) {
          switch (field.type) {
            case Types.dropdown:
              return _buildSmartDropDown(field, index, length);
            case Types.datepicker:
              return _buildSmartDatePicker(field, index, length);
            default:
              return _buildSmartField(field, index, length);
          }
        },
      ),
    );
  }

  Widget _buildSmartDatePicker(FieldModel field, int index, int length) {
    return SmartDatepicker(
      field: field,
      focus: _focuses[index],
      controller: _controllers[index],
      nextFocus: index < length - 1 ? _focuses[index + 1] : null,
      type: field.dateType,
      format: DateFormat(field.dateTimeFormat),
    );
  }

  Widget _buildSmartDropDown(FieldModel field, int index, int length) {
    return SmartDropDown(
      field: field,
      focus: _focuses[index],
      nextFocus: index < length - 1 ? _focuses[index + 1] : null,
      controller: _controllers[index],
    );
  }

  Widget _buildSmartField(FieldModel field, int index, int length) {
    TextEditingController sameToController;
    if (field.sameTo.isNotEmpty) {
      final int sameTo = widget.form.fields
          .indexWhere((FieldModel i) => i.name == field.sameTo);
      sameToController = sameTo != -1 ? _controllers[sameTo] : null;
    }
    Function callback;
    if (widget.form.submitButton.isNotEmpty) {
      callback = _validateForm;
    } else if (widget.callback != null) {
      callback = widget.callback;
    }
    return SmartField(
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
      callback: callback,
      action: getInputAction(field.action),
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
