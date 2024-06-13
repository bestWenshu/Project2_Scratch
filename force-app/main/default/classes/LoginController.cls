public with sharing class LoginController {
  @AuraEnabled
  public static String login(String accountId, String password) {
    List<Contact> acc = [
      SELECT Access_Code__c, Email, firstTime__c, userPassword__c
      FROM Contact
    ];
    for (Contact a : acc) {
      if (a.firstTime__c == 'true') {
        if (a.Access_Code__c == password && a.Email == accountId) {
          return 'First time login';
        }
      } else {
        if (a.userPassword__c == password && a.Email == accountId) {
          return 'Login successful';
        }
      }
    }
    return 'Invalid credentials';
  }

  @AuraEnabled
  public static String resetPassword(String accountId, String newPassword) {
    List<Contact> acc = [
      SELECT Access_Code__c, firstTime__c, userPassword__c
      FROM Contact
    ];
    for (Contact a : acc) {
      if (a.firstTime__c == 'true') {
        a.firstTime__c = 'false';
        a.userPassword__c = newPassword;
        update a;
        return 'Password reset successful';
      }
    }
    return 'Account not found';
  }
}
