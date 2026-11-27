import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../theme.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onSignOut;
  final bool isActive;

  const ProfileScreen({
    super.key,
    required this.onBack,
    required this.onSignOut,
    required this.isActive,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const _panelColor = AppColors.cream;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  DateTime _dateOfBirth = DateTime(1991, 10, 9);
  bool _saving = false;
  bool _profileLoaded = false;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    _nameController.text = user?.displayName?.trim().isNotEmpty == true
        ? user!.displayName!.trim()
        : 'John Smith';
    _emailController.text = user?.email ?? 'johnsmith@example.com';
    _phoneController.text = user?.phoneNumber ?? '+123 567 89000';
    if (widget.isActive) _loadProfile();
  }

  @override
  void didUpdateWidget(covariant ProfileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.isActive && widget.isActive) _loadProfile();
  }

  Future<void> _loadProfile() async {
    if (_profileLoaded) return;
    _profileLoaded = true;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (!mounted || !snapshot.exists) return;

      final data = snapshot.data()!;
      setState(() {
        if (data['fullName'] is String) {
          _nameController.text = data['fullName'] as String;
        }
        if (data['phoneNumber'] is String) {
          _phoneController.text = data['phoneNumber'] as String;
        }
        final date = data['dateOfBirth'];
        final parsedDate = date is Timestamp
            ? date.toDate()
            : date is String
                ? DateTime.tryParse(date)
                : null;
        if (parsedDate != null) _dateOfBirth = parsedDate;
      });
    } on FirebaseException catch (error) {
      if (mounted) {
        _showMessage('Could not load profile: ${error.message ?? error.code}');
      }
    }
  }

  Future<void> _selectDateOfBirth() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (selectedDate != null) {
      setState(() => _dateOfBirth = selectedDate);
    }
  }

  Future<void> _saveProfile() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      _showMessage('Enter your full name');
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _showMessage('Please sign in again to update your profile');
      return;
    }

    setState(() => _saving = true);
    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'fullName': name,
        'email': user.email,
        'phoneNumber': _phoneController.text.trim(),
        'dateOfBirth': '${_dateOfBirth.year.toString().padLeft(4, '0')}-'
            '${_dateOfBirth.month.toString().padLeft(2, '0')}-'
            '${_dateOfBirth.day.toString().padLeft(2, '0')}',
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      await user.updateDisplayName(name);
      if (mounted) _showMessage('Profile updated');
    } on FirebaseException catch (error) {
      if (mounted) {
        _showMessage(
            'Could not update profile: ${error.message ?? error.code}');
      }
    } catch (error) {
      if (mounted) _showMessage('Could not update profile: $error');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  String get _formattedDate =>
      '${_dateOfBirth.day.toString().padLeft(2, '0')} / '
      '${_dateOfBirth.month.toString().padLeft(2, '0')} / '
      '${_dateOfBirth.year}';

  String get _initials {
    final parts = _nameController.text
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .take(2);
    final initials = parts.map((part) => part[0]).join().toUpperCase();
    return initials.isEmpty ? 'JS' : initials;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: _panelColor,
      body: Column(
        children: [
          Container(
            color: AppColors.yellow,
            child: SafeArea(
              bottom: false,
              child: SizedBox(
                height: 92,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: widget.onBack,
                      icon: const Icon(Icons.arrow_back_ios_new,
                          size: 18, color: AppColors.primary),
                    ),
                    const Expanded(
                      child: Text(
                        'My profile',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: _panelColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(26, 18, 26, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          ClipOval(
                            child: user?.photoURL == null
                                ? Container(
                                    width: 82,
                                    height: 82,
                                    color: AppColors.yellow
                                        .withValues(alpha: 0.35),
                                    alignment: Alignment.center,
                                    child: Text(
                                      _initials,
                                      style: const TextStyle(
                                        color: AppColors.dark,
                                        fontSize: 24,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  )
                                : Image.network(
                                    user!.photoURL!,
                                    width: 82,
                                    height: 82,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        const CircleAvatar(
                                      radius: 41,
                                      backgroundColor: AppColors.yellow,
                                      child: Icon(Icons.person,
                                          color: Colors.white, size: 42),
                                    ),
                                  ),
                          ),
                          Positioned(
                            right: -2,
                            bottom: 0,
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.camera_alt,
                                  color: Colors.white, size: 15),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    _ProfileField(
                      label: 'Full Name',
                      controller: _nameController,
                    ),
                    const SizedBox(height: 12),
                    _ProfileField(
                      label: 'Date of Birth',
                      value: _formattedDate,
                      readOnly: true,
                      onTap: _selectDateOfBirth,
                    ),
                    const SizedBox(height: 12),
                    _ProfileField(
                      label: 'Email',
                      controller: _emailController,
                      readOnly: true,
                    ),
                    const SizedBox(height: 12),
                    _ProfileField(
                      label: 'Phone Number',
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 22),
                    Center(
                      child: SizedBox(
                        height: 40,
                        child: ElevatedButton(
                          onPressed: _saving ? null : _saveProfile,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(148, 40),
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: const StadiumBorder(),
                            textStyle: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          child: _saving
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('Update Profile'),
                        ),
                      ),
                    ),
                    Center(
                      child: TextButton.icon(
                        onPressed: widget.onSignOut,
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.primary,
                        ),
                        icon: const Icon(Icons.logout, size: 16),
                        label: const Text('Log out'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final String? value;
  final bool readOnly;
  final VoidCallback? onTap;
  final TextInputType? keyboardType;

  const _ProfileField({
    required this.label,
    this.controller,
    this.value,
    this.readOnly = false,
    this.onTap,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.dark,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 5),
        SizedBox(
          height: 40,
          child: TextFormField(
            initialValue: value,
            controller: controller,
            readOnly: readOnly,
            onTap: onTap,
            keyboardType: keyboardType,
            style: const TextStyle(color: AppColors.dark, fontSize: 13),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.paleYellow,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
