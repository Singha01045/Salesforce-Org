system.enqueueJob( new ChildQueueableClass() );
string jobID = System.enqueueJob(new QueueableClass());
System.debug('@@@@@ JOB ID @@@@@ : ' + jobID );

Database.executeBatch(new UpdateContactAddress(), 200);

BatchClassAccount batchObject = new BatchClassAccount();
Id batchID = Database.executeBatch(batchObject, 200);
AsyncApexJob job = [SELECT Id, Status, JobItemsProcessed, TotalJobItems, NumberOfErrors FROM AsyncApexJob WHERE ID = :batchId ];

TodayTaskUsingFutureMethod obj = new TodayTaskUsingFutureMethod();
system.debug(obj);