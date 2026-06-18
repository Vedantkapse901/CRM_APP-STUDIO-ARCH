# CRM APP - COMPREHENSIVE PLAN DOCUMENT

**Project**: Architectural CRM Application  
**Tech Stack**: Flutter (Mobile)  
**Client**: [Your Client]  
**Date**: June 18, 2026

---

## 1. PROJECT CATEGORIES

The system will manage projects across three main categories:

| Category | Description |
|----------|-------------|
| **Architectural Design** | Design phase only |
| **Architectural Design + Licensing** | Design + licensing & approvals |
| **PMC** | Project Management Consultant - Full project oversight |

---

## 2. PROJECT TYPES

Three types of projects based on building classification:

- **Residential** - Homes, apartments, residential complexes
- **Commercial** - Office buildings, retail, malls, hotels
- **Hospital** - Healthcare facilities, clinics, medical centers

---

## 3. PROJECT DETAILS STRUCTURE

Each project must include the following information:

### Required Fields:
1. **Category** - (Architectural Design / Design+Licensing / PMC)
2. **Client Information** - Name, contact, email, phone
3. **Location** - Project address/location
4. **Area** - Built-up area in sq.ft/sq.m
5. **Type** - (Residential / Commercial / Hospital)
6. **Consultant** - Name of assigned architect/consultant
7. **Staff Assignment** - Minimum 4 staff members assigned to project
   - Each staff gets a specific role/responsibility
   - Staff can only see their assigned projects

---

## 4. USER ROLES & PERMISSIONS

### 4.1 ARCHITECT
**Access Level**: Full Administrative

| Feature | Access |
|---------|--------|
| View Live Projects | ✓ |
| View Project Details | ✓ |
| View Consultant Info | ✓ |
| View Assigned Staff | ✓ |
| Create Projects | ✓ |
| Edit Projects | ✓ |
| Assign Staff to Projects | ✓ |
| Receive Messages | ✓ |
| Send Messages | ✓ |
| View Message History | ✓ |
| Approve/Monitor | ✓ |

---

### 4.2 HR & ADMIN
**Access Level**: Full Administrative

*Note: Same access level as Architect - both manage projects and staff*

| Feature | Access |
|---------|--------|
| View All Projects | ✓ |
| View Project Details | ✓ |
| Create New Projects | ✓ |
| Edit Projects | ✓ |
| Assign Staff to Projects | ✓ |
| Manage User Accounts | ✓ |
| Send Messages to Staff | ✓ |
| View Message History | ✓ |
| Approve/Monitor | ✓ |

---

### 4.3 STAFF MEMBERS
**Access Level**: Limited to Assigned Work

| Feature | Access |
|---------|--------|
| View Assigned Projects Only | ✓ |
| View Project Details (Assigned) | ✓ |
| Receive Messages | ✓ |
| View Message Notifications | ✓ |
| Submit Progress Updates | ✓ |
| View All Projects | ✗ |
| Create Projects | ✗ |
| Assign Staff | ✗ |
| Send Messages | ✗ |

---

## 5. APP WORKFLOW & NAVIGATION

### 5.1 ENTRY POINT: LOGIN PAGE
```
App Opens
   ↓
LOGIN PAGE
   ├─ Email/Username field
   ├─ Password field
   ├─ Login button
   └─ Forget password option
```

### 5.2 LOGIN FLOW BY ROLE

**ARCHITECT LOGIN**
```
Login → Authentication → Dashboard (Live Projects) + Full Admin Access
         ├─ Create/Edit Projects
         ├─ Assign Staff
         └─ Send Messages
```

**HR/ADMIN LOGIN**
```
Login → Authentication → Dashboard (All Projects) + Full Admin Access
         ├─ Manage Users
         ├─ Create/Edit Projects
         ├─ Assign Staff
         └─ Send Messages
```

**STAFF LOGIN**
```
Login → Authentication → Dashboard (Assigned Projects Only)
         ├─ View Project Details
         ├─ Receive Messages
         └─ Mark Progress
```

### 5.3 MAIN NAVIGATION STRUCTURE

After successful login, users see:

