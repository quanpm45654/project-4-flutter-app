class CustomValidator {
  static String? combine(List<String?> validators) {
    for (final validator in validators) {
      final result = validator;
      if (result != null) {
        return result;
      }
    }
    return null;
  }

  static String? required(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Please enter ${fieldName.toLowerCase()}';
    }
    return null;
  }

  static String? minLength(String? value, int minLength, String fieldName) {
    if (value != null && value.length < minLength) {
      return 'Please enter ${fieldName.toLowerCase()} with min $minLength characters';
    }
    return null;
  }

  static String? maxLength(String? value, int maxLength, String fieldName) {
    if (value != null && value.length < maxLength) {
      return 'Please enter ${fieldName.toLowerCase()} with max $maxLength characters';
    }
    return null;
  }

  static String? email(String? value) {
    final emailRegExp = RegExp(r"^((?!\.)[\w\-_.]*[^.])(@\w+)(\.\w+(\.\w+)?[^.\W])$");
    if (value != null && !emailRegExp.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? number(String? value) {
    if (value != null && int.tryParse(value) == null) {
      return 'Please enter a number';
    }
    return null;
  }
}
