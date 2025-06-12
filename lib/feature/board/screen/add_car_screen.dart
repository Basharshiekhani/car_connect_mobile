import 'dart:convert';
import 'dart:io';

import 'package:car_connect/core/resource/size_manager.dart';
import 'package:car_connect/core/storage/shared/shared_pref.dart';
import 'package:car_connect/core/widget/app_bar/main_app_bar.dart';
import 'package:car_connect/core/widget/drop_down/NameAndId.dart';
import 'package:car_connect/core/widget/drop_down/title_drop_down_form_field.dart';
import 'package:car_connect/core/widget/form_field/title_app_form_filed.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../../core/api/api_links.dart';
import '../../../core/api/api_methods.dart';
import '../../../core/helper/image_helper.dart';
import '../../../core/resource/color_manager.dart';
import '../../../core/resource/font_manager.dart';
import '../../../core/widget/button/main_app_button.dart';
import '../../../core/widget/button/main_app_dotted_button.dart';
import '../../../core/widget/text/app_text_widget.dart';

class AddCarScreen extends StatefulWidget {
  const AddCarScreen({super.key});

  @override
  State<AddCarScreen> createState() => _AddCarScreenState();
}

class _AddCarScreenState extends State<AddCarScreen> {
  var brands = [];
  List<NameAndId> brandsOptions = [];
  var gears = [];
  List<NameAndId> gearsOptions = [];

  var color = [];
  List<NameAndId> colorOptions = [];

  var model = [];
  List<NameAndId> modelOptions = [];

  String? brandId;
  String? colorId;
  String? modelId;
  String? gearId;
  String? desc;

  String? kilo;

  String? price;

  List<File> carImages = [];
  File? owner;
  bool isOwnerImageAdded = false;

  addCar() async {
    if (brandId == null ||
        gearId == null ||
        modelId == null ||
        colorId == null ||
        desc == null ||
        price == null ||
        kilo == null ||
        carImages.isEmpty ||
        (AppSharedPreferences.getCommercialRegister().isEmpty &&
            owner == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColorManager.white,
          content: AppTextWidget(
            text: "Enter All Required Fields",
            color: AppColorManager.red,
            fontSize: FontSizeManager.fs16,
            fontWeight: FontWeight.w600,
            overflow: TextOverflow.visible,
          ),
        ),
      );
      return;
    }

    List<File> files = [...carImages];
    List<String> names = List.generate(carImages.length, (index) => "image$index");
    
    if (owner != null) {
      files.add(owner!);
      names.add("ownerShipImageUrl");
    }

    Map<String, dynamic> requestEntity = {
      "id": AppSharedPreferences.getUserId(),
      "brandId": brandId.toString(),
      "modelId": modelId.toString(),
      "gearId": gearId.toString(),
      "colorId": colorId.toString(),
      "killo": kilo.toString(),
      "price": price.toString(),
      "desc": desc.toString(),
      "rent": selectedType.toString()
    };

    http.Response response = await HttpMethods()
        .postWithMultiFile(ApiPostUrl.addCar, requestEntity, files, names);

