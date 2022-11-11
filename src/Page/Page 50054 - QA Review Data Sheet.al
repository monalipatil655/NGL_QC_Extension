page 50054 "QA Review Data Sheet"
{
    // version PCPL/QC/V3/001,PCPL/BRB/003

    // s

    Caption = 'Inspection Sheet';
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = false;
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = 50020;
    SourceTableView = SORTING("No.")
                      ORDER(Ascending)
                      WHERE(Status = FILTER(Open | "Under Test"),
                            "QA Reviewed" = FILTER(False),
                            Approval = FILTER("Under Approval"));

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
                }
                field("Document No."; "Document No.")
                {
                    Editable = false;
                }
                field("Ref ID"; "Ref ID")
                {
                    Editable = false;
                }
                field("Posting Date"; "Posting Date")
                {
                    Editable = true;
                }
                field(Quantity; Quantity)
                {
                    Editable = false;
                }
                field("Document Date"; "Document Date")
                {
                    Editable = false;
                }
                field("Unit of Messure"; "Unit of Messure")
                {
                    Editable = false;
                }
                field("Certificate No."; "Certificate No.")
                {
                    Editable = true;
                }
                field("Lot No."; "Lot No.")
                {
                    Editable = false;
                }
                field("Item No."; "Item No.")
                {
                    Editable = false;
                }
                field("Item Description"; "Item Description")
                {
                    Editable = false;
                }
                field("Item Description 2"; "Item Description 2")
                {
                    Editable = false;
                }
                field("Prod. Packing Detail"; "Prod. Packing Detail")
                {
                }
                field("Before GRN"; "Before GRN")
                {
                    Editable = false;
                }
                field("Sample Drawn Quantity"; "Sample Drawn Quantity")
                {
                    DecimalPlaces = 0 : 3;
                }
                field("Sample UOM"; "Sample UOM")
                {
                }
                field("Location Code"; "Location Code")
                {
                }
                field("Sample Drawn On"; "Sample Drawn On")
                {
                    Editable = false;
                }
                field("No. Container Sample"; "No. Container Sample")
                {
                }
                field("EXP Date"; "EXP Date")
                {
                    Editable = true;
                }
                field("Mfg. Date"; "Mfg. Date")
                {
                    Editable = true;
                }
                field("Retest on"; "Retest on")
                {
                    Editable = true;
                }
                field("Analyzed on"; "Analyzed on")
                {
                }
                field("Approved By"; "Approved By")
                {
                    Editable = false;
                }
                field("Inspected By"; "Inspected By")
                {
                }
                field("Item Tracking"; "Item Tracking")
                {
                    Editable = false;
                }
                field("Pending Inspection"; "Pending Inspection")
                {
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
            group(GRN)
            {
                Caption = 'GRN';
                field("Vendor No."; "Vendor No.")
                {
                }
                field("Vendor Name"; "Vendor Name")
                {
                }
                field("Purch. Order Quantity"; "Purch. Order Quantity")
                {
                    Editable = false;
                }
                field("GRN No."; "GRN No.")
                {
                    Editable = false;
                }
                field("GRN Date"; "GRN Date")
                {
                    Editable = false;
                }
                field("GRN Quantity"; "GRN Quantity")
                {
                    Editable = false;
                }
            }
            group("Prod. Order")
            {
                Caption = 'Prod. Order';
                field("Prod. Order Date"; "Prod. Order Date")
                {
                    Editable = false;
                }
                field("Prod. Order Quantity"; "Prod. Order Quantity")
                {
                    Editable = false;
                }
            }
            group("Transfer Order")
            {
                Caption = 'Transfer Order';
                field("Transfer Receipt No."; "Transfer Receipt No.")
                {
                }
                field("Transfer Receipt Quantity"; "Transfer Receipt Quantity")
                {
                }
                field("Transfer Receipt Date"; "Transfer Receipt Date")
                {
                }
            }
            group(Return)
            {
                Caption = 'Return';
                field("Return Receipt No."; "Return Receipt No.")
                {
                }
                field("Return Receipt Quantity"; "Return Receipt Quantity")
                {
                }
                field("Return Receipt Date"; "Return Receipt Date")
                {
                }
                field("Customer No."; "Customer No.")
                {
                }
                field("Customer Name"; "Customer Name")
                {
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
                }
                field(Approval; Approval)
                {
                    Editable = false;
                    OptionCaption = '<WIP,Under Approval,Approved,Rejected>';
                }
                field(Status; Status)
                {
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
                action(Review)
                {
                    Caption = 'Review';
                    Image = Approval;

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

