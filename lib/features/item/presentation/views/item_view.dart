import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../config/sizing/sizing_config.dart';
import '../../../../config/themes/app_color.dart';
import '../../../../core/common/components/custom_circular_loader.dart';
import '../../../../core/common/components/custom_message_box.dart';
import '../../../../core/common/components/qr_container.dart';
import '../../../../core/common/components/reusable_rich_text.dart';
import '../../../../core/models/item_inventory/item.dart';
import '../../../../core/models/item_inventory/item_with_stock.dart';
import '../../../../core/utils/format_specification.dart';
import '../../../../core/utils/readable_enum_converter.dart';
import '../bloc/item_bloc.dart';

class ItemView extends StatefulWidget {
  const ItemView({
    super.key,
    required this.itemId,
  });

  final String itemId;

  @override
  State<ItemView> createState() => _ItemViewState();
}

class _ItemViewState extends State<ItemView> {
  late ItemBloc _itemBloc;

  @override
  void initState() {
    super.initState();
    _itemBloc = context.read<ItemBloc>();
    _fetchItemInformation();
  }

  void _fetchItemInformation() {
    _itemBloc.add(
      GetItemByEncryptedIdEvent(
        id: widget.itemId,
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BackButton(),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizingConfig.widthMultiplier * 5.0,
                    vertical: SizingConfig.heightMultiplier * 3.0,
                  ),
                  child: BlocBuilder<ItemBloc, ItemState>(
                      builder: (context, state) {
                    return _buildMainView(
                      state,
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainView(ItemState state) {
    if (state is ItemLoading) {
      return _buildLoadingStateView();
    }

    if (state is ItemNotFound) {
      return _buildInvalidFormatStateView();
    }

    if (state is ItemError) {
      return CustomMessageBox.error(
        message: state.message,
      );
    }

    if (state is ItemLoaded) {
      return _buildItemDetails(state);
    }

    return const SizedBox.shrink();
  }

  Widget _buildItemDetails(ItemLoaded state) {
    final item = state.item as ItemWithStockModel;
    final itemData = item.itemEntity as ItemModel;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildInitialItemInformationSection(itemData),
        _buildItemDescriptionSection(item),
      ],
    );
  }

  Widget _buildInitialItemInformationSection(ItemModel item) {
    return Column(
      children: [
        QrContainer(
          data: item.encryptedId,
        ),
        SizedBox(
          height: SizingConfig.heightMultiplier * 5.0,
        ),
        Divider(
          color: Theme.of(context).dividerColor,
          thickness: 1.0,
        ),
        ReusableRichText(
          title: 'Item Id: ',
          value: item.id,
        ),
      ],
    );
  }

  Widget _buildItemDescriptionSection(ItemWithStockModel item) {
    final dataMap = {
      'Item Name': item.productStockEntity.productName.name,
      'Description': item.productStockEntity.productDescription?.description ?? 'N/A',
      'Manufacturer': item.manufacturerBrandEntity.manufacturer.name,
      'Brand': item.manufacturerBrandEntity.brand.name,
      'Serial No.': item.itemEntity.serialNo ?? 'N/A',
      'Specification': formatSpecification(item.itemEntity.specification, ' - '),
      'Asset Classification': readableEnumConverter(item.itemEntity.assetClassification),
      'Asset Sub Class': readableEnumConverter(item.itemEntity.assetSubClass),
      'Unit': readableEnumConverter(item.itemEntity.unit),
      'Unit Cost': item.itemEntity.unitCost.toString(),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: dataMap.entries.map((entry) {
        return Padding(
          padding: EdgeInsets.only(bottom: SizingConfig.heightMultiplier * 1.5),
          child: ReusableRichText(
            title: '${entry.key}: ',
            value: entry.value,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildInvalidFormatStateView() {

    return Column(
      children: [
        Icon(
          HugeIcons.strokeRoundedAlert01,
          size: SizingConfig.heightMultiplier * 15.0,
          color: AppColor.yellowOutline,
        ),
        SizedBox(
          height: SizingConfig.heightMultiplier * 1.5,
        ),
        Text(
          'Not Found.',
          softWrap: true,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppColor.yellowText,
            fontSize: SizingConfig.textMultiplier * 3.5,
              ),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: SizingConfig.heightMultiplier * 0.5,
        ),
        Text(
          'The scanned QR Code is invalid or unrecognized.',
          softWrap: true,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColor.yellowText,
                fontSize: SizingConfig.textMultiplier * 2.2,
                fontWeight: FontWeight.w400,
                //overflow: TextOverflow.ellipsis,
              ),
          textAlign: TextAlign.center,
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
