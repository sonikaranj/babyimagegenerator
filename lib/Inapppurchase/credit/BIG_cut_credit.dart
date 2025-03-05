import 'package:babyimage/services/BIG_Sharepreferance.dart';
import 'BIG_creditManager.dart';


class BigCutCredit{
  static Future<void> cutCredit(int cutcredit) async {
    var credit = await Big_Sharepreferance.getCreditValue('Credit');
    credit -= cutcredit;
    Big_Sharepreferance.setCreditValue(credit,'Credit');
    BIG_CreditsManager.saveUserCredits(credit);
  }

  static Future<void> addCredit(int cutcredit) async {
    var credit = await Big_Sharepreferance.getCreditValue('Credit');
    credit += cutcredit;
    Big_Sharepreferance.setCreditValue(credit,'Credit');
    BIG_CreditsManager.saveUserCredits(credit);
  }
}