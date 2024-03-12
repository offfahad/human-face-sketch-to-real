class TException {
  final String message;
  const TException([this.message = "Provided credentials are wrong!"]);
  factory TException.fromCode(String code) {
    switch (code) {
      case 'email-already-in-use':
        return const TException('An account already exists for that email.');
      case 'invalid-email':
        return const TException(
            'The email address is not valid or badly formatted.');
      case 'weak-password':
        return const TException('Please enter a stronger password.');
      case 'user-disabled':
        return const TException(
            'This user has been disabled. Please contact support.');
      case 'user-not-found':
        return const TException(
            'There is no user corresponding to the given email address.');
      case 'wrong-password':
        return const TException(
            'The password is invalid for the given email address.');
      case 'too-many-requests':
        return const TException(
            'Too many unsuccessful login attempts. Please try again later.');
      case 'invalid-arguments':
        return const TException('An Incorrect argument was provided to an Authentication Method.');
      case 'invalid-password':
        return const TException('Invalid password, please try again with correct password.');     
      case 'invalid-phone-number':
        return const TException(
            'The provided Phone Number is invalid.');
      case 'operation-not-allowed':
        return const TException(
            'Operation is not allowed. Please contact support.');
      case 'session-cookie-expired':
        return const TException(
            'The provided Firebase session cookie is expired.');
      case 'uid-already-exists':
        return const TException(
            'The provided uid is already in use by an exisiting user.');
      default:
        return const TException();
    }
  }
}
