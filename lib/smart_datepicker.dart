import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:smart_forms/models/field.model.dart';
import 'package:smart_forms/utils/enums.dart';

class SmartDatepicker extends StatefulWidget {
  final FieldModel? field;
  final FocusNode? focus;
  final FocusNode? nextFocus;
  final DateFormat? format;
  final TextEditingController? controller;
  final DateTypes? type;

  const SmartDatepicker(
      {Key? key,
      this.field,
      this.focus,
      this.controller,
      this.nextFocus,
      this.format,
      this.type})
      : super(key: key);
  @override
  _SmartDatepickerState createState() => _SmartDatepickerState();
}

class _SmartDatepickerState extends State<SmartDatepicker> {
  DateTime? dateTime;
  DateTime? initial;
  DateTime? first;
  DateTime? last;
  ThemeData? _theme;

  @override
  void initState() {
    this.setInitialDate();
    super.initState();
  }

  setInitialDate() {
    this.initial = DateTime.now();
    // We can validate the default value based on the type of date input selected.
    switch (widget.type) {
      case DateTypes.eighteenYearsBefore:
        // DateType eighteen years before restrict the user to use dates with a minimum of 18 years.
        this.initial = DateTime.now().subtract(Duration(days: (366 * 18)));
        this.first = this.initial!.subtract(Duration(days: 36600));
        this.last = this.initial;
        break;
      case DateTypes.free:
        // DateType free let the user set any date
        this.first = this.initial!.subtract(Duration(days: 36600));
        this.last = this.initial!.add(Duration(days: 365));
        break;
      case DateTypes.todayAfter:
        // DateType today after. This let the user set the date after today.
        this.first = this.initial;
        this.last = this.initial!.add(Duration(days: 90));
        break;
    }
    if (widget.field!.value != null) {
      // Incase the code set a date is used as initialization.
      this.initial = DateTime.fromMillisecondsSinceEpoch(widget.field!.value);
    }
    if (this.dateTime == null) {
      this.dateTime = this.initial;
      widget.controller!.text =
          this.dateTime!.toUtc().millisecondsSinceEpoch.toString();
    }
  }

  _launchAndroidPicker(BuildContext context) async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: this.initial!,
      firstDate: this.first!,
      lastDate: this.last!,
    );
    widget.focus!.unfocus();
    _datePicked(date);
  }

  _datePicked(DateTime? date) {
    this.setState(() {
      this.dateTime = date;
    });
    widget.controller!.text =
        this.dateTime!.toUtc().millisecondsSinceEpoch.toString();
    if (widget.nextFocus != null &&
        (kIsWeb || TargetPlatform.android == this._theme!.platform)) {
      FocusScope.of(context).requestFocus(widget.nextFocus);
    }
  }

  _launchIosPicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext ctx) {
          return Container(
            height: MediaQuery.of(context).size.height / 4,
            width: double.infinity,
            child: CupertinoDatePicker(
              onDateTimeChanged: _datePicked,
              initialDateTime: this.initial,
              minimumDate: this.first,
              maximumDate: this.last,
              mode: CupertinoDatePickerMode.date,
            ),
          );
        })
      ..then((value) => widget.focus!.unfocus());
  }

  _launchPicker(BuildContext context) {
    FocusScope.of(context).requestFocus(widget.focus);

    if (this._theme!.platform != TargetPlatform.iOS || kIsWeb) {
      _launchAndroidPicker(context);
    } else if (this._theme!.platform == TargetPlatform.iOS) {
      _launchIosPicker(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    this._theme = Theme.of(context);
    return InkWell(
      onTap: () => _launchPicker(context),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 1,
              color: widget.focus!.hasFocus
                  ? Theme.of(context).accentColor
                  : Color(0xFF7C7C7C),
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.field!.label,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: widget.focus!.hasFocus
                    ? Theme.of(context).accentColor
                    : Color(0xFF7C7C7C),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              this.dateTime == null
                  ? widget.field!.hint
                  : widget.format!.format(this.dateTime!),
            )
          ],
        ),
      ),
    );
  }
}
