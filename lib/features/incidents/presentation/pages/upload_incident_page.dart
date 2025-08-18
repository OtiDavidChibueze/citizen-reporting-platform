import 'dart:io';
import 'package:citizen_report_incident/core/common/cubit/navigation_cubit/navigation_cubit.dart';
import 'package:citizen_report_incident/core/logger/app_logger.dart';

import '../../../../core/constants/app_string.dart';
import '../../../../core/common/cubit/geolocator/geolocator_cubit.dart';
import '../../../../core/common/cubit/image_picker/cubit/image_picker_cubit.dart';
import '../../../../core/common/theme/app_colors.dart';
import '../../../../core/common/widgets/custom_button_widget.dart';
import '../../../../core/common/widgets/custom_textfield_widget.dart';
import '../../../../core/utils/custom_dialog_loader.dart';
import '../../../../core/utils/custom_snackbar.dart';
import '../../../../core/utils/screen_util.dart';
import '../../../../core/utils/validations/validation.dart';
import '../../data/dto/upload_incident_dto.dart';
import '../bloc/incident_bloc.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher_string.dart';

class UploadIncidentPage extends StatefulWidget {
  static const String routeName = 'add-incident';

  const UploadIncidentPage({super.key});

  @override
  State<UploadIncidentPage> createState() => _UploadIncidentPageState();
}

class _UploadIncidentPageState extends State<UploadIncidentPage> {
  final _incidentFormKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  String? _selectedCategory;
  File? imageFile;
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
    _selectedCategory;
    imageFile = null;
    lat = null;
    long = null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<IncidentBloc, IncidentState>(
      listener: (context, state) {
        if (state is IncidentLoadingState) {
          return CustomDialogLoader.show(context);
        }

        if (state is IncidentSuccessState) {
          CustomDialogLoader.cancel(context);
          _clear();
          CustomSnackbar.success(context, AppString.incidentSuccess);
          return context.read<NavigationCubit>().setSelectedIndex(0);
        }

        if (state is IncidentErrorState) {
          CustomDialogLoader.cancel(context);
          return CustomSnackbar.error(context, state.message);
        }
      },
      builder: (context, state) {
        AppLogger.d(state);

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: w(16), vertical: h(16)),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Form(
              key: _incidentFormKey,
              child: Column(
                children: [
                  Text(
                    'Upload Incident',
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
                        imageFile = state.imageFile;
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
                      labelStyle: TextStyle(color: AppColors.borderColor),

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
                      context.read<GeolocatorCubit>().getCurrentPosition();
                    },
                    child: BlocBuilder<GeolocatorCubit, GeolocatorState>(
                      builder: (context, state) {
                        if (state is GeolocatorLoading) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: AppColors.scaffold,
                              padding: EdgeInsets.all(50),
                            ),
                          );
                        }

                        if (state is GeolocatorSuccess) {
                          return Text(
                            'latitude: ${lat = state.position.latitude},  longitude: ${long = state.position.longitude}',
                            style: TextStyle(fontSize: sp(13)),
                          );
                        }

                        if (state is GeolocatorError) {
                          return Text(state.message);
                        }

                        return Text(
                          'Click to get location',
                          style: TextStyle(fontSize: sp(13)),
                        );
                      },
                    ),
                  ),

                  VSpace(10),

                  TextButton(
                    onPressed: () async {
                      if (lat != null && long != null) {
                        String googleUrl =
                            'https://www.google.com/maps?q=$lat,$long';

                        if (await canLaunchUrlString(googleUrl)) {
                          await launchUrlString(googleUrl);
                        }
                      } else {
                        setState(() {
                          googleMapMessage =
                              'Lat/Long not set yet! Click get location';
                        });
                      }
                    },
                    child: Text(
                      googleMapMessage,
                      style: TextStyle(fontSize: sp(13)),
                    ),
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

                        context.read<IncidentBloc>().add(
                          AddIncidentEvent(
                            req: UploadIncidentDto(
                              title: _titleCtrl.text.trim(),
                              description: _descriptionCtrl.text.trim(),
                              category: _selectedCategory!,
                              latitude: lat!,
                              longitude: long!,
                              imageFile: imageFile ?? File(''),
                            ),
                          ),
                        );
                      },
                      color: AppColors.scaffold,
                    ),
                  ),

                  VSpace(30),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
