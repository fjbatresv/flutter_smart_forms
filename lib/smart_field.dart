import 'package:flutter/material.dart';

class SmartField extends StatefulWidget {
  final TextInputType type;
  final FocusNode focusNode;
  final FocusNode nextFocus;
  final TextInputAction action;
  final TextEditingController sameTo;
  final String sameToMessage;
  final VoidCallback callback;
  final String label;
  final String hint;
  final String errorMessage;
  final bool mandatory;
  final bool validate;
  final bool password;
  final int maxLength;
  final TextEditingController controller;
  final bool readOnly;

  SmartField(
      {Key key,
      this.type = TextInputType.text,
      @required this.focusNode,
      @required this.nextFocus,
      this.action,
      @required this.label,
      this.hint,
      this.errorMessage,
      this.mandatory = false,
      this.validate = false,
      this.maxLength,
      this.callback,
      this.password = false,
      @required this.controller,
      this.readOnly = false,
      this.sameTo,
      this.sameToMessage})
      : super(key: key);

  @override
  _SmartField createState() {
    return _SmartField();
  }
}

class _SmartField extends State<SmartField> {
  bool _error = false;
  TextInputAction _action;
  String _label;
  String errorMessage = '';

  bool validField(TextInputType type, String value) {
    errorMessage = widget.errorMessage;
    bool result = true;
    switch (type.index) {
      case 0: //text
      case 1: //multiline
        break;
      case 2: //number
        String pattern = r"^[0-9]*$";
        result = RegExp(pattern).hasMatch(value);
        break;
      case 3: //phone
        String pattern = r"^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$";
        result = RegExp(pattern).hasMatch(value);
        break;
      case 4: //datetime
        break;
      case 5: //email
        String pattern =
            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
        result = RegExp(pattern).hasMatch(value);
        break;
      case 6: //url
        String pattern =
            r"^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$";
        result = RegExp(pattern).hasMatch(value);
        break;
    }
    if (result && widget.sameTo != null) {
      result = widget.sameTo.text == widget.controller.text;
      if (!result) {
        this.errorMessage = widget.sameToMessage;
      }
    }
    return result;
  }

  void _editCompleted() {
    String text = widget.controller.text;
    setState(() {
      _error = ((widget.mandatory && (text == null || text.isEmpty)) ||
          (widget.validate && !validField(widget.type, text)));
    });
  }

  void _fieldSubmit(String value) {
    if (widget.nextFocus != null) {
      FocusScope.of(context).requestFocus(widget.nextFocus);
    } else if (widget.callback != null) {
      widget.callback();
    }
  }

  @override
  void initState() {
    _action = widget.action;
    if (_action == null) {
      _action = (widget.nextFocus == null)
          ? TextInputAction.done
          : TextInputAction.next;
    }
    _label = widget.label;
    if (widget.mandatory) {
      _label = _label + "*";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      keyboardType: widget.type,
      maxLength: widget.maxLength,
      obscureText: widget.password,
      textInputAction: _action,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        labelText: _label,
        errorText: _error ? widget.errorMessage : null,
        hintText: widget.hint,
      ),
      onEditingComplete: _editCompleted,
      onFieldSubmitted: _fieldSubmit,
      keyboardAppearance: Brightness.light,
      readOnly: widget.readOnly,
      validator: (value) {
        String text = value;
        return ((widget.mandatory && (text == null || text.isEmpty)) ||
                (widget.validate && !validField(widget.type, text)))
            ? errorMessage
            : null;
      },
    );
  }
}
