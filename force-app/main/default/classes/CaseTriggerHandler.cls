/*Req: Write a trigger to create a task and send email to the account owner. Whenever  case is deleted from the account   */

public class CaseTriggerHandler {
    public static void sendEmailToAccountOwner(List<Case> caseList){
        Map<Id,Case>caseMap=new Map<Id,Case>();
        List<Task> taskList=new List<Task>();
        
        if(!caseList.isEmpty()){
            for(Case c:caseList){
                if(c.AccountId!=null){
                    caseMap.put(c.AccountId,c);
                }
            }
        }
        
        if(!caseMap.isEmpty()){
            Map<Id,Account>accMap=new Map<Id,Account>([Select Id,Owner.Email from Account Where Id IN:caseMap.keySet()]);
            List<Messaging.Email>emailList=new List<Messaging.Email>();
            for(Case c:caseList){
                if(AccMap.containsKey(c.AccountId)){
                    Account a= accMap.get(c.AccountId);
                    Task t=new Task();
                    t.WhatId=a.Id;
                    t.Subject='Case Number: '+c.CaseNumber + 'Was Deleted!!';
                    t.Priority='High';
                    t.ActivityDate=System.today();
                    t.Status='Deferred';
                    taskList.add(t);
                    System.debug('Heelo');
                    if(a.Owner.Email!=null){
                        Messaging.singleEmailMessage emailMsg=new Messaging.singleEmailMessage();
                        emailMsg.setToAddresses(new String[] {a.Owner.Email});
                        emailMsg.setSubject('Case Deletion Notification');
                        emailMsg.setPlainTextBody('Hi\n\n Case Number:'+c.CaseNumber + 'Has been deleted \n\n Thanks and Regards,\n Jeetesh SFDC');
                        emailList.add(emailMsg);
                        
                    }
                }
            }
            if(!emailList.isEmpty()){
                Messaging.sendEmail(emailList);
            }
            if(!taskList.isEmpty()){
                insert taskList;
            }
        }
        
        
    }
}