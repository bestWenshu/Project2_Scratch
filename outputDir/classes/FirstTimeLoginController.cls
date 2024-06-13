public class FirstTimeLoginController {
  @AuraEnabled
  public static String resetUserPassword(
    String username,
    String accessCode,
    String newPassword
  ) {
    try {
      // Query user based on username
      User user = [
        SELECT Id, Contact.Access_Code__c
        FROM User
        WHERE Username = :username
        LIMIT 1
      ];

      // Check if the access code matches
      if (user.Contact.Access_Code__c != accessCode) {
        return 'Invalid access code.';
      }

      // Reset the user's password
      System.setPassword(user.Id, newPassword);

      Contact contact = [
        SELECT Id, firstTime__c
        FROM Contact
        WHERE Id = :user.ContactId
        LIMIT 1
      ];

      contact.firstTime__c = 'false';
      update contact;
      return 'Success';
    } catch (Exception e) {
      System.debug('Error resetting password: ' + e.getMessage());
      return 'Error resetting password: ' + e.getMessage();
    }
  }
}
