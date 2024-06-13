public class ContactToCustomerUser {
  public static User createCustomerUser(String email, String accessCode) {
    if (String.isBlank(email)) {
      throw new CustomException('Email parameter cannot be blank.');
    }

    List<Contact> contacts = [
      SELECT
        Id,
        Email,
        LastName,
        AccountId,
        Account.OwnerId,
        Account.Owner.UserRoleId
      FROM Contact
      WHERE Email = :email
      LIMIT 1
    ];

    if (contacts.isEmpty()) {
      throw new CustomException('No contact found with the provided email.');
    }

    Contact contact = contacts[0];
    if (contact.Account.Owner.UserRoleId == null) {
      throw new CustomException(
        'The account owner does not have a role assigned, which is required to create a community user.'
      );
    }

    List<Profile> profiles = [
      SELECT Id
      FROM Profile
      WHERE Name = 'Customer Community User'
      LIMIT 1
    ];

    Profile profile = profiles[0];
    User newUser = new User(
      Username = contact.Email,
      Email = contact.Email,
      LastName = contact.LastName,
      Alias = contact.LastName.substring(0, 1).toLowerCase(),
      TimeZoneSidKey = 'America/Los_Angeles',
      LocaleSidKey = 'en_US',
      EmailEncodingKey = 'UTF-8',
      ProfileId = profile.Id,
      ContactId = contact.Id,
      LanguageLocaleKey = 'en_US'
    );

   

    try {
      insert newUser;
      // change here
      System.setPassword(newUser.Id, accessCode);
      System.debug(newUser.Id);
      System.debug(accessCode);
    } catch (Exception e) {
      throw new CustomException(
        'Failed to create and setup new user: ' + e.getMessage()
      );
    }

    return newUser;
  }

  public class CustomException extends Exception {
  }
}
