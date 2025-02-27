String toSnakeCase(String input) {
  return input.toLowerCase().trim().split(RegExp(r'\s+')).join('_');
}
