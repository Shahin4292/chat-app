class AuthFormStateModel {
  final String name;
  final String email;
  final String password;
  final String? nameError;
  final String? emailError;
  final String? passwordError;
  final bool isLoading;
  final bool isPasswordVisible;

  AuthFormStateModel({
    this.email = "",
    this.password = "",
    this.name = "",
    this.nameError,
    this.emailError,
    this.passwordError,
    this.isLoading = false,
    this.isPasswordVisible = true,
  });

  bool get isFormValid =>
      emailError == null &&
      passwordError == null &&
      (name.isEmpty || nameError == null);

  AuthFormStateModel copyWith({
    String? name,
    String? email,
    String? password,
    String? nameError,
    String? emailError,
    String? passwordError,
    bool? isLoading,
    bool? isPasswordVisible,
  }) {
    return AuthFormStateModel(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      nameError: nameError,
      emailError: emailError,
      passwordError: passwordError,
      isLoading: isLoading ?? this.isLoading,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
    );
  }
}
