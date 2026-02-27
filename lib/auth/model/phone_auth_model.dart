class PhoneAuthModel {
  final bool isLoading;
  final String? error;
  final String? phoneNumber;
  final String? verificationId;

  PhoneAuthModel({
    this.isLoading = false,
    this.error,
    this.phoneNumber,
    this.verificationId,
  });

  PhoneAuthModel copyWith({
    bool? isLoading,
    String? error,
    String? phoneNumber,
    String? verificationId,
  }) {
    return PhoneAuthModel(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      verificationId: verificationId ?? this.verificationId,
    );
  }
}