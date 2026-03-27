class ProfileModel {
  final String? photoUrl;
  final String name;
  final String? email;
  final bool isLoading;
  final bool isUpLoading;
  final DateTime? createdAt;
  final String? userId;

  ProfileModel({
    required this.name,
    this.email,
    this.isLoading = false,
    this.isUpLoading = false,
    this.createdAt,
    this.userId,
    this.photoUrl,
  });

  ProfileModel copyWith({
    String? photoUrl,
    String? name,
    String? email,
    bool? isLoading,
    bool? isUpLoading,
    DateTime? createdAt,
    String? userId,
  }) {
    return ProfileModel(
      photoUrl: photoUrl ?? this.photoUrl,
      name: name ?? this.name,
      email: email ?? this.email,
      isLoading: isLoading ?? this.isLoading,
      isUpLoading: isUpLoading ?? this.isUpLoading,
      createdAt: createdAt ?? this.createdAt,
      userId: userId ?? this.userId,
    );
  }
}