```
┌─────────────────────────────────────────┐
│  [☰] LOGO/APP NAME      [Profile]      │
└─────────────────────────────────────────┘
│                                         │
│  HAMBURGER MENU (Left Side)             │
│  ├─ Dashboard                           │
│  ├─ Projects                            │
│  ├─ Client Details                      │
│  ├─ Project Details                     │
│  ├─ Messages                            │
│  ├─ My Profile                          │
│  └─ Logout                              │
│                                         │
├─────────────────────────────────────────┤
│                                         │
│         MAIN CONTENT AREA               │
│                                         │
│  (Changes based on selected menu)       │
│                                         │
└─────────────────────────────────────────┘
```

---

## 6. DETAILED SCREEN SPECIFICATIONS

### 6.1 LOGIN SCREEN
**Elements:**
- Company Logo
- Email/Username input field
- Password input field
- "Login" button
- "Forgot Password?" link
- Role selector (optional - if multi-role support needed)

**Behavior:**
- Validate credentials against backend
- Show error messages if login fails
- Navigate to dashboard on success
- Remember login state

---

### 6.2 DASHBOARD SCREEN

#### ARCHITECT VIEW:
- **Title**: "Live Projects"
- **Display**: List/Grid of live projects assigned as consultant
- **Cards Show**: Project name, category, type, location, status, staff count
- **Quick Actions**: 
  - Create New Project button (floating)
  - Edit project
  - Assign staff
  - View details
  - Send messages to team

#### HR/ADMIN VIEW:
- **Title**: "All Projects"
- **Display**: List/Grid of all projects
- **Cards Show**: Project name, category, type, location, status, staff count
- **Quick Actions**: 
  - Add New Project button (floating)
  - Edit project
  - Assign staff
  - View details

#### STAFF VIEW:
- **Title**: "My Projects"
- **Display**: Only projects assigned to this staff member
- **Cards Show**: Project name, consultant name, location, role assigned
- **Actions**: Tap to view details, mark progress

---

### 6.3 PROJECT DETAILS SCREEN

**Displays:**
1. **Project Overview**
   - Project name
   - Category (Arch Design / Design+Licensing / PMC)
   - Type (Residential / Commercial / Hospital)
   - Status (Active/On-Hold/Completed)

2. **Project Information**
   - Location
   - Area (sq.ft/sq.m)
   - Client name & contact
   - Project address

3. **Consultant Information**
   - Consultant name
   - Contact details
   - Role/Designation

4. **Assigned Staff**
   - Staff list (minimum 4)
   - For each staff:
     - Name
     - Role/Designation
     - Contact info
     - Assignment status

5. **Timeline/Status**
   - Project phases
   - Milestones
   - Current status

---

### 6.4 CLIENT DETAILS SCREEN
**Shows:**
- List of all clients in system
- Client info: Name, contact, phone, email
- Projects associated with client
- Can tap to expand and see details

**Access:**
- HR/Admin: View and manage
- Architect: View only
- Staff: Not applicable

---

### 6.5 MESSAGES SCREEN

#### For Architect & HR/Admin (Senders):
- **Send Message** section
  - Recipient selector (Staff member)
  - Message input field
  - Attachment option
  - Send button
- **Sent Messages** history
- **Broadcast Message** to multiple staff

#### For Staff (Receivers):
- **Incoming Messages** list
- Each message shows:
  - Sender name (Architect/Admin)
  - Message text
  - Timestamp
  - Read/Unread status
- **Message Detail** view when tapped
- **Notification** badge on menu

**Message Notification:**
- Real-time pop-up notification when message arrives
- Push notification (if app is in background)
- Badge counter on Messages menu item

---

## 7. HAMBURGER MENU STRUCTURE

```
┌─────────────────────────┐
│  ☰  CRM Application    │
├─────────────────────────┤
│ ▶ Dashboard             │
├─────────────────────────┤
│ ▶ Projects              │
├─────────────────────────┤
│ ▶ Client Details        │
├─────────────────────────┤
│ ▶ Project Details       │
├─────────────────────────┤
│ ▶ Messages              │
│   (with badge count)    │
├─────────────────────────┤
│ ▶ My Profile            │
├─────────────────────────┤
│ ▶ Settings              │
├─────────────────────────┤
│ 🚪 Logout               │
└─────────────────────────┘
```

