import 'package:flutter/material.dart';
import 'package:movie_ticket_booking/models/screen_model.dart';
import 'package:movie_ticket_booking/constants/api_routes.dart';
import 'package:movie_ticket_booking/services/api_client.dart';
import '../../../constants/color.dart';
import '../../widgets/theatre/screen_card.dart';
import 'add_edit_screen_page.dart';

class Screens extends StatefulWidget {
  final String theatreId;
  final String theatreName;

  const Screens({ super.key, required this.theatreId, required this.theatreName });

  @override
  State<Screens> createState() => _ScreensState();
}

class _ScreensState extends State<Screens> {
  List<ScreenModel> screens = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadScreens();
  }

  Future<void> _loadScreens() async {
    setState(() => isLoading = true);
    try {
      final response = await ApiClient.dio.post(
        ApiRoutes.getScreenByTheatre,
        data: {
          'theatre_id': widget.theatreId,
        },
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        setState(() {
          screens = (response.data['data'] as List)
              .map((json) => ScreenModel.fromJson(json))
              .toList();
        });
      }
    } catch (e) {
      _showError('Failed to load screens: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _deleteScreen(String screenId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Screen'),
        content: const Text('Are you sure you want to delete this screen?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      final response = await ApiClient.dio.post(
        ApiRoutes.deleteScreen,
        data: {
          'screen_id': screenId,
        },
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        _showSuccess('Screen deleted successfully');  // Added success message
        _loadScreens();
      } else {
        _showError(response.data['message'] ?? 'Failed to delete screen');
      }
    } catch (e) {
      _showError('Error: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _showSuccess(String message) {  // Added success message helper
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _navigateToAddEdit({ScreenModel? screen}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditScreenPage(
          theatreId: widget.theatreId,
          screen: screen,
        ),
      ),
    );

    if (result == true) {
      _loadScreens();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Screens'),
            Text(
              widget.theatreName,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
      )
          : screens.isEmpty
          ? _buildEmptyState()
          : RefreshIndicator(
        onRefresh: _loadScreens,
        color: AppColors.primary,
        child: ListView.builder(
          padding: const EdgeInsets.only(top: 16, bottom: 80),
          itemCount: screens.length,
          itemBuilder: (context, index) {
            final screen = screens[index];
            return AdminScreenCard(
              screen: screen,
              onEdit: () => _navigateToAddEdit(screen: screen),
              onDelete: () => _deleteScreen(screen.screenId),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToAddEdit(),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Screen'),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.tv_off,
              size: 64,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No Screens Found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first screen to get started',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}