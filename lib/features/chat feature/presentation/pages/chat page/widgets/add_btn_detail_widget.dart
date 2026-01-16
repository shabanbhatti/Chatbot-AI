import 'package:chatbot_ai/config/DI/injector.dart';
import 'package:chatbot_ai/core/utils/image_picker_utils.dart';
import 'package:chatbot_ai/core/utils/show_toast.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/utils/photo_manager_method_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

class AddBtnDetailWidget extends StatefulWidget {
  const AddBtnDetailWidget({
    super.key,
    required this.multiImgsPaths,
    required this.assetsEntity,
    required this.selectedAssetIds,
  });

  final ValueNotifier<List<String>> multiImgsPaths;
  final ValueNotifier<List<AssetEntity>> assetsEntity;
  final ValueNotifier<List<String>> selectedAssetIds;

  @override
  State<AddBtnDetailWidget> createState() => _AddBtnDetailWidgetState();
}

class _AddBtnDetailWidgetState extends State<AddBtnDetailWidget> {
  @override
  void initState() {
    super.initState();
    loadImages();
  }

  Future<void> loadImages() async {
    widget.assetsEntity.value = await PhotoManagerUtils.loadImages();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder<List<AssetEntity>>(
              valueListenable: widget.assetsEntity,
              builder: (context, assets, _) {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: assets.length + 1,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return GestureDetector(
                        onTap: () async {
                          var list = await getIt<ImagePickerUtils>()
                              .takeMultipleImage();
                          if (list.isNotEmpty) {
                            widget.multiImgsPaths.value = [
                              ...widget.multiImgsPaths.value,
                              ...list,
                            ];
                          }
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: EdgeInsetsGeometry.only(bottom: 112),
                          child: Stack(
                            children: [
                              Container(
                                width: 100,
                                height: 130,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                color: CupertinoColors.secondarySystemFill,
                                child: const Icon(
                                  CupertinoIcons.camera_fill,
                                  size: 30,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    final asset = assets[index - 1];

                    return ValueListenableBuilder(
                      valueListenable: widget.selectedAssetIds,
                      builder: (context, selectedIds, _) {
                        final selectiveIndex = selectedIds.indexOf(asset.id);
                        return Opacity(
                          opacity:
                              (selectedIds.length == 2 &&
                                  !selectedIds.contains(asset.id))
                              ? 0.5
                              : 1.0,
                          child: GestureDetector(
                            onTap:
                                (selectedIds.length == 2 &&
                                    !selectedIds.contains(asset.id))
                                ? null
                                : () async {
                                    if (widget.selectedAssetIds.value.length >=
                                            2 &&
                                        !widget.selectedAssetIds.value.contains(
                                          asset.id,
                                        )) {
                                      ShowToast.basicToast(
                                        message: 'Max 3 images allowed',
                                        color: CupertinoColors.destructiveRed,
                                      );
                                    } else if (widget.selectedAssetIds.value
                                        .contains(asset.id)) {
                                      final file = await asset.getFile();
                                      widget.multiImgsPaths.value = widget
                                          .multiImgsPaths
                                          .value
                                          .where(
                                            (element) => element != file!.path,
                                          )
                                          .toList();
                                      widget.selectedAssetIds.value = widget
                                          .selectedAssetIds
                                          .value
                                          .where(
                                            (element) => element != asset.id,
                                          )
                                          .toList();
                                    } else {
                                      final file = await asset.getFile();
                                      if (file == null) return;

                                      widget.selectedAssetIds.value = [
                                        ...widget.selectedAssetIds.value,
                                        asset.id,
                                      ];

                                      widget.multiImgsPaths.value = [
                                        ...widget.multiImgsPaths.value,
                                        file.path,
                                      ];
                                    }
                                  },
                            child: Stack(
                              children: [
                                Container(
                                  width: 100,
                                  height: 130,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  color: CupertinoColors.inactiveGray,
                                  child: AssetEntityImage(
                                    asset,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                if (selectiveIndex == -1)
                                  const SizedBox()
                                else
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: CircleAvatar(
                                      radius: 13,
                                      backgroundColor: CupertinoColors.white,
                                      child: Text(
                                        '${selectiveIndex + 1}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
