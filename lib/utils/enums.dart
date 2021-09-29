import 'package:flutter/material.dart';

enum Types {
  text,
  multiline,
  number,
  phone,
  email,
  url,
  dropdown,
  datepicker,
}

enum DateTypes {
  eighteenYearsBefore,
  todayAfter,
  free,
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

enum InputActions {
  auto,
  next,
  done,
}

TextInputAction? getInputAction(InputActions action) {
  switch (action) {
    case InputActions.done:
      return TextInputAction.done;
      break;
    case InputActions.next:
      return TextInputAction.next;
      break;
    case InputActions.auto:
    default:
      return null;
      break;
  }
}
