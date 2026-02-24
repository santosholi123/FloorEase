import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  const ProfileEntity({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    this.profileImage,
  });

  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String? profileImage;

  ProfileEntity copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phone,
    String? profileImage,
  }) {
    return ProfileEntity(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
    );
  }

  @override
  List<Object?> get props => [id, fullName, email, phone, profileImage];
}
