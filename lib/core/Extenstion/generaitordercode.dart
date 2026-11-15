import 'dart:math';

/// يولّد رمز الطلب الظاهر للزبون والسائق، مثل TLV-84920
abstract final class OrderCode {
  static const _prefix = 'TLV';
  static final _random = Random();

  /// خمسة أرقام لا تبدأ بصفر: من 10000 إلى 99999
  static String generate() => '$_prefix-${10000 + _random.nextInt(90000)}';
}