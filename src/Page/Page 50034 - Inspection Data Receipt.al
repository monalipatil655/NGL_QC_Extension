
page 50034 "Inspection Data Receipt"
{
    // version PCPL/QC/V3/001,PCPL/CUST/QC/IRL/002

    Caption = 'Inspection Data Receipt';
    DeleteAllowed = true;
    InsertAllowed = false;
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = 50020;
    SourceTableView = SORTING("No.")
                      ORDER(Ascending)
                      WHERE(Approval = FILTER("Under Approval"),
                            Status = FILTER(Open | "Under Test"),
                            "QA Reviewed" = FILTER(true));
    ApplicationArea = all;
    UsageCategory = Lists;

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
                    Editable = true;
                    ApplicationArea = all;
                }
                field(Quantity; Quantity)
                {
                    DecimalPlaces = 0 : 5;
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
                    Caption = 'AR No.';
                    Editable = true;
                    ApplicationArea = all;
                }
                field("Lot No."; "Lot No.")
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
                field("Prod. Packing Detail"; "Prod. Packing Detail")
                {
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
                field("Sample Drawn On"; "Sample Drawn On")
                {
                    ApplicationArea = all;
                }
                field("Mfg. Date"; "Mfg. Date")
                {
                    ApplicationArea = all;
                }
                field("EXP Date"; "EXP Date")
                {
                    ApplicationArea = all;
                }
                field("Analyzed on"; "Analyzed on")
                {
                    ApplicationArea = all;
                }
                field("Retest on"; "Retest on")
                {
                    Editable = true;
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
                field("Pending Inspection"; "Pending Inspection")
                {
                    ApplicationArea = all;
                }
                field("Posted Sample Quanity"; "Posted Sample Quanity")
                {
                    DecimalPlaces = 0 : 5;
                    ApplicationArea = all;
                }
            }
            part(InspectionLine; 50035)
            {
                SubPageLink = "No." = FIELD("No."),
                              "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("Document No.");
                SubPageView = SORTING("No.", "Line No.")
                              ORDER(Ascending);
            }
            group(Approval1)
            {
                Caption = 'Approval';
                field("Approved Quantity"; "Approved Quantity")
                {
                    DecimalPlaces = 0 : 5;

                    trigger OnValidate();
                    begin
                        //  "Approved Quantity" := Quantity - "Sample Drawn Quantity";
                    end;
                }
                field("Rejected Quantity"; "Rejected Quantity")
                {

                    trigger OnValidate();
                    begin

                        IF "Rejected Quantity" <> "Approved Quantity" THEN   //PCPL 0028 ADDED PARTIAL REJECTION 240118
                            ERROR('Partial Rejected Quantity Not Allowed..!!!!'); //PCPL 0028 ADDED PARTIAL REJECTION 240118


                        ApprovedQty := "Approved Quantity";

                        IF "Rejected Quantity" > ApprovedQty THEN ERROR('Rejected Quantity should not be greater than' + ' "' + FORMAT("GRN Quantity" - "Sample Drawn Quantity") + '"');

                        IF xRec."Rejected Quantity" <> 0 THEN
                            "Approved Quantity" := (ApprovedQty + xRec."Rejected Quantity") - "Rejected Quantity"
                        ELSE
                            "Approved Quantity" := ApprovedQty - "Rejected Quantity";


                        CLEAR(ApprovedQty);
                        CurrPage.UPDATE(TRUE);
                    end;
                }
                field("Control Sample Quantity"; "Control Sample Quantity")
                {
                    Visible = false;
                }
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
                field(Approval; Approval)
                {
                    ApplicationArea = all;
                    Editable = false;
                    OptionCaption = '<WIP,Under Approval,Approved,Rejected>';
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
            //Caption = 'ACTION';
            group(Process)
            {
                Caption = 'Process';
                action("Partial Approve")
                {
                    Image = Alerts;
                    Visible = false;
                    ApplicationArea = all;

                    trigger OnAction();
                    begin
                        Line := 0;
                        recQltySetup.GET;
                        IF NOT ApprovalControl THEN
                            ERROR(TEXT002);

                        CALCFIELDS("Pending Inspection");
                        IF "Pending Inspection" <> 0 THEN
                            ERROR(TEXT003);
                        TESTFIELD("Sample Drawn Quantity");
                        TESTFIELD("Sample Drawn On");

                        IF CONFIRM('Do You want to Approve the Document', TRUE) THEN BEGIN
                            recInspectionLine.RESET;
                            recInspectionLine.SETRANGE(recInspectionLine."No.", "No.");
                            recInspectionLine.SETRANGE(recInspectionLine."Account Type", recInspectionLine."Account Type"::Posting);
                            recInspectionLine.SETRANGE(recInspectionLine.Qualitative, FALSE);
                            recInspectionLine.SETRANGE(recInspectionLine."Test Mandatory", TRUE);
                            IF recInspectionLine.FINDFIRST THEN
                                REPEAT
                                    IF (recInspectionLine."Min. Value" <> 0) AND (recInspectionLine."Max. Value" <> 0) THEN
                                        IF recInspectionLine."Actual Value" = 0 THEN
                                            ERROR(TEXT004, recInspectionLine);
                                UNTIL recInspectionLine.NEXT = 0;
                            //Inserting into Ledger
                            recItem.GET("Item No.");
                            Status := Status::Release;
                            Approval := Approval::"Partially Approved";
                            // "Retest on":=CALCDATE(recItem."Retain Sample Quantity","Posting Date");
                            "Approved By" := USERID;
                            cduQltyMgmt.CreatePostedEntry(Rec);
                            MESSAGE(TEXT005);
                            CurrPage.CLOSE;
                        END;
                    end;
                }
                action(Post)
                {
                    Caption = 'Post';
                    Enabled = ApprovalEdit;
                    Image = Post;
                    ApplicationArea = all;

                    trigger OnAction();
                    begin
                        Line := 0;
                        recQltySetup.GET;

                        IF NOT ApprovalControl THEN
                            ERROR(TEXT002);
                        IF recQltySetup."Split Inspection Group Wise" THEN BEGIN
                            CALCFIELDS("Pending Inspection");
                            IF "Pending Inspection" <> 0 THEN
                                ERROR(TEXT003);
                        END;


                        //>>PCPL/CUST/QC/IRL/002
                        CALCFIELDS("Posted Sample Quanity");
                        IF ("Approved Quantity" + "Rejected Quantity" + "Control Sample Quantity" + "Posted Sample Quanity" <> Quantity) THEN
                            ERROR(TEXT006);
                        //<<PCPL/CUST/QC/IRL/002

                        //PCPL-25
                        IF "Posting Date" <> WORKDATE THEN BEGIN
                            IF CONFIRM(TEXT007, TRUE, "Posting Date", WORKDATE) THEN BEGIN
                                VALIDATE("Posting Date", WORKDATE);
                                VALIDATE("Document Date", WORKDATE);
                                MODIFY(TRUE);
                            END;
                        END;
                        IF (AllowPostingFrom = 0D) AND (AllowPostingTo = 0D) THEN BEGIN
                            GLSetup.GET;
                            IF USERID <> '' THEN
                                IF UserSetup.GET(USERID) THEN BEGIN
                                    AllowPostingFrom := UserSetup."Allow Posting From";
                                    AllowPostingTo := UserSetup."Allow Posting To";
                                END;
                            IF (AllowPostingFrom = 0D) AND (AllowPostingTo = 0D) THEN BEGIN
                                AllowPostingFrom := GLSetup."Allow Posting From";
                                AllowPostingTo := GLSetup."Allow Posting To";
                            END;
                            IF AllowPostingTo = 0D THEN
                                AllowPostingTo := 99991231D;
                        END;
                        IF ("Posting Date" < AllowPostingFrom) OR ("Posting Date" > AllowPostingTo) THEN
                            FIELDERROR("Posting Date", TEXT008);
                        //PCPL-25

                        IF CONFIRM(TEXT001, TRUE) THEN BEGIN
                            recInspectionLine.RESET;
                            recInspectionLine.SETRANGE(recInspectionLine."No.", "No.");
                            recInspectionLine.SETRANGE(recInspectionLine."Account Type", recInspectionLine."Account Type"::Posting);
                            recInspectionLine.SETRANGE(recInspectionLine.Qualitative, FALSE);
                            recInspectionLine.SETRANGE(recInspectionLine."Test Mandatory", TRUE);
                            IF recInspectionLine.FINDFIRST THEN
                                REPEAT
                                    IF (recInspectionLine."Min. Value" <> 0) AND (recInspectionLine."Max. Value" <> 0) THEN
                                        IF recInspectionLine."Actual Value" = 0 THEN
                                            ERROR(TEXT004, recInspectionLine);
                                UNTIL recInspectionLine.NEXT = 0;
                            //Inserting into Ledger
                            recItem.GET("Item No.");
                            cduQltyMgmt.UpdateQlyStatus(Rec);
                            cduQltyMgmt.CreatePostedEntry(Rec);
                            MESSAGE(TEXT005);
                            CurrPage.CLOSE;
                        END;
                    end;
                }
                action("Post with Conditional Release")
                {
                    Caption = 'Post with Conditional Release';
                    Enabled = ApprovalEdit;
                    Image = Post;
                    ApplicationArea = all;

                    trigger OnAction();
                    begin
                        Line := 0;
                        recQltySetup.GET;

                        IF NOT ApprovalControl THEN
                            ERROR(TEXT002);
                        IF recQltySetup."Split Inspection Group Wise" THEN BEGIN
                            CALCFIELDS("Pending Inspection");
                            IF "Pending Inspection" <> 0 THEN
                                ERROR(TEXT003);
                        END;
                        TESTFIELD("Sample Drawn Quantity");
                        TESTFIELD("Sample Drawn On");


                        IF CONFIRM(TEXT001, TRUE) THEN BEGIN
                            recInspectionLine.RESET;
                            recInspectionLine.SETRANGE(recInspectionLine."No.", "No.");
                            recInspectionLine.SETRANGE(recInspectionLine."Account Type", recInspectionLine."Account Type"::Posting);
                            recInspectionLine.SETRANGE(recInspectionLine.Qualitative, FALSE);
                            recInspectionLine.SETRANGE(recInspectionLine."Test Mandatory", TRUE);
                            IF recInspectionLine.FINDFIRST THEN
                                REPEAT
                                    IF (recInspectionLine."Min. Value" <> 0) AND (recInspectionLine."Max. Value" <> 0) THEN
                                        IF recInspectionLine."Actual Value" = 0 THEN
                                            ERROR(TEXT004, recInspectionLine);
                                UNTIL recInspectionLine.NEXT = 0;
                            //Inserting into Ledger
                            recItem.GET("Item No.");
                            cduQltyMgmt.UpdateQlyStatus(Rec);
                            cduQltyMgmt.CreatePostedEntry(Rec);
                            MESSAGE(TEXT005);
                            CurrPage.CLOSE;
                        END;
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
                            REPORT.RUNMODAL(50113, TRUE, FALSE, recInspectionSheet);
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

                        TempBlob1.CreateInStream(Ins);
                        "File Attach".CreateOutStream(OutS);
                        CopyStream(OutS, Ins);

                        //TempBlob.Blob := "File Attach";
                        filemanag.BLOBExport(TempBlob1, FORMAT('*' + Extension + ''), TRUE);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        ApprovalEdit := ApprovalControl;
        //"Inspected By":=USERID; //PCPL/BRB/23-03-18
        CurrPage.UPDATE(FALSE);
    end;

    trigger OnNextRecord(Steps: Integer): Integer;
    begin
        ApprovalEdit := ApprovalControl;
    end;

    trigger OnOpenPage();
    begin
        ApprovalEdit := ApprovalControl;
        "GRN Quantity" := Quantity;
        //"Approved Quantity" := "GRN Quantity" - "Sample Drawn Quantity" - "Rejected Quantity";
        CALCFIELDS("Posted Sample Quanity");///
        "Approved Quantity" := "GRN Quantity" - "Posted Sample Quanity" - "Rejected Quantity";    //PCPL-BRB-20211220
        CurrPage.UPDATE(TRUE);

        IF ("Document Type" = "Document Type"::"Purch. Order") AND ("Before GRN") THEN
            beforeGRN := TRUE
        ELSE
            beforeGRN := FALSE
    end;

    var
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
        TEXT000: Label 'You are not authorised to do inspection,please contact administrator';
        TEXT001: Label 'Do You want to Post the Document';
        TEXT002: Label 'You are not authorized for the action';
        TEXT003: Label 'You still have pending inspection to receive';
        TEXT004: Label 'All the QC Value to be updated properly %1';
        TEXT005: Label 'Document successfully posted';
        TEXT006: Label 'Please check total qty';
        ApprovedQty: Decimal;
        filemanag: Codeunit 419;
        TEXT007: Label 'Do you want to Change Posting Date %1 to Work Date %2?';
        TEXT008: Label 'is not within your range of allowed posting dates';
        GLSetup: Record 98;
        UserSetup: Record 91;
        AllowPostingTo: Date;
        AllowPostingFrom: Date;

    procedure ApprovalControl() editApp: Boolean;
    var
        recUserSetup: Record 91;
    begin
        IF recUserSetup.GET(USERID) THEN BEGIN
            IF recUserSetup."User ID" <> recUserSetup."QC Approver" THEN
                EXIT(FALSE)
            ELSE
                EXIT(TRUE);
        END
        ELSE
            ERROR(TEXT000);
    end;
}

