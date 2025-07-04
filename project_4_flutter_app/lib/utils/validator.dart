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

  static String? minLength(String? value, int minLength) {
    if (value != null && value.length < minLength) {
      return 'Please enter min $minLength characters';
    }
    return null;
  }

  static String? maxLength(String? value, int maxLength) {
    if (value != null && value.length > maxLength) {
      return 'Please enter max $maxLength characters';
    }
    return null;
  }

  static String? email(String? value) {
    final emailRegExp = RegExp(
      r"^((?!\.)[\w\-_.]*[^.])(@\w+)(\.\w+(\.\w+)?[^.\W])$",
    );
    if (value != null && !emailRegExp.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? number(String? value) {
    if (value != null && num.tryParse(value) == null) {
      return 'Please enter a number';
    }
    return null;
  }

  static String? minValue(String? value, double minValue) {
    if (value != null && value.isNotEmpty && double.parse(value) < minValue) {
      return 'Please enter a number greater than $minValue';
    }
    return null;
  }

  static String? maxValue(String? value, double maxValue) {
    if (value != null && value.isNotEmpty && double.parse(value) > maxValue) {
      return 'Please enter a number less than $maxValue';
    }
    return null;
  }
}
