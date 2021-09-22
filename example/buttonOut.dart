import 'package:flutter/material.dart';
import 'package:smart_forms/models/field.model.dart';
import 'package:smart_forms/models/form.model.dart';
import 'package:smart_forms/smart_forms.dart';
import 'package:smart_forms/utils/enums.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Forms',
      theme: ThemeData(
        primarySwatch: Colors.black as MaterialColor?,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Smart Forms'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FormModel? _form;
  GlobalKey<SmartFormsState> _formState = new GlobalKey<SmartFormsState>();

  _formDone() {
    final SmartFormsState currentState = this._formState.currentState!;
    if (currentState.validateForm()) {
      print(currentState.responseToMap());
    }
  }

  @override
  void initState() {
    _form = FormModel(name: "buttonOut", fields: [
      FieldModel(
        label: "Field 1",
        type: Types.number,
        vallidate: true,
      ),
      FieldModel(
        label: "Field 2",
        type: Types.text,
        vallidate: true,
      )
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: Container(
        child: Column(
          children: [
            SmartForms(
              key: _formState,
              form: _form,
            ),
            SizedBox(
              height: 16,
            ),
            RaisedButton(
              onPressed: _formDone,
              child: Text('Submit'),
            )
          ],
        ),
      ),
    );
  }
}
