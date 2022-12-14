page 50030 "Inspection Data Sheet"
{
    // version PCPL/QC/V3/001PCPL QC/03/BRB

    // //QC11 //PCPL QC/03/BRB  Comment to Complies and Send for Receipt action
    // 
    // expdatefunc...created By PCPL/24 Azhar..

    Caption = 'Inspection Sheet';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = 50011;
    SourceTableView = SORTING("No.")
                      ORDER(Ascending)
                      WHERE(Status = FILTER(Open | "Under Test"),
                            "QA Reviewed" = FILTER(false));

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
                    Caption = 'Purchase/Production Order No.';
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Document Date"; "Document Date")
                {
                    Caption = 'Purchase/Production Order Date';
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Ref ID"; "Ref ID")
                {
                    Editable = false;
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
                field("Unit of Messure"; "Unit of Messure")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field(Quantity; Quantity)
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Lot No."; "Lot No.")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Location Code"; "Location Code")
                {
                    ApplicationArea = all;
                }
                field("Mfg Date"; "Mfg. Date")
                {
                    Editable = true;
                    ApplicationArea = all;
                }
                field("EXP Date"; "EXP Date")
                {
                    Editable = true;
                    ApplicationArea = all;
                }
                field("External Lot No."; "External Lot No.")
                {
                    ApplicationArea = all;
                }
                field("Retest on"; "Retest on")
                {
                    ApplicationArea = all;
                }
                field("Sample UOM"; "Sample UOM")
                {
                    ApplicationArea = all;
                }
                field("Certificate No."; "Certificate No.")
                {
                    ApplicationArea = all;
                    Caption = 'AR No.';
                }
                field("Item Tracking"; "Item Tracking")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Before GRN"; "Before GRN")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Status; Status)
                {
                    ApplicationArea = all;
                    OptionCaption = 'Quarantine,Release,Under Test';
                }
                field("Sample Drawn Quantity"; "Sample Drawn Quantity")
                {
                    ApplicationArea = all;
                    DecimalPlaces = 0 : 3;
                }
                field("Sample Drawn On"; "Sample Drawn On")
                {
                    ApplicationArea = all;
                    Editable = true;

                    trigger OnValidate();
                    begin
                        IF "Sample Drawn On" <> WORKDATE THEN
                            ERROR('"Sample Drawn On" date should be workdate. ');
                    end;
                }
                field("Outer Package"; "Outer Package")
                {
                    ApplicationArea = all;
                }
                field("Inner Package"; "Inner Package")
                {
                    ApplicationArea = all;
                }
                field("No. Container Sample"; "No. Container Sample")
                {
                    ApplicationArea = all;
                }
                field("Prod. Packing Detail"; "Prod. Packing Detail")

                {
                    ApplicationArea = all;
                }
                field("Posting Date"; "Posting Date")
                {
                    Editable = true;
                    ApplicationArea = all;
                }
                field("Posted Sample Quanity"; "Posted Sample Quanity")
                {
                    DecimalPlaces = 0 : 3;
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
                field("Analyzed on"; "Analyzed on")
                {
                    ApplicationArea = all;
                }
            }
            part(InspectionLine; 50031)
            {
                SubPageLink = "No." = FIELD("No."),
                              "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("Document No.");
                SubPageView = SORTING("No.", "Line No.")
                              ORDER(Ascending);
                ApplicationArea = Suite;
            }
            group(GRN)
            {
                Caption = 'GRN';
                field("Vendor No."; "Vendor No.")
                {
                    ApplicationArea = all;
                }
                field("Vendor Name"; "Vendor Name")
                {
                    ApplicationArea = all;
                }
                field("Purch. Order Quantity"; "Purch. Order Quantity")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("GRN No."; "GRN No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("GRN Date"; "GRN Date")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("GRN Quantity"; "GRN Quantity")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
            }
            group("Prod. Order")
            {
                Caption = 'Prod. Order';
                field("Prod. Order Date"; "Prod. Order Date")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Prod. Order Quantity"; "Prod. Order Quantity")
                {
                    ApplicationArea = all;
                    Editable = false;
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
                    ApplicationArea = all;
                }
                field("Retest from Doc No"; "Retest from Doc No")
                {
                    ApplicationArea = all;
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
            }
        }
    }

    actions
    {
        area(processing)
        {
            //Caption = 'ACTION';
            group(Process)
            {
                Caption = 'Process';
                action("Sample Withdraw")
                {
                    Caption = 'Sample Withdraw';
                    Image = PickLines;
                    ApplicationArea = all;

                    trigger OnAction();
                    var
                        Itemrec: Record 27;
                    begin
                        IF CONFIRM(TEXT002, TRUE) THEN BEGIN
                            IF Itemrec.GET("Item No.") THEN   //PCPL QC/ 03/BRB
                                                              //   IF (Itemrec."Gen. Prod. Posting Group" <> 'PM') AND (Itemrec."Gen. Prod. Posting Group" <> 'CONS') THEN BEGIN//PCPL QC/ 03/BRB
                                CALCFIELDS("Posted Sample Quanity");
                            IF "Posted Sample Quanity" = 0 THEN BEGIN
                                recQltySetup.GET;
                                recQltySetup.TESTFIELD(recQltySetup."Sampling Location");
                                TESTFIELD("Sample Drawn Quantity");
                                cduQltyMgmt.CreateSampleEntry(Rec);
                            END ELSE BEGIN
                                recInspectionLine.RESET;
                                recInspectionLine.SETRANGE(recInspectionLine."No.", "No.");
                                recInspectionLine.SETRANGE("Document Type", "Document Type");
                                recInspectionLine.SETRANGE("Document No.", "Document No.");
                                recInspectionLine.SETRANGE(recInspectionLine."Reject/Retest QC", FALSE);
                                IF recInspectionLine.ISEMPTY THEN BEGIN
                                    recQltySetup.GET;
                                    recQltySetup.TESTFIELD(recQltySetup."Sampling Location");
                                    TESTFIELD("Sample Drawn Quantity");
                                    cduQltyMgmt.CreateSampleEntry(Rec);
                                END;
                            END;
                        END ELSE
                            ERROR('Sample cannot be withdrawn for CON and PM');
                    end;
                }
                action("Send for Approval")
                {
                    Caption = 'Send for Approval';
                    Image = Approval;
                    ApplicationArea = all;

                    trigger OnAction();
                    var
                        isSamplingDone: Boolean;
                        Itemrec: Record 27;

                    begin
                        TESTFIELD("Analyzed on");   //PCPL 38
                        IF CONFIRM(TEXT001, TRUE) THEN BEGIN
                            //IF Itemrec.GET("Item No.") THEN   //PCPL QC/ 03/BRB
                            //IF Itemrec."Gen. Prod. Posting Group" <> 'RM' THEN BEGIN//PCPL QC/ 03/BRB
                            CALCFIELDS("Posted Sample Quanity");
                            isSamplingDone := FALSE;
                            IF "Posted Sample Quanity" = 0 THEN BEGIN
                                recInspectionSheet.RESET;
                                recInspectionSheet.SETRANGE(recInspectionSheet."Item No.", "Item No.");
                                recInspectionSheet.SETRANGE(recInspectionSheet."Lot No.", "Lot No.");
                                recInspectionSheet.SETFILTER(recInspectionSheet."No.", '<>%1', "No.");
                                IF recInspectionSheet.FINDSET THEN
                                    REPEAT
                                        recInspectionSheet.CALCFIELDS("Posted Sample Quanity");
                                        IF recInspectionSheet."Posted Sample Quanity" > 0 THEN
                                            isSamplingDone := TRUE;
                                    UNTIL recInspectionSheet.NEXT = 0;
                                recInspectionSheetR.RESET;
                                recInspectionSheetR.SETRANGE(recInspectionSheetR."Item No.", "Item No.");
                                recInspectionSheetR.SETRANGE(recInspectionSheetR."Lot No.", "Lot No.");
                                IF recInspectionSheetR.FINDSET THEN
                                    REPEAT
                                        recInspectionSheetR.CALCFIELDS("Posted Sample Quanity");
                                        IF recInspectionSheetR."Posted Sample Quanity" > 0 THEN
                                            isSamplingDone := TRUE;
                                    UNTIL recInspectionSheetR.NEXT = 0
                            END ELSE
                                isSamplingDone := TRUE;
                            /*IF NOT isSamplingDone THEN
                              ERROR(TEXT003);*/ // Sandeep PCPL
                                                /*  //PCPL QC/03/BRB
                                                recInspectionLine.RESET;
                                                recInspectionLine.SETRANGE(recInspectionLine."No.","No.");
                                                recInspectionLine.SETRANGE(recInspectionLine."Account Type",recInspectionLine."Account Type"::Posting);
                                                recInspectionLine.SETRANGE(recInspectionLine.Complies,FALSE);  //QC11 //PCPL QC/03/BRB
                                                IF recInspectionLine.FINDFIRST THEN
                                                REPEAT
                                                  ERROR(TEXT004);
                                                UNTIL recInspectionLine.NEXT=0;
                                                *///PCPL QC/03/BRB
                            cduQltyMgmt.CreateReceiptEntry(Rec);
                            CurrPage.CLOSE;
                            //END ELSE
                            //ERROR('This is RM Item');
                        END;

                    end;
                }
                action("Send for Receipt")
                {
                    Image = Approval;
                    Visible = false;
                    ApplicationArea = all;

                    trigger OnAction();
                    var
                        Item: Record 27;
                        InspeDatareceipt: Record 50020;
                        inspectionreceiptLine: Record 50021;
                        isSamplingDone: Boolean;
                        InspectionLedger: Record 50014;
                        recInspectionSheetLine: Record 50012;
                        recInspectionReceipt: Record 50020;
                    begin
                        //PCPL QC/ 03/BRB
                        IF CONFIRM(TEXT001, TRUE) THEN BEGIN
                            IF Item.GET("Item No.") THEN
                                IF Item."Gen. Prod. Posting Group" <> 'RM' THEN
                                    ERROR('Gen. Prod. Posting Group is not RM');
                            CALCFIELDS("Posted Sample Quanity");
                            isSamplingDone := FALSE;
                            IF "Posted Sample Quanity" = 0 THEN BEGIN
                                recInspectionSheet.RESET;
                                recInspectionSheet.SETRANGE(recInspectionSheet."Item No.", "Item No.");
                                recInspectionSheet.SETRANGE(recInspectionSheet."Lot No.", "Lot No.");
                                recInspectionSheet.SETFILTER(recInspectionSheet."No.", '<>%1', "No.");
                                IF recInspectionSheet.FINDSET THEN
                                    REPEAT
                                        recInspectionSheet.CALCFIELDS("Posted Sample Quanity");
                                        IF recInspectionSheet."Posted Sample Quanity" > 0 THEN
                                            isSamplingDone := TRUE;
                                    UNTIL recInspectionSheet.NEXT = 0;
                                recInspectionSheetR.RESET;
                                recInspectionSheetR.SETRANGE(recInspectionSheetR."Item No.", "Item No.");
                                recInspectionSheetR.SETRANGE(recInspectionSheetR."Lot No.", "Lot No.");
                                IF recInspectionSheetR.FINDSET THEN
                                    REPEAT
                                        recInspectionSheetR.CALCFIELDS("Posted Sample Quanity");
                                        IF recInspectionSheetR."Posted Sample Quanity" > 0 THEN
                                            isSamplingDone := TRUE;
                                    UNTIL recInspectionSheetR.NEXT = 0

                            END ELSE
                                isSamplingDone := TRUE;
                            IF NOT isSamplingDone THEN
                                ERROR(TEXT003);
                            //PCPL QC/ 03/BRB
                            QCSetup.GET;
                            QCSetup.TESTFIELD("Inspection Receipt No. Series");
                            recInspectionReceipt.RESET;
                            recInspectionReceipt.SETRANGE(recInspectionReceipt."Item No.", "Item No.");
                            recInspectionReceipt.SETRANGE(recInspectionReceipt."Lot No.", "Lot No.");
                            recInspectionReceipt.SETRANGE(recInspectionReceipt."Certificate No.", "Certificate No.");
                            IF recInspectionReceipt.FINDFIRST THEN BEGIN
                                QualityManagementrec.CreateReceiptLine(Rec, recInspectionReceipt);
                                InspectionLedger.RESET;
                                InspectionLedger.SETRANGE(InspectionLedger."No.", "No.");
                                IF InspectionLedger.FINDFIRST THEN BEGIN
                                    InspectionLedger."Inspection Receipt No." := recInspectionReceipt."No.";
                                    InspectionLedger.MODIFY;
                                END;
                            END
                            ELSE BEGIN
                                InspeDatareceipt.INIT;
                                InspeDatareceipt.TRANSFERFIELDS(Rec);
                                InspeDatareceipt."No." := NoSeriesMgmt.GetNextNo(QCSetup."Inspection Receipt No. Series", WORKDATE, TRUE);
                                InspeDatareceipt."Inspected By" := USERID;
                                InspeDatareceipt."Analyzed on" := WORKDATE;
                                InspeDatareceipt."QA Reviewed" := TRUE;
                                InspeDatareceipt.Approval := InspeDatareceipt.Approval::"Under Approval";
                                InspeDatareceipt."Inspection Sheet No." := "No.";
                                QualityManagementrec.CreateReceiptLine(Rec, InspeDatareceipt);
                                QualityManagementrec.CreateReceiptLedger(InspeDatareceipt);
                                InspectionLedger.RESET;
                                InspectionLedger.SETRANGE(InspectionLedger."No.", "No.");
                                IF InspectionLedger.FINDFIRST THEN BEGIN
                                    InspectionLedger."Inspection Receipt No." := InspeDatareceipt."No.";
                                    InspectionLedger.MODIFY;
                                END;
                                InspeDatareceipt.INSERT;
                            END;

                            recInspectionSheetLine.RESET;
                            recInspectionSheetLine.SETRANGE(recInspectionSheetLine."No.", "No.");
                            IF recInspectionSheetLine.FINDSET THEN
                                recInspectionSheetLine.DELETEALL;
                            DELETE;
                            // cduQltyMgmt.CreateReceiptEntry(Rec);
                            CurrPage.CLOSE;
                            //END;
                        END;
                        //PCPL QC/ 03/BRB
                    end;
                }
            }
            group(Report)
            {
                Caption = 'Report';
                action(Print)
                {
                    Caption = 'Print';
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = "Report";
                    ApplicationArea = all;

                    trigger OnAction();
                    begin
                        recInspectionSheet.RESET;
                        recInspectionSheet.SETRANGE(recInspectionSheet."No.", "No.");
                        IF recInspectionSheet.FINDFIRST THEN
                            REPORT.RUNMODAL(50301, TRUE, FALSE, recInspectionSheet);
                    end;
                }
                action("Intermediate Intimation Slip")
                {
                    Image = Print;
                    RunObject = Report 50028;
                }
                action("Finished Product Intimation Slip")
                {
                    Caption = 'Finished Product Intimation Slip';
                    RunObject = Report 50014;
                    ApplicationArea = all;
                }
                action("File Attach")
                {
                    Image = Import;
                    ApplicationArea = all;

                    trigger OnAction();
                    var
                        //TempBlob: Record 99008535;
                        Txt002: Label 'Import Attachment.';
                        Txt005: Label 'Attachment File ''''%1'''' imported successfully.';
                        Tempblob1: Codeunit "Temp Blob";
                        InS: InStream;
                        OutS: OutStream;

                    begin
                        //Filetext := FileManagement.OpenFileDialog('Nav file','','');
                        //Rec."File Attach".IMPORT('',TRUE);
                        CALCFIELDS("File Attach");

                        IF "File Attach".HASVALUE THEN
                            ERROR('file is already exist');
                        filtetext := filemanag.BLOBImportWithFilter(TempBlob1, Txt002, '', '*.*|', '*.*'); //PCPL/NSW/MIG 19July22 TempBlob1 Added

                        IF filtetext = '' THEN
                            EXIT;
                        //<<PCPL/NSW/MIG 19July22
                        Tempblob1.CreateInStream(Ins);
                        "File Attach".CreateOutStream(OutS);
                        CopyStream(OutS, InS);
                        //>>PCPL/NSW/MIG 19July22
                        // "File Attach" := TempBlob.Blob;

                        Extension := '.' + filemanag.GetExtension(filtetext);
                        //INSERT;
                        MODIFY;

                        IF "File Attach".HASVALUE THEN
                            MESSAGE(Txt005, filtetext);
                    end;
                }
                action("File Export")
                {
                    ApplicationArea = all;
                    trigger OnAction();
                    var
                        //TempBlob: Record 99008535;
                        TempBlob1: Codeunit "Temp Blob";
                        Ins: InStream;
                        OutS: OutStream;
                    begin
                        CALCFIELDS("File Attach");

                        IF NOT "File Attach".HASVALUE THEN
                            ERROR('file does not exist');

                        //TempBlob.Blob := "File Attach";
                        TempBlob1.CreateInStream(Ins);
                        "File Attach".CreateOutStream(OutS);
                        CopyStream(OutS, Ins);
                        filemanag.BLOBExport(TempBlob1, FORMAT('*' + Extension + ''), TRUE);
                    end;
                }
                action(Update)
                {
                    //Image = Update;
                    ApplicationArea = all;

                    trigger OnAction();
                    var
                        // TempBlob: Record 99008535;
                        Tempblob1: Codeunit "Temp Blob";
                        Ins: InStream;
                        OutS: OutStream;
                    begin
                        CALCFIELDS("File Attach");
                        IF NOT CONFIRM(txt001) THEN
                            EXIT;
                        filtetext := filemanag.BLOBImportWithFilter(Tempblob1, Txt002, '', '*.*|', '*.*');

                        IF filtetext = '' THEN
                            EXIT;

                        //"File Attach" := TempBlob.Blob;
                        Tempblob1.CreateInStream(Ins);
                        "File Attach".CreateOutStream(outs);
                        CopyStream(OutS, Ins);

                        Extension := '.' + filemanag.GetExtension(filtetext);

                        MODIFY;

                        IF "File Attach".HASVALUE THEN
                            MESSAGE(Txt005, filtetext);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        ApprovalEdit := ApprovalControl;
        "Inspected By" := USERID;
        CurrPage.UPDATE(FALSE);
        expdatefunc;
    end;

    trigger OnNextRecord(Steps: Integer): Integer;
    begin
        ApprovalEdit := ApprovalControl;
    end;

    trigger OnOpenPage();
    begin

        ApprovalEdit := ApprovalControl;

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
        recInspectionSheet: Record 50011;
        cduQltyMgmt: Codeunit 50005;
        TEXT001: Label 'Do you want to send for approval';
        TEXT002: Label 'Do you want to Withdraw the mentioned Sample Quantity for testing?';
        Rec_InsDataSheet: Record 50011;
        RecSpeciLine: Record 50016;
        RecSpecificationHeader: Record 50015;
        vEntryNo: Integer;
        recReason: Record 231;
        pgReason: Page 259;
        TEXT003: Label 'Sampling to be withdrawn';
        TEXT004: Label 'All the QC value to be updated properly for this Inspection';
        recInspectionSheetR: Record 50020;
        HasIncomingDocument: Boolean;
        LotInfo: Record 6505;
        QCSetup: Record 50010;
        QualityManagementrec: Codeunit 50005;
        InspectionSheetLine: Record 50012;
        reInspectionDataSheet: Record 50011;
        filemanag: Codeunit 419;
        txt001: Label 'Do you want to overwrite existing Attachment ?';
        filtetext: Text;
        Txt005: Label 'Attachment File ''''%1'''' imported successfully.';
        Txt002: Label 'Import Attachment.';
        expdatevar: Record 336;

    procedure ApprovalControl() editApp: Boolean;
    var
        recUserSetup: Record 91;
    begin
        IF recUserSetup.GET(USERID) THEN BEGIN
            recUserSetup.TESTFIELD(recUserSetup."QC Approver");
            IF recUserSetup."User ID" <> recUserSetup."QC Approver" THEN
                EXIT(FALSE)
            ELSE
                EXIT(TRUE);
        END
        ELSE
            ERROR('You are not authorised to do inspection,please contact administrator');
    end;

    procedure UpdateAttachment();
    var
        //TempBlob: Record 99008535;
        Txt002: Label 'Import Attachment.';
        Tempblob1: Codeunit "Temp Blob";
        Ins: InStream;
        OutS: OutStream;
    begin
        CALCFIELDS("File Attach");
        IF NOT CONFIRM(txt001) THEN
            EXIT;

        filtetext := filemanag.BLOBImportWithFilter(TempBlob1, Txt002, '', '*.*|', '*.*');

        IF filtetext = '' THEN
            EXIT;

        Tempblob1.CreateInStream(Ins);
        "File Attach".CreateOutStream(outs);
        CopyStream(OutS, Ins);
        //"File Attach" := TempBlob.Blob;
        Extension := '.' + filemanag.GetExtension(filtetext);

        MODIFY;

        IF "File Attach".HASVALUE THEN
            MESSAGE(Txt005, filtetext);
    end;

    procedure RecordExist();
    begin
    end;

    procedure expdatefunc();
    begin
        //created By PCPL/24...Azhar
        /*
        expdatevar.RESET;
        expdatevar.SETRANGE(expdatevar."Lot No.","Lot No.");
        IF expdatevar.FINDFIRST THEN
        BEGIN
            "EXP Date" := expdatevar."Expiration Date";
        
        END
        */

    end;
}

