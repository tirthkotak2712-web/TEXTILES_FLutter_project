/// Display helpers shared by the shop and the admin panel.
abstract final class Format {
  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  static String inr(num value, {bool symbol = true}) {
    final negative = value < 0;
    final digits = value.abs().round().toString();
    final grouped = _group(digits);
    final sign = negative ? '-' : '';
    return symbol ? '$sign₹$grouped' : '$sign$grouped';
  }

  static String _group(String digits) {
    if (digits.length <= 3) return digits;
    final tail = digits.substring(digits.length - 3);
    var head = digits.substring(0, digits.length - 3);
    final parts = <String>[];
    while (head.length > 2) {
      parts.insert(0, head.substring(head.length - 2));
      head = head.substring(0, head.length - 2);
    }
    if (head.isNotEmpty) parts.insert(0, head);
    return '${parts.join(',')},$tail';
  }

  static String date(DateTime value) =>
      '${value.day} ${_months[value.month - 1]} ${value.year}';

  static String dateTime(DateTime value) {
    final hour = value.hour % 12 == 0 ? 12 : value.hour % 12;
    final minute = value.minute.toString().padLeft(2, '0');
    final suffix = value.hour >= 12 ? 'PM' : 'AM';
    return '${date(value)}, $hour:$minute $suffix';
  }

  static String time(DateTime value) {
    final hour = value.hour % 12 == 0 ? 12 : value.hour % 12;
    final minute = value.minute.toString().padLeft(2, '0');
    final suffix = value.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $suffix';
  }
}
