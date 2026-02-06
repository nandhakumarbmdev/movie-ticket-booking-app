import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie_ticket_booking/shared/no_internet_screen.dart';
import 'package:provider/provider.dart';

import 'login.dart';
import '../users/screens/user_home_screen.dart';
import '../admin/screens/admin_home_screen.dart';
import '../providers/user_provider.dart';
import '../services/user_api.dart';
import '../shared/loader.dart';
import '../shared/error_state.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  late final Stream<User?> _authStream;
  Future<void>? _loadUserFuture;
  Future<bool>? _internetCheckFuture;

  @override
  void initState() {
    super.initState();
    _authStream = FirebaseAuth.instance.authStateChanges();
  }

  /// Loads backend user ONCE per login
  Future<void> _loadUser(BuildContext context, User firebaseUser) async {
    final userProvider = context.read<UserProvider>();

    // Guard: never reload if already present
    if (userProvider.user != null) return;

    final user = await UserApi.getUserByEmail(
      email: firebaseUser.email!,
    );

    userProvider.setUser(user);
  }

  /// Retry loading user data
  void _retry() {
    setState(() {
      _loadUserFuture = null;
      _internetCheckFuture = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _authStream,
      builder: (context, authSnapshot) {
        if (authSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Loader(content: "Checking authentication..."),
          );
        }

        if (!authSnapshot.hasData) {
          context.read<UserProvider>().clearUser();
          _loadUserFuture = null;

          return const LoginScreen();
        }

        final firebaseUser = authSnapshot.data!;
        final userProvider = context.watch<UserProvider>();

        _loadUserFuture ??= _loadUser(context, firebaseUser);

        return FutureBuilder<void>(
          future: _loadUserFuture,
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Loader(content: "Loading user data..."),
              );
            }

            if (userSnapshot.hasError) {
              _internetCheckFuture ??= hasInternet();

              return FutureBuilder<bool>(
                future: _internetCheckFuture,
                builder: (context, netSnapshot) {
                  if (netSnapshot.connectionState == ConnectionState.waiting) {
                    return const Scaffold(
                      body: Loader(content: "Checking internet connection..."),
                    );
                  }
                  final isOnline = netSnapshot.data ?? false;
                  if (!isOnline) {
                    return Scaffold(
                      body: Center(
                        child: NoInternetScreen(
                          onRetry: _retry,
                        ),
                      ),
                    );
                  }
                  return ErrorState();
                },
              );
            }

            final user = userProvider.user!;

            if (user.role == "admin") {
              return const AdminHomeScreen();
            }

            return const UserHomeScreen();
          },
        );
      },
    );
  }
}

Future<bool> hasInternet() async {
  final result = await Connectivity().checkConnectivity();
  return result != ConnectivityResult.none;
}