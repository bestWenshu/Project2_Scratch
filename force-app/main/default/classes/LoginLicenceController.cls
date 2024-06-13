public with sharing class LoginLicenceController {
  public LoginLicenceController() {
  }
  @AuraEnabled
  public static String login(String username, String password) {
    try {
      // Authenticate the user using Site.login
      PageReference loginPage = Site.login(username, password, null);
      if (loginPage != null) {
        // Login successful
        return 'SUCCESS';
      } else {
        return 'Invalid username or password';
      }
    } catch (Exception e) {
      return e.getMessage();
    }
  }
}
