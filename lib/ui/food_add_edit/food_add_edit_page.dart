import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mismedidasb/domain/dish/dish_model.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_base/bloc_state.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_bottom_sheet.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_cupertino_dialog_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_cupertino_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_divider_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_gesture_hide_key_board.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_icon_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_loading_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_main_app_bar_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_network_image.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_textfield_widget.dart';
import 'package:mismedidasb/ui/food_add_edit/food_add_edit_bloc.dart';
import 'package:mismedidasb/ui/food_search/food_search_page.dart';
import 'package:mismedidasb/utils/file_manager.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../enums.dart';

class FoodAddEditPage extends StatefulWidget {
  final FoodModel foodModel;

  const FoodAddEditPage({Key key, this.foodModel}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FoodAddEditState();
}

class _FoodAddEditState
    extends StateWithBloC<FoodAddEditPage, FoodAddEditBloC> {
  final TextEditingController _nameController = TextEditingController();
  final _keyFormFood = new GlobalKey<FormState>();

  void _navBack() {
    if (!bloc.reload && widget.foodModel != null) {
      bloc.currentFoodModel.children = bloc.currentChildren;
      bloc.currentFoodModel.children.forEach((f) => f.isSelected = true);
    }
    NavigationUtils.pop(context, result: bloc.reload);
  }

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.foodModel?.name ?? "";
    bloc.init(widget.foodModel);
    bloc.addEditResult.listen((onData) {
      _navBack();
    });
  }

