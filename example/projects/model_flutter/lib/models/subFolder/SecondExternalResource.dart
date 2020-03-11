class SecondExternalResource {
  String id;
  String stringValue;
  bool boolValue;
  int intValue;

  SecondExternalResource({
    this.id,
    this.stringValue,
    this.boolValue,
    this.intValue,
  });

  SecondExternalResource.prettyRead(String data) {
    final parts = data.split(';');
    id = parts.elementAt(0);
    stringValue = parts.elementAt(1);
    boolValue = parts.elementAt(2).toLowerCase() == 'true';
    intValue = int.parse(parts.elementAt(3));
  }

  String prettyWrite() => '$id;$stringValue;$boolValue;$intValue;';
}