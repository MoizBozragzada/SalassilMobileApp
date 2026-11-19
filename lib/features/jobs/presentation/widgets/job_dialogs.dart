import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/job.dart';

const _red = Color(0xFFDC1F3C);

/// Shows the End Job Confirmation pop-up. Resolves to true when the courier
/// chose Create Manifest.
Future<bool> showEndJobDialog(BuildContext context, Job job) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (_) => EndJobDialog(job: job),
  );
  return result == true;
}

/// Shows the Report Exception pop-up. Resolves to `(reason, notes)` on
/// submit, or null if cancelled.
Future<(String, String)?> showExceptionDialog(BuildContext context, Job job) {
  return showDialog<(String, String)>(
    context: context,
    builder: (_) => ExceptionDialog(job: job),
  );
}
/// "End Job Confirmation" pop-up. Pops `true` for Create Manifest and
/// `false`/`null` for Cancel or dismiss.
class EndJobDialog extends StatelessWidget {
  const EndJobDialog({super.key, required this.job});

  final Job job;

  @override
  Widget build(BuildContext context) {
    final isPickup = job.type == JobType.pickup;
    final noun = isPickup ? 'booking' : 'shipment';

    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFBE3E8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.assignment_turned_in_outlined,
                      color: _red),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'End Job Confirmation',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Are you sure you want to end this job? Create '
                        'manifest for $noun ${job.reference} or cancel to '
                        'return.',
                        style: const TextStyle(
                          fontSize: 12,
                          height: 1.4,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.pop(context, false),
                  child: const Icon(Icons.close,
                      size: 20, color: AppColors.textMuted),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F3FB),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isPickup ? 'Booking Number:' : 'AWB Number:',
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textMuted),
                  ),
                  Text(
                    job.reference,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context, true),
                icon: const Icon(Icons.description_outlined, size: 18),
                label: const Text('Create Manifest',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context, false),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF1F2F8),
                  foregroundColor: AppColors.textDark,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Cancel',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const _exceptionReasons = [
  'Parcel not ready',
  "Can't contact the person",
  'Premises closed',
];

/// "Report Exception" pop-up. Pops `(reason, notes)` on submit, `null` on
/// cancel or dismiss.
class ExceptionDialog extends StatefulWidget {
  const ExceptionDialog({super.key, required this.job});

  final Job job;

  @override
  State<ExceptionDialog> createState() => ExceptionDialogState();
}

class ExceptionDialogState extends State<ExceptionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _notes = TextEditingController();
  String? _reason;

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(context, (_reason!, _notes.text.trim()));
  }

  InputDecoration _decoration({String? hint}) => InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 12, color: AppColors.hint),
        filled: true,
        fillColor: const Color(0xFFF4F3FB),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE6E6F2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE6E6F2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _red, width: 1.2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1.2),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final job = widget.job;
    final noun = job.type == JobType.pickup ? 'booking' : 'shipment';

    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFBE3E8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.warning_amber_rounded, color: _red),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Report Exception',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 6),
                        Text.rich(
                          TextSpan(
                            text:
                                'Log a delivery issue or obstacle for $noun\n',
                            children: [
                              TextSpan(
                                text: job.reference,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textDark,
                                ),
                              ),
                              const TextSpan(text: '.'),
                            ],
                          ),
                          style: const TextStyle(
                            fontSize: 12,
                            height: 1.4,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close,
                        size: 20, color: AppColors.textMuted),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              const Text.rich(
                TextSpan(
                  text: 'Select Reason ',
                  children: [
                    TextSpan(text: '*', style: TextStyle(color: _red)),
                  ],
                ),
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: _reason,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down,
                    color: AppColors.textMuted),
                decoration: _decoration(),
                hint: const Text(
                  'Choose exception reason...',
                  style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
                style:
                    const TextStyle(fontSize: 13, color: AppColors.textDark),
                borderRadius: BorderRadius.circular(12),
                items: [
                  for (final r in _exceptionReasons)
                    DropdownMenuItem(value: r, child: Text(r)),
                ],
                onChanged: (v) => setState(() => _reason = v),
                validator: (v) => v == null ? 'Please select a reason' : null,
              ),
              const SizedBox(height: 14),
              const Text(
                'Comment / Notes',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _notes,
                maxLines: 3,
                style: const TextStyle(fontSize: 13),
                decoration: _decoration(
                  hint: 'Add additional details or driver comments...',
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _submit,
                  icon: const Icon(Icons.error_outline, size: 18),
                  label: const Text('Submit Exception',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF1F2F8),
                    foregroundColor: AppColors.textDark,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Cancel',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

