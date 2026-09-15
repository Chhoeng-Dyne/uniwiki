import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/scholarship_model.dart';

class ApplyScholarshipModal extends StatefulWidget {
  final ScholarshipModel scholarship;
  final VoidCallback onSubmitted;

  const ApplyScholarshipModal({
    super.key,
    required this.scholarship,
    required this.onSubmitted,
  });

  static Future<void> show({
    required BuildContext context,
    required ScholarshipModel scholarship,
    required VoidCallback onSubmitted,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.35),
      builder: (context) {
        return Stack(
          children: [
            // Background blur covering underlying screen
            Positioned.fill(
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                behavior: HitTestBehavior.opaque,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.15),
                  ),
                ),
              ),
            ),
            // Draggable modal sheet that dismisses on scroll/drag down
            ApplyScholarshipModal(
              scholarship: scholarship,
              onSubmitted: onSubmitted,
            ),
          ],
        );
      },
    );
  }

  @override
  State<ApplyScholarshipModal> createState() => _ApplyScholarshipModalState();
}

class _ApplyScholarshipModalState extends State<ApplyScholarshipModal> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _fullNameController;
  late final TextEditingController _dobController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _nationalityController;
  late final TextEditingController _intendedMajorController;
  late final TextEditingController _reasonController;

  DateTime? _selectedDob;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _selectedDob = null;
    _dobController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _nationalityController = TextEditingController();
    _intendedMajorController = TextEditingController();
    _reasonController = TextEditingController();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _dobController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _nationalityController.dispose();
    _intendedMajorController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _pickDateOfBirth() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDob ?? DateTime(2005, 1, 1),
      firstDate: DateTime(1970),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.dark,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDob = picked;
        final day = picked.day.toString().padLeft(2, '0');
        final month = picked.month.toString().padLeft(2, '0');
        _dobController.text = '$day/$month/${picked.year}';
      });
    }
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.of(context).pop();
      widget.onSubmitted();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.45,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: [
              BoxShadow(
                color: Color(0x29000000),
                blurRadius: 28,
                offset: Offset(0, -6),
              ),
            ],
          ),
          child: Column(
            children: [
              // Sticky Drag Handle & Header bar
              Container(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 14),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColors.secondary, width: 0.8),
                  ),
                ),
                child: Column(
                  children: [
                    // Pill drag handle
                    Center(
                      child: Container(
                        width: 44,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Apply for Scholarship',
                            style: TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: AppColors.dark,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '${widget.scholarship.provider} · ${widget.scholarship.universityName}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Scrollable Form Body
              Expanded(
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      // Form guidance hint
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.secondary),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              size: 18,
                              color: AppColors.primary,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Fill in your details below. Scroll down at any time to close this form.',
                                style: TextStyle(
                                  fontFamily: AppTextStyles.fontFamily,
                                  fontSize: 12,
                                  color: AppColors.dark,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),

                      // 1. Full Name
                      _buildFieldLabel('Full Name *'),
                      TextFormField(
                        controller: _fullNameController,
                        style: const TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: 14,
                          color: AppColors.dark,
                        ),
                        decoration: _inputDecoration(
                          hintText: 'e.g. Chhoeng Dyne',
                          prefixIcon: Icons.person_outline_rounded,
                        ),
                        validator: (val) =>
                            (val == null || val.trim().isEmpty)
                                ? 'Please enter your full name'
                                : null,
                      ),
                      const SizedBox(height: 16),

                      // 2. Date of Birth
                      _buildFieldLabel('Date of Birth *'),
                      TextFormField(
                        controller: _dobController,
                        style: const TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: 14,
                          color: AppColors.dark,
                        ),
                        decoration: _inputDecoration(
                          hintText: 'DD/MM/YYYY',
                          prefixIcon: Icons.calendar_today_outlined,
                        ).copyWith(
                          suffixIcon: IconButton(
                            icon: const Icon(
                              Icons.calendar_month_rounded,
                              color: AppColors.primary,
                              size: 20,
                            ),
                            onPressed: _pickDateOfBirth,
                            tooltip: 'Select date',
                          ),
                        ),
                        validator: (val) =>
                            (val == null || val.trim().isEmpty)
                                ? 'Please enter or select date of birth'
                                : null,
                      ),
                      const SizedBox(height: 16),

                      // 3. Email & Phone Number
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildFieldLabel('Email *'),
                                TextFormField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  style: const TextStyle(
                                    fontFamily: AppTextStyles.fontFamily,
                                    fontSize: 14,
                                    color: AppColors.dark,
                                  ),
                                  decoration: _inputDecoration(
                                    hintText: 'student@domain.com',
                                    prefixIcon: Icons.email_outlined,
                                  ),
                                  validator: (val) =>
                                      (val == null || !val.contains('@'))
                                          ? 'Valid email required'
                                          : null,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildFieldLabel('Phone Number *'),
                                TextFormField(
                                  controller: _phoneController,
                                  keyboardType: TextInputType.phone,
                                  style: const TextStyle(
                                    fontFamily: AppTextStyles.fontFamily,
                                    fontSize: 14,
                                    color: AppColors.dark,
                                  ),
                                  decoration: _inputDecoration(
                                    hintText: '+855 12 345 678',
                                    prefixIcon: Icons.phone_outlined,
                                  ),
                                  validator: (val) =>
                                      (val == null || val.trim().isEmpty)
                                          ? 'Phone required'
                                          : null,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // 4. Nationality / Country of residence
                      _buildFieldLabel('Nationality / Country of Residence *'),
                      TextFormField(
                        controller: _nationalityController,
                        style: const TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: 14,
                          color: AppColors.dark,
                        ),
                        decoration: _inputDecoration(
                          hintText: 'e.g. Cambodian / Cambodia',
                          prefixIcon: Icons.public_rounded,
                        ),
                        validator: (val) =>
                            (val == null || val.trim().isEmpty)
                                ? 'Please enter nationality / residence'
                                : null,
                      ),
                      const SizedBox(height: 16),

                      // 5. Intended major / field of study
                      _buildFieldLabel('Intended Major / Field of Study *'),
                      TextFormField(
                        controller: _intendedMajorController,
                        style: const TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: 14,
                          color: AppColors.dark,
                        ),
                        decoration: _inputDecoration(
                          hintText: 'e.g. Computer Science & AI',
                          prefixIcon: Icons.school_outlined,
                        ),
                        validator: (val) =>
                            (val == null || val.trim().isEmpty)
                                ? 'Please enter intended major'
                                : null,
                      ),
                      const SizedBox(height: 16),

                      // 6. Why do you deserve this scholarship
                      _buildFieldLabel('Why do you deserve this scholarship? *'),
                      TextFormField(
                        controller: _reasonController,
                        maxLines: 4,
                        minLines: 3,
                        style: const TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: 14,
                          color: AppColors.dark,
                        ),
                        decoration: _inputDecoration(
                          hintText:
                              'Briefly share your academic achievements, leadership, financial need, and career goals...',
                          prefixIcon: Icons.edit_note_rounded,
                        ),
                        validator: (val) =>
                            (val == null || val.trim().isEmpty)
                                ? 'Please provide your reason or statement'
                                : null,
                      ),
                      const SizedBox(height: 24),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton.icon(
                          onPressed: _handleSubmit,
                          icon: const Icon(
                            Icons.send_rounded,
                            size: 18,
                            color: Colors.white,
                          ),
                          label: const Text(
                            'Submit Application',
                            style: TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            elevation: 2,
                            shadowColor: AppColors.primary.withValues(alpha: 0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, left: 2),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: AppTextStyles.fontFamily,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.dark,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hintText,
    required IconData prefixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        fontFamily: AppTextStyles.fontFamily,
        fontSize: 13,
        color: Colors.grey.shade400,
      ),
      prefixIcon: Icon(prefixIcon, size: 20, color: AppColors.primary),
      filled: true,
      fillColor: AppColors.background,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.secondary, width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.6),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.6),
      ),
    );
  }
}
