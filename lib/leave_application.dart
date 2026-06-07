import 'package:flutter/material.dart';
import 'owner_panel.dart';
import 'main.dart';

const _kBg = Color(0xFF0D0D0D);
const _kSurface = Color(0xFF1A1A2E);
const _kSurface2 = Color(0xFF16213E);
const _kBorder = Color(0xFF2A2A4A);
const _kAccent = Color(0xFF4ECDC4);
const _kTextPrimary = Colors.white;
const _kTextSecondary = Color(0xFF8892B0);

class WorkerLeavePage extends StatefulWidget {
  final List<LeaveRequest> requests;
  final String employeeId;

  const WorkerLeavePage({
    super.key,
    required this.requests,
    required this.employeeId,
  });

  @override
  State<WorkerLeavePage> createState() => _WorkerLeavePageState();
}

class _WorkerLeavePageState extends State<WorkerLeavePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnim =
        CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  List<LeaveRequest> get myRequests => widget.requests
      .where((r) => r.employeeId == widget.employeeId)
      .toList();

  Color getStatusColor(String status) {
    switch (status) {
      case 'Approved':
        return Colors.green;
      case 'Rejected':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  IconData getStatusIcon(String status) {
    switch (status) {
      case 'Approved':
        return Icons.check_circle;
      case 'Rejected':
        return Icons.cancel;
      default:
        return Icons.access_time;
    }
  }

  IconData leaveTypeIcon(String type) {
    switch (type) {
      case 'Sick Leave':
        return Icons.local_hospital_outlined;
      case 'Casual Leave':
        return Icons.beach_access_outlined;
      case 'Emergency Leave':
        return Icons.warning_amber_outlined;
      default:
        return Icons.event_available_outlined;
    }
  }

  Color leaveTypeColor(String type) {
    switch (type) {
      case 'Sick Leave':
        return Colors.red;
      case 'Casual Leave':
        return Colors.teal;
      case 'Emergency Leave':
        return Colors.orange;
      default:
        return _kAccent;
    }
  }

  // ── FIXED: no BuildContext parameter ──
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
          'Are you sure you want to logout?',
          style: TextStyle(
              color: _kTextSecondary, fontSize: 13, height: 1.5),
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
                MaterialPageRoute(
                    builder: (_) => const LoginScreen()),
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

  // ── Drawer ──
  Widget _buildDrawer(BuildContext context) {
    final pending =
        myRequests.where((r) => r.status == 'Pending').length;
    final approved =
        myRequests.where((r) => r.status == 'Approved').length;
    final rejected =
        myRequests.where((r) => r.status == 'Rejected').length;

    return Drawer(
      backgroundColor: _kSurface,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 56, 20, 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0A1628), Color(0xFF0F2A1E)],
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
                  child: const Icon(Icons.badge_outlined,
                      color: _kAccent, size: 30),
                ),
                const SizedBox(height: 14),
                const Text('My Portal',
                    style: TextStyle(
                        color: _kTextPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(widget.employeeId,
                    style: const TextStyle(
                        color: _kTextSecondary, fontSize: 12)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _drawerStat(
                        '$pending', 'Pending', Colors.orange),
                    const SizedBox(width: 8),
                    _drawerStat(
                        '$approved', 'Approved', Colors.green),
                    const SizedBox(width: 8),
                    _drawerStat(
                        '$rejected', 'Rejected', Colors.red),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          _drawerItem(
            icon: Icons.home_outlined,
            label: 'Home',
            onTap: () => Navigator.pop(context),
          ),
          _drawerItem(
            icon: Icons.history_outlined,
            label: 'My Leave History',
            badge: myRequests.isNotEmpty
                ? '${myRequests.length}'
                : null,
            badgeColor: _kAccent,
            onTap: () => Navigator.pop(context),
          ),
          _drawerItem(
            icon: Icons.pending_actions_outlined,
            label: 'Pending',
            badge: pending > 0 ? '$pending' : null,
            badgeColor: Colors.orange,
            onTap: () => Navigator.pop(context),
          ),
          _drawerItem(
            icon: Icons.check_circle_outline,
            label: 'Approved',
            onTap: () => Navigator.pop(context),
          ),
          _drawerItem(
            icon: Icons.cancel_outlined,
            label: 'Rejected',
            onTap: () => Navigator.pop(context),
          ),
          const Padding(
            padding:
            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
              leading: const Icon(Icons.logout,
                  color: Color(0xFFEF4444)),
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
            style: const TextStyle(
                color: _kTextPrimary, fontSize: 14)),
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

  void openApplyDialog() {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final idController =
    TextEditingController(text: widget.employeeId);
    final deptController = TextEditingController();
    final daysController = TextEditingController();
    final reasonController = TextEditingController();
    final contactController = TextEditingController();
    final remarkController = TextEditingController();

    String leaveType = 'Annual Leave';
    DateTime? fromDate;
    DateTime? toDate;

    Future<void> pickDate(
        bool isFrom, StateSetter setStateDialog) async {
      final picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2023),
        lastDate: DateTime(2100),
        builder: (context, child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: const ColorScheme.dark(
                primary: _kAccent,
                surface: _kSurface,
                background: _kBg,
              ),
            ),
            child: child!,
          );
        },
      );
      if (picked != null) {
        setStateDialog(() {
          if (isFrom) {
            fromDate = picked;
          } else {
            toDate = picked;
          }
        });
      }
    }

    String formatDate(DateTime? date) {
      if (date == null) return '';
      return date.toIso8601String().substring(0, 10);
    }

    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(builder: (context, setStateDialog) {
          return AlertDialog(
            backgroundColor: _kSurface,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: _kBorder)),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _kAccent.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: _kAccent.withOpacity(0.3)),
                  ),
                  child: const Icon(Icons.add_task,
                      color: _kAccent, size: 20),
                ),
                const SizedBox(width: 10),
                const Text('Apply Leave',
                    style: TextStyle(
                        color: _kTextPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionLabel('Employee Info'),
                      _darkInput(nameController, 'Full Name',
                          Icons.person_outline),
                      const SizedBox(height: 10),
                      _darkInput(idController, 'Employee ID',
                          Icons.badge_outlined),
                      const SizedBox(height: 10),
                      _darkInput(deptController, 'Department',
                          Icons.business_outlined),
                      const SizedBox(height: 16),
                      _sectionLabel('Leave Details'),
                      DropdownButtonFormField<String>(
                        value: leaveType,
                        dropdownColor: _kSurface2,
                        style: const TextStyle(
                            color: _kTextPrimary),
                        items: [
                          'Annual Leave',
                          'Sick Leave',
                          'Casual Leave',
                          'Emergency Leave'
                        ]
                            .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e,
                                style: const TextStyle(
                                    color: _kTextPrimary))))
                            .toList(),
                        onChanged: (v) => setStateDialog(
                                () => leaveType = v!),
                        decoration: _inputDecor('Leave Type',
                            Icons.event_note_outlined),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () =>
                                  pickDate(true, setStateDialog),
                              child: _dateChip('From Date',
                                  fromDate, Colors.teal),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: GestureDetector(
                              onTap: () =>
                                  pickDate(false, setStateDialog),
                              child: _dateChip(
                                  'To Date', toDate, Colors.purple),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      _darkInput(daysController, 'Number of Days',
                          Icons.today,
                          keyboard: TextInputType.number),
                      const SizedBox(height: 16),
                      _sectionLabel('Additional Info'),
                      _darkInput(reasonController, 'Reason',
                          Icons.edit_note,
                          maxLines: 2),
                      const SizedBox(height: 10),
                      _darkInput(
                          contactController, 'Contact Number',
                          Icons.phone_outlined,
                          keyboard: TextInputType.phone),
                      const SizedBox(height: 10),
                      _darkInput(
                          remarkController, 'Remark (Optional)',
                          Icons.comment_outlined,
                          required: false),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel',
                    style: TextStyle(color: _kTextSecondary)),
              ),
              ElevatedButton(
                onPressed: () {
                  if (!formKey.currentState!.validate() ||
                      fromDate == null ||
                      toDate == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                            'Please fill all required fields'),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(10)),
                        margin: const EdgeInsets.all(12),
                      ),
                    );
                    return;
                  }
                  final newRequest = LeaveRequest(
                    id: 'LA-${(widget.requests.length + 1).toString().padLeft(3, '0')}',
                    employeeName: nameController.text,
                    employeeId: idController.text,
                    department: deptController.text,
                    leaveType: leaveType,
                    fromDate: formatDate(fromDate),
                    toDate: formatDate(toDate),
                    days: daysController.text,
                    reason: reasonController.text,
                    contact: contactController.text,
                    remark: remarkController.text,
                  );
                  setState(() {
                    widget.requests.add(newRequest);
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Row(
                        children: [
                          Icon(Icons.check_circle,
                              color: Colors.white),
                          SizedBox(width: 10),
                          Text(
                              'Leave request submitted successfully!'),
                        ],
                      ),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      margin: const EdgeInsets.all(12),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _kAccent,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 12),
                ),
                child: const Text('Submit',
                    style:
                    TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          );
        });
      },
    );
  }

  Widget _sectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          fontSize: 10,
          color: _kAccent,
          letterSpacing: 1.5,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  InputDecoration _inputDecor(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon:
      Icon(icon, color: _kAccent.withOpacity(0.7), size: 20),
      filled: true,
      fillColor: _kSurface2,
      labelStyle: const TextStyle(color: _kTextSecondary),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _kBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _kBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _kAccent, width: 1.5),
      ),
    );
  }

  Widget _darkInput(
      TextEditingController controller,
      String label,
      IconData icon, {
        int maxLines = 1,
        bool required = true,
        TextInputType keyboard = TextInputType.text,
      }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboard,
      style: const TextStyle(color: _kTextPrimary),
      validator: (v) {
        if (!required) return null;
        if (v == null || v.isEmpty) return 'Required';
        return null;
      },
      decoration: _inputDecor(label, icon),
    );
  }

  Widget _dateChip(String label, DateTime? date, Color color) {
    return Container(
      padding:
      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color:
            date != null ? color.withOpacity(0.5) : _kBorder),
      ),
      child: Row(
        children: [
          Icon(Icons.calendar_month_outlined,
              color: date != null ? color : _kTextSecondary,
              size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                        fontSize: 10,
                        color: date != null
                            ? color.withOpacity(0.8)
                            : _kTextSecondary)),
                Text(
                  date != null
                      ? date.toIso8601String().substring(0, 10)
                      : 'Tap to select',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: date != null
                        ? _kTextPrimary
                        : _kTextSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pending =
        myRequests.where((r) => r.status == 'Pending').length;
    final approved =
        myRequests.where((r) => r.status == 'Approved').length;
    final rejected =
        myRequests.where((r) => r.status == 'Rejected').length;

    return Scaffold(
      backgroundColor: _kBg,
      drawer: _buildDrawer(context),
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverAppBar(
            expandedHeight: 200,
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
                  if (pending > 0)
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
                            '$pending',
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
                icon: const Icon(Icons.logout,
                    color: Color(0xFFEF4444)),
                tooltip: 'Logout',
                onPressed: _showLogoutDialog, // ✅ no argument
              ),
              const SizedBox(width: 4),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF0A1628),
                      Color(0xFF0F2A1E)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      bottom: -40,
                      right: -40,
                      child: Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _kAccent.withOpacity(0.05),
                        ),
                      ),
                    ),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                            20, 16, 20, 0),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 40),
                            Row(
                              children: [
                                Container(
                                  padding:
                                  const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: _kAccent
                                        .withOpacity(0.12),
                                    borderRadius:
                                    BorderRadius.circular(12),
                                    border: Border.all(
                                        color: _kAccent
                                            .withOpacity(0.3)),
                                  ),
                                  child: const Icon(
                                      Icons.badge_outlined,
                                      color: _kAccent,
                                      size: 22),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    const Text('My Leaves',
                                        style: TextStyle(
                                            color: _kTextPrimary,
                                            fontSize: 20,
                                            fontWeight:
                                            FontWeight.bold,
                                            letterSpacing: 0.4)),
                                    Text(widget.employeeId,
                                        style: const TextStyle(
                                            color: _kTextSecondary,
                                            fontSize: 12,
                                            letterSpacing: 0.8)),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                _statChip('Pending', pending,
                                    Colors.orange),
                                const SizedBox(width: 10),
                                _statChip('Approved', approved,
                                    Colors.green),
                                const SizedBox(width: 10),
                                _statChip('Rejected', rejected,
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
              preferredSize: const Size.fromHeight(1),
              child: Container(height: 1, color: _kBorder),
            ),
          ),
        ],
        body: myRequests.isEmpty
            ? FadeTransition(
          opacity: _fadeAnim,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _kAccent.withOpacity(0.08),
                    border: Border.all(
                        color: _kAccent.withOpacity(0.2)),
                  ),
                  child: const Icon(Icons.inbox_outlined,
                      size: 36, color: _kTextSecondary),
                ),
                const SizedBox(height: 20),
                const Text('No Leave History',
                    style: TextStyle(
                        color: _kTextPrimary,
                        fontSize: 17,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                const Text('Tap + to apply for leave',
                    style: TextStyle(
                        color: _kTextSecondary,
                        fontSize: 13)),
              ],
            ),
          ),
        )
            : FadeTransition(
          opacity: _fadeAnim,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: myRequests.length,
            itemBuilder: (context, index) {
              final r = myRequests[index];
              final color = leaveTypeColor(r.leaveType);
              final statusColor =
              getStatusColor(r.status);

              return Container(
                margin:
                const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: _kSurface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: _kBorder),
                  boxShadow: [
                    BoxShadow(
                      color:
                      Colors.black.withOpacity(0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(
                          16, 14, 16, 12),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.07),
                        borderRadius:
                        const BorderRadius.vertical(
                            top: Radius.circular(18)),
                        border: const Border(
                            bottom: BorderSide(
                                color: _kBorder,
                                width: 1)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding:
                            const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color:
                              color.withOpacity(0.12),
                              borderRadius:
                              BorderRadius.circular(
                                  12),
                              border: Border.all(
                                  color: color
                                      .withOpacity(0.3)),
                            ),
                            child: Icon(
                                leaveTypeIcon(
                                    r.leaveType),
                                color: color,
                                size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(r.leaveType,
                                    style: const TextStyle(
                                        fontWeight:
                                        FontWeight.bold,
                                        fontSize: 15,
                                        color:
                                        _kTextPrimary)),
                                Text(r.id,
                                    style: const TextStyle(
                                        color:
                                        _kTextSecondary,
                                        fontSize: 11,
                                        letterSpacing:
                                        0.5)),
                              ],
                            ),
                          ),
                          Container(
                            padding:
                            const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5),
                            decoration: BoxDecoration(
                              color: statusColor
                                  .withOpacity(0.12),
                              borderRadius:
                              BorderRadius.circular(20),
                              border: Border.all(
                                  color: statusColor
                                      .withOpacity(0.3)),
                            ),
                            child: Row(
                              mainAxisSize:
                              MainAxisSize.min,
                              children: [
                                Icon(
                                    getStatusIcon(
                                        r.status),
                                    color: statusColor,
                                    size: 12),
                                const SizedBox(width: 4),
                                Text(r.status,
                                    style: TextStyle(
                                        color: statusColor,
                                        fontSize: 11,
                                        fontWeight:
                                        FontWeight
                                            .w600)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              _miniBox(
                                  Icons
                                      .arrow_circle_right_outlined,
                                  'From',
                                  r.fromDate,
                                  Colors.teal),
                              const SizedBox(width: 8),
                              _miniBox(
                                  Icons
                                      .arrow_circle_left_outlined,
                                  'To',
                                  r.toDate,
                                  Colors.purple),
                              const SizedBox(width: 8),
                              _miniBox(
                                  Icons.calendar_today,
                                  'Days',
                                  '${r.days}d',
                                  _kAccent),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            padding:
                            const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: _kSurface2,
                              borderRadius:
                              BorderRadius.circular(10),
                              border: Border.all(
                                  color: _kBorder),
                            ),
                            child: Row(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                    Icons.edit_note,
                                    size: 16,
                                    color: _kTextSecondary),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(r.reason,
                                      style: const TextStyle(
                                          fontSize: 13,
                                          color:
                                          _kTextPrimary,
                                          height: 1.4)),
                                ),
                              ],
                            ),
                          ),
                          if (r.ownerNote != null &&
                              r.ownerNote!.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              padding:
                              const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: statusColor
                                    .withOpacity(0.07),
                                borderRadius:
                                BorderRadius.circular(
                                    10),
                                border: Border.all(
                                    color: statusColor
                                        .withOpacity(0.25)),
                              ),
                              child: Row(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                      Icons
                                          .admin_panel_settings_outlined,
                                      size: 16,
                                      color: statusColor),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                        r.ownerNote!,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color:
                                            statusColor,
                                            fontWeight:
                                            FontWeight
                                                .w500)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          if (r.actionDate != null) ...[
                            const SizedBox(height: 6),
                            Align(
                              alignment:
                              Alignment.centerRight,
                              child: Text(
                                'Action on: ${r.actionDate}',
                                style: const TextStyle(
                                    fontSize: 10,
                                    color: _kTextSecondary),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openApplyDialog,
        backgroundColor: _kAccent,
        foregroundColor: Colors.black,
        elevation: 6,
        child: const Icon(Icons.add, size: 26),
      ),
    );
  }

  Widget _statChip(String label, int count, Color color) {
    return Container(
      padding:
      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                  fontSize: 14)),
          const SizedBox(width: 4),
          Text(label,
              style: TextStyle(color: color, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _miniBox(
      IconData icon, String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.07),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 12, color: color),
                const SizedBox(width: 4),
                Text(label,
                    style: TextStyle(
                        fontSize: 9,
                        color: color.withOpacity(0.8))),
              ],
            ),
            const SizedBox(height: 2),
            Text(value,
                style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _kTextPrimary),
                overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}