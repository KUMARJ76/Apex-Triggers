public class ContactTriggerHandler {
   
    // Req:1 --- Write a trigger that updates the Parent Account Phone and all related contacts Phone whenever Contact Phone field is updated
    public static void updatePhone(List<Contact> conList, Map<Id, Contact> oldMap) {
        Map<Id, Contact> conMap = new Map<Id, Contact>();
        List<Contact> contList = new List<Contact>();
        List<Account> accList = new List<Account>();
        Map<String, Set<Id>> processRecords = new Map<String, Set<Id>>();

        if (!processRecords.containsKey('afterUpdate')) {
            processRecords.put('afterUpdate', new Set<Id>());
        }

        for (Contact con : conList) {
            if (!processRecords.get('afterUpdate').contains(con.Id) && 
                String.isNotBlank(con.AccountId) && 
                String.isNotBlank(con.Phone) && 
                con.Phone != oldMap.get(con.Id).Phone) {

                conMap.put(con.AccountId, con);
                processRecords.get('afterUpdate').add(con.Id);
            }
        }

        if (!conMap.isEmpty()) {
            for (Contact con : [SELECT Id, AccountId, Phone FROM Contact WHERE AccountId IN :conMap.keySet()]) {
                if (conMap.containsKey(con.AccountId)) {
                    con.Phone = conMap.get(con.AccountId).Phone;
                    contList.add(con);
                }
            }

            for (Id accId : conMap.keySet()) {
                accList.add(new Account(Id = accId, Phone = conMap.get(accId).Phone));
            }

            if (!accList.isEmpty()) {
                update accList;
            }
            if (!contList.isEmpty()) {
                update contList;
            }
        }
    }
}