@isTest
public class ContactToCustomerUserTest {
  @isTest
  static void testCreateCustomerUserWithValidData() {
    // Set up data
    Account testAccount = new Account(Name = 'Test Account');
    insert testAccount;

    Contact testContact = new Contact(
      Email = 'test@example.com',
      LastName = 'Tester',
      AccountId = testAccount.Id
    );
    insert testContact;

    Profile customerProfile = [
      SELECT Id
      FROM Profile
      WHERE Name = 'Customer Community User'
      LIMIT 1
    ];
    User user = ContactToCustomerUser.createCustomerUser('test@example.com');

    // Asserts
    System.assertNotEquals(null, user);
    System.assertEquals(testContact.Email, user.Email);
  }

  @isTest
  static void testCreateCustomerUserWithInvalidEmail() {
    // Expect an exception
    try {
      User user = ContactToCustomerUser.createCustomerUser('');
      System.assert(false, 'Exception should have been thrown');
    } catch (ContactToCustomerUser.CustomException e) {
      System.assertEquals('Email parameter cannot be blank.', e.getMessage());
    }
  }

  @isTest
  static void testCreateCustomerUserWithNoContactFound() {
    // Expect an exception
    try {
      User user = ContactToCustomerUser.createCustomerUser(
        'nonexistent@example.com'
      );
      System.assert(false, 'Exception should have been thrown');
    } catch (ContactToCustomerUser.CustomException e) {
      System.assertEquals(
        'No contact found with the provided email.',
        e.getMessage()
      );
    }
  }
}
