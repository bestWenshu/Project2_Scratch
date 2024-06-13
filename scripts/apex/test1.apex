List<Account> accList = [SELECT Access_Code__c FROM Account];
String password = 'XR0VTELZPZ';
for (Account a : accList) {
    if(a.Access_Code__c == password){
        System.debug('yes');
    }
}