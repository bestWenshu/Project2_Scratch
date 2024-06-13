public class AccessCodeGenerator {
  // Method to generate a random access code
  public static String generateAccessCode() {
    String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    String code = '';
    Integer length = 10;
    for (Integer i = 0; i < length; i++) {
      Integer idx = Math.mod(
        Math.abs(Crypto.getRandomInteger()),
        chars.length()
      );
      code += chars.substring(idx, idx + 1);
    }
    return code;
  }

  // Method to send an email with the access code
  public static void sendAccessCodeEmail(String email, String accessCode) {
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    mail.setToAddresses(new List<String>{ email });
    mail.setSubject('Your Access Code');
    mail.setPlainTextBody(
      'Congratulations! Here is your access code: ' +
        accessCode +
        '\nPlease use this as your temporary password to log in and reset your password.'
    );
    Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ mail });
  }

}
