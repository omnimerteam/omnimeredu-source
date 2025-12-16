import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/presentation/common/widgets/input/app_image_picker.dart';
import '../../../../../core/constants/enum_constant.dart';
import '../../../../../domain/entities/school/school_data_entity.dart';
import '../../../../../core/validation/field_validator.dart';
import '../../../../common/widgets/input/primary_dropdown.dart';
import '../../../../common/widgets/input/primary_multiline_text_field.dart';
import '../../../../common/widgets/input/primary_text_field.dart';
import '../../../../../core/theme/app_colors.dart';

typedef OnSubmitSchool = void Function(SchoolDataEntity school);

class SchoolFormDialog extends StatefulWidget {
  final SchoolDataEntity? school;
  final OnSubmitSchool onSubmit;

  const SchoolFormDialog({super.key, this.school, required this.onSubmit});

  @override
  State<SchoolFormDialog> createState() => _SchoolFormDialogState();
}

class _SchoolFormDialogState extends State<SchoolFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;
  late TextEditingController _descriptionController;

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _addressFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _descriptionFocus = FocusNode();

  EducationSystemLevelsEnum? _selectedLevel;
  File? _logoFile;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _setupFocusListeners();
  }

  void _initializeControllers() {
    _nameController = TextEditingController(text: widget.school?.name ?? '');
    _addressController = TextEditingController(
      text: widget.school?.address ?? '',
    );
    _phoneController = TextEditingController(text: widget.school?.phone ?? '');
    _descriptionController = TextEditingController(
      text: widget.school?.description ?? '',
    );
    _selectedLevel = widget.school?.level;
  }

  void _setupFocusListeners() {
    _nameFocus.addListener(() => setState(() {}));
    _addressFocus.addListener(() => setState(() {}));
    _phoneFocus.addListener(() => setState(() {}));
    _descriptionFocus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _descriptionController.dispose();
    _nameFocus.dispose();
    _addressFocus.dispose();
    _phoneFocus.dispose();
    _descriptionFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isUpdate = widget.school != null;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(16.w),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(maxHeight: 700.h),
        decoration: BoxDecoration(
          color: AppColors.getCardBackground(isDark),
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Column(
          children: [
            _buildHeader(isUpdate),
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Logo Section
                      Center(
                        child: Column(
                          children: [
                            ImagePickerWidget(
                              imageFile: _logoFile,
                              onTap: () {
                                // TODO: Implement image picker
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Tính năng chọn ảnh sẽ được cập nhật sau',
                                    ),
                                  ),
                                );
                              },
                              label: 'Logo trường',
                              size: 100.w,
                              isCircular: false,
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'Nhấn để chọn logo',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppColors.grey600,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 32.h),

                      // Basic Information
                      _buildSectionTitle('Thông tin cơ bản'),
                      SizedBox(height: 16.h),

                      PrimaryTextField(
                        controller: _nameController,
                        focusNode: _nameFocus,
                        hintText: 'Nhập tên trường...',
                        prefixIcon: Icons.school,
                        isFocused: _nameFocus.hasFocus,
                        validator: (v) => FieldValidators.required<String>(
                          fieldName: 'Tên trường',
                        )(v),
                      ),

                      SizedBox(height: 20.h),

                      PrimaryDropdown<EducationSystemLevelsEnum>(
                        value: _selectedLevel,
                        items: EducationSystemLevelsEnum.values
                            .map(
                              (e) =>
                                  DropdownMenuItem<EducationSystemLevelsEnum>(
                                    value: e,
                                    child: Text(e.displayName),
                                  ),
                            )
                            .toList(),
                        hintText: 'Chọn cấp học...',
                        prefixIcon: Icons.school_outlined,
                        isFocused: _selectedLevel != null,
                        onChanged: (v) => setState(() => _selectedLevel = v),
                        validator: (v) => FieldValidators.required(
                          fieldName: "Cấp trường",
                        )(v),
                      ),

                      SizedBox(height: 32.h),

                      // Contact Information
                      _buildSectionTitle('Thông tin liên hệ'),
                      SizedBox(height: 16.h),

                      PrimaryTextField(
                        controller: _addressController,
                        focusNode: _addressFocus,
                        hintText: 'Nhập địa chỉ trường...',
                        prefixIcon: Icons.location_on,
                        isFocused: _addressFocus.hasFocus,
                        validator: (v) =>
                            FieldValidators.address(fieldName: "Địa chỉ")(v),
                      ),

                      SizedBox(height: 20.h),

                      PrimaryTextField(
                        controller: _phoneController,
                        focusNode: _phoneFocus,
                        hintText: 'Nhập số điện thoại...',
                        prefixIcon: Icons.phone,
                        isFocused: _phoneFocus.hasFocus,
                        keyboardType: TextInputType.phone,
                        validator: (v) => FieldValidators.phone(
                          fieldName: "Số điện thoại",
                        )(v),
                      ),

                      SizedBox(height: 32.h),

                      // Description
                      _buildSectionTitle('Mô tả'),
                      SizedBox(height: 16.h),

                      PrimaryMultilineTextField(
                        controller: _descriptionController,
                        focusNode: _descriptionFocus,
                        hintText: "Nhập mô tả về trường...",
                        prefixIcon: Icons.description,
                      ),

                      SizedBox(height: 32.h),
                    ],
                  ),
                ),
              ),
            ),
            _buildFooterButtons(isUpdate),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isUpdate) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: AppColors.primaryGradient,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              isUpdate ? Icons.edit : Icons.add,
              color: Colors.white,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Text(
              isUpdate ? 'Cập nhật thông tin trường' : 'Tạo trường mới',
              style: TextStyle(
                fontSize: 20.sp,
                fontFamily: "Nunito",
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(Icons.close, color: Colors.white, size: 20.sp),
              padding: EdgeInsets.all(8.w),
              constraints: const BoxConstraints(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Text(
      title,
      style: TextStyle(
        fontSize: 18.sp,
        fontFamily: "Nunito",
        fontWeight: FontWeight.bold,
        color: AppColors.getTextColor(isDark),
      ),
    );
  }

  Widget _buildFooterButtons(bool isUpdate) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppColors.grey300.withOpacity(0.5),
            width: 1.h,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                side: const BorderSide(color: AppColors.grey400),
              ),
              child: Text(
                'Hủy',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.grey600,
                ),
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isUpdate
                      ? AppColors.successGradient
                      : AppColors.primaryGradient,
                ),
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: (isUpdate ? AppColors.success : AppColors.primary)
                        .withOpacity(0.3),
                    offset: const Offset(0, 4),
                    blurRadius: 12.r,
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: _isLoading
                    ? SizedBox(
                        width: 20.w,
                        height: 20.w,
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isUpdate ? Icons.check : Icons.add,
                            color: Colors.white,
                            size: 20.sp,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            isUpdate ? 'Cập nhật' : 'Tạo trường',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final school = SchoolDataEntity(
        id: widget.school?.id,
        name: _nameController.text,
        address: _addressController.text.isEmpty
            ? null
            : _addressController.text,
        phone: _phoneController.text.isEmpty ? null : _phoneController.text,
        description: _descriptionController.text.isEmpty
            ? null
            : _descriptionController.text,
        level: _selectedLevel,
        logoUrl: widget.school?.logoUrl,
        studentCount: widget.school?.studentCount ?? 0,
      );

      widget.onSubmit(school);
      Navigator.of(context).pop();
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
