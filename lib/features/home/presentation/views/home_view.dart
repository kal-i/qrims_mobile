import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../config/routes/app_routing_constants.dart';
import '../../../../config/sizing/sizing_config.dart';
import '../../../../config/themes/app_color.dart';
import '../../../../core/constants/assets_path.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 30.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeaderRow(),
              SizedBox(
                height: SizingConfig.heightMultiplier * 3.0,
              ),
              Expanded(
                child: _buildSummaryReportsContainer(),
              ),
              SizedBox(
                height: SizingConfig.heightMultiplier * 3.0,
              ),
              Expanded(
                flex: 2,
                child: _buildPendingRequestsView(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back,',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Text(
              'Jessica!',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        _buildProfileContainer(),
        // IconButton(
        //   onPressed: () => context.go(
        //     RoutingConstants.nestedQrScannerViewRoutePath,
        //   ),
        //   icon: const Icon(
        //     HugeIcons.strokeRoundedQrCode01,
        //     size: 24.0,
        //   ),
        // ),
      ],
    );
  }

  Widget _buildSummaryReportsContainer() {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  label: 'Fulfilled',
                  icon: HugeIcons.strokeRoundedPackageDelivered,
                  background: AppColor.lightGreen,
                  outlineColor: AppColor.lightGreenOutline,
                  foreground: AppColor.lightGreenText,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Expanded(
                child: _buildSummaryCard(
                  label: 'Semi-Fulfilled',
                  icon: HugeIcons.strokeRoundedPackageRemove,
                  background: AppColor.lightBlue,
                  outlineColor: AppColor.lightBlueOutline,
                  foreground: AppColor.lightBlueText,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 10.0,
        ),
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  label: 'Pending',
                  icon: HugeIcons.strokeRoundedPackageProcess,
                  background: AppColor.lightYellow,
                  outlineColor: AppColor.lightYellowOutline,
                  foreground: AppColor.lightYellowText,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Expanded(
                  child: _buildSummaryCard(
                label: 'Cancelled',
                icon: HugeIcons.strokeRoundedPackageRemove,
                background: AppColor.lightRed,
                outlineColor: AppColor.lightRedOutline,
                foreground: AppColor.lightRedText,
              )),
            ],
          ),
        ),
      ],
    );
  }

  // todo: prolly move the cancelled and fulfilled to history

  Widget _buildSummaryCard({
    required String label,
    required IconData icon,
    required Color background,
    required Color outlineColor,
    required Color foreground,
  }) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Theme.of(context).primaryColor,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: outlineColor,
              ),
              borderRadius: BorderRadius.circular(10.0),
              color: background,
            ),
            child: Icon(
              icon,
              color: outlineColor,
              size: 20.0,
            ),
          ),
          const SizedBox(
            width: 10.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: foreground,
                        fontSize: SizingConfig.textMultiplier * 1.6,
                      ),
                ),
                Text(
                  '69',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: foreground,
                        fontSize: SizingConfig.textMultiplier * 3.5,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileContainer() {
    return Container(
      width: 60.0,
      height: 60.0,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: AssetImage(
            ImagePath.profile,
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  // convert to enum later
  final List<String> _prStatusLists = [
    'Pending',
    'Semi-Fulfilled',
    'Fulfilled',
    'Cancelled',
  ];

  Widget _buildPendingRequestsView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Purchase Requests',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'See all',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColor.lightSubTitleText,
                    ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 5.0,
        ),
        Container(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: _prStatusLists
                .map(
                  (prStatus) => Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      prStatus,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            decoration: TextDecoration.underline,
                            decorationThickness: 3.0,
                          ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        const SizedBox(
          height: 5.0,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return Slidable(
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (_) {},
                      borderRadius: BorderRadius.circular(10.0),
                      backgroundColor: AppColor.lightYellow,
                      foregroundColor: AppColor.lightYellowText,
                      icon: HugeIcons.strokeRoundedView,
                      label: 'View',
                    ),
                    // send some kind of distress signal in a form of notif I guess
                    SlidableAction(
                      borderRadius: BorderRadius.circular(10.0),
                      onPressed: (_) {},
                      backgroundColor: AppColor.lightGreen,
                      foregroundColor: AppColor.lightGreenText,
                      icon: HugeIcons.strokeRoundedSent,
                      label: 'Notify',
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    bottom: 5.0,
                  ),
                  child: ListTile(
                    isThreeLine: true,
                    // contentPadding: const EdgeInsets.symmetric(
                    //   horizontal: 10.0,
                    //   vertical: 5.0,
                    // ),
                    tileColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    // leading: Text(
                    //   '2024/10/12',
                    //   style: Theme.of(context).textTheme.bodySmall,
                    // ),
                    subtitle: RichText(
                      text: TextSpan(
                        text: 'Date:      ',
                        style: Theme.of(context).textTheme.bodySmall,
                        children: [
                          TextSpan(
                            text: '12/02/2024',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    title: RichText(
                      text: TextSpan(
                        text: 'PR No.:  ',
                        style: Theme.of(context).textTheme.bodySmall,
                        children: [
                          TextSpan(
                            text: 'PR-2024-10-012',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    trailing: Text(
                      'Pending',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
