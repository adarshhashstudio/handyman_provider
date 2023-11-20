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

class InspectionAddArea extends StatefulWidget {
  const InspectionAddArea({super.key});

  @override
  State<InspectionAddArea> createState() => _InspectionAddAreaState();
}

class _InspectionAddAreaState extends State<InspectionAddArea> {
  UniqueKey uniqueKey = UniqueKey();
  TextEditingController? sizeController;
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

  SampleAreaNameResponse? selectedFloor;
  int? selectedFloorId;
  List<SampleAreaNameResponse> floorNameList = [
    SampleAreaNameResponse(
      name: 'Basement',
      id: 1,
    ),
    SampleAreaNameResponse(
      name: 'Ground Floor',
      id: 2,
    ),
    SampleAreaNameResponse(
      name: 'Floor No. 1',
      id: 3,
    ),
    SampleAreaNameResponse(
      name: 'Floor No. 2',
      id: 4,
    ),
    SampleAreaNameResponse(
      name: 'Floor No. 3',
      id: 5,
    ),
    SampleAreaNameResponse(
      name: 'Floor No. 5',
      id: 6,
    ),
    SampleAreaNameResponse(
      name: 'Floor No. 6',
      id: 7,
    ),
  ];

  List<File> imageFiles = [];
  List<Attachments> tempAttachments = [];
  bool isUpdate = false;

  //region Remove Attachment
  Future<void> removeAttachment({required int id}) async {
    appStore.setLoading(true);

    // Map req = {
    //   CommonKeys.type: BLOG_ATTACHMENT,
    //   CommonKeys.id: id,
    // };

    // await deleteImage(req).then((value) {
    tempAttachments.validate().removeWhere((element) => element.id == id);
    setState(() {});

    uniqueKey = UniqueKey();

    appStore.setLoading(false);
    //   toast(value.message.validate(), print: true);
    // }).catchError((e) {
    //   appStore.setLoading(false);
    //   toast(e.toString(), print: true);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget('Add Area',
          textColor: white,
          elevation: 0.0,
          color: context.primaryColor,
          backWidget: BackWidget()),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            children: [
              DropdownButtonFormField<SampleAreaNameResponse>(
                decoration: inputDecoration(context, hint: 'Floor'),
                style: primaryTextStyle(color: primaryColor),
                isExpanded: true,
                dropdownColor: context.cardColor,
                menuMaxHeight: 300,
                value: selectedFloor,
                items: floorNameList.map((SampleAreaNameResponse e) {
                  return DropdownMenuItem<SampleAreaNameResponse>(
                    value: e,
                    child: Text(e.name ?? '',
                        style: primaryTextStyle(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  );
                }).toList(),
                onChanged: (SampleAreaNameResponse? value) async {
                  selectedFloorId = value?.id ?? 0;
                  setState(() {});
                },
              ),
              16.height,
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
              AppTextField(
                textFieldType: TextFieldType.NAME,
                controller: sizeController,
                isValidationRequired: false,
                decoration: inputDecoration(context, hint: 'Size'),
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
                selectedImages: imageFiles
                    .validate()
                    .map((e) => e.path.validate())
                    .toList(),
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
      ),
    );
  }
}
