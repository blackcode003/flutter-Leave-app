import 'package:flutter/material.dart';
import 'main.dart';

// ─────────────────────────────────────────────
// Shared data model
// ─────────────────────────────────────────────
class LeaveRequest {
  final String id;
  final String employeeName;
  final String employeeId;
  final String department;
  final String leaveType;
  final String fromDate;
  final String toDate;
  final String days;
  final String reason;
  final String contact;
  final String remark;
  String status;
  String? ownerNote;
  String? actionDate;

  LeaveRequest({
    required this.id,
    required this.employeeName,
    required this.employeeId,
    required this.department,
    required this.leaveType,
    required this.fromDate,
    required this.toDate,
    required this.days,
    required this.reason,
    required this.contact,
    this.remark = '',
    this.status = 'Pending',
    this.ownerNote,
    this.actionDate,
  });
}

// ─────────────────────────────────────────────
// Demo data
// ─────────────────────────────────────────────
final List<LeaveRequest> demoRequests = [
  LeaveRequest(
    id: 'LA-001',
    employeeName: 'Ahmad Raza',
    employeeId: 'EMP-2024-085',
    department: 'Operations',
    leaveType: 'Annual Leave',
    fromDate: '2024-03-15',
    toDate: '2024-03-17',
    days: '3',
    reason: 'Family vacation trip',
    contact: '+92-300-1234567',
    remark: 'Work handed over to Ali.',
  ),
  LeaveRequest(
    id: 'LA-002',
    employeeName: 'Sara Khan',
    employeeId: 'EMP-2024-042',
    department: 'HR',
    leaveType: 'Sick Leave',
    fromDate: '2024-03-18',
    toDate: '2024-03-18',
    days: '1',
    reason: 'Doctor appointment – fever',
    contact: '+92-333-9876543',
  ),
  LeaveRequest(
    id: 'LA-003',
    employeeName: 'Bilal Ahmed',
    employeeId: 'EMP-2024-011',
    department: 'IT',
    leaveType: 'Casual Leave',
    fromDate: '2024-03-20',
    toDate: '2024-03-21',
    days: '2',
    reason: 'Personal work at home city',
    contact: '+92-321-5556677',
    remark: 'Urgent task, please approve.',
  ),
  LeaveRequest(
    id: 'LA-004',
    employeeName: 'Fatima Malik',
    employeeId: 'EMP-2024-067',
    department: 'Finance',
    leaveType: 'Emergency Leave',
    fromDate: '2024-03-19',
    toDate: '2024-03-19',
    days: '1',
    reason: 'Family emergency',
    contact: '+92-312-7778899',
  ),
];

// Dark theme colors
const _kBg = Color(0xFF0D0D0D);
const _kSurface = Color(0xFF1A1A2E);
const _kSurface2 = Color(0xFF16213E);
const _kBorder = Color(0xFF2A2A4A);
const _kAccent = Color(0xFF45B7D1);
const _kTextPrimary = Colors.white;
const _kTextSecondary = Color(0xFF8892B0);

// ─────────────────────────────────────────────
// Owner Panel – Main Screen
// ─────────────────────────────────────────────
class OwnerPanelScreen extends StatefulWidget {
  final List<LeaveRequest> requests;
  const OwnerPanelScreen({super.key, required this.requests});

  @override
  State<OwnerPanelScreen> createState() => _OwnerPanelScreenState();
}

