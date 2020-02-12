class ExternalResource {
  String id;
  String stringValue;
  bool boolValue;
  int intValue;

  ExternalResource({
    this.id,
    this.stringValue,
    this.boolValue,
    this.intValue,
  });

  ExternalResource.prettyRead(String data) {
    List<String> parts = data.split(";");
    this.id = parts.elementAt(0);
    this.stringValue = parts.elementAt(1);
    this.boolValue = parts.elementAt(2).toLowerCase() == "true";
    this.intValue = int.parse(parts.elementAt(3));
  }

  String prettyWrite() => "$id;$stringValue;$boolValue;$intValue;";
}