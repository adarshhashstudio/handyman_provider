import 'dart:io';

import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/components/back_widget.dart';
import 'package:handyman_provider_flutter/components/custom_image_picker.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/added_area.dart';
import 'package:handyman_provider_flutter/models/attachment_model.dart';
import 'package:handyman_provider_flutter/models/sample_area_name_response.dart';
import 'package:handyman_provider_flutter/utils/common.dart';
import 'package:handyman_provider_flutter/utils/configs.dart';
import 'package:nb_utils/nb_utils.dart';

class ItemDetailsScreen extends StatefulWidget {
  final AddedArea? item;
  const ItemDetailsScreen({super.key, this.item});

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  UniqueKey uniqueKey = UniqueKey();
  TextEditingController? commentsController;

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
      appBar: appBarWidget('${widget.item?.name ?? ''}',
          textColor: white,
          elevation: 0.0,
          color: context.primaryColor,
          backWidget: BackWidget()),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            12.height,
            Text(
              '${widget.item?.name ?? ''}',
              style: primaryTextStyle(color: black, weight: FontWeight.bold),
            ),
            12.height,
            Text(
              '${widget.item?.description ?? ''}',
              style: primaryTextStyle(
                color: gray,
              ),
            ),
            16.height,
            TextFormField(
              controller: commentsController,
              maxLines: 4,
              decoration: inputDecoration(context, hint: 'Comments'),
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
              text: languages.lblSubmit,
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
