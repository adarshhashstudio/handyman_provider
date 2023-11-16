import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/handyman/screen/item_details_screen.dart';
import 'package:handyman_provider_flutter/models/added_area.dart';
import 'package:handyman_provider_flutter/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/back_widget.dart';

class AreaDetailsScreen extends StatefulWidget {
  final AddedArea? areaDetails;
  const AreaDetailsScreen({super.key, this.areaDetails});

  @override
  State<AreaDetailsScreen> createState() => _AreaDetailsScreenState();
}

class _AreaDetailsScreenState extends State<AreaDetailsScreen> {
  List<AddedArea> itemsList = [
    AddedArea(
      name: 'Fridge',
      description:
          'A refrigerator, colloquially fridge, is a commercial and home appliance consisting of a thermally insulated compartment and a heat pump (mechanical, electronic or chemical) ',
    ),
    AddedArea(
      name: 'Water Cooler',
      description:
          'We provides the wide range of water cooler with a powerful and rugged compressor. with faster cooling, eco-friendly, stainless steel body.',
    ),
  ];

  Widget listViewItems() {
    return AnimatedListView(
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: itemsList.length,
        itemBuilder: (context, index) {
          return itemListItem(index, itemsList).paddingOnly(bottom: 12);
        });
  }

  Widget itemListItem(int index, List<AddedArea> itemList) {
    return Container(
      padding: EdgeInsets.all(10),
      width: context.width() * 0.1,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: cardColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${itemList[index].name}',
            maxLines: 1,
            style: primaryTextStyle(weight: FontWeight.bold),
          ),
          8.height,
          Text(
            '${itemList[index].description}',
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: primaryTextStyle(
                weight: FontWeight.bold, size: 12, color: gray),
          ),
        ],
      ),
    ).onTap(() {
      ItemDetailsScreen(
        item: itemsList[index],
      ).launch(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        '${widget.areaDetails?.name ?? ''}',
        textColor: white,
        elevation: 0.0,
        color: context.primaryColor,
        backWidget: BackWidget(),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20, top: 5),
            child: Icon(
              Icons.add_circle,
              color: white,
            ).onTap(() {}),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: listViewItems(),
      ),
    );
  }
}
