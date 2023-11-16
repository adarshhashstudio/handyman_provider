import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/components/back_widget.dart';
import 'package:handyman_provider_flutter/handyman/screen/area_details_screen.dart';
import 'package:handyman_provider_flutter/handyman/screen/inspection_add_area.dart';
import 'package:handyman_provider_flutter/handyman/screen/inspection_add_item.dart';
import 'package:handyman_provider_flutter/handyman/screen/item_details_screen.dart';
import 'package:handyman_provider_flutter/utils/colors.dart';
import 'package:handyman_provider_flutter/utils/configs.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/cached_image_widget.dart';
import '../../models/added_area.dart';
import '../../models/caregory_response.dart';

class InspectionScreen extends StatefulWidget {
  const InspectionScreen({super.key});

  @override
  State<InspectionScreen> createState() => _InspectionScreenState();
}

class _InspectionScreenState extends State<InspectionScreen> {
  List<CategoryData> staticList = [
    CategoryData(name: 'Add Area', categoryImage: 'assets/images/plan.png')
  ];

  List<AddedArea> areaList = [];

  void addAreaListData() {
    areaList.addAll([
      AddedArea(
          name: 'Drawing Room',
          size: 1200,
          description:
              'There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don\'t look even slightly believable.',
          imageFiles: [
            'https://picsum.photos/id/238/200/300',
            'https://picsum.photos/id/137/200/300',
            'https://picsum.photos/id/247/200/300',
            'https://picsum.photos/id/232/200/300'
          ]),
      AddedArea(
          name: 'Bed Room',
          size: 1200,
          description:
              'There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don\'t look even slightly believable.',
          imageFiles: [
            'https://picsum.photos/id/8/200/300',
            'https://picsum.photos/id/17/200/300',
          ]),
      AddedArea(
          name: 'Bath Room',
          size: 1200,
          description:
              'There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don\'t look even slightly believable.',
          imageFiles: [
            'https://picsum.photos/id/23/200/300',
            'https://picsum.photos/id/13/200/300',
            'https://picsum.photos/id/24/200/300',
          ]),
    ]);
    setState(() {});
  }

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

  Widget inspectionItem({String? image, String? name, Color? textColor}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(width: 1, color: Colors.black26),
      ),
      child: Center(
        child: Column(
          children: [
            Container(
              width: context.width() * 0.3,
              height: context.height() * 0.15,
              child: Image.asset(
                image ?? '',
                fit: BoxFit.cover,
              ),
            ),
            6.height,
            Text(
              name ?? '',
              style: primaryTextStyle(
                  weight: FontWeight.bold, color: textColor ?? primaryColor),
            )
          ],
        ),
      ),
    );
  }

  Widget gridViewItems() {
    return GridView.builder(
      itemCount: staticList.length + 1,
      physics: AlwaysScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
      ),
      itemBuilder: (context, index) => (index < staticList.length)
          ? inspectionItem(
                  image: staticList[index].categoryImage.toString(),
                  name: staticList[index].name.toString())
              .onTap(() {
              InspectionAddArea().launch(context);
              addAreaListData();
            })
          : inspectionItem(
              image: 'assets/images/home-appliance.png',
              name: 'Add Item',
              textColor: black,
            ).onTap(() {
              InspectionAddItem().launch(context);
              addAreaListData();
            }),
    );
  }

  Widget listViewItems() {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Area',
            style: primaryTextStyle(color: gray, weight: FontWeight.bold),
          ),
          12.height,
          AnimatedListView(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: areaList.length,
              itemBuilder: (context, index) {
                return areaListItem(index, areaList).paddingOnly(bottom: 12);
              }),
          20.height,
          Text(
            'Item',
            style: primaryTextStyle(color: gray, weight: FontWeight.bold),
          ),
          12.height,
          AnimatedListView(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: itemsList.length,
              itemBuilder: (context, index) {
                return itemListItem(index, itemsList).paddingOnly(bottom: 12);
              }),
        ],
      ),
    );
  }

  Widget areaListItem(int index, List<AddedArea> areaList) {
    return Container(
      padding: EdgeInsets.all(10),
      width: context.width() * 0.1,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: cardColor),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    SizedBox(
                      child: Text(
                        '${areaList[index].name} \u2022 ',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: primaryTextStyle(weight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      width: context.width() * 0.4,
                      child: Text(
                        '${areaList[index].size} Sq/Ft',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: primaryTextStyle(
                            weight: FontWeight.bold, color: gray),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.keyboard_arrow_right,
                color: black,
                size: 28,
              )
            ],
          ),
          if (areaList[index].imageFiles != null &&
              areaList[index].imageFiles!.isNotEmpty)
            8.height,
          if (areaList[index].imageFiles != null &&
              areaList[index].imageFiles!.isNotEmpty)
            Align(
              alignment: Alignment.centerLeft,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: AlwaysScrollableScrollPhysics(),
                child: Row(
                  children: [
                    for (var i = 0; i < areaList[index].imageFiles!.length; i++)
                      CachedImageWidget(
                        url: areaList[index].imageFiles![i],
                        fit: BoxFit.cover,
                        width: 52,
                        height: 48,
                        radius: defaultRadius,
                      ).paddingRight(5)
                  ],
                ),
              ),
            )
        ],
      ),
    ).onTap(() {
      AreaDetailsScreen(
        areaDetails: areaList[index],
      ).launch(context);
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
          'Inspection',
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
        body: Stack(
          children: [
            Container(
              height: context.height() * 1,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: areaList.isEmpty ? gridViewItems() : listViewItems(),
            ),
            if (areaList.isNotEmpty)
              Positioned(
                bottom: 0,
                child: AppButton(
                  text: 'Complete Inspection',
                  color: primaryColor,
                  textColor: white,
                  width: context.width() * 0.9,
                  onTap: () {
                    areaList = [];
                    setState(() {});
                  },
                ).paddingSymmetric(horizontal: 16),
              ),
          ],
        ));
  }
}
