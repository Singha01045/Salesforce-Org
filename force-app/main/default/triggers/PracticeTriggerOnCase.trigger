trigger PracticeTriggerOnCase on Case (before insert) 
{
    Practice.practice1(trigger.new);
}