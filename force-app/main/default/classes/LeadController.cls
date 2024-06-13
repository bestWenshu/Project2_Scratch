public with sharing class LeadController {
  @AuraEnabled
  public static void createLead(Lead lead) {
    try {
      insert lead;
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }
}
