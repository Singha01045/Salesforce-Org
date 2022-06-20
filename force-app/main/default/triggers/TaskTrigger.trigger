trigger TaskTrigger on Task (before insert) {
    Helper.triggerHelper(trigger.new);
}