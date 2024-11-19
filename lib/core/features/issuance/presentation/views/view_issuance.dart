import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../config/sizing/sizing_config.dart';
import '../../../../common/components/custom_circular_loader.dart';
import '../../../../common/components/custom_loading_filled_button.dart';
import '../../../../common/components/custom_message_box.dart';
import '../../../../common/components/qr_container.dart';
import '../../../../common/components/reusable_rich_text.dart';
import '../../../../constants/static_data.dart';
import '../../../../models/issuance/inventory_custodian_slip.dart';
import '../../../../models/issuance/issuance.dart';
import '../../../../models/issuance/issuance_item.dart';
import '../../../../models/issuance/property_acknowledgement_receipt.dart';
import '../../../../utils/capitalizer.dart';
import '../../../../utils/date_formatter.dart';
import '../../../../utils/delightful_toast_utils.dart';
import '../../../../utils/readable_enum_converter.dart';
import '../bloc/issuances_bloc.dart';

/// todo: further optimization
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
  late IssuanceModel _issuance = IssuanceModel.fromJson(issuanceInitData);

  final ValueNotifier<bool> _isLoading = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _issuancesBloc = context.read<IssuancesBloc>();
    _fetchIssuance();
  }

  void _fetchIssuance() {
    _issuancesBloc.add(
      GetIssuanceByIdEvent(
        id: widget.issuanceId,
      ),
    );
  }

  @override
  void dispose() {
    _isLoading.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizingConfig.widthMultiplier * 5.0,
            vertical: SizingConfig.heightMultiplier * 3.0,
          ),
          child: BlocListener<IssuancesBloc, IssuancesState>(
            listener: (context, state) {
              if (state is ReceivingIssuanceLoading) {
                _isLoading.value = true;
              }

              if (state is ReceivedIssuance) {
                _isLoading.value = false;
                _issuance = state.issuance as IssuanceModel;
                DelightfulToastUtils.showDelightfulToast(
                  context: context,
                  icon: HugeIcons.strokeRoundedNotificationSquare,
                  title: 'Received Issuance',
                  subtitle: 'Issuance marked as received.',
                );
              }

              if (state is ReceiveIssuanceError) {
                _isLoading.value = false;
                DelightfulToastUtils.showDelightfulToast(
                  context: context,
                  icon: HugeIcons.strokeRoundedNotificationSquare,
                  title: 'Receiving Issuance Error',
                  subtitle: state.message,
                );
              }

              if (state is IssuanceLoaded) {
                _isLoading.value = false;
                _issuance = state.issuance as IssuanceModel;
              }
            },
            child: BlocBuilder<IssuancesBloc, IssuancesState>(
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const BackButton(),
                    if (state is IssuancesError)
                      CustomMessageBox.error(
                        message: state.message,
                      ),
                    // if (state is IssuancesLoading)
                    //   _buildLoadingStateView(),
                    Expanded(
                      child: SingleChildScrollView(
                        child: _buildIssuanceSection(
                          _issuance,
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

  Widget _buildIssuanceSection(IssuanceModel issuance) {
    return Column(
      children: [
        QrContainer(
          data: issuance.id,
        ),
        SizedBox(
          height: SizingConfig.heightMultiplier * 2.0,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!issuance.isReceived)
              CustomLoadingFilledButton(
                onTap: () => _issuancesBloc.add(
                  ReceiveIssuanceEvent(
                    id: issuance.id,
                  ),
                ),
                isLoadingNotifier: _isLoading,
                text: 'Receive Issuance',
                height: 50.0,
              ),
            SizedBox(
              height: SizingConfig.heightMultiplier * 5.0,
            ),
            Divider(
              color: Theme.of(context).dividerColor,
              thickness: 1.0,
            ),
            _buildDetailsSection(
              issuance,
            ),
            SizedBox(
              height: SizingConfig.heightMultiplier * 1.5,
            ),
            _buildItemListSection(
              issuance.items as List<IssuanceItemModel>,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailsSection(IssuanceModel issuance) {
    final issuanceData = issuance is InventoryCustodianSlipModel
        ? InventoryCustodianSlipModel.fromEntity(issuance)
        : issuance is PropertyAcknowledgementReceiptModel
            ? PropertyAcknowledgementReceiptModel.fromEntity(issuance)
            : null;

    String?
        concreteIssuanceId; // this will represent the concrete entity id of abstract base entity issuance
    String? sendingOfficerName;
    // String? sendingOfficerOffice;
    // String? sendingOfficerPosition;

    String? propertyNumber; // exclusive for par only

    if (issuanceData is InventoryCustodianSlipModel) {
      concreteIssuanceId = issuanceData.icsId;
      sendingOfficerName = issuanceData.sendingOfficerEntity.name;
      // sendingOfficerOffice = issuanceData.sendingOfficerEntity.officeName;
      // sendingOfficerPosition = issuanceData.sendingOfficerEntity.positionName;
    }

    if (issuanceData is PropertyAcknowledgementReceiptModel) {
      concreteIssuanceId = issuanceData.parId;
      sendingOfficerName = issuanceData.sendingOfficerEntity.name;
      // sendingOfficerOffice = issuanceData.sendingOfficerEntity.officeName;
      // sendingOfficerPosition = issuanceData.sendingOfficerEntity.positionName;
      propertyNumber = issuanceData.propertyNumber;
    }

    return Column(
      children: [
        ReusableRichText(
          title: 'Issuance No: ',
          value: issuanceData!.id,
        ),
        SizedBox(
          height: SizingConfig.heightMultiplier * 1.5,
        ),
        ReusableRichText(
          title: issuanceData is InventoryCustodianSlipModel
              ? 'ICS No:'
              : 'PAR No: ',
          value: concreteIssuanceId!,
        ),
        SizedBox(
          height: SizingConfig.heightMultiplier * 1.5,
        ),
        if (issuanceData is PropertyAcknowledgementReceiptModel &&
            propertyNumber != null &&
            propertyNumber.isNotEmpty)
          Column(
            children: [
              ReusableRichText(
                title: 'Property Number: ',
                value: propertyNumber,
              ),
              SizedBox(
                height: SizingConfig.heightMultiplier * 1.5,
              ),
            ],
          ),
        ReusableRichText(
          title: 'PR No: ',
          value: issuanceData.purchaseRequestEntity.id,
        ),
        SizedBox(
          height: SizingConfig.heightMultiplier * 1.5,
        ),
        ReusableRichText(
          title: 'Entity: ',
          value: issuanceData.purchaseRequestEntity.entity.name,
        ),
        SizedBox(
          height: SizingConfig.heightMultiplier * 1.5,
        ),
        ReusableRichText(
          title: 'Fund Cluster: ',
          value: readableEnumConverter(
              issuanceData.purchaseRequestEntity.fundCluster),
        ),
        SizedBox(
          height: SizingConfig.heightMultiplier * 1.5,
        ),
        ReusableRichText(
          title: 'Issue Date: ',
          value: dateFormatter(issuanceData.issuedDate),
        ),
        SizedBox(
          height: SizingConfig.heightMultiplier * 1.5,
        ),
        ReusableRichText(
          title: 'Receiving Officer:',
          value: capitalizeWord(
            issuanceData.receivingOfficerEntity.name,
          ),
        ),
        SizedBox(
          height: SizingConfig.heightMultiplier * 1.5,
        ),
        ReusableRichText(
          title: 'Sending Officer:',
          value: capitalizeWord(
            sendingOfficerName!,
          ),
        ),
      ],
    );
  }

  Widget _buildItemListSection(List<IssuanceItemModel> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Issued Item(s):',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: SizingConfig.textMultiplier * 2.0,
                  fontWeight: FontWeight.w500,
                )),
        SizedBox(
          height: SizingConfig.heightMultiplier * 1.0,
        ),
        SizedBox(
          height: 200.0,
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];

              return Container(
                key: ValueKey(item.itemEntity.itemEntity.id),
                margin: const EdgeInsets.only(bottom: 3.0),
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Theme.of(context).cardColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.itemEntity.itemEntity.id,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: SizingConfig.textMultiplier * 1.5,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    Text(
                      item.quantity.toString(),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: SizingConfig.textMultiplier * 1.5,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    Text(
                      item.itemEntity.itemEntity.unitCost.toString(),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: SizingConfig.textMultiplier * 1.5,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingStateView() {
    return Center(
      child: Column(
        children: [
          const CustomCircularLoader(),
          Text(
            'Fetching purchase request...',
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
