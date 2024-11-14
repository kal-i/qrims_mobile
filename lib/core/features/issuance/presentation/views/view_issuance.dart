import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../../config/sizing/sizing_config.dart';
import '../../../../../config/themes/app_color.dart';
import '../../../../common/components/custom_circular_loader.dart';
import '../../../../common/components/custom_filled_button.dart';
import '../../../../common/components/custom_message_box.dart';
import '../../../../utils/capitalizer.dart';
import '../../../../utils/date_formatter.dart';
import '../../../../utils/readable_enum_converter.dart';
import '../bloc/issuances_bloc.dart';

class ViewIssuanceInformation extends StatefulWidget {
  const ViewIssuanceInformation({
    super.key,
    required this.issuanceId,
  });

  final String issuanceId;

  @override
  State<ViewIssuanceInformation> createState() =>
      _ViewIssuanceInformationState();
}

class _ViewIssuanceInformationState extends State<ViewIssuanceInformation> {
  late IssuancesBloc _issuancesBloc;

  @override
  void initState() {
    super.initState();
    _issuancesBloc = context.read<IssuancesBloc>();
    print('received: ${widget.issuanceId}');
    _issuancesBloc.add(
      GetIssuanceByIdEvent(
        id: widget.issuanceId,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // listener to show message when receive was clicked
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizingConfig.widthMultiplier * 5.0,
            vertical: SizingConfig.heightMultiplier * 3.0,
          ),
          child: BlocListener<IssuancesBloc, IssuancesState>(
            listener: (context, state) {},
            child: BlocBuilder<IssuancesBloc, IssuancesState>(
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const BackButton(),
                    if (state is IssuancesLoading) _buildLoadingStateView(),
                    if (state is IssuancesError)
                      CustomMessageBox.error(
                        message: state.message,
                      ),
                    if (state is IssuanceLoaded)
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              _buildQrContainer(
                                issuanceId: state.issuance.id,
                              ),
                              SizedBox(
                                height: SizingConfig.heightMultiplier * 2.0,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Text(
                                  //   'Issuance Information #${state.issuance.id}',
                                  //   style:
                                  //       Theme.of(context).textTheme.titleMedium?.copyWith(
                                  //             fontSize: SizingConfig.textMultiplier * 3.8,
                                  //             //fontWeight: FontWeight.w600,
                                  //           ),
                                  // ),
                                  // SizedBox(
                                  //   height: SizingConfig.heightMultiplier * 2.0,
                                  // ),
                                  const CustomFilledButton(
                                    text: 'Receive Issuance',
                                    height: 50.0,
                                    width: 300.0,
                                  ),
                                  SizedBox(
                                    height: SizingConfig.heightMultiplier * 5.0,
                                  ),
                                  Divider(
                                    color: Theme.of(context).dividerColor,
                                    thickness: 1.0,
                                  ),
                                  _reusableRichText(
                                    title: 'Issuance Id: ',
                                    value: state.issuance.id,
                                  ),
                                  SizedBox(
                                    height: SizingConfig.heightMultiplier * 1.5,
                                  ),
                                  _reusableRichText(
                                    title: 'PR No: ',
                                    value:
                                        state.issuance.purchaseRequestEntity.id,
                                  ),
                                  SizedBox(
                                    height: SizingConfig.heightMultiplier * 1.5,
                                  ),
                                  _reusableRichText(
                                    title: 'Entity: ',
                                    value: state.issuance.purchaseRequestEntity
                                        .entity.name,
                                  ),
                                  SizedBox(
                                    height: SizingConfig.heightMultiplier * 1.5,
                                  ),
                                  _reusableRichText(
                                    title: 'Fund Cluster: ',
                                    value: readableEnumConverter(state.issuance
                                        .purchaseRequestEntity.fundCluster),
                                  ),
                                  SizedBox(
                                    height: SizingConfig.heightMultiplier * 1.5,
                                  ),
                                  _reusableRichText(
                                    title: 'Issue Date: ',
                                    value: dateFormatter(
                                        state.issuance.issuedDate),
                                  ),
                                  SizedBox(
                                    height: SizingConfig.heightMultiplier * 1.5,
                                  ),
                                  _reusableRichText(
                                    title: 'Receiving Officer:',
                                    value: capitalizeWord(
                                      state
                                          .issuance.receivingOfficerEntity.name,
                                    ),
                                  ),
                                  SizedBox(
                                    height: SizingConfig.heightMultiplier * 1.5,
                                  ),
                                  Text('Issued Item(s):',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontSize:
                                                SizingConfig.textMultiplier *
                                                    2.0,
                                            fontWeight: FontWeight.w500,
                                          )),
                                  SizedBox(
                                    height: SizingConfig.heightMultiplier * 1.0,
                                  ),
                                  SizedBox(
                                    height: 200.0,
                                    child: ListView.builder(
                                      itemCount: state.issuance.items.length,
                                      itemBuilder: (context, index) {
                                        final item =
                                            state.issuance.items[index];

                                        return Container(
                                          margin: EdgeInsets.only(bottom: 3.0),
                                          padding: const EdgeInsets.all(20.0),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            color: Theme.of(context).cardColor,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                item.itemEntity.itemEntity.id,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                      fontSize: SizingConfig
                                                              .textMultiplier *
                                                          1.5,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                              ),
                                              Text(
                                                item.quantity.toString(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                      fontSize: SizingConfig
                                                              .textMultiplier *
                                                          1.5,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                              ),
                                              Text(
                                                item.itemEntity.itemEntity
                                                    .unitCost
                                                    .toString(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                      fontSize: SizingConfig
                                                              .textMultiplier *
                                                          1.5,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingStateView() {
    return Center(
      child: Column(
        children: [
          const CustomCircularLoader(),
          Text(
            'Fetching issuance information...',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: SizingConfig.textMultiplier * 1.8,
                  fontWeight: FontWeight.w400,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrContainer({required String issuanceId}) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      width: 180.0,
      height: 180.0,
      decoration: BoxDecoration(
        // border: Border.all(
        //   color: Theme.of(context).dividerColor,
        //   width: 0.4,
        // ),
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: AppColor.darkPrimary.withOpacity(0.25),
            blurRadius: 4.0,
            spreadRadius: 0.0,
            offset: const Offset(0.0, 4.0),
          )
        ],
        color: Theme.of(context).primaryColor,
      ),
      child: QrImageView(
        data: issuanceId,
        eyeStyle: const QrEyeStyle(
          eyeShape: QrEyeShape.circle,
          color: AppColor.darkPrimary,
        ),
        dataModuleStyle: const QrDataModuleStyle(
          dataModuleShape: QrDataModuleShape.circle,
          color: AppColor.darkPrimary,
        ),
      ),
    );
  }

  Widget _reusableRichText({
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: SizingConfig.textMultiplier * 2.0,
                fontWeight: FontWeight.w500,
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontSize: SizingConfig.textMultiplier * 1.8,
            fontWeight: FontWeight.w400,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
    return RichText(
      text: TextSpan(
        text: title,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: SizingConfig.textMultiplier * 2.0,
              fontWeight: FontWeight.w500,
            ),
        children: [
          TextSpan(
            text: value,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: SizingConfig.textMultiplier * 1.8,
                  fontWeight: FontWeight.w400,
                  overflow: TextOverflow.ellipsis,
                ),
          ),
        ],
      ),
    );
  }
}
