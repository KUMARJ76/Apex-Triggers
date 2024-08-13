trigger ContactTrigger on Contact (after insert,after Update) {
    if(Trigger.isAfter && Trigger.isUpdate){
    
           ContactTriggerHandler.updatePhone(Trigger.new,Trigger.oldMap); 
        
    }
    

}