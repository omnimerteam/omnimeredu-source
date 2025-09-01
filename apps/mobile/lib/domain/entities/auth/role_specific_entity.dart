class RoleSpecificEntity {
  final Map<String, dynamic> _data;

  RoleSpecificEntity(this._data);

  T? get<T>(String key) {
    final value = _data[key];
    if (value is T) return value;
    return null;
  }

  static RoleSpecificEntity fromJson(
    Map<String, dynamic> json,
    Map<String, dynamic> Function(Map<String, dynamic>) parser,
  ) {
    return RoleSpecificEntity(parser(json));
  }

  Map<String, dynamic> toMap() => _data;
}
