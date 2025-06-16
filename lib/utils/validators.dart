class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email required';
    final emailReg = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailReg.hasMatch(value)) return 'Invalid email';
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.length < 6) return 'Min 6 characters required';
    return null;
  }

  static String? validateRequired(String? value) {
    if (value == null || value.isEmpty) return 'Field required';
    return null;
  }

  static String? validateNumber(String? value) {
    if (value == null || value.isEmpty) return 'Field required';
    if (double.tryParse(value) == null) return 'Invalid number';
    return null;
  }
}
