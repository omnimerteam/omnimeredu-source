import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../../core/constants/enum_constant.dart';
import '../../../../../domain/entities/school/school_data_entity.dart';
import '../../../../utils/validator.dart';
import '../../../../widgets/dropdown/primary_dropdown.dart';
import '../../../../widgets/image_picker/app_image_picker.dart';
import '../../../../widgets/text_field/primary_multiline_text_field.dart';
import '../../../../widgets/text_field/primary_text_field.dart';
import '../../../../../core/theme/app_colors.dart';

typedef OnSubmitSchool = void Function(SchoolDataEntity school);

class SchoolFormDialog extends StatefulWidget {
  final SchoolDataEntity? school;
  final OnSubmitSchool onSubmit;

  const SchoolFormDialog({Key? key, this.school, required this.onSubmit})
    : super(key: key);

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
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxHeight: 700),
        decoration: BoxDecoration(
          color: AppColors.getCardBackground(isDark),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            _buildHeader(isUpdate),
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
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
                              size: 100,
                              isCircular: false,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Nhấn để chọn logo',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.grey600,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Basic Information
                      _buildSectionTitle('Thông tin cơ bản'),
                      const SizedBox(height: 16),

                      PrimaryTextField(
                        controller: _nameController,
                        focusNode: _nameFocus,
                        hintText: 'Nhập tên trường...',
                        prefixIcon: Icons.school,
                        isFocused: _nameFocus.hasFocus,
                        validator: (v) =>
                            Validators.requiredField(v, name: 'Tên trường'),
                      ),

                      const SizedBox(height: 20),

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
                        validator: (v) =>
                            Validators.requiredField(v, name: "Cấp trường"),
                      ),

                      const SizedBox(height: 32),

                      // Contact Information
                      _buildSectionTitle('Thông tin liên hệ'),
                      const SizedBox(height: 16),

                      PrimaryTextField(
                        controller: _addressController,
                        focusNode: _addressFocus,
                        hintText: 'Nhập địa chỉ trường...',
                        prefixIcon: Icons.location_on,
                        isFocused: _addressFocus.hasFocus,
                        validator: Validators.address,
                      ),

                      const SizedBox(height: 20),

                      PrimaryTextField(
                        controller: _phoneController,
                        focusNode: _phoneFocus,
                        hintText: 'Nhập số điện thoại...',
                        prefixIcon: Icons.phone,
                        isFocused: _phoneFocus.hasFocus,
                        keyboardType: TextInputType.phone,
                        validator: Validators.phone,
                      ),

                      const SizedBox(height: 32),

                      // Description
                      _buildSectionTitle('Mô tả'),
                      const SizedBox(height: 16),

                      PrimaryMultilineTextField(
                        controller: _descriptionController,
                        focusNode: _descriptionFocus,
                        hintText: "Nhập mô tả về trường...",
                        prefixIcon: Icons.description,
                        validator: Validators.description,
                      ),

                      const SizedBox(height: 32),
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
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.primaryGradient,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isUpdate ? Icons.edit : Icons.add,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              isUpdate ? 'Cập nhật thông tin trường' : 'Tạo trường mới',
              style: const TextStyle(
                fontSize: 20,
                fontFamily: "Nunito",
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close, color: Colors.white, size: 20),
              padding: const EdgeInsets.all(8),
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
        fontSize: 18,
        fontFamily: "Nunito",
        fontWeight: FontWeight.bold,
        color: AppColors.getTextColor(isDark),
      ),
    );
  }

  Widget _buildFooterButtons(bool isUpdate) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.grey300.withOpacity(0.5), width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: BorderSide(color: AppColors.grey400),
              ),
              child: Text(
                'Hủy',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.grey600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isUpdate
                      ? AppColors.successGradient
                      : AppColors.primaryGradient,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: (isUpdate ? AppColors.success : AppColors.primary)
                        .withOpacity(0.3),
                    offset: const Offset(0, 4),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
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
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            isUpdate ? 'Cập nhật' : 'Tạo trường',
                            style: const TextStyle(
                              fontSize: 16,
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
