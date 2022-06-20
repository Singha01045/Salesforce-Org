public class SendCustomNotification {
    
    public static void mthd(){
        
        Messaging.CustomNotification notification = new Messaging.CustomNotification();
        notification.setBody('This is body of the custom notification!');
        notification.setTitle('Hi this is first notification sent using apex!');
        notification.setSenderId(Userinfo.getUserId());
        CustomNotificationType type = [SELECT Id FROM CustomNotificationType WHERE DeveloperName = 'Task_creation_notification'];
        notification.setNotificationTypeId(type.id);
        notification.setTargetId('00Q5j00000Ate2aEAB');
        notification.send(new Set<String> { Userinfo.getUserId() });
         try {
            notification.send(new Set<String> { Userinfo.getUserId() });
        }
        catch (Exception e) {
            System.debug('Problem sending notification: ' + e.getMessage());
        }
    }

}