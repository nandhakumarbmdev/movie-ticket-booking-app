import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '/admin/screens/theatre_screen/screens.dart';
import '/shared/loader.dart';
import 'package:provider/provider.dart';
import '/models/theatre_model.dart';
import '/providers/theatre_provider.dart';
import '/constants/color.dart';
import '/constants/api_routes.dart';
import '/services/api_client.dart';
import '../../../shared/confirmation_dialog.dart';
import '../../widgets/theatre/admin_theatre_card.dart';
import 'theatre_form_screen.dart';

class TheatreScreen extends StatefulWidget {
  const TheatreScreen({super.key});

  @override
  State<TheatreScreen> createState() => _TheatreScreenState();
}

class _TheatreScreenState extends State<TheatreScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TheatreProvider>().loadTheatres();
    });
  }

  Future<void> _refreshTheatres() async {
    await context.read<TheatreProvider>().loadTheatres(refresh: true);
  }

  Future<void> _deleteTheatre(String id) async {
    try {
      await ApiClient.dio.post(ApiRoutes.deleteTheatre, data: {'theatre_id': id});

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Theatre deleted successfully'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );

      await _refreshTheatres();
    } on DioException catch (e) {
      if (!mounted) return;

      final message = e.response?.data?['message'] ??
          e.message ??
          'Failed to delete theatre';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('An unexpected error occurred'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  void _showDeleteConfirmation(TheatreModel theatre) {
    ConfirmationDialog(
      context: context,
      title: 'Delete Theatre',
      message: 'Are you sure you want to delete "${theatre.name}"?',
      onDelete: () => _deleteTheatre(theatre.theatreId),
    );
  }


  void _navigateToAddEdit({TheatreModel? theatre}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TheatreFormScreen(theatre: theatre),
      ),
    );

    if (result == true) {
      _refreshTheatres();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Consumer<TheatreProvider>(
        builder: (context, theatreProvider, child) {
          // Loading state (initial load)
          if (theatreProvider.loading && theatreProvider.theatres.isEmpty) return Loader(content: "Loading theatres...");

          // Empty state
          if (theatreProvider.theatres.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.business_outlined,
                      size: 100,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'No theatres found',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Add your first theatre to get started',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[500],
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      onPressed: () => _navigateToAddEdit(),
                      icon: const Icon(Icons.add, size: 20),
                      label: const Text(
                        'Add Theatre',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // Theatres list
          return RefreshIndicator(
            onRefresh: _refreshTheatres,
            color: AppColors.primary,
            child: Stack(
              children: [
                ListView.builder(
                  padding: const EdgeInsets.only(
                    top: 8,
                    bottom: 80,
                  ),
                  itemCount: theatreProvider.theatres.length,
                  itemBuilder: (context, index) {
                    final theatre = theatreProvider.theatres[index];
                    return AdminTheatreCard(
                      theatre: theatre,
                      onEdit: () => _navigateToAddEdit(theatre: theatre),
                      onDelete: () => _showDeleteConfirmation(theatre),
                      onViewScreens: () { Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Screens(theatreId: theatre.theatreId, theatreName: theatre.name),
                        ),
                      ); }
                    );
                  },
                ),

                // Centered loading indicator during refresh
                if (theatreProvider.loading && theatreProvider.theatres.isNotEmpty)
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Loader(content: "Refreshing")
                    ),
                  ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToAddEdit(),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add, size: 22),
        label: const Text(
          'Add Theatre',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        elevation: 4,
      ),
    );
  }
}