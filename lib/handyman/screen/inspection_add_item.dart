import 'dart:io';

import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/components/back_widget.dart';
import 'package:handyman_provider_flutter/components/custom_image_picker.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/sample_area_name_response.dart';
import 'package:handyman_provider_flutter/models/state_list_response.dart';
import 'package:handyman_provider_flutter/utils/common.dart';
import 'package:handyman_provider_flutter/utils/configs.dart';
import 'package:handyman_provider_flutter/utils/constant.dart';
import 'package:handyman_provider_flutter/utils/model_keys.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../models/attachment_model.dart';

class InspectionAddItem extends StatefulWidget {
  const InspectionAddItem({super.key});

  @override
  State<InspectionAddItem> createState() => _InspectionAddItemState();
}

class _InspectionAddItemState extends State<InspectionAddItem> {
  UniqueKey uniqueKey = UniqueKey();
  TextEditingController? descriptionController;
  SampleAreaNameResponse? selectedArea;
  int? selectedAreaId;
  List<SampleAreaNameResponse> areaNameList = [
    SampleAreaNameResponse(
      name: 'Drawing Room',
      id: 1,
    ),
    SampleAreaNameResponse(
      name: 'Bed Room',
      id: 2,
    ),
    SampleAreaNameResponse(
      name: 'Lobby',
      id: 3,
    ),
    SampleAreaNameResponse(
      name: 'Kitchen',
      id: 4,
    ),
  ];

  SampleAreaNameResponse? selectedItem;
  int? selectedItemId;
  List<SampleAreaNameResponse> itemNameList = [
    SampleAreaNameResponse(
      name: 'Fridge',
      id: 1,
    ),
    SampleAreaNameResponse(
      name: 'AC',
      id: 2,
    ),
    SampleAreaNameResponse(
      name: 'Sofa',
      id: 3,
    ),
    SampleAreaNameResponse(
      name: 'Bed',
      id: 4,
    ),
  ];

  List<File> imageFiles = [];
  List<Attachments> tempAttachments = [];
  bool isUpdate = false;

  //region Remove Attachment
  Future<void> removeAttachment({required int id}) async {
    appStore.setLoading(true);
    tempAttachments.validate().removeWhere((element) => element.id == id);
    setState(() {});

    uniqueKey = UniqueKey();

    appStore.setLoading(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget('Add Item',
          textColor: white,
          elevation: 0.0,
          color: context.primaryColor,
          backWidget: BackWidget()),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          children: [
            DropdownButtonFormField<SampleAreaNameResponse>(
              decoration: inputDecoration(context, hint: 'Area Name'),
              style: primaryTextStyle(color: primaryColor),
              isExpanded: true,
              dropdownColor: context.cardColor,
              menuMaxHeight: 300,
              value: selectedArea,
              items: areaNameList.map((SampleAreaNameResponse e) {
                return DropdownMenuItem<SampleAreaNameResponse>(
                  value: e,
                  child: Text(e.name ?? '',
                      style: primaryTextStyle(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                );
              }).toList(),
              onChanged: (SampleAreaNameResponse? value) async {
                selectedAreaId = value?.id ?? 0;
                setState(() {});
              },
            ),
            16.height,
            DropdownButtonFormField<SampleAreaNameResponse>(
              decoration: inputDecoration(context, hint: 'Items'),
              style: primaryTextStyle(color: primaryColor),
              isExpanded: true,
              dropdownColor: context.cardColor,
              menuMaxHeight: 300,
              value: selectedItem,
              items: itemNameList.map((SampleAreaNameResponse e) {
                return DropdownMenuItem<SampleAreaNameResponse>(
                  value: e,
                  child: Text(e.name ?? '',
                      style: primaryTextStyle(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                );
              }).toList(),
              onChanged: (SampleAreaNameResponse? value) async {
                selectedItemId = value?.id ?? 0;
                setState(() {});
              },
            ),
            16.height,
            TextFormField(
              controller: descriptionController,
              maxLines: 4,
              decoration: inputDecoration(context, hint: 'Description'),
            ),
            16.height,
            CustomImagePicker(
              onRemoveClick: (value) {
                if (tempAttachments.validate().isNotEmpty &&
                    imageFiles.isNotEmpty) {
                  showConfirmDialogCustom(
                    context,
                    dialogType: DialogType.DELETE,
                    positiveText: languages.lblDelete,
                    negativeText: languages.lblCancel,
                    onAccept: (p0) {
                      imageFiles
                          .removeWhere((element) => element.path == value);
                      removeAttachment(
                          id: tempAttachments
                              .validate()
                              .firstWhere((element) => element.url == value)
                              .id
                              .validate());
                    },
                  );
                } else {
                  showConfirmDialogCustom(
                    context,
                    dialogType: DialogType.DELETE,
                    positiveText: languages.lblDelete,
                    negativeText: languages.lblCancel,
                    onAccept: (p0) {
                      imageFiles
                          ?.removeWhere((element) => element.path == value);
                      if (isUpdate) {
                        uniqueKey = UniqueKey();
                      }
                      setState(() {});
                    },
                  );
                }
              },
              selectedImages:
                  imageFiles.validate().map((e) => e.path.validate()).toList(),
              onFileSelected: (List<File> files) async {
                imageFiles = files;
                setState(() {});
              },
            ),
            16.height,
            AppButton(
              text: 'Save',
              width: context.width(),
              color: primaryColor,
              onTap: () {},
            )
          ],
        ),
      ),
    );
  }
}
