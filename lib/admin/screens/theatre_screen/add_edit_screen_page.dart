import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_ticket_booking/models/screen_model.dart';
import '../../../constants/api_routes.dart';
import '../../../constants/color.dart';
import '../../../services/api_client.dart';

class AddEditScreenPage extends StatefulWidget {
  final String theatreId;
  final ScreenModel? screen;

  const AddEditScreenPage({ super.key, required this.theatreId, this.screen });

  @override
  State<AddEditScreenPage> createState() => _AddEditScreenPageState();
}

class _AddEditScreenPageState extends State<AddEditScreenPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _totalSeatsController;
  bool _isLoading = false;

  bool get isEditMode => widget.screen != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.screen?.name ?? '');
    _totalSeatsController = TextEditingController(
      text: widget.screen?.totalSeats.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _totalSeatsController.dispose();
    super.dispose();
  }

  Future<void> _saveScreen() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final data = {
        'name': _nameController.text.trim(),
        'theatre_id': widget.theatreId,
        'total_seats': int.parse(_totalSeatsController.text),
      };

      if (isEditMode) {
        data['screen_id'] = widget.screen!.screenId;
      }

      final response = await ApiClient.dio.post(
        isEditMode ? ApiRoutes.updateScreen : ApiRoutes.addScreen,
        data: data,
      );

      if (response.data['success'] == true) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                isEditMode
                    ? 'Screen updated successfully'
                    : 'Screen added successfully',
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
          Navigator.pop(context, true);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Screen' : 'Add Screen'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Screen Name
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.tv, color: AppColors.primary, size: 20),
                        const SizedBox(width: 8),
                        const Text(
                          'Screen Information',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Screen Name',
                        hintText: 'e.g., Screen 1, IMAX Hall, Gold Class',
                        prefixIcon: const Icon(Icons.label_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: AppColors.primary,
                            width: 2,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter screen name';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Seating Capacity
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.event_seat, color: AppColors.primary, size: 20),
                        const SizedBox(width: 8),
                        const Text(
                          'Seating Capacity',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _totalSeatsController,
                      decoration: InputDecoration(
                        labelText: 'Total Seats',
                        hintText: 'Enter total number of seats',
                        prefixIcon: const Icon(Icons.airline_seat_recline_normal),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: AppColors.primary,
                            width: 2,
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter total seats';
                        }
                        final seats = int.tryParse(value);
                        if (seats == null || seats <= 0) {
                          return 'Please enter a valid number';
                        }
                        if (seats > 1000) {
                          return 'Maximum 1000 seats allowed';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Save Button
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveScreen,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 2,
                ),
                child: _isLoading
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                    : Text(
                  isEditMode ? 'Update Screen' : 'Add Screen',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}