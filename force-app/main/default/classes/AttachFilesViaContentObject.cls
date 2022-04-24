public class AttachFilesViaContentObject 
{
    Public static void showPDF()
    {
        //Inserting Content Version...
        string dataToBeInsertedInPDF = 'This is to be stored in PDF';
        ContentVersion DocVersion = new ContentVersion();
        DocVersion.ContentLocation = 'S';    //ContentLoaction specifies the Origin of the Document  { S: Document is located within Salesforce }...
        DocVersion.Title = 'TestFile';
        
        //DocVersion.PathOnClient = DocVersion.Title + '.pdf';          //Respresents File Type...
        DocVersion.PathOnClient = DocVersion.Title + '.txt';
        
        //Blob textData = Blob.valueOf(dataToBeInsertedInPDF);
        //DocVersion.VersionData = textData;
        
        DocVersion.VersionData = Blob.valueOf(dataToBeInsertedInPDF);
        //DocVersion.VersionData = Blob.toPdf(dataToBeInsertedInPDF);   // The content or body of the note, which can include properly formatted HTML or plain text. When a document is uploaded or downloaded via the API, it should be base64 encoded (for upload) or decoded (for download).
        insert DocVersion;
        
        //Specifying the user with whom we'll be sharing the File...
        Id conDocument = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =: DocVersion.Id].ContentDocumentId;   //Fetching ContentDocumentId...
        ContentDocumentLink DocLink = new ContentDocumentLink();
        DocLink.ContentDocumentId = conDocument;
        DocLink.LinkedEntityId = '0015j00000c4oqBAAQ';
        DocLink.Visibility ='AllUsers';
        DocLink.ShareType ='I';    //Permission granted to the users...  {V: Viewer Permission}
        insert DocLink;
    }

}