import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:yaanam/core/constant/app_images.dart';
import 'package:yaanam/core/constant/enums.dart';
import 'package:yaanam/core/presentation/widgets/adaptive_status_bar.dart';
import 'package:yaanam/core/router/route_names.dart';
import 'package:yaanam/core/theme/app_colors.dart';
import 'package:yaanam/core/network/api_endpoints.dart';
import 'package:yaanam/features/trip/domain/entities/organiser_trip_entity.dart';
import 'package:yaanam/features/trip/presentation/bloc/trip_bloc.dart';
import 'package:yaanam/features/trip/domain/entities/trip_entity.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String _userName = 'User';
  DashboardTab _selectedTab = DashboardTab.myTrip;
  AwesomeDialog? _loadingDialog;

  @override
  void initState() {
    super.initState();
    _loadUserName();
    // Fetch initial data for MY TRIP
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<TripBloc>().add(const GetTripsRequested(ApiEndpoints.tripList));
      }
    });
  }

  @override
  void dispose() {
    _loadingDialog?.dismiss();
    super.dispose();
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('userName') ?? 'User';
    });
  }

  void _onTabSelected(DashboardTab tab) {
    setState(() {
      _selectedTab = tab;
    });

    switch (tab) {
      case DashboardTab.myTrip:
        context.read<TripBloc>().add(const GetTripsRequested(ApiEndpoints.tripList));
        break;
      case DashboardTab.organise:
        context.read<TripBloc>().add(const GetOrganisedTripsRequested());
        break;
      case DashboardTab.active:
        context.read<TripBloc>().add(const GetTripsRequested(ApiEndpoints.activeTrips));
        break;
    }
  }

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
                              Row(
                                children: [
                                  Text(
                                    _userName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.verified, color: Colors.white, size: 18),
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
                          _buildTab('MY TRIP', DashboardTab.myTrip),
                          const SizedBox(width: 10),
                          _buildTab('ORGANISE', DashboardTab.organise),
                          const SizedBox(width: 10),
                          _buildTab('ACTIVE', DashboardTab.active),
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
                  child: BlocConsumer<TripBloc, TripState>(
                    listener: (context, state) {
                      if (state.status == TripStatus.loading || state.status == TripStatus.detailLoading) {
                        if (_loadingDialog == null) {
                          _loadingDialog = AwesomeDialog(
                            context: context,
                            dialogType: DialogType.noHeader,
                            animType: AnimType.scale,
                            body: const Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircularProgressIndicator(),
                                  SizedBox(height: 16),
                                  Text('Loading...',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            dismissOnTouchOutside: false,
                            dismissOnBackKeyPress: false,
                          );
                          _loadingDialog?.show();
                        }
                      } else {
                        _loadingDialog?.dismiss();
                        _loadingDialog = null;
                        
                        if (state.status == TripStatus.detailSuccess) {
                          if (state.trip != null) {
                            context.push(RouteNames.editTrip, extra: state.trip);
                          }
                        } else if (state.status == TripStatus.detailError) {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            title: 'Error',
                            desc: state.errorMessage ?? 'Failed to load trip details',
                            btnOkOnPress: () {},
                          ).show();
                        }
                      }
                    },
                    builder: (context, state) {
                      if (state.status == TripStatus.loading && state.trips.isEmpty && state.organisedTrips.isEmpty) {
                        return const SizedBox.shrink();
                      } else if (state.status == TripStatus.error && state.trips.isEmpty && state.organisedTrips.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              state.errorMessage ?? 'An error occurred',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }

                      if (_selectedTab == DashboardTab.organise) {
                        if (state.organisedTrips.isEmpty && state.status != TripStatus.loading) {
                          return const Center(child: Text('No organised trips found'));
                        }
                        return ListView.builder(
                          padding: const EdgeInsets.all(20),
                          itemCount: state.organisedTrips.length,
                          itemBuilder: (context, index) {
                            final trip = state.organisedTrips[index];
                            return _buildTripCard(
                              onTap: () {
                                context.read<TripBloc>().add(GetTripDetailRequested(trip.id));
                              },
                              title: trip.name,
                              bike: '', // Summary model doesn't have bike info
                              status: trip.tripStatus,
                              statusColor: _getStatusColor(trip.tripStatus),
                              days: '${trip.startDate.split('T')[0]} - ${trip.endDate.split('T')[0]}',
                              start: trip.sourceCity,
                              startDate: trip.startDate.split('T')[0],
                              end: trip.destinationCity,
                              endDate: trip.endDate.split('T')[0],
                              extraInfo: 'Participants: ${trip.participants.remaining} remaining',
                            );
                          },
                        );
                      } else {
                        if (state.trips.isEmpty && state.status != TripStatus.loading) {
                          return const Center(child: Text('No trips found'));
                        }
                        return ListView.builder(
                          padding: const EdgeInsets.all(20),
                          itemCount: state.trips.length,
                          itemBuilder: (context, index) {
                            final trip = state.trips[index];
                            return _buildTripCard(
                              onTap: null, // Only user can edit trip in organiser list.
                              title: trip.name,
                              bike: '(${trip.vehicleType})',
                              status: trip.tripStatus,
                              statusColor: _getStatusColor(trip.tripStatus),
                              days: '${trip.startDate} - ${trip.endDate}',
                              start: trip.sourceCity,
                              startDate: trip.startDate,
                              end: trip.destinationCity,
                              endDate: trip.endDate,
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: _selectedTab == DashboardTab.organise
            ? FloatingActionButton.extended(
                onPressed: () => context.push(RouteNames.createTrip),
                backgroundColor: AppColors.primary,
                label: const Text('Create', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              )
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        // bottomNavigationBar: Container(
        //   padding: const EdgeInsets.symmetric(vertical: 10),
        //   decoration: const BoxDecoration(
        //     color: AppColors.primary,
        //     borderRadius: BorderRadius.only(
        //       topLeft: Radius.circular(20),
        //       topRight: Radius.circular(20),
        //     ),
        //   ),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceAround,
        //     children: [
        //       _buildNavItem(HugeIcons.strokeRoundedHome01, 0, isSelected: true),
        //       _buildNavItem(HugeIcons.strokeRoundedCalendar01, 1),
        //       _buildNavItem(HugeIcons.strokeRoundedAssignments, 2),
        //       _buildNavItem(HugeIcons.strokeRoundedArrangeByNumbers19, 3, isSelected: false),
        //       _buildNavItem(HugeIcons.strokeRoundedGroupLayers, 4),
        //     ],
        //   ),
        // ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
      case 'active':
        return Colors.green;
      case 'pending':
      case 'approval pending':
        return Colors.orange;
      case 'rejected':
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.blue;
    }
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

  Widget _buildTab(String label, DashboardTab tab) {
    final bool isSelected = _selectedTab == tab;
    return Expanded(
      child: GestureDetector(
        onTap: () => _onTabSelected(tab),
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
    String? extraInfo,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(width: 4),
                        if (bike.isNotEmpty)
                          Text(bike, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(width: 8, height: 8, decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle)),
                        const SizedBox(width: 4),
                        Text(status, style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.w500)),
                        if (extraInfo != null) ...[
                          const SizedBox(width: 12),
                          Text(extraInfo, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                        ]
                      ],
                    ),
                  ],
                ),
                Image.asset(
                  AppImages.bike,
                  height: 50,
                ),
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
    );
  }

  Widget _buildLocationTag(String loc, String date) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          Text(loc, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
          if (date.isNotEmpty)
            Text(date, style: const TextStyle(fontSize: 9, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index, {bool isSelected = false}) {
    return Icon(
      icon,
      color: isSelected ? Colors.white : Colors.white70,
      size: 28,
    );
  }
}
