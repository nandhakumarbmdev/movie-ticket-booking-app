import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:movie_ticket_booking/models/theatre_model.dart';
import 'package:movie_ticket_booking/services/theatre_api.dart';
import 'package:movie_ticket_booking/constants/color.dart';

class TheatreFormScreen extends StatefulWidget {
  final TheatreModel? theatre;

  const TheatreFormScreen({ super.key, this.theatre });

  @override
  State<TheatreFormScreen> createState() => _TheatreFormScreenState();
}

class _TheatreFormScreenState extends State<TheatreFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _cityController;
  late final TextEditingController _addressController;

  late bool _isActive;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    final theatre = widget.theatre;

    _nameController = TextEditingController(text: theatre?.name ?? '');
    _cityController = TextEditingController(text: theatre?.city ?? '');
    _addressController = TextEditingController(text: theatre?.address ?? '');
    _isActive = theatre?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _saveTheatre() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final payload = {
      'name': _nameController.text.trim(),
      'city': _cityController.text.trim(),
      'address': _addressController.text.trim(),
      'is_active': _isActive,
    };

    try {
      if (!mounted) return;

      if (widget.theatre == null) {
        await TheatreService.createTheatre(payload);
      } else {
        await TheatreService.updateTheatre(widget.theatre!.theatreId, payload);
      }

      if (!mounted) return;

      _showSnackBar( widget.theatre == null ? 'Theatre created successfully' : 'Theatre updated successfully');

      Navigator.pop(context, true);
    } on DioException {
      if (!mounted) return;

      _showSnackBar("Failed to save theatre", isError: true);
    } catch (e) {
      if (!mounted) return;
      _showSnackBar('An unexpected error occurred', isError: true);
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.theatre != null;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Theatre' : 'Add Theatre'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                controller: _nameController,
                label: 'Theatre Name',
                hint: 'Enter theatre name',
                icon: Icons.business,
                validator: (v) =>
                v == null || v.trim().isEmpty ? 'Name is required' : null,
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _cityController,
                label: 'City',
                hint: 'Enter city name',
                icon: Icons.location_city,
                validator: (v) =>
                v == null || v.trim().isEmpty ? 'City is required' : null,
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _addressController,
                label: 'Address',
                hint: 'Enter complete address',
                icon: Icons.location_on,
                maxLines: 3,
                validator: (v) =>
                v == null || v.trim().isEmpty ? 'Address is required' : null,
              ),
              const SizedBox(height: 20),

              // Active Status
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: SwitchListTile(
                  title: const Text(
                    'Active Status',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    _isActive
                        ? 'Theatre is visible to users'
                        : 'Theatre is hidden from users',
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                  value: _isActive,
                  activeColor: AppColors.primary,
                  onChanged: (v) => setState(() => _isActive = v),
                ),
              ),
              const SizedBox(height: 32),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveTheatre,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: AppColors.primary.withOpacity(0.6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: _isSaving
                      ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                      : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(isEditing ? Icons.check : Icons.add, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        isEditing ? 'Update Theatre' : 'Create Theatre',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
    );
  }
}