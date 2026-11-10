import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../../domain/job.dart';
import '../widgets/job_card.dart';
import '../widgets/route_map.dart';

const _red = Color(0xFFDC1F3C);

class JobInProgressScreen extends StatefulWidget {
  const JobInProgressScreen({super.key, required this.job});

  final Job job;

  @override
  State<JobInProgressScreen> createState() => _JobInProgressScreenState();
}

/// "End Job Confirmation" pop-up. Pops `true` for Create Manifest and
/// `false`/`null` for Cancel or dismiss.
class _EndJobDialog extends StatelessWidget {
  const _EndJobDialog({required this.job});

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
class _ExceptionDialog extends StatefulWidget {
  const _ExceptionDialog({required this.job});

  final Job job;

  @override
  State<_ExceptionDialog> createState() => _ExceptionDialogState();
}

class _ExceptionDialogState extends State<_ExceptionDialog> {
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

class _JobInProgressScreenState extends State<JobInProgressScreen> {
  final DateTime _startedAt = DateTime.now();

  static String _clock24(DateTime t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  static String _clock12(DateTime t) {
    final h = t.hour % 12 == 0 ? 12 : t.hour % 12;
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m ${t.hour < 12 ? 'AM' : 'PM'}';
  }

  void _soon(String what) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('$what: coming soon')));
  }

  Future<void> _reportException() async {
    final result = await showDialog<(String, String)>(
      context: context,
      builder: (_) => _ExceptionDialog(job: widget.job),
    );
    // Not sent anywhere yet: there is no exceptions endpoint.
    if (result != null) _soon('Exception "${result.$1}"');
  }

  Future<void> _endJob() async {
    final createManifest = await showDialog<bool>(
      context: context,
      builder: (_) => _EndJobDialog(job: widget.job),
    );
    // The manifest screen is not designed yet, so stay on this screen.
    if (createManifest == true) _soon('Create manifest');
  }

  @override
  Widget build(BuildContext context) {
    final job = widget.job;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: jobMaroon,
        foregroundColor: Colors.white,
        centerTitle: false,
        automaticallyImplyLeading: false,
        toolbarHeight: 64,
        titleSpacing: 12,
        title: Row(
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () =>
                  context.canPop() ? context.pop() : context.go(AppRoutes.jobs),
              child: const SizedBox(
                width: 36,
                height: 40,
                child: Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
            const SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Job In Progress',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                const SizedBox(height: 2),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.circle,
                              size: 6, color: Color(0xFF3DDC97)),
                          const SizedBox(width: 4),
                          Text(
                            job.reference,
                            style: const TextStyle(
                                fontSize: 10, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '• ${_clock24(_startedAt)}',
                      style: const TextStyle(
                          fontSize: 10, color: Color(0xFFFFB3C1)),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          _circleButton(Icons.phone_outlined, () => _soon('Call dispatch')),
          const SizedBox(width: 8),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: _circleButton(
              Icons.person,
              () => context.push(AppRoutes.profile),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: RouteMap()),
          Positioned(
            top: 10,
            left: 12,
            right: 12,
            child: _jobCard(job),
          ),
          Positioned(
            top: 84,
            left: 12,
            child: _turnCard(),
          ),
          Positioned(
            top: 90,
            right: 12,
            child: Material(
              color: Colors.white,
              shape: const CircleBorder(),
              elevation: 2,
              child: IconButton(
                icon: const Icon(Icons.navigation, size: 18, color: _red),
                onPressed: () => _soon('Recenter'),
              ),
            ),
          ),
          Positioned(
            left: 12,
            right: 12,
            bottom: 84,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _chip(
                  const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.circle, size: 7, color: Color(0xFF12A36B)),
                      SizedBox(width: 6),
                      Text('12 min',
                          style: TextStyle(
                              fontSize: 11, fontWeight: FontWeight.w700)),
                      SizedBox(width: 8),
                      Icon(Icons.circle, size: 4, color: AppColors.hint),
                      SizedBox(width: 8),
                      Text('4.2 km',
                          style: TextStyle(
                              fontSize: 11, color: AppColors.textMuted)),
                    ],
                  ),
                ),
                _chip(
                  const Text('Live Traffic',
                      style: TextStyle(
                          fontSize: 10, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ),
          Positioned(
            left: 12,
            right: 12,
            bottom: 16,
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: OutlinedButton.icon(
                      onPressed: _reportException,
                      icon: const Icon(Icons.warning_amber_rounded, size: 18),
                      label: const Text('Exception',
                          style: TextStyle(fontWeight: FontWeight.w700)),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: _red,
                        side: BorderSide(color: _red.withValues(alpha: 0.35)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: _endJob,
                      icon: const Icon(Icons.check_circle_outline, size: 18),
                      label: const Text('End Job',
                          style: TextStyle(fontWeight: FontWeight.w700)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(current: NavTab.jobs),
    );
  }

  Widget _circleButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: onTap,
      child: CircleAvatar(
        radius: 18,
        backgroundColor: Colors.white.withValues(alpha: 0.2),
        child: Icon(icon, size: 18, color: Colors.white),
      ),
    );
  }

  Widget _jobCard(Job job) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Color(0x1A000000), blurRadius: 10, offset: Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFFBE3E8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.local_shipping_outlined, color: _red),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('#JOB-0001',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w800)),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFEFF8),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        job.routeCode,
                        style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textMuted),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.schedule,
                        size: 12, color: AppColors.textMuted),
                    const SizedBox(width: 4),
                    Text(
                      'Started ${_clock12(_startedAt)}',
                      style: const TextStyle(
                          fontSize: 10, color: AppColors.textMuted),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.circle, size: 4, color: _red),
                    const SizedBox(width: 4),
                    const Text('On Schedule',
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: _red)),
                  ],
                ),
              ],
            ),
          ),
          OutlinedButton.icon(
            onPressed: () => _soon('SOP'),
            icon: const Icon(Icons.menu_book_outlined, size: 14),
            label: const Text('SOP',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textMuted,
              backgroundColor: const Color(0xFFF2F2FC),
              side: BorderSide.none,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              minimumSize: const Size(0, 34),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _turnCard() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Color(0x1A000000), blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: jobMaroon,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.turn_right, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 8),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('In 350m Turn Right',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800)),
              Text('King Fahd Rd / Exit 14',
                  style: TextStyle(fontSize: 9, color: AppColors.textMuted)),
            ],
          ),
          const SizedBox(width: 6),
        ],
      ),
    );
  }

  Widget _chip(Widget child) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(color: Color(0x1A000000), blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: child,
    );
  }
}
