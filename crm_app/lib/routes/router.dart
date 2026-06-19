import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/projects/projects_list_screen.dart';
import '../screens/projects/project_details_screen.dart';
import '../screens/projects/create_project_screen.dart';
import '../screens/clients/clients_list_screen.dart';
import '../screens/clients/client_details_screen.dart';
import '../screens/messages/messages_screen.dart';
import '../screens/profile/profile_screen.dart';

GoRouter createRouter() {
  return GoRouter(
    redirect: (context, state) {
      final authProvider = context.read<AuthProvider>();
      final isAuthenticated = authProvider.isAuthenticated;
      final isLoggingIn = state.matchedLocation == '/login';
      final isRegistering = state.matchedLocation == '/register';

      // If not authenticated and not on auth screens, redirect to login
      if (!isAuthenticated && !isLoggingIn && !isRegistering) {
        return '/login';
      }

      // If authenticated and on auth screens, redirect to dashboard
      if (isAuthenticated && (isLoggingIn || isRegistering)) {
        return '/dashboard';
      }

      // Otherwise, allow the route
      return null;
    },
    routes: [
      // Auth Routes
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      // Main Routes
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),

      // Project Routes
      GoRoute(
        path: '/projects',
        builder: (context, state) => const ProjectsListScreen(),
      ),
      GoRoute(
        path: '/projects/create',
        builder: (context, state) => const CreateProjectScreen(),
      ),
      GoRoute(
        path: '/projects/:id',
        builder: (context, state) {
          final projectId = state.pathParameters['id']!;
          return ProjectDetailsScreen(projectId: projectId);
        },
      ),

      // Client Routes
      GoRoute(
        path: '/clients',
        builder: (context, state) => const ClientsListScreen(),
      ),
      GoRoute(
        path: '/clients/:id',
        builder: (context, state) {
          final clientId = state.pathParameters['id']!;
          return ClientDetailsScreen(clientId: clientId);
        },
      ),

      // Message Routes
      GoRoute(
        path: '/messages',
        builder: (context, state) => const MessagesScreen(),
      ),

      // Profile Route
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  );
}
