bool isEmailValid(String email) {
  return RegExp(r'^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$')
      .hasMatch(email);
}

bool isUsernameValid(String username) {
  return RegExp(r'^[A-Za-z0-9_.-]+$').hasMatch(username);
}

bool isVowels(String char) {
  if (char == 'username') {
    return false;
  }
  return RegExp('[aeiou]').hasMatch(char[0].toLowerCase());
}
