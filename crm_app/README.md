# CRM Application - Flutter

A complete architectural project management CRM application built with Flutter and Supabase.

## Features

✅ **Multi-Role Authentication**
- Architect (Admin access)
- HR/Admin (Full management)
- Staff (Limited access to assigned projects)

✅ **Project Management**
- Create, read, update, delete projects
- Track project categories (Architectural Design, Design+Licensing, PMC)
- Support for 3 project types (Residential, Commercial, Hospital)
- Project status tracking (Active, On Hold, Completed)

✅ **Client Management**
- Client database
- Link clients to projects
- Track client information

✅ **Staff Assignment**
- Assign staff to projects (minimum 4 per project)
- Track staff roles and responsibilities
- Staff can only see assigned projects

✅ **Real-time Messaging**
- Send messages from Architect/Admin to Staff
- Real-time notifications for staff
- Message history tracking

✅ **User Dashboards**
- Role-specific dashboards
- Project statistics
- Quick actions based on user role

## Project Structure

```
crm_app/
├── lib/
│   ├── config/
│   │   └── constants.dart          # App constants, colors, and configuration
│   ├── models/
│   │   ├── user_model.dart         # User data model
│   │   ├── project_model.dart      # Project data model
│   │   ├── client_model.dart       # Client data model
│   │   ├── message_model.dart      # Message data model
│   │   └── project_staff_model.dart # Staff assignment model
│   ├── providers/
│   │   └── auth_provider.dart      # Authentication state management
│   ├── routes/
│   │   └── router.dart             # App routing configuration
│   ├── screens/
│   │   ├── auth/
│   │   │   ├── login_screen.dart   # Login screen
│   │   │   └── register_screen.dart # Registration screen
│   │   ├── dashboard/
│   │   │   └── dashboard_screen.dart # Main dashboard
│   │   ├── projects/
│   │   │   ├── projects_list_screen.dart
│   │   │   ├── project_details_screen.dart
│   │   │   └── create_project_screen.dart
│   │   ├── clients/
│   │   │   ├── clients_list_screen.dart
│   │   │   └── client_details_screen.dart
│   │   ├── messages/
│   │   │   └── messages_screen.dart
│   │   └── profile/
│   │       └── profile_screen.dart
│   ├── widgets/
│   │   └── base_scaffold.dart      # Reusable base layout with hamburger menu
│   └── main.dart                   # App entry point
├── pubspec.yaml                    # Dependencies
└── README.md                       # This file
```

## Prerequisites

- Flutter 3.0 or higher
- Dart 3.0 or higher
- Android Studio / Xcode (for mobile development)
- A Supabase account (free tier available)

## Test Credentials

Use these credentials to test the app after setup:

| Role | Email | Password | Access Level |
|------|-------|----------|--------------|
| **Architect** | `architect@example.com` | `password123` | Admin (Full Control) |
| **HR/Admin** | `admin@example.com` | `password123` | Admin (Full Control) |
| **HR** | `hr@example.com` | `password123` | Admin (Full Control) |
| **Staff 1** | `staff1@example.com` | `password123` | Limited (Assigned Projects Only) |
| **Staff 2** | `staff2@example.com` | `password123` | Limited (Assigned Projects Only) |
| **Staff 3** | `staff3@example.com` | `password123` | Limited (Assigned Projects Only) |
| **Staff 4** | `staff4@example.com` | `password123` | Limited (Assigned Projects Only) |

**Note**: These credentials are for development/testing only. Create real credentials before deploying to production.

---

## Getting Started

### 1. Clone the Repository

