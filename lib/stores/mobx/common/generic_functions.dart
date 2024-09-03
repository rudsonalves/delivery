class StoreFunc {
  StoreFunc._();

  static bool itsNotEmail(String? email) {
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return (email == null || email.isEmpty || !regex.hasMatch(email));
  }
}
