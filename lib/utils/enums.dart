import 'package:flutter/material.dart';

enum Types {
  text,
  multiline,
  number,
  phone,
  email,
  url,
}

TextInputType getInputType(Types type) {
  switch (type) {
    case Types.multiline:
      return TextInputType.multiline;
      break;
    case Types.number:
      return TextInputType.number;
      break;
    case Types.phone:
      return TextInputType.phone;
      break;
    case Types.email:
      return TextInputType.emailAddress;
      break;
    case Types.url:
      return TextInputType.url;
      break;
    case Types.text:
    default:
      return TextInputType.text;
      break;
  }
}

enum Actions {
  auto,
  next,
  done,
}

TextInputAction getInputAction(Actions action) {
  switch (action) {
    case Actions.done:
      return TextInputAction.done;
      break;
    case Actions.next:
      return TextInputAction.next;
      break;
    case Actions.auto:
    default:
      return null;
      break;
  }
}