```bash
git clone <repository-url>
cd CRM_APP-STUDIO-ARCH/crm_app
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Set Up Supabase

Follow the **[SUPABASE_SETUP_GUIDE.md](../SUPABASE_SETUP_GUIDE.md)** to:
1. Create a Supabase project
2. Set up database tables
3. Configure authentication
4. Set up RLS policies

### 4. Configure App Constants

Edit `lib/config/constants.dart` and replace the Supabase credentials:

```dart
class AppConstants {
  static const String supabaseUrl = 'YOUR_PROJECT_URL';
  static const String supabaseAnonKey = 'YOUR_ANON_KEY';
  // ...
}
```

### 5. Run the App

```bash
flutter run
```

Or for specific device:
```bash
flutter run -d chrome          # Web
flutter run -d android-device  # Android
flutter run -d ios            # iOS
```

## Usage

### Login

1. Launch the app
2. You'll be on the Login screen
3. Enter email and password
4. Click **Login**

**Test Credentials:**
```
Email: architect@example.com
Password: password123
```

### Navigation

Use the hamburger menu (☰) to navigate between:
- Dashboard
- Projects
- Clients
- Messages
- My Profile
- Settings
- Logout

### Creating a Project (Admin/Architect only)

1. Click the **+** button (FAB) or go to Projects → Create
2. Fill in project details:
   - Project name
   - Category
   - Type
   - Location
   - Area
   - Status
3. Click **Create Project**

### Assigning Staff (Admin/Architect only)

1. Go to a project
2. Scroll to "Assigned Staff"
3. Click to add staff members
4. Select staff and assign roles

### Sending Messages (Admin/Architect only)

1. Go to Messages
2. Click the "Send Message" tab
3. Select recipient (or broadcast to all staff)
4. Type your message
5. Click **Send Message**

### Viewing Assigned Projects (Staff only)

1. Go to Dashboard
2. See only projects you're assigned to
3. Click on project to view details

## Architecture

### State Management
- **Provider** - For authentication state and user management

### Navigation
- **GoRouter** - For declarative routing

### Database
- **Supabase** - Backend as a Service (BaaS)

### Authentication
- **Supabase Auth** - Email/password authentication with JWT tokens

## Key Technologies

| Feature | Technology |
|---------|-----------|
| UI Framework | Flutter with Material Design 3 |
| State Management | Provider |
| Routing | GoRouter |
| Backend | Supabase (PostgreSQL + Auth) |
| Real-time | Supabase Realtime |
| Authentication | JWT (Supabase Auth) |
| Storage | Supabase Storage (optional) |

## API Integration

The app uses Supabase REST API and real-time subscriptions. Main operations:

- **Auth**: Login, Register, Logout, Password Reset
- **Projects**: CRUD operations with role-based filtering
- **Clients**: CRUD operations
- **Staff Assignment**: Create and manage staff assignments
- **Messages**: Send and receive messages with real-time updates

## Development

### Adding a New Feature

1. Create models in `lib/models/`
2. Create provider/service in `lib/providers/`
3. Create screens in `lib/screens/<feature>/`
4. Update router in `lib/routes/router.dart`
5. Add navigation items to `lib/widgets/base_scaffold.dart`

### Database Queries

Supabase queries use REST API:

```dart
// Read data
final data = await supabase
  .from('projects')
  .select()
  .eq('status', 'active');

// Insert data
await supabase
  .from('projects')
  .insert({'project_name': 'New Project', ...});

// Update data
await supabase
  .from('projects')
  .update({'status': 'completed'})
  .eq('id', projectId);

// Delete data
await supabase
  .from('projects')
  .delete()
  .eq('id', projectId);
```

### Real-time Subscriptions

```dart
supabase
  .channel('projects')
  .onPostgresChanges(
    event: PostgresChangeEvent.all,
    schema: 'public',
    table: 'projects',
    callback: (payload) {
      // Handle real-time updates
    },
  )
  .subscribe();
```

## Troubleshooting

### "Invalid API key" Error
- Check that supabaseUrl and supabaseAnonKey are correct in `constants.dart`
- Make sure you copied from the correct Supabase project

### "User not found" Error
- Ensure the user exists in Supabase Auth → Users
- Check that the user record exists in the `users` table

### "Permission denied" Error
- Check RLS policies in Supabase
- Make sure the user's role is correct

### "Connection timeout" Error
- Check internet connection
- Verify Supabase project is running
- Try restarting the app

## Performance Optimization

1. **Pagination**: Implement pagination for large lists
2. **Caching**: Cache frequently accessed data locally
3. **Lazy Loading**: Load images and data on demand
4. **Compression**: Compress images before upload

## Security

✅ **Best Practices Implemented:**
- JWT token-based authentication
- Row Level Security (RLS) policies
- Environment variable protection
- User role validation
- Input validation and sanitization

## Deployment

### Android Release

```bash
flutter build apk
# or
flutter build appbundle  # for Google Play
```

### iOS Release

```bash
flutter build ios --release
```

### Web Deployment

```bash
flutter build web
# Deploy the `build/web` folder to your web server
```

## Contributing

1. Create a feature branch
2. Commit your changes
3. Push to the branch
4. Create a Pull Request

## License

This project is proprietary and confidential.

## Support

For issues or questions:
1. Check the Supabase documentation
2. Review the SUPABASE_SETUP_GUIDE.md
3. Check Flutter documentation at flutter.dev

## Version History

- **v1.0.0** (June 18, 2026) - Initial release
  - Multi-role authentication
  - Project management
  - Staff assignment
  - Messaging system
  - Client management
  - Dashboard with statistics

---

**Last Updated**: June 18, 2026

**Author**: Development Team

**Client**: High Profile CRM App Project
