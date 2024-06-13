trigger LeadTrigger on Lead(after update) {
  for (Lead lead : Trigger.new) {
    if (lead.IsConverted && !Trigger.oldMap.get(lead.Id).IsConverted) {
      // Generate Access Code
      String accessCode = AccessCodeGenerator.generateAccessCode();

      // Get the converted Account and Contact
      Account acc = [
        SELECT Id
        FROM Account
        WHERE Id = :lead.ConvertedAccountId
        LIMIT 1
      ];
      Contact con = [
        SELECT Id, Email, LastName
        FROM Contact
        WHERE Id = :lead.ConvertedContactId
        LIMIT 1
      ];

      // Set the Access Code on the Account and Contact
      // Set the firstTime__c
      acc.Access_Code__c = accessCode;
      con.Access_Code__c = accessCode;
      con.firstTime__c = 'true';
      update acc;
      update con;

      if (con != null) {
        AccessCodeGenerator.sendAccessCodeEmail(con.Email, accessCode);
      }

      // insert new user with license
      ContactToCustomerUser.createCustomerUser(con.Email, accessCode);
    }
  }
}
