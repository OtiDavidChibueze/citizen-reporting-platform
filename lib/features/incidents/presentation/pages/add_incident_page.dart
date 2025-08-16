import 'dart:io';

import '../../../../core/common/cubit/image_picker/cubit/image_picker_cubit.dart';
import '../../../../core/common/theme/app_colors.dart';
import '../../../../core/common/widgets/custom_button_widget.dart';
import '../../../../core/common/widgets/custom_textfield_widget.dart';
import '../../../../core/logger/app_logger.dart';
import '../../../../core/utils/custom_dialog_loader.dart';
import '../../../../core/utils/custom_snackbar.dart';
import '../../../../core/utils/screen_util.dart';
import '../../../../core/utils/validations/validation.dart';
import '../../data/dto/upload_incident_dto.dart';
import '../bloc/incident_bloc.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../../../core/service/geo_location.dart';

class AddIncidentPage extends StatefulWidget {
  static const String routeName = 'add-incident';

  const AddIncidentPage({super.key});

  @override
  State<AddIncidentPage> createState() => _AddIncidentPageState();
}

class _AddIncidentPageState extends State<AddIncidentPage> {
  final _incidentFormKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  String? _selectedCategory;
  File? imageUrl;
  double? lat;
  double? long;

  String locationMessage = 'Get Current Location';
  String googleMapMessage = 'Open on Google Map';

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descriptionCtrl.dispose();
    super.dispose();
  }

  _clear() {
    _titleCtrl.clear();
    _descriptionCtrl.clear();
    _selectedCategory = null;
    imageUrl = null;
    lat = null;
    long = null;
  }

  _liveLocationUpdate() {
    LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    Geolocator.getPositionStream(locationSettings: locationSettings).listen((
      Position position,
    ) {
      setState(() {
        lat = position.latitude;
        long = position.longitude;

        locationMessage =
            'Latitude: ${lat.toString()}, Longtitide: ${long.toString()}';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<IncidentBloc, IncidentState>(
      listener: (context, state) {
        if (state is IncidentLoadingState) {
          CustomDialogLoader.show(context);
        }

        if (state is IncidentSuccessState) {
          CustomDialogLoader.cancel(context);
          _clear();
          context.pop();
        }

        if (state is IncidentErrorState) {
          CustomDialogLoader.cancel(context);
          CustomSnackbar.error(context, state.message);
        }
      },
      builder: (context, state) {
        AppLogger.d('ImageUrl: $imageUrl');

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: w(25), vertical: h(25)),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Form(
              key: _incidentFormKey,
              child: Column(
                children: [
                  VSpace(20),

                  Text(
                    'Add Incident',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: sp(20),
                    ),
                  ),

                  VSpace(40),

                  CustomTextfieldWidget(
                    focusBorderColor: AppColors.scaffold,
                    focusBorderWidth: 2,
                    textColor: AppColors.scaffold,
                    controller: _titleCtrl,
                    hintText: 'Title',
                    keyboardType: TextInputType.text,
                    validator: (val) => Validation.isEmpty(val),
                  ),

                  VSpace(20),

                  CustomTextfieldWidget(
                    focusBorderColor: AppColors.scaffold,
                    focusBorderWidth: 2,
                    textColor: AppColors.scaffold,
                    maxLines: null,
                    controller: _descriptionCtrl,
                    hintText: 'Description',
                    keyboardType: TextInputType.text,
                    validator: (val) => Validation.isEmpty(val),
                  ),

                  VSpace(30),

                  BlocBuilder<ImagePickerCubit, ImagePickerState>(
                    builder: (context, state) {
                      if (state is ImagePickerLoadingState) {
                        return Center(
                          child: CircularProgressIndicator(color: Colors.black),
                        );
                      }

                      if (state is ImagePickerSuccessState) {
                        imageUrl = state.imageFile;
                        return GestureDetector(
                          onTap: () {
                            context.read<ImagePickerCubit>().resetImage();
                          },
                          child: SizedBox(
                            height: 300,
                            width: double.infinity,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                File(state.imageFile.path),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      }

                      return GestureDetector(
                        onTap: () {
                          context.read<ImagePickerCubit>().pickImage();
                        },
                        child: DottedBorder(
                          options: RoundedRectDottedBorderOptions(
                            radius: Radius.circular(10),
                            color: AppColors.borderColor,
                            dashPattern: [10, 4],
                            strokeCap: StrokeCap.round,
                          ),

                          child: SizedBox(
                            height: 150,
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.folder_open, size: 50),

                                SizedBox(height: 15),

                                Text(
                                  'Tap the folder to select your image',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  VSpace(30),

                  DropdownButtonFormField(
                    dropdownColor: Colors.grey.shade100,
                    decoration: InputDecoration(
                      labelText: 'Category',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.borderColor,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(sr(20)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.scaffold,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(sr(20)),
                      ),
                    ),
                    items: ['Accident', 'Fire', 'Theft', 'Rioting', 'Other']
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(
                              e,
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        )
                        .toList(),
                    value: _selectedCategory,
                    onChanged: (val) => _selectedCategory = val,
                  ),

                  VSpace(30),

                  TextButton(
                    onPressed: () {
                      getCurrentPosition()
                          .then((value) {
                            setState(() {
                              lat = value.latitude;
                              long = value.longitude;
                              locationMessage =
                                  'Latitude: ${lat.toString()}, Longtitude: ${long.toString()}';
                            });
                            _liveLocationUpdate();
                          })
                          .catchError((e) {
                            setState(() {
                              locationMessage = e.toString();
                            });
                          });
                    },
                    child: Text(locationMessage),
                  ),

                  VSpace(10),

                  TextButton(
                    onPressed: () async {
                      if (lat != null && long != null) {
                        String googleUrl =
                            'https://www.google.com/maps?q=$lat,$long';

                        await launchUrlString(googleUrl);
                      } else {
                        setState(() {
                          googleMapMessage =
                              'Lat/Long not set yet! Click get location';
                        });
                      }
                    },
                    child: Text(googleMapMessage),
                  ),

                  VSpace(30),

                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(sr(20)),
                      boxShadow: [
                        BoxShadow(color: AppColors.scaffold, blurRadius: 5),
                      ],
                    ),
                    child: CustomButtonWidget(
                      horizontal: w(20),
                      vertical: h(10),
                      text: 'Submit incident',
                      onPressed: () {
                        if (_incidentFormKey.currentState?.validate() != true) {
                          CustomSnackbar.error(
                            context,
                            'Please fill all required fields.',
                          );
                          return;
                        }
                        if (_selectedCategory == null) {
                          CustomSnackbar.error(
                            context,
                            'Please select a category.',
                          );
                          return;
                        }
                        if (lat == null || long == null) {
                          CustomSnackbar.error(
                            context,
                            'Please get your current location.',
                          );
                          return;
                        }
                        // imageFile is optional, but you can enforce it if needed:
                        // if (imageUrl == null) {
                        //   showCustomSnackBar(context, 'Please select an image.');
                        //   return;
                        // }
                        context.read<IncidentBloc>().add(
                          AddIncidentEvent(
                            req: UploadIncidentDto(
                              title: _titleCtrl.text.trim(),
                              description: _descriptionCtrl.text.trim(),
                              category: _selectedCategory!,
                              latitude: lat!,
                              longitude: long!,
                              imageUrl: imageUrl ?? File(''),
                            ),
                          ),
                        );
                      },
                      color: AppColors.scaffold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
