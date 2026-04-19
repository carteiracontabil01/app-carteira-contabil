class ProfileFormData {
  const ProfileFormData({
    required this.fullName,
    required this.email,
    required this.phone,
    this.imageUrl,
  });

  final String fullName;
  final String email;
  final String phone;
  final String? imageUrl;

  ProfileFormData copyWith({
    String? fullName,
    String? email,
    String? phone,
    String? imageUrl,
  }) {
    return ProfileFormData(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
