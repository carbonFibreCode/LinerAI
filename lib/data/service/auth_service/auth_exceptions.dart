//login exceptions
class InvalidCredentialsAuthException implements Exception{}

class ChannelErrorAuthException implements Exception{}

//register exceptions
class EmailAlreadyInUseAuthException implements Exception{}

class InvalidEmailAuthException implements Exception{}

class WeakPasswordAuthException implements Exception{}

//genericAuth Exceptions
class GenericAuthException implements Exception{}

class UserNotLoggedInAuthException implements Exception{}