    if (response.statusCode == 200 || response.statusCode == 201) {
      if ((response.body ?? "").isNotEmpty) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColorManager.white,
            content: AppTextWidget(
              text: "success",
              color: AppColorManager.green,
              fontSize: FontSizeManager.fs16,
              fontWeight: FontWeight.w600,
              overflow: TextOverflow.visible,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColorManager.white,
            content: AppTextWidget(
              text: utf8.decode(response.bodyBytes),
              color: AppColorManager.navy,
              fontSize: FontSizeManager.fs16,
              fontWeight: FontWeight.w600,
              overflow: TextOverflow.visible,
            ),
          ),
        );
      }
    }
  }

  void getBrands() async {
    http.Response response =
        await HttpMethods().getMethod(ApiGetUrl.getBrands, {});
    if (response.statusCode == 200 || response.statusCode == 201) {
      if ((response.body ?? "").isNotEmpty) {
        brands = jsonDecode(response.body);
        if (brands.isNotEmpty) {
          for (var element in brands) {
            brandsOptions.add(
                NameAndId(name: element['name'], id: element['id'].toString()));
          }
          setState(() {});
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColorManager.white,
            content: AppTextWidget(
              text: utf8.decode(response.bodyBytes),
              color: AppColorManager.navy,
              fontSize: FontSizeManager.fs16,
              fontWeight: FontWeight.w600,
              overflow: TextOverflow.visible,
            ),
          ),
        );
      }
    }
  }

  void getGears() async {
    http.Response response =
        await HttpMethods().getMethod(ApiGetUrl.getGears, {});
    if (response.statusCode == 200 || response.statusCode == 201) {
      if ((response.body ?? "").isNotEmpty) {
        gears = jsonDecode(response.body);
        if (gears.isNotEmpty) {
          for (var element in gears) {
            gearsOptions.add(
                NameAndId(name: element['name'], id: element['id'].toString()));
          }
          setState(() {});
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColorManager.white,
            content: AppTextWidget(
              text: utf8.decode(response.bodyBytes),
              color: AppColorManager.navy,
              fontSize: FontSizeManager.fs16,
              fontWeight: FontWeight.w600,
              overflow: TextOverflow.visible,
            ),
          ),
        );
      }
    }
  }

  void getColors() async {
    http.Response response =
        await HttpMethods().getMethod(ApiGetUrl.getColors, {});
    if (response.statusCode == 200 || response.statusCode == 201) {
      if ((response.body ?? "").isNotEmpty) {
        color = jsonDecode(response.body);
        if (color.isNotEmpty) {
          for (var element in color) {
            colorOptions.add(
                NameAndId(name: element['name'], id: element['id'].toString()));
          }
          setState(() {});
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColorManager.white,
            content: AppTextWidget(
              text: utf8.decode(response.bodyBytes),
              color: AppColorManager.navy,
              fontSize: FontSizeManager.fs16,
              fontWeight: FontWeight.w600,
              overflow: TextOverflow.visible,
            ),
          ),
        );
      }
    }
  }

  void getModels() async {
    http.Response response =
        await HttpMethods().getMethod(ApiGetUrl.getModels, {});
    if (response.statusCode == 200 || response.statusCode == 201) {
      if ((response.body ?? "").isNotEmpty) {
        model = jsonDecode(response.body);
        model = jsonDecode(response.body);
        if (model.isNotEmpty) {
          for (var element in model) {
            modelOptions.add(
                NameAndId(name: element['name'], id: element['id'].toString()));
          }
          setState(() {});
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColorManager.white,
            content: AppTextWidget(
              text: utf8.decode(response.bodyBytes),
              color: AppColorManager.navy,
              fontSize: FontSizeManager.fs16,
              fontWeight: FontWeight.w600,
              overflow: TextOverflow.visible,
            ),
          ),
        );
      }
    }
  }

  @override
  void initState() {
    getBrands();
    getColors();
    getModels();
    getGears();
    super.initState();
  }

  int selectedType = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(title: "add car"),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(AppWidthManager.w3Point8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TitleDropDownFormFieldWidget(
                        hint: "Brand",
                        title: "Brand",
                        onChanged: (value) {
                          brandId = value?.id;
                          return null;
                        },
                        options: brandsOptions),
                  ),
                  SizedBox(
                    width: AppHeightManager.h1point8,
                  ),
                  Expanded(
                    child: TitleDropDownFormFieldWidget(
                        hint: "Gear",
                        title: "Gear",
                        onChanged: (value) {
                          gearId = value?.id;

                          return null;
                        },
                        options: gearsOptions),
                  ),
                ],
              ),
              SizedBox(
                height: AppHeightManager.h1point8,
              ),
              Row(
                children: [
                  Expanded(
                    child: TitleDropDownFormFieldWidget(
                        hint: "Color",
                        title: "Color",
                        onChanged: (value) {
                          colorId = value?.id;

                          return null;
                        },
                        options: colorOptions),
                  ),
                  SizedBox(
                    width: AppHeightManager.h1point8,
                  ),
                  Expanded(
                    child: TitleDropDownFormFieldWidget(
                        hint: "Model",
                        title: "Model",
                        onChanged: (value) {
                          modelId = value?.id;

                          return null;
                        },
                        options: modelOptions),
                  ),
                ],
              ),
              SizedBox(
                height: AppHeightManager.h1point8,
              ),
              TitleAppFormFiled(
                hint: "desc",
                title: "desc",
                onChanged: (value) {
                  desc = value;
                  return null;
                },
                validator: (p0) {
                  return null;
                },
              ),
              SizedBox(
                height: AppHeightManager.h1point8,
              ),
              Row(
                children: [
                  Expanded(
                    child: TitleAppFormFiled(
                      hint: "kilometers",
                      title: "kilometers",
                      inputType: TextInputType.number,
                      onChanged: (value) {
                        kilo = value;

                        return null;
                      },
                      validator: (p0) {
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    width: AppHeightManager.h1point8,
                  ),
                  Expanded(
                    child: TitleAppFormFiled(
                      hint: "price",
                      inputType: TextInputType.number,
                      title: "price",
                      onChanged: (value) {
                        price = value;

                        return null;
                      },
                      validator: (p0) {
                        return null;
                      },
                    ),
                  )
                ],
              ),
              SizedBox(
                height: AppHeightManager.h1point8,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MainAppDottedButton(
                    onTap: () async {
                      File? newImage = await ImageHelper.pickImageFrom(
                          source: ImageSource.gallery);
                      if (newImage != null) {
                        setState(() {
                          carImages.add(newImage);
                        });
                        showImageAddedMessage("Car image added successfully");
                      }
                    },
                    color: AppColorManager.navy.withAlpha(50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppTextWidget(
                          text: "Add Car Image (${carImages.length} added)",
                          color: AppColorManager.white,
                          fontWeight: FontWeight.w600,
                          fontSize: FontSizeManager.fs15,
                          maxLines: 2,
                        ),
                        if (carImages.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.only(left: AppWidthManager.w2),
                            child: Icon(
                              Icons.check_circle,
                              color: AppColorManager.green,
                              size: 20,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (carImages.isNotEmpty)
                    Container(
                      height: 100,
                      margin: EdgeInsets.only(top: AppHeightManager.h1),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: carImages.length,
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              Container(
                                width: 100,
                                margin: EdgeInsets.only(right: AppWidthManager.w2),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: FileImage(carImages[index]),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 0,
                                top: 0,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.remove_circle,
                                    color: AppColorManager.red,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      carImages.removeAt(index);
                                    });
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                ],
              ),
              SizedBox(
                height: AppHeightManager.h1point8,
              ),
              AppTextWidget(
                text: "Car Type",
                fontSize: FontSizeManager.fs16,
                fontWeight: FontWeight.w500,
                color: AppColorManager.white,
              ),
              SizedBox(
                height: AppHeightManager.h1,
              ),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<int>(
                      title: AppTextWidget(
                        text: "For Rent",
                        fontSize: FontSizeManager.fs16,
                        fontWeight: FontWeight.w500,
                        color: AppColorManager.white,
                      ),
                      value: 1,
                      groupValue: selectedType,
                      onChanged: (value) {
                        setState(() {
                          selectedType = value ?? 1;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<int>(
                      title: AppTextWidget(
                        text: "For Sale",
                        fontSize: FontSizeManager.fs16,
                        fontWeight: FontWeight.w500,
                        color: AppColorManager.white,
                      ),
                      value: 0,
                      groupValue: selectedType,
                      onChanged: (value) {
                        setState(() {
                          selectedType = value ?? 0;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: AppHeightManager.h1point8,
              ),
              Visibility(
                visible: AppSharedPreferences.getCommercialRegister().isEmpty,
                child: MainAppDottedButton(
                  onTap: () async {
                    owner = await ImageHelper.pickImageFrom(
                        source: ImageSource.gallery);
                    if (owner != null) {
                      setState(() {
                        isOwnerImageAdded = true;
                      });
                      showImageAddedMessage("Ownership image added successfully");
                    }
                  },
                  color: AppColorManager.navy.withAlpha(50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppTextWidget(
                        text: "OwnerShip Image(Required)",
                        color: AppColorManager.white,
                        fontWeight: FontWeight.w600,
                        fontSize: FontSizeManager.fs15,
                        maxLines: 2,
                      ),
                      if (isOwnerImageAdded)
                        Padding(
                          padding: EdgeInsets.only(left: AppWidthManager.w2),
                          child: Icon(
                            Icons.check_circle,
                            color: AppColorManager.green,
                            size: 20,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: AppHeightManager.h1point8,
              ),
              MainAppButton(
                onTap: () {
                  addCar();
                },
                alignment: Alignment.center,
                width: AppWidthManager.w100,
                color: AppColorManager.navy,
                height: AppHeightManager.h6,
                child: AppTextWidget(
                  text: "Next",
                  color: AppColorManager.white,
                  fontWeight: FontWeight.w600,
                  fontSize: FontSizeManager.fs15,
                  maxLines: 2,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void showImageAddedMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColorManager.green,
        content: AppTextWidget(
          text: message,
          color: AppColorManager.white,
          fontSize: FontSizeManager.fs16,
          fontWeight: FontWeight.w600,
          overflow: TextOverflow.visible,
        ),
      ),
    );
  }
}
