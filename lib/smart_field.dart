import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SmartField extends StatefulWidget {
  final TextInputType type;
  final FocusNode focusNode;
  final FocusNode? nextFocus;
  final TextInputAction? action;
  final TextEditingController? sameTo;
  final String? sameToMessage;
  final VoidCallback? callback;
  final String label;
  final String? hint;
  final String? errorMessage;
  final bool mandatory;
  final bool validate;
  final bool password;
  final int? maxLength;
  final String? maxLengthMessage;
  final int? minLength;
  final String? minLengthMessage;
  final TextEditingController controller;
  final bool readOnly;
  final Color readOnlyColor;
  final TextCapitalization capitalization;
  final Function(String)? onChange;
  final List<TextInputFormatter>? formatters;
  final String? initialValue;

  SmartField(
      {Key? key,
      this.type = TextInputType.text,
      required this.focusNode,
      required this.nextFocus,
      this.action,
      required this.label,
      this.hint,
      this.errorMessage,
      this.mandatory = false,
      this.validate = false,
      this.maxLength,
      this.maxLengthMessage,
      this.minLength,
      this.minLengthMessage,
      this.callback,
      this.onChange,
      this.password = false,
      required this.controller,
      this.readOnly = false,
      this.sameTo,
      this.readOnlyColor = const Color(0xFFE9EAEE),
      this.capitalization = TextCapitalization.none,
      this.sameToMessage,
      this.formatters,
      this.initialValue})
      : super(key: key);

  @override
  SmartFieldState createState() {
    return SmartFieldState();
  }
}

class SmartFieldState extends State<SmartField> {
  bool _error = false;
  TextInputAction? _action;
  String? _label;
  String? errorMessage = '';
  bool dirty = false;
  String defaultStr = '';
  InputDecoration decoration = InputDecoration();

  onChange(String value) {
    this.validateDirty();
    if (widget.onChange != null) {
      widget.onChange!(value);
    }
  }

  validateDirty() {
    if (!dirty) {
      dirty = widget.controller.text != this.defaultStr;
    }
  }

  bool validField(TextInputType type, String? value) {
    errorMessage = widget.errorMessage;
    bool result = true;
    switch (type.index) {
      case 0: //text
      case 1: //multiline
        break;
      case 2: //number
        String pattern = r"^[0-9]*$";
        result = RegExp(pattern).hasMatch(value!);
        break;
      case 3: //phone
        String pattern = r"^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$";
        result = RegExp(pattern).hasMatch(value!);
        break;
      case 4: //datetime
        break;
      case 5: //email
        String pattern =
            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
        result = RegExp(pattern).hasMatch(value!);
        break;
      case 6: //url
        String pattern =
            r"^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$";
        result = RegExp(pattern).hasMatch(value!);
        break;
    }
    if (result && widget.sameTo != null) {
      result = widget.sameTo!.text == value;
      if (!result) {
        this.errorMessage = widget.sameToMessage;
      }
    } else if (result && widget.minLength != null) {
      result = value!.length >= widget.minLength!;
      if (!result) {
        this.errorMessage = widget.minLengthMessage;
      }
    } else if (result && widget.maxLength != null) {
      result = value!.length <= widget.maxLength!;
      if (!result) {
        this.errorMessage = widget.maxLengthMessage;
      }
    }
    return result;
  }

  void _editCompleted() {
    this.validateDirty();
    String text = widget.controller.text;
    setState(() {
      _error = ((widget.mandatory && (text == null || text.isEmpty)) ||
          (widget.validate && !validField(widget.type, text)));
    });
  }

  void _fieldSubmit(String value) {
    this.validateDirty();
    if (widget.nextFocus != null) {
      FocusScope.of(context).requestFocus(widget.nextFocus);
    } else if (widget.callback != null) {
      widget.callback!();
    }
  }

  @override
  void initState() {
    _action = widget.action;
    this.defaultStr = widget.controller.text;
    if (_action == null) {
      _action = (widget.nextFocus == null)
          ? TextInputAction.done
          : TextInputAction.next;
    }
    _label = widget.label;
    if (widget.mandatory) {
      _label = _label! + "*";
    }
    errorMessage = widget.errorMessage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    this.decoration.applyDefaults(Theme.of(context).inputDecorationTheme);
    return TextFormField(
      controller: widget.controller,
      initialValue: widget.initialValue,
      focusNode: widget.focusNode,
      keyboardType: widget.type,
      obscureText: widget.password,
      textInputAction: _action,
      inputFormatters: widget.formatters,
      textCapitalization: widget.capitalization,
      onChanged: onChange,
      decoration: this.decoration.copyWith(
            fillColor: widget.readOnly
                ? widget.readOnlyColor
                : this.decoration.fillColor,
            labelText: _label,
            errorText: _error ? this.errorMessage : null,
            hintText: widget.hint,
          ),
      onEditingComplete: _editCompleted,
      onFieldSubmitted: _fieldSubmit,
      keyboardAppearance: Brightness.light,
      readOnly: widget.readOnly,
      validator: (value) {
        String? text = value;
        return ((widget.mandatory && (text == null || text.isEmpty)) ||
                (widget.validate && !validField(widget.type, text)))
            ? errorMessage
            : null;
      },
    );
  }
}