class _OwnerPanelScreenState extends State<OwnerPanelScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<LeaveRequest> _filtered(String status) {
    return widget.requests.where((r) {
      final matchStatus = r.status == status;
      final matchSearch = _searchQuery.isEmpty ||
          r.employeeName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          r.id.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          r.department.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchStatus && matchSearch;
    }).toList();
  }

  int get _pendingCount =>
      widget.requests.where((r) => r.status == 'Pending').length;

  void _updateStatus(LeaveRequest req, String newStatus, String? note) {
    setState(() {
      req.status = newStatus;
      req.ownerNote = note;
      req.actionDate = DateTime.now().toIso8601String().substring(0, 10);
    });
  }

  // ── FIXED: no BuildContext parameter, uses State's context directly ──
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: _kSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFFEF4444), width: 1),
        ),
        title: const Row(
          children: [
            Icon(Icons.logout, color: Color(0xFFEF4444), size: 24),
            SizedBox(width: 10),
            Text('Logout',
                style: TextStyle(color: _kTextPrimary, fontSize: 18)),
          ],
        ),
        content: const Text(
          'Are you sure you want to logout from the Owner Panel?',
          style:
          TextStyle(color: _kTextSecondary, fontSize: 13, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: _kTextSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      drawer: _buildDrawer(context),
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverAppBar(
            expandedHeight: 160,
            pinned: true,
            backgroundColor: _kSurface,
            iconTheme: const IconThemeData(color: _kAccent),
            actions: [
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined,
                        color: _kTextSecondary),
                    onPressed: () {},
                  ),
                  if (_pendingCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: const BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '$_pendingCount',
                            style: const TextStyle(
                                fontSize: 9,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.logout, color: Color(0xFFEF4444)),
                tooltip: 'Logout',
                onPressed: _showLogoutDialog, // ✅ no argument
              ),
              const SizedBox(width: 4),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0F1B33), Color(0xFF1A2A4A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: -30,
                      right: -30,
                      child: Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _kAccent.withOpacity(0.06),
                        ),
                      ),
                    ),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 40),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: _kAccent.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color: _kAccent.withOpacity(0.3)),
                                  ),
                                  child: const Icon(
                                      Icons.admin_panel_settings,
                                      color: _kAccent,
                                      size: 24),
                                ),
                                const SizedBox(width: 12),
                                const Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text('Owner Panel',
                                        style: TextStyle(
                                            color: _kTextPrimary,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 0.4)),
                                    Text('Leave Management',
                                        style: TextStyle(
                                            color: _kTextSecondary,
                                            fontSize: 12,
                                            letterSpacing: 0.8)),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                _summaryChip('Pending',
                                    _filtered('Pending').length,
                                    Colors.orange),
                                const SizedBox(width: 8),
                                _summaryChip('Approved',
                                    _filtered('Approved').length,
                                    Colors.green),
                                const SizedBox(width: 8),
                                _summaryChip('Rejected',
                                    _filtered('Rejected').length,
                                    Colors.red),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(105),
              child: Container(
                color: _kSurface,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: TextField(
                        onChanged: (v) =>
                            setState(() => _searchQuery = v),
                        style: const TextStyle(color: _kTextPrimary),
                        decoration: InputDecoration(
                          hintText:
                          'Search by name, ID or department...',
                          hintStyle: const TextStyle(
                              color: _kTextSecondary, fontSize: 13),
                          prefixIcon: const Icon(Icons.search,
                              color: _kTextSecondary, size: 20),
                          filled: true,
                          fillColor: _kSurface2,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                            const BorderSide(color: _kBorder),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                            const BorderSide(color: _kBorder),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: _kAccent, width: 1.5),
                          ),
                          contentPadding:
                          const EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                    TabBar(
                      controller: _tabController,
                      labelColor: _kAccent,
                      unselectedLabelColor: _kTextSecondary,
                      indicatorColor: _kAccent,
                      indicatorWeight: 2,
                      dividerColor: _kBorder,
                      tabs: [
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Pending'),
                              if (_pendingCount > 0) ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 7, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.orange,
                                    borderRadius:
                                    BorderRadius.circular(10),
                                  ),
                                  child: Text('$_pendingCount',
                                      style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                ),
                              ]
                            ],
                          ),
                        ),
                        const Tab(text: 'Approved'),
                        const Tab(text: 'Rejected'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _RequestList(
              requests: _filtered('Pending'),
              onAction: _updateStatus,
              emptyMessage: 'No pending requests',
              emptyIcon: Icons.check_circle_outline,
            ),
            _RequestList(
              requests: _filtered('Approved'),
              onAction: _updateStatus,
              emptyMessage: 'No approved requests yet',
              emptyIcon: Icons.thumb_up_outlined,
            ),
            _RequestList(
              requests: _filtered('Rejected'),
              onAction: _updateStatus,
              emptyMessage: 'No rejected requests',
              emptyIcon: Icons.thumb_down_outlined,
            ),
          ],
        ),
      ),
    );
  }

  // ── Drawer ──────────────────────────────────
  Widget _buildDrawer(BuildContext context) {
    final approved = _filtered('Approved').length;
    final rejected = _filtered('Rejected').length;
    final pending = _filtered('Pending').length;

    return Drawer(
      backgroundColor: _kSurface,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 56, 20, 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0F1B33), Color(0xFF1A2A4A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _kAccent.withOpacity(0.15),
                    border: Border.all(
                        color: _kAccent.withOpacity(0.4), width: 2),
                  ),
                  child: const Icon(Icons.admin_panel_settings,
                      color: _kAccent, size: 30),
                ),
                const SizedBox(height: 14),
                const Text('Owner Panel',
                    style: TextStyle(
                        color: _kTextPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                const Text('Leave Management System',
                    style: TextStyle(
                        color: _kTextSecondary, fontSize: 12)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _drawerStat('$pending', 'Pending', Colors.orange),
                    const SizedBox(width: 8),
                    _drawerStat(
                        '$approved', 'Approved', Colors.green),
                    const SizedBox(width: 8),
                    _drawerStat('$rejected', 'Rejected', Colors.red),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          _drawerItem(
            icon: Icons.dashboard_outlined,
            label: 'Dashboard',
            onTap: () => Navigator.pop(context),
          ),
          _drawerItem(
            icon: Icons.pending_actions_outlined,
            label: 'Pending Requests',
            badge: pending > 0 ? '$pending' : null,
            badgeColor: Colors.orange,
            onTap: () {
              Navigator.pop(context);
              _tabController.animateTo(0);
            },
          ),
          _drawerItem(
            icon: Icons.check_circle_outline,
            label: 'Approved',
            onTap: () {
              Navigator.pop(context);
              _tabController.animateTo(1);
            },
          ),
          _drawerItem(
            icon: Icons.cancel_outlined,
            label: 'Rejected',
            onTap: () {
              Navigator.pop(context);
              _tabController.animateTo(2);
            },
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Divider(color: _kBorder),
          ),
          _drawerItem(
            icon: Icons.settings_outlined,
            label: 'Settings',
            onTap: () => Navigator.pop(context),
          ),
          _drawerItem(
            icon: Icons.help_outline,
            label: 'Help & Support',
            onTap: () => Navigator.pop(context),
          ),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text('v1.0.0',
                style: TextStyle(color: _kBorder, fontSize: 11)),
          ),
          // ── FIXED: _showLogoutDialog() with no argument ──
          Container(
            margin: const EdgeInsets.fromLTRB(12, 0, 12, 24),
            decoration: BoxDecoration(
              color: const Color(0xFFEF4444).withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: const Color(0xFFEF4444).withOpacity(0.25)),
            ),
            child: ListTile(
              leading:
              const Icon(Icons.logout, color: Color(0xFFEF4444)),
              title: const Text('Logout',
                  style: TextStyle(
                      color: Color(0xFFEF4444),
                      fontWeight: FontWeight.w600)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              onTap: () {
                Navigator.pop(context); // close drawer first
                _showLogoutDialog(); // ✅ no argument
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawerItem({
    required IconData icon,
    required String label,
    String? badge,
    Color badgeColor = Colors.orange,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: ListTile(
        leading: Icon(icon, color: _kTextSecondary, size: 22),
        title: Text(label,
            style:
            const TextStyle(color: _kTextPrimary, fontSize: 14)),
        trailing: badge != null
            ? Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: badgeColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(badge,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold)),
        )
            : null,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
        onTap: onTap,
        hoverColor: _kAccent.withOpacity(0.06),
      ),
    );
  }

  Widget _drawerStat(String count, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Column(
          children: [
            Text(count,
                style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
            Text(label,
                style: TextStyle(
                    color: color.withOpacity(0.8), fontSize: 9)),
          ],
        ),
      ),
    );
  }

  Widget _summaryChip(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Text('$count',
              style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 15)),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(color: color, fontSize: 11)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Request List Widget
// ─────────────────────────────────────────────
class _RequestList extends StatelessWidget {
  final List<LeaveRequest> requests;
  final Function(LeaveRequest, String, String?) onAction;
  final String emptyMessage;
  final IconData emptyIcon;

  const _RequestList({
    required this.requests,
    required this.onAction,
    required this.emptyMessage,
    required this.emptyIcon,
  });

  @override
  Widget build(BuildContext context) {
    if (requests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(emptyIcon, size: 64, color: _kBorder),
            const SizedBox(height: 16),
            Text(emptyMessage,
                style: const TextStyle(
                    color: _kTextSecondary, fontSize: 15)),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: requests.length,
      itemBuilder: (context, i) =>
          _RequestCard(request: requests[i], onAction: onAction),
    );
  }
}

// ─────────────────────────────────────────────
// Individual Request Card
// ─────────────────────────────────────────────
class _RequestCard extends StatelessWidget {
  final LeaveRequest request;
  final Function(LeaveRequest, String, String?) onAction;

  const _RequestCard({required this.request, required this.onAction});

  Color get _statusColor {
    switch (request.status) {
      case 'Approved':
        return Colors.green;
      case 'Rejected':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  IconData get _statusIcon {
    switch (request.status) {
      case 'Approved':
        return Icons.check_circle;
      case 'Rejected':
        return Icons.cancel;
      default:
        return Icons.access_time;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: _kSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _kBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Header ──
          Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
            decoration: BoxDecoration(
              color: _kSurface2,
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(18)),
              border: const Border(
                  bottom: BorderSide(color: _kBorder, width: 1)),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _kAccent.withOpacity(0.12),
                    border:
                    Border.all(color: _kAccent.withOpacity(0.3)),
                  ),
                  child: Center(
                    child: Text(
                      request.employeeName[0],
                      style: const TextStyle(
                          color: _kAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(request.employeeName,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: _kTextPrimary)),
                      const SizedBox(height: 2),
                      Text(
                          '${request.employeeId}  •  ${request.department}',
                          style: const TextStyle(
                              color: _kTextSecondary, fontSize: 11)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: _statusColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: _statusColor.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(_statusIcon,
                          color: _statusColor, size: 13),
                      const SizedBox(width: 4),
                      Text(request.status,
                          style: TextStyle(
                              color: _statusColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Body ──
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    _infoBox(Icons.event_note_outlined, 'Leave Type',
                        request.leaveType, Colors.blue),
                    const SizedBox(width: 10),
                    _infoBox(Icons.calendar_today, 'Duration',
                        '${request.days} day(s)', Colors.purple),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _infoBox(Icons.arrow_circle_right_outlined, 'From',
                        request.fromDate, Colors.teal),
                    const SizedBox(width: 10),
                    _infoBox(Icons.arrow_circle_left_outlined, 'To',
                        request.toDate, const Color(0xFF7C3AED)),
                  ],
                ),
                const SizedBox(height: 14),
                _detailRow(
                    Icons.edit_note, 'Reason', request.reason),
                const SizedBox(height: 8),
                _detailRow(Icons.phone_outlined, 'Contact',
                    request.contact),
                if (request.remark.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  _detailRow(Icons.comment_outlined, 'Remark',
                      request.remark),
                ],
                if (request.ownerNote != null &&
                    request.ownerNote!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  _detailRow(
                    Icons.admin_panel_settings_outlined,
                    'Owner Note',
                    request.ownerNote!,
                    color: _statusColor,
                  ),
                ],
                if (request.actionDate != null) ...[
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Action on: ${request.actionDate}',
                      style: const TextStyle(
                          fontSize: 10, color: _kTextSecondary),
                    ),
                  ),
                ],
                if (request.status == 'Pending') ...[
                  const SizedBox(height: 16),
                  const Divider(height: 1, color: _kBorder),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () =>
                              _showActionDialog(context, 'Rejected'),
                          icon: const Icon(Icons.close,
                              color: Colors.red, size: 18),
                          label: const Text('Reject',
                              style: TextStyle(color: Colors.red)),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                                color: Colors.red.withOpacity(0.6)),
                            backgroundColor:
                            Colors.red.withOpacity(0.06),
                            padding: const EdgeInsets.symmetric(
                                vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () =>
                              _showActionDialog(context, 'Approved'),
                          icon: const Icon(Icons.check, size: 18),
                          label: const Text('Approve'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                if (request.status != 'Pending') ...[
                  const SizedBox(height: 12),
                  const Divider(height: 1, color: _kBorder),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton.icon(
                      onPressed: () =>
                          _showReReviewDialog(context),
                      icon: const Icon(Icons.refresh,
                          size: 16, color: _kTextSecondary),
                      label: const Text('Change Decision',
                          style:
                          TextStyle(color: _kTextSecondary)),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoBox(
      IconData icon, String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: TextStyle(
                          fontSize: 10,
                          color: color.withOpacity(0.8))),
                  Text(value,
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _kTextPrimary),
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value,
      {Color? color}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: color ?? _kTextSecondary),
        const SizedBox(width: 8),
        SizedBox(
          width: 70,
          child: Text('$label:',
              style: const TextStyle(
                  fontSize: 12,
                  color: _kTextSecondary,
                  fontWeight: FontWeight.w500)),
        ),
        Expanded(
          child: Text(value,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: color ?? _kTextPrimary)),
        ),
      ],
    );
  }

  void _showActionDialog(BuildContext context, String action) {
    final noteController = TextEditingController();
    final isApprove = action == 'Approved';
    final actionColor = isApprove ? Colors.green : Colors.red;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: _kSurface,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side:
            BorderSide(color: actionColor.withOpacity(0.3))),
        title: Row(
          children: [
            Icon(
              isApprove
                  ? Icons.check_circle_outline
                  : Icons.cancel_outlined,
              color: actionColor,
              size: 26,
            ),
            const SizedBox(width: 10),
            Text(
                isApprove ? 'Approve Leave' : 'Reject Leave',
                style: const TextStyle(
                    fontSize: 17, color: _kTextPrimary)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                style: const TextStyle(
                    color: _kTextSecondary,
                    fontSize: 13,
                    height: 1.5),
                children: [
                  TextSpan(
                      text: isApprove
                          ? 'You are about to approve the leave request for '
                          : 'You are about to reject the leave request for '),
                  TextSpan(
                      text: request.employeeName,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _kTextPrimary)),
                  TextSpan(
                      text: isApprove
                          ? ' (${request.days} day(s)).'
                          : '. This action will notify the employee.'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: noteController,
              maxLines: 3,
              style: const TextStyle(color: _kTextPrimary),
              decoration: InputDecoration(
                labelText: isApprove
                    ? 'Note (Optional)'
                    : 'Reason for Rejection *',
                hintText: isApprove
                    ? 'Add a note for the employee...'
                    : 'Please provide a reason...',
                filled: true,
                fillColor: _kSurface2,
                labelStyle: TextStyle(
                    color: actionColor.withOpacity(0.8)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                      color: actionColor.withOpacity(0.4)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                  const BorderSide(color: _kBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                  BorderSide(color: actionColor, width: 2),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: _kTextSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              if (!isApprove &&
                  noteController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(
                  content:
                  Text('Please provide a rejection reason'),
                  backgroundColor: Colors.red,
                ));
                return;
              }
              onAction(request, action,
                  noteController.text.trim());
              Navigator.pop(context);
              _showConfirmationSnackbar(context, action);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: actionColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(isApprove ? 'Approve' : 'Reject'),
          ),
        ],
      ),
    );
  }

  void _showReReviewDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: _kSurface,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: _kBorder)),
        title: const Text('Change Decision',
            style: TextStyle(color: _kTextPrimary)),
        content: const Text(
            'Do you want to change your previous decision on this leave request?',
            style: TextStyle(color: _kTextSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: _kTextSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              onAction(request, 'Pending', null);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Reset to Pending'),
          ),
        ],
      ),
    );
  }

  void _showConfirmationSnackbar(
      BuildContext context, String action) {
    final isApprove = action == 'Approved';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isApprove ? Icons.check_circle : Icons.cancel,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            Text(
              isApprove
                  ? 'Leave approved for ${request.employeeName}'
                  : 'Leave rejected for ${request.employeeName}',
            ),
          ],
        ),
        backgroundColor: isApprove ? Colors.green : Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(12),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}