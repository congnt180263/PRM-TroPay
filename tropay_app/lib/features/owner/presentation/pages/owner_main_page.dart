import 'package:flutter/material.dart';
import '../pages/owner_dashboard_page.dart';
import '../pages/owner_services_page.dart';
import '../pages/owner_incidents_page.dart';
import '../pages/owner_invoices_page.dart';
import '../pages/owner_profile_page.dart';

class OwnerMainPage extends StatefulWidget {
  const OwnerMainPage({super.key});

  @override
  State<OwnerMainPage> createState() => _OwnerMainPageState();
}

class _OwnerMainPageState extends State<OwnerMainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    OwnerDashboardPage(),
    OwnerServicesPage(),
    OwnerIncidentsPage(),
    OwnerInvoicesPage(),
    OwnerProfilePage(),
  ];

  final List<NavigationDestination> _destinations = const [
    NavigationDestination(
      icon: Icon(Icons.dashboard_outlined),
      selectedIcon: Icon(Icons.dashboard),
      label: 'Dashboard',
    ),
    NavigationDestination(
      icon: Icon(Icons.miscellaneous_services_outlined),
      selectedIcon: Icon(Icons.miscellaneous_services),
      label: 'Dịch vụ',
    ),
    NavigationDestination(
      icon: Icon(Icons.report_problem_outlined),
      selectedIcon: Icon(Icons.report_problem),
      label: 'Sự cố',
    ),
    NavigationDestination(
      icon: Icon(Icons.receipt_long_outlined),
      selectedIcon: Icon(Icons.receipt_long),
      label: 'Hóa đơn',
    ),
    NavigationDestination(
      icon: Icon(Icons.person_outline),
      selectedIcon: Icon(Icons.person),
      label: 'Hồ sơ',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: _destinations,
        animationDuration: const Duration(milliseconds: 300),
        backgroundColor: Colors.white,
        elevation: 8,
      ),
    );
  }
}
