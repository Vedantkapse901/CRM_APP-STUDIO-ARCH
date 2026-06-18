# CRM App - Supabase Setup Guide

This guide will help you set up Supabase for the CRM application. Follow each step carefully.

---

## Table of Contents

1. [Create Supabase Project](#create-supabase-project)
2. [Database Tables Setup](#database-tables-setup)
3. [Authentication Configuration](#authentication-configuration)
4. [Row Level Security (RLS) Policies](#row-level-security-rls-policies)
5. [Connect Flutter App to Supabase](#connect-flutter-app-to-supabase)
6. [Test the Connection](#test-the-connection)

---

## Create Supabase Project

### Step 1: Sign Up / Login to Supabase

1. Go to [https://supabase.com](https://supabase.com)
2. Click **"Sign Up"** or **"Login"** with your GitHub or email
3. Create a new account if needed

### Step 2: Create a New Project

1. Click **"New Project"** button
2. Fill in the following details:
   - **Project Name**: `CRM App` (or your preferred name)
   - **Database Password**: Create a strong password (save this!)
   - **Region**: Choose region closest to your location
3. Click **"Create New Project"**
4. Wait for the project to be initialized (1-2 minutes)

### Step 3: Get Your Credentials

Once the project is created:

1. Go to **Settings** → **API**
2. Copy the following values (you'll need them later):
   - **Project URL** (looks like: `https://xxxxx.supabase.co`)
   - **anon key** (public API key)
   - **service_role key** (for backend operations)

**Save these securely!** You'll use them to configure the Flutter app.

---

## Database Tables Setup

Now we'll create all the necessary tables for the CRM app.

### Step 1: Access SQL Editor

1. In Supabase Dashboard, go to **SQL Editor**
2. Click **"New Query"**

### Step 2: Create Users Table

Copy and paste this SQL query:

```sql
CREATE TABLE users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email VARCHAR(255) NOT NULL UNIQUE,
  full_name VARCHAR(255) NOT NULL,
  role VARCHAR(50) NOT NULL CHECK (role IN ('architect', 'admin', 'hr', 'staff')),
  phone VARCHAR(20),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create index for role-based queries
CREATE INDEX idx_users_role ON users(role);

-- Create trigger to update updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
```

Click **"Run"** to execute.

### Step 3: Create Clients Table

Click **"New Query"** and paste:

```sql
CREATE TABLE clients (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  client_name VARCHAR(255) NOT NULL,
  contact_person VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL,
  phone VARCHAR(20) NOT NULL,
  address TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create index for searching
CREATE INDEX idx_clients_name ON clients(client_name);
```

Click **"Run"**.

### Step 4: Create Projects Table

Click **"New Query"** and paste:

```sql
CREATE TABLE projects (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_name VARCHAR(255) NOT NULL,
  category VARCHAR(50) NOT NULL CHECK (category IN ('architectural_design', 'design_licensing', 'pmc')),
  type VARCHAR(50) NOT NULL CHECK (type IN ('residential', 'commercial', 'hospital')),
  location TEXT NOT NULL,
  area DECIMAL(10, 2) NOT NULL,
  consultant_id UUID NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
  consultant_name VARCHAR(255) NOT NULL,
  client_id UUID NOT NULL REFERENCES clients(id) ON DELETE RESTRICT,
  client_name VARCHAR(255) NOT NULL,
  status VARCHAR(50) NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'on_hold', 'completed')),
  staff_count INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX idx_projects_consultant ON projects(consultant_id);
CREATE INDEX idx_projects_client ON projects(client_id);
CREATE INDEX idx_projects_status ON projects(status);
CREATE INDEX idx_projects_category ON projects(category);
CREATE INDEX idx_projects_type ON projects(type);

-- Trigger for updated_at
CREATE TRIGGER update_projects_updated_at BEFORE UPDATE ON projects
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
```

Click **"Run"**.

### Step 5: Create Project Staff Assignment Table

Click **"New Query"** and paste:

```sql
CREATE TABLE project_staff (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  staff_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  staff_name VARCHAR(255) NOT NULL,
  role VARCHAR(255) NOT NULL,
  assigned_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  assigned_by UUID NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
  UNIQUE(project_id, staff_id)
);

-- Indexes
CREATE INDEX idx_project_staff_project ON project_staff(project_id);
CREATE INDEX idx_project_staff_staff ON project_staff(staff_id);
```

Click **"Run"**.

### Step 6: Create Messages Table

Click **"New Query"** and paste:

```sql
CREATE TABLE messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  sender_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  sender_name VARCHAR(255) NOT NULL,
  recipient_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  project_id UUID REFERENCES projects(id) ON DELETE CASCADE,
  message_text TEXT NOT NULL,
  is_broadcast BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  read_at TIMESTAMP WITH TIME ZONE
);

-- Indexes
CREATE INDEX idx_messages_sender ON messages(sender_id);
CREATE INDEX idx_messages_recipient ON messages(recipient_id);
CREATE INDEX idx_messages_project ON messages(project_id);
CREATE INDEX idx_messages_created_at ON messages(created_at DESC);
```

Click **"Run"**.

---

## Authentication Configuration

### Step 1: Enable Email Authentication

1. Go to **Authentication** → **Providers**
2. Make sure **Email** is enabled (it should be by default)
3. Go to **Authentication** → **Email Templates**
4. Review the email templates (confirm email, password reset, etc.)

### Step 2: Configure Auth Settings

1. Go to **Authentication** → **Settings**
2. Configure the following:
   - **Site URL**: `http://localhost:5000` (for development)
   - **Redirect URLs**: Add your app's redirect URL (e.g., `io.supabase.crm://login`)
   - **JWT expiration**: Set to 3600 (1 hour) or your preference
   - **Refresh token rotation**: Enable
   - **Enable signup**: Keep enabled

### Step 3: Create Test Users

1. Go to **Authentication** → **Users**
2. Click **"Add user"**
3. Create test users with the credentials below:

| Role | Email | Password |
|------|-------|----------|
| Architect | `architect@example.com` | `password123` |
| Admin | `admin@example.com` | `password123` |
| HR | `hr@example.com` | `password123` |
| Staff 1 | `staff1@example.com` | `password123` |
| Staff 2 | `staff2@example.com` | `password123` |
| Staff 3 | `staff3@example.com` | `password123` |
| Staff 4 | `staff4@example.com` | `password123` |

After creating all users, go to **SQL Editor** and run this query to update their roles:

```sql
UPDATE users SET role = 'architect', full_name = 'Test Architect' WHERE email = 'architect@example.com';
UPDATE users SET role = 'admin', full_name = 'Test Admin' WHERE email = 'admin@example.com';
UPDATE users SET role = 'hr', full_name = 'Test HR' WHERE email = 'hr@example.com';
UPDATE users SET role = 'staff', full_name = 'Test Staff 1' WHERE email = 'staff1@example.com';
UPDATE users SET role = 'staff', full_name = 'Test Staff 2' WHERE email = 'staff2@example.com';
UPDATE users SET role = 'staff', full_name = 'Test Staff 3' WHERE email = 'staff3@example.com';
UPDATE users SET role = 'staff', full_name = 'Test Staff 4' WHERE email = 'staff4@example.com';
```

---

## Row Level Security (RLS) Policies

RLS ensures users can only access data they're authorized to see.

### Step 1: Enable RLS on All Tables

Go to **SQL Editor** and run:

```sql
-- Enable RLS on all tables
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE clients ENABLE ROW LEVEL SECURITY;
ALTER TABLE projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE project_staff ENABLE ROW LEVEL SECURITY;
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;
```

### Step 2: Users Table Policies

```sql
-- Allow users to read their own profile
CREATE POLICY "Users can read own profile" ON users
  FOR SELECT USING (auth.uid() = id);

-- Allow users to read all user info (for dropdown, etc.)
CREATE POLICY "Users can read all user info" ON users
  FOR SELECT USING (true);

-- Allow authenticated users to insert their own record
CREATE POLICY "Users can insert own record" ON users
  FOR INSERT WITH CHECK (auth.uid() = id);

-- Allow users to update their own profile
CREATE POLICY "Users can update own profile" ON users
  FOR UPDATE USING (auth.uid() = id);
```

### Step 3: Clients Table Policies

```sql
-- Allow authenticated users to read clients
CREATE POLICY "Authenticated users can read clients" ON clients
  FOR SELECT USING (true);

-- Allow admin/architect to create clients
CREATE POLICY "Admin and architect can create clients" ON clients
  FOR INSERT WITH CHECK (
    (SELECT role FROM users WHERE id = auth.uid()) IN ('admin', 'architect')
  );

-- Allow admin/architect to update clients
CREATE POLICY "Admin and architect can update clients" ON clients
  FOR UPDATE USING (
    (SELECT role FROM users WHERE id = auth.uid()) IN ('admin', 'architect')
  );
```

### Step 4: Projects Table Policies

```sql
-- Allow staff to read assigned projects
CREATE POLICY "Staff can read assigned projects" ON projects
  FOR SELECT USING (
    (SELECT role FROM users WHERE id = auth.uid()) = 'staff'
    AND id IN (
      SELECT project_id FROM project_staff WHERE staff_id = auth.uid()
    )
    OR
    (SELECT role FROM users WHERE id = auth.uid()) IN ('architect', 'admin', 'hr')
  );

-- Allow admin/architect to read all projects
CREATE POLICY "Admin and architect can read all projects" ON projects
  FOR SELECT USING (
    (SELECT role FROM users WHERE id = auth.uid()) IN ('admin', 'architect', 'hr')
  );

-- Allow admin/architect to create projects
CREATE POLICY "Admin and architect can create projects" ON projects
  FOR INSERT WITH CHECK (
    (SELECT role FROM users WHERE id = auth.uid()) IN ('admin', 'architect')
  );

-- Allow admin/architect to update projects
CREATE POLICY "Admin and architect can update projects" ON projects
  FOR UPDATE USING (
    (SELECT role FROM users WHERE id = auth.uid()) IN ('admin', 'architect')
  );
```

### Step 5: Project Staff Table Policies

```sql
-- Allow staff to read their assignments
CREATE POLICY "Staff can read their assignments" ON project_staff
  FOR SELECT USING (
    staff_id = auth.uid()
    OR
    (SELECT role FROM users WHERE id = auth.uid()) IN ('admin', 'architect', 'hr')
  );

-- Allow admin/architect to manage assignments
CREATE POLICY "Admin can manage staff assignments" ON project_staff
  FOR INSERT WITH CHECK (
    (SELECT role FROM users WHERE id = auth.uid()) IN ('admin', 'architect')
  );

CREATE POLICY "Admin can update staff assignments" ON project_staff
  FOR UPDATE USING (
    (SELECT role FROM users WHERE id = auth.uid()) IN ('admin', 'architect')
  );

CREATE POLICY "Admin can delete staff assignments" ON project_staff
  FOR DELETE USING (
    (SELECT role FROM users WHERE id = auth.uid()) IN ('admin', 'architect')
  );
```

### Step 6: Messages Table Policies

```sql
-- Allow staff to read messages sent to them
CREATE POLICY "Staff can read messages sent to them" ON messages
  FOR SELECT USING (
    recipient_id = auth.uid()
    OR
    sender_id = auth.uid()
  );

-- Allow admin/architect to read all messages (optional)
CREATE POLICY "Admin can read all messages" ON messages
  FOR SELECT USING (
    (SELECT role FROM users WHERE id = auth.uid()) IN ('admin', 'architect')
  );

-- Allow admin/architect to send messages
CREATE POLICY "Admin and architect can send messages" ON messages
  FOR INSERT WITH CHECK (
    (SELECT role FROM users WHERE id = auth.uid()) IN ('admin', 'architect')
  );
```

---

## Connect Flutter App to Supabase

Now that Supabase is set up, we need to connect the Flutter app to it.

### Step 1: Update App Constants

Open `lib/config/constants.dart` and replace the placeholder values:

```dart
class AppConstants {
  // Supabase Configuration
  static const String supabaseUrl = 'YOUR_PROJECT_URL'; // e.g., https://xxxxx.supabase.co
  static const String supabaseAnonKey = 'YOUR_ANON_KEY'; // Your public API key
  
  // ... rest of constants
}
```

**Where to find these values:**
1. Go to Supabase Dashboard
2. Click **Settings** → **API**
3. Under **Project API keys**:
   - Copy the **Project URL**
   - Copy the **anon/public key**

### Step 2: Update pubspec.yaml (if needed)

The pubspec.yaml is already configured with Supabase dependencies. Make sure you have the latest versions:

```bash
flutter pub get
```

### Step 3: Configure Deep Links (Optional, for Production)

For production, configure deep linking for OAuth (if you plan to use it):

**Android:** Edit `android/app/AndroidManifest.xml`
```xml
<intent-filter>
  <action android:name="android.intent.action.VIEW" />
  <category android:name="android.intent.category.DEFAULT" />
  <category android:name="android.intent.category.BROWSABLE" />
  <data
    android:scheme="io.supabase.crm"
    android:host="login-callback" />
</intent-filter>
```

**iOS:** Edit `ios/Runner/Info.plist`
```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleTypeRole</key>
    <string>Editor</string>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>io.supabase.crm</string>
    </array>
  </dict>
</array>
```

---

## Test the Connection

### Step 1: Run the App

```bash
flutter run
```

### Step 2: Test Authentication

1. Go to the login screen
2. Enter test credentials:
   - Email: `architect@example.com`
   - Password: `password123`
3. Click **Login**

If successful:
- You should see the dashboard
- You should be able to navigate the app
- The user should be logged in

### Step 3: Test Database Connection

To verify the database is working:

1. Go to **SQL Editor** in Supabase
2. Run this query to check if your user profile was created:

```sql
SELECT * FROM users WHERE email = 'architect@example.com';
```

You should see your user record.

### Step 4: Troubleshooting

If you encounter issues:

1. **"Invalid API key"** error:
   - Check that you copied the correct anon key
   - Make sure the URL and key are in the right format

2. **"User not found"** error:
   - Make sure you created the user in Auth → Users
   - Make sure you updated the users table with the correct role

3. **"Network error"** error:
   - Check your internet connection
   - Make sure the Supabase project is running
   - Check the browser console for more details

4. **"Permission denied"** error:
   - Check your RLS policies
   - Make sure the policies are correctly configured for your user role

---

## Next Steps

1. **Implement Data Services**: Create service classes to interact with Supabase from the Flutter app
2. **Implement Real-time Features**: Use Supabase Realtime for live updates on messages
3. **Add File Storage**: Use Supabase Storage for project documents/images
4. **Deploy**: When ready, deploy the app to production

---

## Useful Supabase Resources

- **Official Docs**: https://supabase.com/docs
- **Flutter Integration**: https://supabase.com/docs/reference/flutter/introduction
- **REST API**: https://supabase.com/docs/guides/api
- **Real-time**: https://supabase.com/docs/guides/realtime

---

## Support

If you encounter any issues:
1. Check the Supabase documentation
2. Review your RLS policies
3. Check the browser console for error messages
4. Verify your API credentials are correct

---

**Last Updated**: June 18, 2026
