page 50048 "Posted Inspection Datasheet"
{
    // version PCPL/QC/V3/001,PCPL/BRB/003,PCPL/FinishedProd/INCDoc

    Caption = 'Posted Inspection Datasheet';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = 50022;
    SourceTableView = SORTING("No.")
                      ORDER(Ascending)
                      WHERE(Status = FILTER(Release));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; "No.")
                {
                    Editable = false;
                    ApplicationArea = all;

                }
                field("Document No."; "Document No.")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Ref ID"; "Ref ID")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Posting Date"; "Posting Date")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field(Quantity; Quantity)
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Document Date"; "Document Date")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Unit of Messure"; "Unit of Messure")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Certificate No."; "Certificate No.")
                {
                    Editable = true;
                    ApplicationArea = all;
                }
                field("Incoming Document Attached"; "Incoming Document Attached")
                {
                    ApplicationArea = all;
                }
                field("Lot No."; "Lot No.")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("External Lot No."; "External Lot No.")
                {
                    ApplicationArea = all;
                }
                field("Item No."; "Item No.")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Item Description"; "Item Description")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Item Description 2"; "Item Description 2")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Before GRN"; "Before GRN")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Sample Drawn Quantity"; "Sample Drawn Quantity")
                {
                    DecimalPlaces = 0 : 3;
                    ApplicationArea = all;
                }
                field("Sample UOM"; "Sample UOM")
                {
                    ApplicationArea = all;
                }
                field("EXP Date"; "EXP Date")
                {
                    ApplicationArea = all;
                }
                field("Sample Drawn On"; "Sample Drawn On")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Outer Package"; "Outer Package")
                {
                    ApplicationArea = all;
                }
                field("Inner Package"; "Inner Package")
                {
                    ApplicationArea = all;
                }
                field("Mfg. Date"; "Mfg. Date")
                {
                    Editable = true;
                    ApplicationArea = all;
                }
                field("Analyzed on"; "Analyzed on")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Posted Sample Quanity"; "Posted Sample Quanity")
                {
                    DecimalPlaces = 0 : 3;
                    ApplicationArea = all;
                }
                field("No. Container Sample"; "No. Container Sample")
                {
                    ApplicationArea = all;
                }
                field("Retest on"; "Retest on")
                {
                    Editable = true;
                    ApplicationArea = all;
                }
                field("RM Packing Detail"; "RM Packing Detail")
                {
                    Caption = 'Packing Detail';
                    ApplicationArea = all;
                }
                field("Approved By"; "Approved By")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Item Tracking"; "Item Tracking")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Conditional Released"; "Conditional Released")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Prod. Packing Detail"; "Prod. Packing Detail")
                {
                    ApplicationArea = all;
                }
                field("Pending Inspection"; "Pending Inspection")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
            }
            part(InspectionLine; 50049)
            {
                Editable = editablePartialApp;
                SubPageLink = "No." = FIELD("No."),
                              "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("Document No.");
                SubPageView = SORTING("No.", "Line No.")
                              ORDER(Ascending);
            }
            group(Approval)
            {
                Caption = 'Approval';
                field("Approved Quantity"; "Approved Quantity")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Rejected Quantity"; "Rejected Quantity")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Control Sample Quantity"; "Control Sample Quantity")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
            }
            group(GRN)
            {
                Caption = 'GRN';
                field("Vendor No."; "Vendor No.")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Vendor Name"; "Vendor Name")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Purch. Order Quantity"; "Purch. Order Quantity")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("GRN No."; "GRN No.")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("GRN Date"; "GRN Date")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("GRN Quantity"; "GRN Quantity")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
            }
            group("Prod. Order")
            {
                Caption = 'Prod. Order';
                field("Prod. Order Date"; "Prod. Order Date")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Prod. Order Quantity"; "Prod. Order Quantity")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
            }
            group("Transfer Order")
            {
                Caption = 'Transfer Order';
                field("Transfer Receipt No."; "Transfer Receipt No.")
                {
                    ApplicationArea = all;
                }
                field("Transfer Receipt Quantity"; "Transfer Receipt Quantity")
                {
                    ApplicationArea = all;
                }
                field("Transfer Receipt Date"; "Transfer Receipt Date")
                {
                    ApplicationArea = all;
                }
            }
            group(Return)
            {
                Caption = 'Return';
                field("Return Receipt No."; "Return Receipt No.")
                {
                    ApplicationArea = all;
                }
                field("Return Receipt Quantity"; "Return Receipt Quantity")
                {
                    ApplicationArea = all;
                }
                field("Return Receipt Date"; "Return Receipt Date")
                {
                    ApplicationArea = all;
                }
                field("Customer No."; "Customer No.")
                {
                    ApplicationArea = all;
                }
                field("Customer Name"; "Customer Name")
                {
                    ApplicationArea = all;
                }
            }
            group(Retest)
            {
                Caption = 'Retest';
                field("Retest Document"; "Retest Document")
                {
                }
                field("Retest from Doc No"; "Retest from Doc No")
                {
                }
            }
            group(Quality)
            {
                Caption = 'Quality';
                field(Remarks; Remarks)
                {
                    ApplicationArea = all;
                }
                field("Inspected By"; "Inspected By")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Approval1; Approval)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Status; Status)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            // Caption = 'ACTION';
            group(Process)
            {
                Caption = 'Process';
                action("Final Approve")
                {
                    Caption = 'Final Approve';
                    Enabled = enablePartialBtn;
                    Image = Approve;
                    ApplicationArea = all;

                    trigger OnAction();
                    begin

                        //IRLQC/CUST/005
                        IF CONFIRM('Do you want to close this document permanently', TRUE) THEN BEGIN
                            Approval := Approval::Approved;
                            MODIFY;
                            CurrPage.UPDATE(TRUE);
                        END;
                        //IRLQC/CUST/005
                    end;
                }
            }
            group(Report)
            {
                Caption = 'Report';
                action("Certificate Of Analysis")
                {
                    Image = Certificate;
                    ApplicationArea = all;

                    trigger OnAction();
                    begin
                        CLEAR(pgReason);
                        TESTFIELD(Approval, Approval::Approved);
                        reInspectionDataSheet.RESET;
                        reInspectionDataSheet.SETRANGE("No.", "No.");
                        IF reInspectionDataSheet.FINDFIRST THEN BEGIN
                            /* IF reInspectionDataSheet."COA Printed"= TRUE THEN
                             BEGIN

                               IF CONFIRM('You need to select Reason code as you have already printed this Document',TRUE) THEN BEGIN
                                 pgReason.SETTABLEVIEW(recReason);
                                 pgReason.LOOKUPMODE(TRUE);
                                 IF pgReason.RUNMODAL=ACTION::LookupOK THEN BEGIN
                                   tempCOALog.RESET;
                                   tempCOALog.SETRANGE(tempCOALog."Inspection No.","No.");
                                   IF tempCOALog.FINDLAST THEN
                                     Version:=tempCOALog."Version No.";
                                   COALog.INIT;
                                   COALog."Inspection No.":="No.";
                                   COALog."Version No.":=Version+1;
                                   COALog."Reason Code":=recReason.Code;
                                   COALog.Description:=recReason.Description;
                                   COALog."User ID":=USERID;
                                   COALog."Creation Date Time":=CURRENTDATETIME;
                                   COALog.INSERT;
                                   REPORT.RUNMODAL(REPORT::"Certificate Of Analysis QC",TRUE,TRUE,reInspectionDataSheet);
                                 END

                               END;
                             END */
                            //ELSE
                            REPORT.RUNMODAL(REPORT::"Certificate Of Analysis", TRUE, TRUE, reInspectionDataSheet);
                        END;

                    end;
                }
                action("File Export")
                {

                    trigger OnAction();
                    var
                        //TempBlob: Record 99008535;
                        Tempblob1: codeunit "Temp Blob";
                        Ins: InStream;
                        OutS: OutStream;
                    begin
                        //PCPL/BRB
                        CALCFIELDS("File Attach");

                        IF NOT "File Attach".HASVALUE THEN
                            ERROR('file does not exist');

                        //TempBlob.Blob := "File Attach";
                        TempBlob1.CreateInStream(Ins);
                        "File Attach".CreateOutStream(OutS);
                        CopyStream(OutS, Ins);

                        //filemanag.BLOBExport(TempBlob, FORMAT('*' + Extension + ''), TRUE);  //PCPL/NSW/MIG   19July22

                        //PCPL/BRB-29jan18
                    end;
                }
                action("Analytic Report for Intermidiate and FG")
                {
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;

                    trigger OnAction();
                    begin
                        PostedInspection.RESET;
                        PostedInspection.SETRANGE("No.", "No.");
                        IF PostedInspection.FINDFIRST THEN
                            REPORT.RUNMODAL(50039, TRUE, FALSE, PostedInspection);
                    end;
                }
                action("Analytic Report for Raw Material")
                {
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;

                    trigger OnAction();
                    begin
                        PostedInspection.RESET;
                        PostedInspection.SETRANGE("No.", "No.");
                        IF PostedInspection.FINDFIRST THEN
                            REPORT.RUNMODAL(50037, TRUE, FALSE, PostedInspection);
                    end;
                }
            }
            group(IncomingDocument)
            {
                action(IncomingDocCard)
                {
                    Caption = 'View Incoming Document';
                    Enabled = HasIncomingDocument;
                    Image = ViewOrder;

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
                    //Image = REmoveline;

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

        //IRLQC/CUST/005
        IF Approval = Approval::"Partially Approved" THEN BEGIN
            editablePartialApp := TRUE;
            enablePartialBtn := TRUE;
        END
        ELSE BEGIN
            editablePartialApp := FALSE;
            enablePartialBtn := FALSE;
        END;
        //IRLQC/CUST/005


        //"Inspected By":=USERID; //PCPL/BRB/23-03-18
        CurrPage.UPDATE(FALSE);
    end;

    trigger OnOpenPage();
    begin

        //IRLQC/CUST/005
        IF Approval = Approval::"Partially Approved" THEN BEGIN
            editablePartialApp := TRUE;
            enablePartialBtn := TRUE;
        END
        ELSE BEGIN
            editablePartialApp := FALSE;
            enablePartialBtn := FALSE;
        END;
        //IRLQC/CUST/005
        IF ("Document Type" = "Document Type"::"Purch. Order") AND ("Before GRN") THEN
            beforeGRN := TRUE
        ELSE
            beforeGRN := FALSE
    end;

    var
        recInspectionLedger: Record 50014;
        Line: Integer;
        recPurchLine: Record 39;
        recProdLine: Record 5406;
        recILE: Record 32;
        recInspectionLine: Record 50012;
        [InDataSet]
        ApprovalEdit: Boolean;
        recQltySetup: Record 50010;
        recReservationEntry: Record 337;
        beforeGRN: Boolean;
        recItem: Record 27;
        NoSeriesMgmt: Codeunit 396;
        editablePartialApp: Boolean;
        enablePartialBtn: Boolean;
        recInspectionSheet: Record 50022;
        reInspectionDataSheet: Record 50011;
        pgReason: Page 259;
        recReason: Record 231;
        COALog: Record 50018;
        tempCOALog: Record 50018;
        Version: Integer;
        filemanag: Codeunit 419;
        PostedInspection: Record 50022;
        HasIncomingDocument: Boolean;
}

