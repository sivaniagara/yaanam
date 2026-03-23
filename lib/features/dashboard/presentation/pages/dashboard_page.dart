import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yaanam/core/constant/app_images.dart';
import 'package:yaanam/core/presentation/widgets/adaptive_status_bar.dart';
import 'package:yaanam/core/router/route_names.dart';
import 'package:yaanam/core/theme/app_colors.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return AdaptiveStatusBar(
      color: Theme.of(context).colorScheme.primary,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: SafeArea(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    // Header Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.orange,
                            child: Text('🧔', style: TextStyle(fontSize: 24)), // Placeholder for avatar
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hello !',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
                              ),
                              const Row(
                                children: [
                                  Text(
                                    'Ragunath K',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(Icons.verified, color: Colors.white, size: 18),
                                ],
                              ),
                            ],
                          ),
                          const Spacer(),
                          _buildHeaderIcon(Icons.chat_bubble_rounded),
                          const SizedBox(width: 12),
                          _buildHeaderIcon(Icons.notifications),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Tabs Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          _buildTab('MY TRIP', isSelected: true),
                          const SizedBox(width: 10),
                          _buildTab('ORGANISE'),
                          const SizedBox(width: 10),
                          _buildTab('ACTIVE'),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Search Bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            icon: const Icon(Icons.search, color: Colors.grey),
                            hintText: 'Search',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.transparent),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.transparent, width: 1.5),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.transparent),
                            ),
                          ),

                        ),
                      ),
                    ),

                    const SizedBox(height: 10),
                  ],
                ),
              ),

              // Trips List
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      _buildTripCard(
                        title: 'Sky Trail Escape',
                        bike: '(Royal Enfield)',
                        status: 'Approval Pending',
                        statusColor: Colors.red,
                        days: '3 Days',
                        start: 'BAN',
                        startDate: '12-Oct-2025',
                        end: 'COORG',
                        endDate: '15-Oct-2025',
                      ),
                      _buildTripCard(
                        title: 'Sky Trail Escape',
                        bike: '(Royal Enfield)',
                        status: 'Approval Pending',
                        statusColor: Colors.orange,
                        days: '3 Days',
                        start: 'BAN',
                        startDate: '12-Oct-2025',
                        end: 'COORG',
                        endDate: '15-Oct-2025',
                      ),
                      _buildTripCard(
                        title: 'Sky Trail Escape',
                        bike: '(Royal Enfield)',
                        status: 'Approved',
                        statusColor: Colors.green,
                        days: '3 Days',
                        start: 'BAN',
                        startDate: '12-Oct-2025',
                        end: 'COORG',
                        endDate: '15-Oct-2025',
                      ),
                      _buildTripCard(
                        title: 'Sky Trail Escape',
                        bike: '(Royal Enfield)',
                        status: 'Approval Pending',
                        statusColor: Colors.red,
                        days: '12-Oct-2025',
                        start: 'BAN',
                        startDate: '',
                        end: 'COORG',
                        endDate: '',
                        showDatesOnly: true,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => context.push(RouteNames.createTrip),
          backgroundColor: AppColors.primary,
          label: const Text('Create', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: const BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_outlined, 0, isSelected: true),
              _buildNavItem(Icons.calendar_today_outlined, 1),
              _buildNavItem(Icons.assignment_outlined, 2),
              _buildNavItem(Icons.confirmation_number_outlined, 3, isSelected: false),
              _buildNavItem(Icons.layers_outlined, 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: AppColors.primary, size: 24),
    );
  }

  Widget _buildTab(String label, {bool isSelected = false}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: isSelected ? null : Border.all(color: Colors.white70),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? AppColors.primaryDark : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTripCard({
    required String title,
    required String bike,
    required String status,
    required Color statusColor,
    required String days,
    required String start,
    required String startDate,
    required String end,
    required String endDate,
    bool showDatesOnly = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(width: 4),
                    Text(bike, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(width: 8, height: 8, decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle)),
                    const SizedBox(width: 4),
                    Text(status, style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.w500)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.calendar_month_outlined, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(days, style: const TextStyle(fontSize: 12, color: Colors.black87)),
                    const SizedBox(width: 8),
                    if (!showDatesOnly) ...[
                      _buildLocationTag(start, startDate),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(Icons.sync_alt, size: 14, color: Colors.grey),
                      ),
                      _buildLocationTag(end, endDate),
                    ] else ...[
                       _buildLocationTag(start, ''),
                       const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(Icons.sync_alt, size: 14, color: Colors.grey),
                      ),
                      _buildLocationTag(end, ''),
                    ]
                  ],
                ),
              ],
            ),
          ),
          Image.asset(
              AppImages.bike,
            height: 50,
          ), // Placeholder for bike image
        ],
      ),
    );
  }

  Widget _buildLocationTag(String loc, String date) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorDark,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          Text(loc, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
          if (date.isNotEmpty)
            Text(date, style: const TextStyle(color: Colors.white, fontSize: 8)),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index, {bool isSelected = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white.withValues(alpha: isSelected ? 1 : 0.7), size: 28),
        if (isSelected)
          Container(
            margin: const EdgeInsets.only(top: 4),
            width: 12,
            height: 2,
            color: Colors.white,
          ),
      ],
    );
  }
}
