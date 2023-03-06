part of virtual_keyboard;

/// The default keyboard height. Can we overriden by passing
///  `height` argument to `VirtualKeyboard` widget.
const double _virtualKeyboardDefaultHeight = 300;

const int _virtualKeyboardBackspaceEventPerioud = 250;

/// Virtual Keyboard widget.
class VirtualKeyboard extends StatefulWidget {
  /// Keyboard Type: Should be inited in creation time.
  final VirtualKeyboardType type;

  /// The text controller
  final TextEditingController textController;

  // TODO: Create focusnode within the package
  final FocusNode focusNode;

  /// Virtual keyboard height. Default is 300
  final double height;

  /// Color for key texts and icons.
  final Color textColor;

  /// Font size for keyboard keys.
  final double fontSize;

  /// The builder function will be called for each Key object.
  final Widget Function(BuildContext context, VirtualKeyboardKey key)? builder;

  /// Set to true if you want only to show Caps letters.
  final bool alwaysCaps;

  const VirtualKeyboard({
    super.key,
    required this.type,
    required this.textController,
    this.builder,
    this.height = _virtualKeyboardDefaultHeight,
    this.textColor = Colors.black,
    this.fontSize = 14,
    this.alwaysCaps = true,
    // TODO: Create focusnode within the package

    required this.focusNode,
  });

  @override
  State<StatefulWidget> createState() {
    return _VirtualKeyboardState();
  }
}

/// Holds the state for Virtual Keyboard class.
class _VirtualKeyboardState extends State<VirtualKeyboard> {
  VirtualKeyboardType? type;
  // The builder function will be called for each Key object.
  Widget Function(BuildContext context, VirtualKeyboardKey key)? builder;
  late double height;
  late TextEditingController textController;
  // TODO: Create focusnode within the package

  late FocusNode focusNode;
  late Color textColor;
  late double fontSize;
  late bool alwaysCaps;
  // Text Style for keys.
  late TextStyle textStyle;

  // True if shift is enabled.
  bool isShiftEnabled = true;

