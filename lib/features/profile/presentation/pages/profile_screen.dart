import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:batch35_floorease/features/profile/domain/entities/profile_entity.dart';
import 'package:batch35_floorease/features/profile/presentation/provider/profile_provider.dart';
import 'package:batch35_floorease/features/auth/presentation/provider/auth_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final String fallbackImageUrl = 'https://i.pravatar.cc/300';
  final ImagePicker _picker = ImagePicker();

  File? _image;
  bool _obscurePassword = true;
  bool _isInitializedFromProfile = false;
  String? _lastProfileId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProfile();
    });
  }

  Future<void> _loadProfile() async {
    final provider = context.read<ProfileProvider>();
    await provider.fetchProfile();
    if (!mounted) return;
    _initializeFromProfile(provider.profile);
  }

  void _initializeFromProfile(ProfileEntity? profile) {
    if (profile == null) return;

    final shouldInit =
        !_isInitializedFromProfile || _lastProfileId != profile.id;
    final controllersEmpty =
        nameController.text.isEmpty &&
        emailController.text.isEmpty &&
        phoneController.text.isEmpty;

    if (shouldInit || controllersEmpty) {
      _lastProfileId = profile.id;
      nameController.text = profile.fullName;
      emailController.text = profile.email;
      phoneController.text = profile.phone;
      _isInitializedFromProfile = true;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F3F5),
      body: SafeArea(
        child: Consumer<ProfileProvider>(
          builder: (context, profileProvider, child) {
            final ProfileEntity? profile = profileProvider.profile;
            _initializeFromProfile(profile);

            if (profileProvider.isLoading && profile == null) {
              return const Center(child: CircularProgressIndicator());
            }

            if (profileProvider.error != null && profile == null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        profileProvider.error!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF1C1C1E),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildActionButton(
                        label: 'Retry',
                        icon: Icons.refresh_rounded,
                        backgroundColor: const Color(0xFF1C1C1E),
                        textColor: Colors.white,
                        onTap: () {
                          context.read<ProfileProvider>().fetchProfile();
                        },
                      ),
                    ],
                  ),
                ),
              );
            }

            return LayoutBuilder(
              builder: (context, constraints) {
                final bool isTablet = constraints.maxWidth > 600;
                final double contentWidth = isTablet
                    ? 500
                    : constraints.maxWidth;
                final double horizontalPadding = isTablet ? 0 : 20;
                final double avatarRadius = math.min(72, contentWidth * 0.18);
                return Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isTablet ? 500 : double.infinity,
                    ),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                        vertical: 16,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: IconButton(
                                onPressed: () =>
                                    Navigator.of(context).maybePop(),
                                icon: const Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                ),
                                color: const Color(0xFF1C1C1E),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Center(
                              child: Consumer<ProfileProvider>(
                                builder: (context, provider, child) {
                                  final imageUrl =
                                      (provider
                                              .profile
                                              ?.profileImage
                                              ?.isNotEmpty ??
                                          false)
                                      ? '${provider.profile!.profileImage}?t=${DateTime.now().millisecondsSinceEpoch}'
                                      : fallbackImageUrl;

                                  return GestureDetector(
                                    onTap: _showImageOptions,
                                    child: CircleAvatar(
                                      radius: avatarRadius,
                                      backgroundColor: Colors.white,
                                      child: ClipOval(
                                        child: Image.network(
                                          imageUrl,
                                          width: avatarRadius * 2,
                                          height: avatarRadius * 2,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 28),
                            _buildProfileField(
                              label: 'Name',
                              controller: nameController,
                              icon: Icons.person_outline_rounded,
                              keyboardType: TextInputType.name,
                            ),
                            const SizedBox(height: 14),
                            _buildProfileField(
                              label: 'Email',
                              controller: emailController,
                              icon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 14),
                            _buildProfileField(
                              label: 'Mobile Number',
                              controller: phoneController,
                              icon: Icons.phone_outlined,
                              keyboardType: TextInputType.phone,
                            ),
                            const SizedBox(height: 14),
                            _buildProfileField(
                              label: 'Password',
                              controller: passwordController,
                              icon: Icons.lock_outline_rounded,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: _obscurePassword,
                              suffixIcon: _obscurePassword
                                  ? Icons.visibility_off_rounded
                                  : Icons.visibility_rounded,
                              onSuffixTap: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            const SizedBox(height: 28),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildActionButton(
                                    label: 'Update Profile',
                                    icon: Icons.edit_outlined,
                                    backgroundColor: const Color(0xFF1C1C1E),
                                    textColor: Colors.white,
                                    onTap: () async {
                                      final isValid =
                                          _formKey.currentState?.validate() ??
                                          false;
                                      if (!isValid) {
                                        return;
                                      }
                                      final provider = context
                                          .read<ProfileProvider>();
                                      await provider.updateProfile(
                                        fullName: nameController.text.trim(),
                                        email: emailController.text.trim(),
                                        phone: phoneController.text.trim(),
                                        password:
                                            passwordController.text
                                                .trim()
                                                .isEmpty
                                            ? null
                                            : passwordController.text.trim(),
                                        nameController: nameController,
                                        emailController: emailController,
                                        phoneController: phoneController,
                                      );
                                      if (!mounted) return;
                                      _initializeFromProfile(provider.profile);
                                      final message =
                                          provider.error ??
                                          provider.actionMessage ??
                                          'Profile updated';
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(content: Text(message)),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: _buildActionButton(
                                    label: 'Log Out',
                                    icon: Icons.logout_rounded,
                                    backgroundColor: Colors.white,
                                    textColor: const Color(0xFF1C1C1E),
                                    onTap: () {
                                      context.read<AuthProvider>().logout(
                                        context,
                                      );
                                    },
                                    borderColor: const Color(0xFFE0E0E0),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required TextInputType keyboardType,
    bool obscureText = false,
    IconData? suffixIcon,
    VoidCallback? onSuffixTap,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: InputDecoration(
          icon: Icon(icon, color: const Color(0xFF8E8E93)),
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xFF8E8E93)),
          border: InputBorder.none,
          suffixIcon: suffixIcon != null
              ? IconButton(
                  onPressed: onSuffixTap,
                  icon: Icon(suffixIcon, color: const Color(0xFF8E8E93)),
                )
              : null,
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
        style: const TextStyle(
          color: Color(0xFF1C1C1E),
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color backgroundColor,
    required Color textColor,
    required VoidCallback onTap,
    Color? borderColor,
  }) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(25),
      child: InkWell(
        borderRadius: BorderRadius.circular(25),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            border: borderColor != null ? Border.all(color: borderColor) : null,
            boxShadow: const [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: textColor),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showImageOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Change Image'),
                onTap: () async {
                  Navigator.of(context).pop();
                  await _handleChangeImage();
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline_rounded),
                title: const Text('Delete Image'),
                onTap: () {
                  Navigator.of(context).pop();
                  _handleDeleteImage();
                },
              ),
              ListTile(
                leading: const Icon(Icons.close_rounded),
                title: const Text('Cancel'),
                onTap: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage() async {
    final XFile? picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked == null) {
      return;
    }
    _image = File(picked.path);
  }

  Future<void> _handleChangeImage() async {
    await _pickImage();
    if (_image == null) return;

    if (!mounted) return;
    _showLoadingDialog();
    await context.read<ProfileProvider>().changeImage(_image!);
    if (!mounted) return;
    Navigator.of(context, rootNavigator: true).pop();

    final provider = context.read<ProfileProvider>();
    final message = provider.error ?? provider.actionMessage;
    if (message != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
    _image = null;
  }

  Future<void> _handleDeleteImage() async {
    if (!mounted) return;
    _showLoadingDialog();
    await context.read<ProfileProvider>().removeImage();
    if (!mounted) return;
    Navigator.of(context, rootNavigator: true).pop();

    final provider = context.read<ProfileProvider>();
    final message = provider.error ?? provider.actionMessage;
    if (message != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
