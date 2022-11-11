page 50047 "Posted Inspection List"
{
    // version PCPL/QC/V3/001,PCPL/FinishedProd/INCDoc

    CardPageID = "Posted Inspection Datasheet";
    DeleteAllowed = false;
    Editable = false;
    PageType = List;
    SourceTable = 50022;
    SourceTableView = SORTING("No.")
                      ORDER(Ascending)
                      WHERE(Status = FILTER(Release));
    ApplicationArea = all;
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                    ApplicationArea = all;
                }
                field("Document Type"; "Document Type")
                {
                    ApplicationArea = all;
                }
                field("Document No."; "Document No.")
                {
                    ApplicationArea = all;
                }
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = all;
                }
                field(Quantity; Quantity)
                {
                    ApplicationArea = all;
                }
                field("Ref ID"; "Ref ID")
                {
                    ApplicationArea = all;
                }
                field("Document Date"; "Document Date")
                {
                    ApplicationArea = all;
                }
                field("Prod. Order Date"; "Prod. Order Date")
                {
                    ApplicationArea = all;
                }
                field("Incoming Document Attached"; "Incoming Document Attached")
                {
                    ApplicationArea = all;
                }
                field("Lot No."; "Lot No.")
                {
                    ApplicationArea = all;
                }
                field("Vendor No."; "Vendor No.")
                {
                    ApplicationArea = all;
                }
                field("Vendor Name"; "Vendor Name")
                {
                    ApplicationArea = all;
                }
                field("Item No."; "Item No.")
                {
                    ApplicationArea = all;
                }
                field("Item Description"; "Item Description")
                {
                    ApplicationArea = all;
                }
                field("Item Description 2"; "Item Description 2")
                {
                    ApplicationArea = all;
                }
                field("Unit of Messure"; "Unit of Messure")
                {
                    ApplicationArea = all;
                }
                field("Item Tracking"; "Item Tracking")
                {
                    ApplicationArea = all;
                }
                field(Remarks; Remarks)
                {
                    ApplicationArea = all;
                }
                field("Certificate No."; "Certificate No.")
                {
                    ApplicationArea = all;
                    TableRelation = "Posted Inspection";
                }
                field("GRN No."; "GRN No.")
                {
                    ApplicationArea = all;
                }
                field("GRN Date"; "GRN Date")
                {
                    ApplicationArea = all;
                }
                field("GRN Quantity"; "GRN Quantity")
                {
                    ApplicationArea = all;
                }
                field("Prod. Order Quantity"; "Prod. Order Quantity")
                {
                    ApplicationArea = all;
                }
                field("Inspection Sheet No."; "Inspection Sheet No.")
                {
                    ApplicationArea = all;
                }
                field("Before GRN"; "Before GRN")
                {
                    ApplicationArea = all;
                }
                field(Approval; Approval)
                {
                    ApplicationArea = all;
                }
                field(Status; Status)
                {
                    ApplicationArea = all;
                }
                field("Sample Drawn Quantity"; "Sample Drawn Quantity")
                {
                    ApplicationArea = all;
                }
                field("Mfg. Date"; "Mfg. Date")
                {
                    ApplicationArea = all;
                    Editable = true;
                }
                field("EXP Date"; "EXP Date")
                {
                    ApplicationArea = all;
                }
                field("Analyzed on"; "Analyzed on")
                {
                    ApplicationArea = all;
                }
                field("Sample By"; "Sample By")
                {
                    ApplicationArea = all;
                }
                field("Transfer Receipt Date"; "Transfer Receipt Date")
                {
                    ApplicationArea = all;
                }
                field("Retest on"; "Retest on")
                {
                    ApplicationArea = all;
                }
                field("Inspected By"; "Inspected By")
                {
                    ApplicationArea = all;
                }
                field("Approved By"; "Approved By")
                {
                    ApplicationArea = all;
                }
                field("Replanned Prod. Order"; "Replanned Prod. Order")
                {
                    ApplicationArea = all;
                }
                field("Purch. Order Quantity"; "Purch. Order Quantity")
                {
                    ApplicationArea = all;
                }
                field("Transfer Receipt No."; "Transfer Receipt No.")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            group(IncomingDocument)
            {
                action(IncomingDocCard)
                {
                    Caption = 'View Incoming Document';
                    Enabled = HasIncomingDocument;
                    Image = ViewOrder;
                    ApplicationArea = all;

                    trigger OnAction();
                    var
                        IncomingDocument: Record 130;
                    begin
                        IncomingDocument.ShowCardFromEntryNo("Incoming Document Entry No.");        //PCPL-25
                    end;
                }
                action(SelectIncomingDoc)
                {
                    Caption = 'Select Incoming Document';
                    Enabled = NOT HasIncomingDocument;
                    Image = SelectLineToApply;
                    Promoted = true;

                    trigger OnAction();
                    var
                        IncomingDocument: Record 130;
                    begin
                        VALIDATE("Incoming Document Entry No.", IncomingDocument.SelectIncomingDocument("Incoming Document Entry No.", RecordId));     //PCPL-25
                    end;
                }
                action(IncomingDocAttachFile)
                {
                    Caption = 'Create Incoming Document from File';
                    Enabled = NOT HasIncomingDocument;
                    Image = Attach;
                    Promoted = true;

                    trigger OnAction();
                    var
                        IncomingDocumentAttachment: Record 133;
                    begin
                        IncomingDocumentAttachment.NewAttachmentFromPostedInspection(Rec);    //PCPL-25
                    end;
                }
                action(RemoveIncomingDoc)
                {
                    Caption = 'Remove Incoming Document';
                    Enabled = HasIncomingDocument;
                    // Image = REmoveline;
                    Promoted = true;

                    trigger OnAction();
                    begin
                        PostedInspection.RESET;
                        PostedInspection.SETRANGE("No.", "No.");
                        IF PostedInspection.FINDFIRST THEN BEGIN
                            PostedInspection."Incoming Document Entry No." := 0;
                            PostedInspection.MODIFY;
                            COMMIT;
                        END;
                    end;
                }
                action(DocumentAttached)
                {
                    Caption = 'Document Attached';
                    Promoted = true;

                    trigger OnAction();
                    begin
                        IF "Incoming Document Entry No." <> 0 THEN BEGIN
                            "Incoming Document Attached" := TRUE;
                            MODIFY;
                        END
                        ELSE
                            IF "Incoming Document Entry No." = 0 THEN BEGIN
                                "Incoming Document Attached" := FALSE;
                                MODIFY;
                            END;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        HasIncomingDocument := "Incoming Document Entry No." <> 0;    //PCPL-25
    end;

    trigger OnOpenPage();
    var
        TmpLocCode: Code[100];
        RecUser: Record 91;
    begin
        //PCPL0017
        RecUser.RESET;
        RecUser.SETRANGE(RecUser."User ID", USERID);
        IF RecUser.FINDFIRST THEN BEGIN
            TmpLocCode := RecUser."Location Code";
        END;
        IF TmpLocCode <> '' THEN BEGIN
            FILTERGROUP(2);
            SETFILTER("Location Code", TmpLocCode);
            FILTERGROUP(0);
        END;
        //PCPL0017
    end;

    var
        RecUser: Record 91;
        HasIncomingDocument: Boolean;
        PostedInspection: Record 50022;
}