  @override
  void didUpdateWidget(VirtualKeyboard oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      type = widget.type;
      height = widget.height;
      textColor = widget.textColor;
      fontSize = widget.fontSize;
      alwaysCaps = widget.alwaysCaps;

      // Init the Text Style for keys.
      textStyle = TextStyle(
        fontSize: fontSize,
        color: textColor,
      );
    });
  }

  @override
  void initState() {
    super.initState();

    textController = widget.textController;
    // TODO: Create focusnode within the package

    focusNode = widget.focusNode;
    type = widget.type;
    height = widget.height;
    textColor = widget.textColor;
    fontSize = widget.fontSize;
    alwaysCaps = widget.alwaysCaps;

    // Init the Text Style for keys.
    textStyle = TextStyle(
      fontSize: fontSize,
      color: textColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return type == VirtualKeyboardType.Numeric ? _numeric() : _alphanumeric();
  }

  Widget _alphanumeric() {
    return SizedBox(
      height: height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _rows(),
      ),
    );
  }

  Widget _numeric() {
    return SizedBox(
      height: height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _rows(),
      ),
    );
  }

  /// Returns the rows for keyboard.
  List<Widget> _rows() {
    // Get the keyboard Rows
    final keyboardRows = type == VirtualKeyboardType.Numeric
        ? _getKeyboardRowsNumeric()
        : _getKeyboardRows();

    // Generate keyboard row.
    final rows = List.generate(keyboardRows.length, (int rowNum) {
      return Material(
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          // Generate keboard keys
          children: List.generate(
            keyboardRows[rowNum].length,
            (int keyNum) {
              // Get the VirtualKeyboardKey object.
              final virtualKeyboardKey = keyboardRows[rowNum][keyNum];

              Widget keyWidget;

              // Check if builder is specified.
              // Call builder function if specified or use default
              //  Key widgets if not.
              if (builder == null) {
                // Check the key type.
                switch (virtualKeyboardKey.keyType) {
                  case VirtualKeyboardKeyType.String:
                    // Draw String key.
                    keyWidget = _keyboardDefaultKey(virtualKeyboardKey);
                    break;
                  case VirtualKeyboardKeyType.Action:
                    // Draw action key.
                    keyWidget = _keyboardDefaultActionKey(virtualKeyboardKey);
                    break;
                }
              } else {
                // Call the builder function, so the user can specify custom UI for keys.
                keyWidget = builder!(context, virtualKeyboardKey);

                throw 'builder function must return Widget';
              }

              return keyWidget;
            },
          ),
        ),
      );
    });

    return rows;
  }

  // True if long press is enabled.
  late bool longPress;

  /// Creates default UI element for keyboard Key.
  Widget _keyboardDefaultKey(VirtualKeyboardKey key) {
    return Expanded(
      child: InkWell(
        onTap: () {
          _onKeyPress(key);
        },
        child: SizedBox(
          height: height / _keyRows.length,
          child: Center(
            child: Text(
              alwaysCaps
                  ? key.capsText!
                  : (isShiftEnabled ? key.capsText! : key.text!),
              style: textStyle,
            ),
          ),
        ),
      ),
    );
  }

  void _onKeyPress(VirtualKeyboardKey key) {
    if (key.keyType == VirtualKeyboardKeyType.String) {
      // TODO: Create focusnode within the package

      focusNode.requestFocus();
      final cursorPos = textController.selection.base.offset;

      // Right text of cursor position
      final suffixText = textController.text.substring(cursorPos);
      // Get the left text of cursor
      final prefixText = textController.text.substring(0, cursorPos);

      textController.text = prefixText + key.text! + suffixText;

      // Cursor move to end of added text
      textController.selection = TextSelection(
        baseOffset: cursorPos + 1,
        extentOffset: cursorPos + 1,
      );
      // textController.text += isShiftEnabled ? key.capsText! : key.text!;
    } else if (key.keyType == VirtualKeyboardKeyType.Action) {
      switch (key.action) {
        case VirtualKeyboardKeyAction.Backspace:
          if (textController.text.isEmpty) return;
          // check if text has selection, if so delete the selection else delete the last character
          textController.text = textController.selection.baseOffset !=
                  textController.selection.extentOffset
              ? textController.text.replaceRange(
                  textController.selection.baseOffset,
                  textController.selection.extentOffset,
                  '',
                )
              : textController.text
                  .substring(0, textController.text.length - 1);
          focusNode.requestFocus();
          break;
        case VirtualKeyboardKeyAction.Return:
          textController.text += '\n';
          break;
        case VirtualKeyboardKeyAction.Space:
          textController.text += key.text!;
          break;
        // case VirtualKeyboardKeyAction.Shift:
        // break;
        default:
      }
    }
  }

  /// Creates default UI element for keyboard Action Key.
  Widget _keyboardDefaultActionKey(VirtualKeyboardKey key) {
    // Holds the action key widget.
    Widget actionKey;

    // Switch the action type to build action Key widget.
    switch (key.action!) {
      case VirtualKeyboardKeyAction.Backspace:
        actionKey = GestureDetector(
          onLongPress: () {
            longPress = true;
            // Start sending backspace key events while longPress is true
            Timer.periodic(
              const Duration(
                milliseconds: _virtualKeyboardBackspaceEventPerioud,
              ),
              (timer) {
                if (longPress) {
                  _onKeyPress(key);
                } else {
                  // Cancel timer.
                  timer.cancel();
                }
              },
            );
          },
          onLongPressUp: () {
            // Cancel event loop
            longPress = false;
          },
          child: SizedBox.expand(
            child: Icon(
              Icons.backspace,
              color: textColor,
            ),
          ),
        );
        break;
      // case VirtualKeyboardKeyAction.Shift:
      //   actionKey = Icon(Icons.arrow_upward, color: textColor);
      //   break;
      case VirtualKeyboardKeyAction.Space:
        actionKey = actionKey = Icon(Icons.space_bar, color: textColor);
        break;
      case VirtualKeyboardKeyAction.Return:
        actionKey = Icon(
          Icons.keyboard_return,
          color: textColor,
        );
        break;
    }

    return Expanded(
      child: InkWell(
        onTap: () {
          // if (key.action == VirtualKeyboardKeyAction.Shift) {
          //   if (!alwaysCaps) {
          //     setState(() {
          //       isShiftEnabled = !isShiftEnabled;
          //     });
          //   }
          // }

          _onKeyPress(key);
        },
        child: Container(
          alignment: Alignment.center,
          height: height / _keyRows.length,
          child: actionKey,
        ),
      ),
    );
  }
}
