public with sharing class SiteLoginController {
  @AuraEnabled
  public static String loginAsUser(String email, String password) {
    User user = [SELECT Id, IsActive FROM User WHERE Email = :email LIMIT 1];

    if (user != null && user.IsActive) {
      PageReference loginPage = Site.login(email, password, '');
      if (loginPage != null) {
        return loginPage.getUrl();
      } else {
        throw new AuraHandledException(
          'Failure: loginPage is null, check credentials and user status.'
        );
      }
    } else {
      throw new AuraHandledException('Failure: User not found or inactive.');
    }
  }
}
