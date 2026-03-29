import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/entities/user_profile.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _fullName = TextEditingController();
  final _country = TextEditingController();
  final _profession = TextEditingController();
  final _bio = TextEditingController();
  bool _fieldsFromNetwork = false;

  @override
  void dispose() {
    _fullName.dispose();
    _country.dispose();
    _profession.dispose();
    _bio.dispose();
    super.dispose();
  }

  void _applyProfileTexts(UserProfile p) {
    _fullName.text = p.fullName;
    _country.text = p.country;
    _profession.text = p.profession;
    _bio.text = p.bio;
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      final s = parts.first;
      return s.length >= 2 ? s.substring(0, 2).toUpperCase() : s.toUpperCase();
    }
    return (parts.first[0] + parts.skip(1).first[0]).toUpperCase();
  }

  Future<void> _pickAvatar(BuildContext context) async {
    final picker = ImagePicker();
    final file = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
    if (file == null || !context.mounted) return;
    context.read<ProfileBloc>().add(ProfilePhotoSelected(file));
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return BlocConsumer<ProfileBloc, ProfileState>(
      listenWhen: (previous, current) =>
          (current is ProfileLoaded && current.lastError != null) ||
          current is ProfileSaved,
      listener: (context, state) {
        if (state is ProfileLoaded && state.lastError != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.lastError!),
              backgroundColor: cs.error,
            ),
          );
          context.read<ProfileBloc>().add(ClearProfileFeedback());
        }
        if (state is ProfileSaved) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Profile updated'),
              backgroundColor: cs.primary,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is ProfileLoading || state is ProfileInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ProfileError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.message, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () =>
                        context.read<ProfileBloc>().add(LoadProfile()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        UserProfile? p;
        var busy = false;

        if (state is ProfileLoaded) {
          p = state.profile;
        } else if (state is ProfileActionInProgress) {
          p = state.profile;
          busy = true;
        } else if (state is ProfileSaved) {
          p = state.profile;
        }

        if (p == null) {
          return const SizedBox.shrink();
        }

        if (!_fieldsFromNetwork) {
          _applyProfileTexts(p);
          _fieldsFromNetwork = true;
        }

        return Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 65,
                          backgroundColor: cs.surfaceContainerHighest,
                          backgroundImage: p.photoUrl.isNotEmpty
                              ? NetworkImage(p.photoUrl)
                              : null,
                          child: p.photoUrl.isEmpty
                              ? Text(
                                  _initials(p.fullName),
                                  style: TextStyle(
                                    color: cs.onSurface,
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : null,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FilledButton(
                                onPressed:
                                    busy ? null : () => _pickAvatar(context),
                                child: const Text('Change avatar'),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'JPG or PNG, max ~1MB recommended.',
                                style: TextStyle(
                                  color: cs.onSurface.withValues(alpha: 0.7),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    _labeledField(
                      context,
                      label: 'Full name',
                      controller: _fullName,
                      enabled: !busy,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Email',
                      style: TextStyle(
                        color: cs.onSurface,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: cs.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        p.email.isEmpty ? '—' : p.email,
                        style: TextStyle(
                          color: cs.onSurface.withValues(alpha: 0.85),
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _labeledField(
                      context,
                      label: 'Country',
                      controller: _country,
                      enabled: !busy,
                    ),
                    const SizedBox(height: 16),
                    _labeledField(
                      context,
                      label: 'Profession',
                      controller: _profession,
                      enabled: !busy,
                    ),
                    const SizedBox(height: 16),
                    _labeledField(
                      context,
                      label: 'Bio',
                      controller: _bio,
                      enabled: !busy,
                      maxLines: 4,
                    ),
                    const SizedBox(height: 32),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: FilledButton(
                        onPressed: busy
                            ? null
                            : () {
                                context.read<ProfileBloc>().add(
                                      SaveProfile(
                                        fullName: _fullName.text,
                                        country: _country.text,
                                        profession: _profession.text,
                                        bio: _bio.text,
                                      ),
                                    );
                              },
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                        ),
                        child: const Text('Update profile'),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            if (busy) const _BusyOverlay(),
          ],
        );
      },
    );
  }

  InputDecoration _fieldDecoration(BuildContext context, {required bool enabled}) {
    final cs = Theme.of(context).colorScheme;
    return InputDecoration(
      filled: true,
      fillColor: enabled ? cs.surface : cs.surfaceContainerHighest,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: cs.primary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  Widget _labeledField(
    BuildContext context, {
    required String label,
    required TextEditingController controller,
    required bool enabled,
    int maxLines = 1,
  }) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: cs.onSurface,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          enabled: enabled,
          decoration: _fieldDecoration(context, enabled: enabled),
          style: TextStyle(
            color: cs.onSurface,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}

class _BusyOverlay extends StatelessWidget {
  const _BusyOverlay();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black26,
      child: Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(width: 16),
                Text(
                  'Please wait…',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
