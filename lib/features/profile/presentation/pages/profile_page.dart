import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.surface,
                  ),
                  child: Center(
                    child: Text(
                      'AM',
                      style: TextStyle(
                        color: AppColors.onSurface,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Change Avatar'),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: 140,
                      child: Text(
                        'JPG, PNG or GIF. Max size 2MB',
                        style: TextStyle(
                          color: AppColors.onSurface,
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.visible,
                      ),
                    )
                  ],
                )
              ],
            ),
            const SizedBox(height: 32),
            
            // Full Name Input
            _buildTextInputField(
              label: 'Full name',
              initialValue: 'Adam Micheal',
            ),
            const SizedBox(height: 16),
            
            // Email Input
            _buildTextInputField(
              label: 'Email',
              initialValue: 'adam@example.com',
            ),
            const SizedBox(height: 16),
            
            // Country Input
            _buildTextInputField(
              label: 'Country',
              initialValue: 'South Africa',
            ),
            const SizedBox(height: 16),
            
            // Profession Input
            _buildTextInputField(
              label: 'Profession',
              initialValue: 'Electrician',
            ),
            const SizedBox(height: 16),
            
            // Bio Input (Multi-line)
            _buildTextInputField(
              label: 'Bio',
              initialValue: 'Electrical student earning through freelance work and weekend coaching.',
              maxLines: 4,
            ),
            const SizedBox(height: 32),
            
            // Update Profile Button
            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton(
                onPressed: () {
                  // Handle update profile action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
                child: const Text('Update Profile'),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildTextInputField({
    required String label,
    required String initialValue,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.onSurface,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: initialValue,
          maxLines: maxLines,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.surface,
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
              borderSide: BorderSide(
                color: AppColors.primary,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          style: TextStyle(
            color: AppColors.onSurface,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}