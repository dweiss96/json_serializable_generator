String toLowerCamelCase(String input) {
  final stringParts = input.trim().split(RegExp(r'[-_ ]'));
  stringParts.removeWhere((str) => str.isEmpty);
  final start = stringParts.first;
  stringParts.removeAt(0);

  if (stringParts.isEmpty && start.toUpperCase() == start) {
    return start.toLowerCase().substring(0, 1) +
        start.substring(1).toLowerCase();
  }
  if (stringParts.isEmpty) {
    return start.toLowerCase().substring(0, 1) + start.substring(1);
  }
  final modified = [
    start.toLowerCase().substring(0, 1) + start.substring(1).toLowerCase()
  ];
  modified.addAll(stringParts.map((string) {
    return string.toUpperCase().substring(0, 1) +
        string.substring(1).toLowerCase();
  }));

  return modified.join('');
}
