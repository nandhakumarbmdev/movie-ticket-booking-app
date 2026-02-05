import 'package:flutter/material.dart';

import '../../../models/user_model.dart';
import 'profile_editable_field.dart';
import 'profile_info_tile.dart';

class ProfileInfoCard extends StatelessWidget {
  final UserModel user;
  final bool isEditing;
  final bool isLoading;
  final TextEditingController nameController;
  final TextEditingController addressController;
  final VoidCallback onCancelEdit;
  final VoidCallback onSave;

  const ProfileInfoCard({
    super.key,
    required this.user,
    required this.isEditing,
    required this.isLoading,
    required this.nameController,
    required this.addressController,
    required this.onCancelEdit,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // NAME
            isEditing
                ? ProfileEditableField(
              icon: Icons.person_outline,
              label: 'Name',
              controller: nameController,
            )
                : ProfileInfoTile(
              icon: Icons.person_outline,
              label: 'Name',
              value: user.name,
            ),

            const SizedBox(height: 16),

            // ADDRESS
            isEditing
                ? ProfileEditableField(
              icon: Icons.location_on_outlined,
              label: 'Address',
              controller: addressController,
              maxLines: 3,
            )
                : ProfileInfoTile(
              icon: Icons.location_on_outlined,
              label: 'Address',
              value: user.address.isNotEmpty
                  ? user.address
                  : 'Not provided',
            ),

            if (isEditing) ...[
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: isLoading ? null : onSave,
                  child: isLoading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : const Text('Save'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
