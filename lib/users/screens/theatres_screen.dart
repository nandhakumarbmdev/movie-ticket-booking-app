import 'package:flutter/material.dart';
import 'package:movie_ticket_booking/models/theatre_model.dart';
import 'package:movie_ticket_booking/shared/loader.dart';
import 'package:movie_ticket_booking/users/screens/movies_by_theatre_screen.dart';
import '/constants/api_routes.dart';
import '/services/api_client.dart';
import '../../constants/color.dart';

class TheatresScreen extends StatefulWidget {
  const TheatresScreen({super.key});

  @override
  State<TheatresScreen> createState() => _TheatresScreenState();
}

class _TheatresScreenState extends State<TheatresScreen> {
  bool _loading = true;
  List<TheatreModel> _theatres = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchTheatres();
  }

  Future<void> _fetchTheatres() async {
    if (!mounted) return;

    setState(() => _loading = true);

    try {
      final response = await ApiClient.dio.post(ApiRoutes.getAllTheatres);

      if (mounted) {
        final List<dynamic> data = response.data['data'] ?? [];
        setState(() {
          _theatres = data.map((json) => TheatreModel.fromJson(json)).toList();
          _loading = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching theatres: $e');
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  List<TheatreModel> get _filteredTheatres {
    if (_searchQuery.isEmpty) return _theatres;

    final query = _searchQuery.toLowerCase();
    return _theatres.where((theatre) {
      return theatre.name.toLowerCase().contains(query) ||
          theatre.city.toLowerCase().contains(query) ||
          theatre.address.toLowerCase().contains(query);
    }).toList();
  }

  void _handleTheatreSelection(TheatreModel theatre) {
    if (!theatre.isActive) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MoviesByTheatreScreen(
          theatreId: theatre.theatreId,
          theatreName: theatre.name, // Optional: pass name for display
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.whiteColor,
      title: const Text(
        'Theatres',
        style: TextStyle(
          color: Color(0xFF1F1F1F),
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          color: AppColors.whiteColor,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: _buildSearchBar(),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        onChanged: (value) => setState(() => _searchQuery = value),
        decoration: InputDecoration(
          hintText: 'Search for theatres',
          hintStyle: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey[600],
            size: 20,
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
            icon: Icon(
              Icons.clear,
              color: Colors.grey[600],
              size: 20,
            ),
            onPressed: () => setState(() => _searchQuery = ''),
          )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(
        child: Loader(content: "Loading theatres..."),
      );
    }

    if (_theatres.isEmpty) {
      return _buildEmptyState(
        icon: Icons.theater_comedy_outlined,
        title: 'No theatres available',
        subtitle: 'Check back later',
      );
    }

    if (_filteredTheatres.isEmpty) {
      return _buildEmptyState(
        icon: Icons.search_off,
        title: 'No theatres found',
        subtitle: 'Try a different search term',
      );
    }

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: _fetchTheatres,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _filteredTheatres.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return TheatreCard(
            theatre: _filteredTheatres[index],
            onTap: () => _handleTheatreSelection(_filteredTheatres[index]),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState({ required IconData icon, required String title, required String subtitle }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
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

// Separate widget for better reusability and performance
class TheatreCard extends StatelessWidget {
  final TheatreModel theatre;
  final VoidCallback onTap;

  const TheatreCard({ super.key, required this.theatre, required this.onTap });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: theatre.isActive ? onTap : null,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                if (theatre.address.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _buildAddress(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.local_movies_outlined,
            color: AppColors.primary,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      theatre.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F1F1F),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (!theatre.isActive) _buildClosedBadge(),
                ],
              ),
              if (theatre.city.isNotEmpty) ...[
                const SizedBox(height: 4),
                _buildCityInfo(),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildClosedBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Text(
        'Closed',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: Colors.black54,
        ),
      ),
    );
  }

  Widget _buildCityInfo() {
    return Row(
      children: [
        Icon(
          Icons.location_city,
          size: 12,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 4),
        Text(
          theatre.city,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildAddress() {
    return Row(
      children: [
        Icon(
          Icons.location_on_outlined,
          size: 16,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            theatre.address,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}