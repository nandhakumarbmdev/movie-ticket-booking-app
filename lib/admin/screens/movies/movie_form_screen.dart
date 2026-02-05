import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:movie_ticket_booking/models/movie_model.dart';
import 'package:movie_ticket_booking/constants/color.dart';

import '../../../services/movie_api.dart';

class MovieFormScreen extends StatefulWidget {
  final MovieModel? movie;

  const MovieFormScreen({ super.key, this.movie });

  @override
  State<MovieFormScreen> createState() => _MovieFormScreenState();
}

class _MovieFormScreenState extends State<MovieFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _durationController;
  late final TextEditingController _languageController;
  late final TextEditingController _posterUrlController;

  late DateTime _releaseDate;
  late bool _isActive;
  bool _isSaving = false;

  List<String> _selectedGenres = [];

  final List<String> _availableGenres = ['Action', 'Adventure', 'Animation', 'Comedy', 'Crime', 'Documentary', 'Drama', 'Fantasy',
    'Horror',
    'Mystery',
    'Romance',
    'Sci-Fi',
    'Thriller',
    'Western',
  ];

  @override
  void initState() {
    super.initState();

    final movie = widget.movie;

    _titleController = TextEditingController(text: movie?.title ?? '');
    _descriptionController = TextEditingController(text: movie?.description ?? '');
    _durationController = TextEditingController(
      text: movie?.durationMinutes.toString() ?? '',
    );
    _languageController = TextEditingController(text: movie?.language ?? '');
    _posterUrlController = TextEditingController(text: movie?.posterUrl ?? '');
    _releaseDate = movie?.releaseDate ?? DateTime.now();
    _isActive = movie?.isActive ?? true;
    _selectedGenres = movie != null ? List<String>.from(movie.genre) : [];
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _durationController.dispose();
    _languageController.dispose();
    _posterUrlController.dispose();
    super.dispose();
  }

  Future<void> _saveMovie() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedGenres.isEmpty) {
      _showSnackBar('Please select at least one genre', isError: true);
      return;
    }

    setState(() => _isSaving = true);

    final payload = {
      'title': _titleController.text.trim(),
      'description': _descriptionController.text.trim(),
      'duration_minutes': int.parse(_durationController.text),
      'genre': _selectedGenres,
      'language': _languageController.text.trim(),
      'poster_url': _posterUrlController.text.trim(),
      'release_date': _releaseDate.toIso8601String(),
      'is_active': _isActive,
    };

    try {
      if (!mounted) return;

      if (widget.movie == null) {
        // Create new movie
        await MovieApi.createMovie(payload);
      } else {
        // Update existing movie
        await MovieApi.updateMovie(widget.movie!.movieId, payload);
      }

      if (!mounted) return;

      _showSnackBar(
        widget.movie == null
            ? 'Movie created successfully'
            : 'Movie updated successfully',
      );

      Navigator.pop(context, true);
    } on DioException catch (e) {
      if (!mounted) return;

      final message = e.response?.data?['message'] ??
          e.message ??
          'Failed to save movie';

      _showSnackBar(message, isError: true);
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

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _releaseDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => _releaseDate = picked);
    }
  }

  void _toggleGenre(String genre) {
    setState(() {
      _selectedGenres.contains(genre)
          ? _selectedGenres.remove(genre)
          : _selectedGenres.add(genre);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.movie != null;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Movie' : 'Add Movie'),
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
                controller: _titleController,
                label: 'Title',
                hint: 'Enter movie title',
                icon: Icons.movie,
                validator: (v) =>
                v == null || v.trim().isEmpty ? 'Title is required' : null,
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _descriptionController,
                label: 'Description',
                hint: 'Enter movie description',
                icon: Icons.description,
                maxLines: 4,
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _durationController,
                      label: 'Duration (min)',
                      hint: '120',
                      icon: Icons.access_time,
                      keyboardType: TextInputType.number,
                      validator: (v) => int.tryParse(v ?? '') == null
                          ? 'Enter valid duration'
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      controller: _languageController,
                      label: 'Language',
                      hint: 'English',
                      icon: Icons.language,
                      validator: (v) => v == null || v.trim().isEmpty
                          ? 'Language is required'
                          : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _posterUrlController,
                label: 'Poster URL',
                hint: 'https://example.com/poster.jpg',
                icon: Icons.image,
                validator: (v) => v == null || v.trim().isEmpty
                    ? 'Poster URL is required'
                    : null,
              ),
              const SizedBox(height: 16),

              // Release Date Picker
              InkWell(
                onTap: _selectDate,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today, color: AppColors.primary, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Release Date',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${_releaseDate.day}/${_releaseDate.month}/${_releaseDate.year}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Genres Section
              Text(
                'Select Genres',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 12),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _availableGenres.map((genre) {
                  final isSelected = _selectedGenres.contains(genre);
                  return FilterChip(
                    label: Text(genre),
                    selected: isSelected,
                    onSelected: (_) => _toggleGenre(genre),
                    selectedColor: AppColors.primary.withOpacity(0.2),
                    checkmarkColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? AppColors.primary : Colors.grey[700],
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                    side: BorderSide(
                      color: isSelected ? AppColors.primary : Colors.grey[300]!,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  );
                }).toList(),
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
                        ? 'Movie is visible to users'
                        : 'Movie is hidden from users',
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
                  onPressed: _isSaving ? null : _saveMovie,
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
                        isEditing ? 'Update Movie' : 'Create Movie',
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