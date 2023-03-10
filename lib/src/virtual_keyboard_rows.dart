part of virtual_keyboard;

/// Keys for Virtual Keyboard's rows.
const List<List<String>> _keyRows = [
  // Row 1
  [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '0',
  ],
  // Row 2
  [
    'q',
    'w',
    'e',
    'r',
    't',
    'y',
    'u',
    'i',
    'o',
    'p',
  ],
  // Row 3
  [
    'a',
    's',
    'd',
    'f',
    'g',
    'h',
    'j',
    'k',
    'l',
    ':',
  ],
  // Row 4
  [
    'z',
    'x',
    'c',
    'v',
    'b',
    'n',
    'm',
    '-',
    '_',
    '/',
  ],
  // Row 5
  [
    '<',
    '>',
  ],
];

/// Keys for Virtual Keyboard's rows.
const List<List<String>> _keyRowsNumeric = [
  // Row 1
  [
    '1',
    '2',
    '3',
  ],
  // Row 1
  [
    '4',
    '5',
    '6',
  ],
  // Row 1
  [
    '7',
    '8',
    '9',
  ],
  // Row 1
  [
    '.',
    '0',
  ],
];

/// Returns a list of `VirtualKeyboardKey` objects for Numeric keyboard.
List<VirtualKeyboardKey> _getKeyboardRowKeysNumeric(int rowNum) {
  // Generate VirtualKeyboardKey objects for each row.
  return List.generate(_keyRowsNumeric[rowNum].length, (int keyNum) {
    // Get key string value.
    final key = _keyRowsNumeric[rowNum][keyNum];

    // Create and return new VirtualKeyboardKey object.
    return VirtualKeyboardKey(
      text: key,
      capsText: key.toUpperCase(),
      keyType: VirtualKeyboardKeyType.String,
    );
  });
}

/// Returns a list of `VirtualKeyboardKey` objects.
List<VirtualKeyboardKey> _getKeyboardRowKeys(int rowNum) {
  // Generate VirtualKeyboardKey objects for each row.
  return List.generate(_keyRows[rowNum].length, (int keyNum) {
    // Get key string value.
    final key = _keyRows[rowNum][keyNum];

    // Create and return new VirtualKeyboardKey object.
    return VirtualKeyboardKey(
      text: key,
      capsText: key.toUpperCase(),
      keyType: VirtualKeyboardKeyType.String,
    );
  });
}

/// Returns a list of VirtualKeyboard rows with `VirtualKeyboardKey` objects.
List<List<VirtualKeyboardKey>> _getKeyboardRows() {
  // Generate lists for each keyboard row.
  return List.generate(_keyRows.length, (int rowNum) {
    // Will contain the keyboard row keys.
    List<VirtualKeyboardKey> rowKeys = [];

    // We have to add Action keys to keyboard.
    switch (rowNum) {
      case 1:
        // String keys.
        rowKeys = _getKeyboardRowKeys(rowNum);

        // 'Backspace' button.
        rowKeys.add(
          VirtualKeyboardKey(
            keyType: VirtualKeyboardKeyType.Action,
            action: VirtualKeyboardKeyAction.Backspace,
          ),
        );
        break;
      case 2:
        // String keys.
        rowKeys = _getKeyboardRowKeys(rowNum);

        // 'Return' button.
        rowKeys.add(
          VirtualKeyboardKey(
            keyType: VirtualKeyboardKeyType.Action,
            action: VirtualKeyboardKeyAction.Return,
            text: '\n',
            capsText: '\n',
          ),
        );
        break;
      case 3:
        // Left Shift
        rowKeys.add(
          VirtualKeyboardKey(
            keyType: VirtualKeyboardKeyType.Action,
            action: VirtualKeyboardKeyAction.Shift,
          ),
        );

        // String keys.
        rowKeys.addAll(_getKeyboardRowKeys(rowNum));

        // Right Shift
        // rowKeys.add(
        //   VirtualKeyboardKey(
        //     keyType: VirtualKeyboardKeyType.Action,
        //     action: VirtualKeyboardKeyAction.Shift,
        //   ),
        // );
        break;
      case 4:
        // String keys.
        rowKeys = _getKeyboardRowKeys(rowNum);

        // Insert the space key into second position of row.
        rowKeys.insert(
          1,
          VirtualKeyboardKey(
            keyType: VirtualKeyboardKeyType.Action,
            text: ' ',
            capsText: ' ',
            action: VirtualKeyboardKeyAction.Space,
          ),
        );

        break;
      default:
        rowKeys = _getKeyboardRowKeys(rowNum);
    }

    return rowKeys;
  });
}

/// Returns a list of VirtualKeyboard rows with `VirtualKeyboardKey` objects.
List<List<VirtualKeyboardKey>> _getKeyboardRowsNumeric() {
  // Generate lists for each keyboard row.
  return List.generate(_keyRowsNumeric.length, (int rowNum) {
    // Will contain the keyboard row keys.
    List<VirtualKeyboardKey> rowKeys = [];

    // We have to add Action keys to keyboard.
    switch (rowNum) {
      case 3:
        // String keys.
        rowKeys.addAll(_getKeyboardRowKeysNumeric(rowNum));

        // Right Shift
        rowKeys.add(
          VirtualKeyboardKey(
            keyType: VirtualKeyboardKeyType.Action,
            action: VirtualKeyboardKeyAction.Backspace,
          ),
        );
        break;
      default:
        rowKeys = _getKeyboardRowKeysNumeric(rowNum);
    }

    return rowKeys;
  });
}
