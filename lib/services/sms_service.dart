import 'package:another_telephony/telephony.dart';

class SmsService {
  final Telephony _telephony = Telephony.instance;

  Future<void> sendSms(List<String> numbers, String message) async {
    for (var number in numbers) {
      await _telephony.sendSms(to: number, message: message);
    }
  }
}
