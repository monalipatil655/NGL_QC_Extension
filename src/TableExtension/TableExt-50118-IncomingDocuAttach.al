tableextension 50118 IncomingDocAttache_QC extends "Incoming Document Attachment"
{
    fields
    {
        // Add changes to table fields here
    }
    procedure NewAttachmentFromPostedInspection(PostedInspection: Record "Posted Inspection")
    begin
        NewAttachmentFromDocument(
        PostedInspection."Incoming Document Entry No.",
        DATABASE::"Posted Inspection",
        7,
        PostedInspection."No.");
    end;

    var
        myInt: Integer;
}