---

## 8. DATABASE SCHEMA (Overview)

### Users Table
```
- user_id (PK)
- email
- password_hash
- full_name
- role (architect/admin/hr/staff)
- phone
- created_at
- updated_at
```

### Projects Table
```
- project_id (PK)
- project_name
- category (enum: architectural_design, design_licensing, pmc)
- type (enum: residential, commercial, hospital)
- location
- area
- consultant_id (FK → Users)
- client_id (FK → Clients)
- status (active/on_hold/completed)
- created_at
- updated_at
```

### Project_Staff Table
```
- assignment_id (PK)
- project_id (FK)
- staff_id (FK → Users)
- role (staff role on this project)
- assigned_date
- assigned_by (FK → Users)
```

### Clients Table
```
- client_id (PK)
- client_name
- contact_person
- email
- phone
- address
- created_at
```

### Messages Table
```
- message_id (PK)
- sender_id (FK → Users)
- recipient_id (FK → Users)
- project_id (FK)
- message_text
- is_broadcast (boolean)
- created_at
- read_at
```

---

## 9. KEY FEATURES SUMMARY

### ✓ Multi-Role Authentication
- 3 distinct login types with role-based access

### ✓ Project Management
- Create, view, edit projects
- Assign staff to projects
- Track project details

### ✓ Staff Assignment
- Assign minimum 4 staff per project
- Staff see only their assigned projects
- Role-based visibility

### ✓ Real-Time Messaging
- Architects & Admins send messages
- Staff receive notifications
- Pop-up notifications on device
- Message history tracking

### ✓ Client Management
- Client database
- View client info
- Link clients to projects

### ✓ Dashboard
- Customized per user role
- Shows live/assigned projects
- Quick action buttons

### ✓ Navigation
- Hamburger menu
- Easy access to all features
- Consistent across all roles

---

## 10. IMPLEMENTATION PHASES

### PHASE 1: MVP (Minimum Viable Product)
**Duration**: 2-3 weeks

**Includes:**
- [ ] Login system (3 roles)
- [ ] Database setup
- [ ] Basic dashboard (role-specific)
- [ ] Project list view
- [ ] Project details view
- [ ] Hamburger menu navigation
- [ ] Basic messaging system

### PHASE 2: Enhancement
**Duration**: 1-2 weeks

**Includes:**
- [ ] Advanced project filtering/search
- [ ] Staff management interface
- [ ] Real-time notifications
- [ ] Message history
- [ ] Profile management
- [ ] Offline capabilities

### PHASE 3: Polish & Optimization
**Duration**: 1 week

**Includes:**
- [ ] UI/UX refinement
- [ ] Performance optimization
- [ ] Bug fixes
- [ ] Testing
- [ ] Documentation

---

## 11. TECHNICAL STACK

| Component | Technology |
|-----------|-----------|
| **Frontend** | Flutter |
| **Backend** | Node.js / Firebase / Your choice |
| **Database** | PostgreSQL / MongoDB / Firebase |
| **Authentication** | JWT / Firebase Auth |
| **Real-time Messaging** | Firebase Realtime DB / WebSocket |
| **State Management** | Provider / Riverpod / GetX |
| **UI Framework** | Material Design 3 |

---

## 12. NEXT STEPS

1. **Review & Approval**: Review this plan and approve
2. **Design**: Create wireframes/mockups for all screens
3. **API Design**: Define backend API endpoints
4. **Database**: Finalize schema and create
5. **Development**: Start Flutter app development
6. **Testing**: QA and testing
7. **Deployment**: Release to app stores

---

## 13. ASSUMPTIONS & NOTES

- **Architect & HR/Admin**: Both have full administrative access (same level)
- **Distinction**: Architect manages by consultant role, HR/Admin manages by system administration
- All staff must have at least 4 members per project
- Messages are one-way (Architect/Admin → Staff)
- Staff cannot message back through app (clarify if needed)
- "Live projects" = projects with status "Active"
- Staff can only view projects assigned to them
- Architects & Admins can view/manage all projects

---

**Created**: June 18, 2026  
**Ready for Review**: Yes  
**Status**: Planning Phase
