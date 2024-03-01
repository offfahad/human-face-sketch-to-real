class LogInWithEmailAndPasswordFailure {
  final String message;

  const LogInWithEmailAndPasswordFailure(
      [this.message = "An unknown error occurred."]);

  factory LogInWithEmailAndPasswordFailure.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return const LogInWithEmailAndPasswordFailure(
            'The email address is not valid or badly formatted.');
      case 'user-not-found':
        return const LogInWithEmailAndPasswordFailure(
            'There is no user corresponding to the given email address.');
      case 'wrong-password':
        return const LogInWithEmailAndPasswordFailure(
            'The password is invalid for the given email address.');
      case 'user-disabled':
        return const LogInWithEmailAndPasswordFailure(
            'This user has been disabled. Please contact support.');
      case 'too-many-requests':
        return const LogInWithEmailAndPasswordFailure(
            'Too many unsuccessful login attempts. Please try again later.');
      default:
        return const LogInWithEmailAndPasswordFailure();
    }
  }
}
