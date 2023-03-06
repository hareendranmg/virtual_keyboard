import 'package:flutter/material.dart';
import 'package:virtual_keyboard/virtual_keyboard.dart';

void main() => runApp(MyApp());

// ignore: prefer-match-file-name
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Virtual Keyboard Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Virtual Keyboard Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Holds the text that user typed.
  String text = '';

  // True if shift enabled.
  bool shiftEnabled = false;

  // is true will show the numeric keyboard.
  bool isNumericMode = true;

  late TextEditingController _controllerText;
  late FocusNode myFocusNode;

  @override
  void initState() {
    _controllerText = TextEditingController();
    myFocusNode = FocusNode();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                controller: _controllerText,
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 5,
                showCursor: true,
                autofocus: true,
                focusNode: myFocusNode,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Your text',
                ),
              ),
            ),
            SwitchListTile(
              title: Text(
                'Keyboard Type = ${isNumericMode ? 'VirtualKeyboardType.Numeric' : 'VirtualKeyboardType.Alphanumeric'}',
              ),
              value: isNumericMode,
              onChanged: (val) {
                setState(() {
                  isNumericMode = val;
                });
              },
            ),
            Expanded(
              child: Container(),
            ),
            VirtualKeyboard(
              type: isNumericMode
                  ? VirtualKeyboardType.Numeric
                  : VirtualKeyboardType.Alphanumeric,
              textController: _controllerText,
              focusNode: myFocusNode,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controllerText.dispose();
    myFocusNode.dispose();

    super.dispose();
  }
}
