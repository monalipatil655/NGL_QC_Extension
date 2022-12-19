page 50054 "QA Review Data Sheet"
{
    // version PCPL/QC/V3/001,PCPL/BRB/003

    // s

    Caption = 'QA Review Data Sheet';
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = Document;
    PromotedActionCategories = 'New,Process,Report';
    RefreshOnActivate = true;
    SourceTable = 50020;
    SourceTableView = SORTING("No.")
                      ORDER(Ascending)
                      WHERE(Status = FILTER(Open | "Under Test"),
                            "QA Reviewed" = FILTER(False),
                            Approval = FILTER("Under Approval"));
    // ApplicationArea = All;
    // UsageCategory = Lists;

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
                    ApplicationArea = All;
                }


                field("Document No."; "Document No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Ref ID"; "Ref ID")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Posting Date"; "Posting Date")
                {
                    Editable = true;
                    ApplicationArea = All;
                }
                field(Quantity; Quantity)
                {
                    Editable = false;
                }
                field("Document Date"; "Document Date")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Unit of Messure"; "Unit of Messure")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Certificate No."; "Certificate No.")
                {
                    Editable = true;
                    ApplicationArea = All;
                }
                field("Lot No."; "Lot No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Item No."; "Item No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Item Description"; "Item Description")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Item Description 2"; "Item Description 2")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Prod. Packing Detail"; "Prod. Packing Detail")
                {
                }
                field("Before GRN"; "Before GRN")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Sample Drawn Quantity"; "Sample Drawn Quantity")
                {
                    DecimalPlaces = 0 : 3;
                    ApplicationArea = All;
                }
                field("Sample UOM"; "Sample UOM")
                {
                    ApplicationArea = All;
                }
                field("Location Code"; "Location Code")
                {
                    ApplicationArea = All;
                }
                field("Sample Drawn On"; "Sample Drawn On")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("No. Container Sample"; "No. Container Sample")
                {
                    ApplicationArea = All;
                }
                field("EXP Date"; "EXP Date")
                {
                    Editable = true;
                    ApplicationArea = All;
                }
                field("Mfg. Date"; "Mfg. Date")
                {
                    Editable = true;
                    ApplicationArea = All;
                }
                field("Retest on"; "Retest on")
                {
                    Editable = true;
                    ApplicationArea = All;
                }
                field("Analyzed on"; "Analyzed on")
                {
                }
                field("Approved By"; "Approved By")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Inspected By"; "Inspected By")
                {
                    ApplicationArea = All;
                }
                field("Item Tracking"; "Item Tracking")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Pending Inspection"; "Pending Inspection")
                {
                    ApplicationArea = All;
                }
            }
            part(InspectionLine; 50035)
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
                    ApplicationArea = All;
                }
                field("Vendor Name"; "Vendor Name")
                {
                    ApplicationArea = All;
                }
                field("Purch. Order Quantity"; "Purch. Order Quantity")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("GRN No."; "GRN No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("GRN Date"; "GRN Date")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("GRN Quantity"; "GRN Quantity")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
            group("Prod. Order")
            {
                Caption = 'Prod. Order';
                field("Prod. Order Date"; "Prod. Order Date")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Prod. Order Quantity"; "Prod. Order Quantity")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
            group("Transfer Order")
            {
                Caption = 'Transfer Order';
                field("Transfer Receipt No."; "Transfer Receipt No.")
                {
                    ApplicationArea = All;
                }
                field("Transfer Receipt Quantity"; "Transfer Receipt Quantity")
                {
                    ApplicationArea = All;
                }
                field("Transfer Receipt Date"; "Transfer Receipt Date")
                {
                    ApplicationArea = All;
                }
            }
            group(Return)
            {
                Caption = 'Return';
                field("Return Receipt No."; "Return Receipt No.")
                {
                    ApplicationArea = All;
                }
                field("Return Receipt Quantity"; "Return Receipt Quantity")
                {
                    ApplicationArea = All;
                }
                field("Return Receipt Date"; "Return Receipt Date")
                {
                    ApplicationArea = All;
                }
                field("Customer No."; "Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Customer Name"; "Customer Name")
                {
                    ApplicationArea = All;
                }
            }
            group(Retest)
            {
                Caption = 'Retest';
                field("Retest Document"; "Retest Document")
                {
                    ApplicationArea = All;
                }
                field("Retest from Doc No"; "Retest from Doc No")
                {
                    ApplicationArea = All;
                }
            }
            group(Quality)
            {
                Caption = 'Quality';
                field(Remarks; Remarks)
                {
                    ApplicationArea = All;
                }
                field(Approval; Approval)
                {
                    Editable = false;
                    ApplicationArea = All;
                    OptionCaption = '<WIP,Under Approval,Approved,Rejected>';
                }
                field(Status; Status)
                {
                    Editable = false;
                    ApplicationArea = All;
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
                action(Review)
                {
                    Caption = 'Review';
                    Image = Approval;
                    ApplicationArea = Suite;

                    trigger OnAction();
                    begin
                        IF CONFIRM(TEXT001, TRUE) THEN BEGIN
                            IF "Pending Inspection" <> 0 THEN
                                ERROR('You still have pending inspection to receive');
                            recInspectionSheet.RESET;
                            recInspectionSheet.SETRANGE(recInspectionSheet."No.", "No.");
                            IF recInspectionSheet.FINDFIRST THEN BEGIN
                                recInspectionSheet."QA Reviewed" := TRUE;
                                recInspectionSheet."Reviewed By" := USERID;
                                recInspectionSheet."Reviewed On" := WORKDATE;
                                recInspectionSheet.MODIFY;
                            END;
                        END;
                    end;
                }
                action("Send to QC for Retest")
                {
                    Caption = 'Send to QC for Retest';
                    Image = SendTo;
                    ApplicationArea = Suite;

                    trigger OnAction();
                    begin
                        IF CONFIRM(TEXT002, TRUE) THEN BEGIN
                            recInspectionLine.RESET;
                            recInspectionLine.SETRANGE(recInspectionLine."No.", "No.");
                            recInspectionLine.SETRANGE(recInspectionLine."Reject/Retest QC", TRUE);
                            IF recInspectionLine.FINDSET THEN BEGIN
                                tempReceiptLine.RESET;
                                tempReceiptLine.SETRANGE(tempReceiptLine."No.", "No.");
                                tempReceiptLine.SETRANGE(tempReceiptLine."Parent Group Code", recInspectionLine."Parent Group Code");
                                IF tempReceiptLine.FINDSET THEN BEGIN
                                    cduQltyMgmt.CreateInspectionForRejRetest(Rec, tempReceiptLine);
                                END;
                            END;
                        END;
                    end;
                }
            }
            group(Reports)
            {
                Caption = 'Report';
                action(Print)
                {
                    Caption = 'Print';
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = "Report";
                    ApplicationArea = Suite;

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
                    ApplicationArea = Suite;
                    trigger OnAction();
                    var
                        // TempBlob: Record 99008535;
                        TempBlob1: Codeunit "Temp Blob";
                        Ins: InStream;
                        OutS: OutStream;
                    begin
                        CALCFIELDS("File Attach");

                        IF NOT "File Attach".HASVALUE THEN
                            ERROR('file does not exist');

                        //TempBlob.Blob := "File Attach";
                        //<<PCPL/NSW/MIG 19July22
                        TempBlob1.CreateInStream(Ins);
                        "File Attach".CreateOutStream(OutS);
                        CopyStream(Outs, InS);
                        filemanag.BLOBExport(TempBlob1, Format('*' + Extension + ''), TRUE)
                        //>>PCPL/NSW/MIG 19July22

                        //filemanag.BLOBExport(TempBlob,FORMAT('*' + Extension + ''),TRUE); PCPL/NSW/MIG 19July22 Code Commented;
                        //
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        // "Inspected By":=USERID;  //PCPL/BRB/23-3-18
        CurrPage.UPDATE(FALSE);
    end;

    trigger OnOpenPage();
    begin

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
        //recQltySetup: Record 50007;
        recReservationEntry: Record 337;
        beforeGRN: Boolean;
        recItem: Record 27;
        NoSeriesMgmt: Codeunit 396;
        recInspectionSheet: Record 50020;
        cduQltyMgmt: Codeunit 50005;
        TEXT001: Label 'Do you want to change the status to Reviewed?';
        TEXT002: Label 'Do you want to send QC parameters for QC check?';
        recInspectionLine: Record 50021;
        tempReceiptLine: Record 50021;
        filemanag: Codeunit 419;
}

