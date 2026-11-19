import 'job.dart';

enum CompletedOutcome { delivered, exception }

class CompletedJob {
  const CompletedJob({
    required this.type,
    required this.outcome,
    required this.reference,
    required this.timeText,
    required this.area,
    required this.zone,
    this.note,
    this.paymentLabel,
    this.paymentValue,
    this.paymentBadge,
    this.alert,
  });

  final JobType type;
  final CompletedOutcome outcome;
  final String reference;
  final String timeText;
  final String area;
  final String zone;

  /// e.g. "Delivered â€¢ E-Signature Captured".
  final String? note;

  /// Left label of the payment row, e.g. "COD Collected" or "Payment".
  final String? paymentLabel;

  /// Plain value on the right, e.g. "Prepaid (Online)".
  final String? paymentValue;

  /// Highlighted value on the right in a white pill, e.g. "SAR 145.00".
  final String? paymentBadge;

  /// Red alert strip, e.g. "Customer Unavailable â€¢ Rescheduled 16:00".
  final String? alert;

  /// Builds a card model from a completed [Job] returned by the API. The API
  /// has no payment, e-signature or exception details, so those stay empty.
  factory CompletedJob.fromJob(Job job) => CompletedJob(
        type: job.type,
        outcome: CompletedOutcome.delivered,
        reference: job.reference,
        timeText: _when(job.completedAt),
        area: job.area,
        zone: job.zone == '-' ? '' : job.zone,
      );

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec', //
  ];

  /// "Today, 11:15 AM" for today, otherwise "11 Nov, 11:15 AM".
  static String _when(String? iso) {
    final t = DateTime.tryParse(iso ?? '');
    if (t == null) return '-';
    final now = DateTime.now();
    final h = t.hour % 12 == 0 ? 12 : t.hour % 12;
    final clock =
        '$h:${t.minute.toString().padLeft(2, '0')} ${t.hour < 12 ? 'AM' : 'PM'}';
    final today = t.year == now.year && t.month == now.month && t.day == now.day;
    return today ? 'Today, $clock' : '${t.day} ${_months[t.month - 1]}, $clock';
  }

  String get referenceLabel =>
      type == JobType.pickup ? 'BOOKING NUMBER' : 'AIR WAYBILL NUMBER';
}