  @override
  Widget buildWidget(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _navBack();
        return false;
      },
      child: Stack(
        children: <Widget>[
          TXMainAppBarWidget(
            title: widget.foodModel == null ? R.string.add : R.string.edit,
            leading: TXIconButtonWidget(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                _navBack();
              },
            ),
            actions: <Widget>[
              widget.foodModel != null
                  ? PopupMenuButton(
                      icon: Icon(
                        Icons.more_vert,
                        color: Colors.white,
                      ),
                      itemBuilder: (ctx) {
                        return [..._popupActions()];
                      },
                      onSelected: (key) async {
                        if (key == PopupActionKey.remove_compound_food) {
                          _showRemoveFood(context: context);
                        }
                      })
                  : Container()
            ],
            body: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: TXGestureHideKeyBoard(
                child: SingleChildScrollView(
                  child: StreamBuilder<FoodModel>(
                      stream: bloc.foodResult,
                      initialData: null,
                      builder: (context, snapshot) {
                        return snapshot.data == null
                            ? Container()
                            : Form(
                                key: _keyFormFood,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      height: 100,
                                      width: 100,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: R.color.gray, width: 1)),
                                      child: InkWell(
                                        onTap: () {
                                          _showMediaSelector(context);
                                        },
                                        child: Stack(
                                          children: <Widget>[
                                            Container(
                                              color: R.color.gray_light,
                                              child: (widget.foodModel ==
                                                          null ||
                                                      !widget.foodModel.image
                                                              .startsWith(
                                                                  "https://") ==
                                                          true)
                                                  ? Center(
                                                      child: snapshot.data.image
                                                              .isEmpty
                                                          ? Image.asset(
                                                              R.image.logo)
                                                          : Image.file(File(
                                                              snapshot
                                                                  .data.image)),
                                                    )
                                                  : TXNetworkImage(
                                                      width: double.infinity,
                                                      height: double.infinity,
                                                      placeholderImage: snapshot
                                                              .data
                                                              .image
                                                              .isNotEmpty
                                                          ? snapshot.data.image
                                                          : R.image.logo,
                                                      imageUrl:
                                                          snapshot.data.image,
                                                    ),
                                            ),
                                            Positioned(
                                              right: 0,
                                              bottom: 0,
                                              child: Icon(
                                                Icons.camera_enhance,
                                                color: R.color.gray,
                                                size: 30,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    TXTextFieldWidget(
                                      controller: _nameController,
                                      label: "Nombre",
                                      validator: bloc.required(),
                                      onChanged: (value) {},
                                      onSubmitted: (value) {},
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        TXTextWidget(
                                          text: "Alimentos",
                                        ),
                                        Expanded(
                                          child: TXDividerWidget(),
                                        ),
                                        TXIconButtonWidget(
                                          icon: Icon(
                                            Icons.add,
                                            color: R.color.primary_color,
                                          ),
                                          onPressed: () async {
                                            final res =
                                                await NavigationUtils.push(
                                                    context,
                                                    FoodSearchPage(
                                                      allFoods: bloc.allFoods,
                                                    ));
                                            bloc.syncAddedFoods(res);
                                          },
                                        )
                                      ],
                                    ),
                                    Column(
                                      children:
                                          _getChildren(snapshot.data.children),
                                    ),
                                    SizedBox(
                                      height: 40,
                                    ),
                                    TXButtonWidget(
                                      title: R.string.save,
                                      onPressed: () {
                                        if (_keyFormFood.currentState
                                            .validate()) {
                                          bloc.currentFoodModel.name =
                                              _nameController.text;
                                          bloc.addFood(
                                              widget.foodModel == null);
                                        }
                                      },
                                    )
                                  ],
                                ),
                              );
                      }),
                ),
              ),
            ),
          ),
          TXLoadingWidget(
            loadingStream: bloc.isLoadingStream,
          )
        ],
      ),
    );
  }

  List<Widget> _getChildren(List<FoodModel> children) {
    List<Widget> list = [];
    children.forEach((f) {
      final w = ListTile(
        contentPadding: EdgeInsets.only(left: 5, right: 0),
        leading: TXNetworkImage(
          width: 40,
          height: 40,
          imageUrl: f.image,
          placeholderImage: R.image.logo,
        ),
        title: Row(
          children: <Widget>[
            Expanded(
              child: TXTextWidget(
                text: f.name,
              ),
            ),
            SizedBox(
              width: 5,
            ),
            InkWell(
              onTap: () {
                final selectorList = f.availableCounts;
                showTXModalBottomSheet(
                    context: context,
                    builder: (ctx) {
                      return TXCupertinoPickerWidget(
                        height: 300,
                        list: selectorList,
                        onItemSelected: (value) {
                          setState(() {
                            f.count = value.partialValue;
                          });
                        },
                        title: "Cantidad",
                        initialId: selectorList[3].id,
                      );
                    });
              },
              child: CircleAvatar(
                backgroundColor: R.color.accent_color,
                child: TXTextWidget(
                  text: "${f.displayCount}",
                  color: Colors.white,
                  size: 11,
                  fontWeight: FontWeight.bold,
                ),
                radius: 12,
              ),
            )
          ],
        ),
        trailing: TXIconButtonWidget(
          onPressed: () {
            bloc.remove(f);
          },
          icon: Icon(
            Icons.close,
            color: R.color.primary_color,
          ),
        ),
      );
      list.add(w);
    });
    return list;
  }

  void _showMediaSelector(BuildContext context) {
    showTXModalBottomSheet(
        context: context,
        builder: (ctx) {
          return Container(
            height: 100,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                  padding: EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Icon(
                        Icons.photo_library,
                        color: R.color.primary_color,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      TXTextWidget(
                        text: R.string.gallery,
                        color: R.color.primary_color,
                      ),
                    ],
                  ),
                  onPressed: () async {
                    await NavigationUtils.pop(context);
                    _launchMediaView(context, ImageSource.gallery);
                  },
                ),
                FlatButton(
                  padding: EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Icon(
                        Icons.camera,
                        color: R.color.primary_color,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      TXTextWidget(
                        text: R.string.camera,
                        color: R.color.primary_color,
                      ),
                    ],
                  ),
                  onPressed: () async {
                    await NavigationUtils.pop(context);
                    _launchMediaView(context, ImageSource.camera);
                  },
                ),
              ],
            ),
          );
        });
  }

  void _launchMediaView(BuildContext context, ImageSource imageSource) async {
    try {
      final file = await FileManager.getImageFromSource(context, imageSource);
      if (file != null && file.existsSync()) {
        bloc.updateImage(file);
      }
    } catch (ex) {
      if (ex is PlatformException) {
        if (ex.code == "photo_access_denied") {
          _showDialogPermissions(
              context: context,
              onOkAction: () async {
                openAppSettings();
              });
        }
      }
    }
  }

  void _showDialogPermissions({BuildContext context, Function onOkAction}) {
    showCupertinoDialog<String>(
      context: context,
      builder: (BuildContext context) => TXCupertinoDialogWidget(
        title: R.string.deniedPermissionTitle,
        content: R.string.deniedPermissionContent,
        onOK: () {
          Navigator.pop(context, R.string.ok);
          onOkAction();
        },
        onCancel: () {
          Navigator.pop(context, R.string.cancel);
        },
      ),
    );
  }

  void _showRemoveFood({BuildContext context}) {
    showCupertinoDialog<String>(
      context: context,
      builder: (BuildContext context) => TXCupertinoDialogWidget(
        title: "Eliminar alimento",
        content: "Está seguro que desea eliminar este alimento?",
        onOK: () {
          bloc.removeCompoundFood();
          Navigator.pop(context, R.string.logout);
        },
        onCancel: () {
          Navigator.pop(context, R.string.cancel);
        },
      ),
    );
  }

  List<PopupMenuItem> _popupActions() {
    List<PopupMenuItem> list = [];

    final remove = PopupMenuItem(
      value: PopupActionKey.remove_compound_food,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.remove_circle_outline,
              size: 20,
              color: Colors.redAccent,
            ),
            SizedBox(
              width: 10,
            ),
            TXTextWidget(
              text: "Eliminar alimento",
              color: Colors.black,
            )
          ],
        ),
      ),
    );
    list.add(remove);
    return list;
  }
}
