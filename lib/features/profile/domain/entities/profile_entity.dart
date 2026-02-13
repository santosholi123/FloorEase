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

  @override
  List<Object?> get props => [id, fullName, email, phone, profileImage];
}
