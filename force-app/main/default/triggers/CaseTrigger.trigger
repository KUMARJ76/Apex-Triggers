trigger CaseTrigger on Case (before insert,before Update, After Insert , After Update,After Delete) {
    if(Trigger.isAfter){
        if(Trigger.isDelete){
            CaseTriggerHandler.sendEmailToAccountOwner(Trigger.old);
                }
    }
}