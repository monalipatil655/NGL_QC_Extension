page 50053 "Review Sheet"
{
    // version PCPL/QC/V3/001

    CardPageID = "QA Review Data Sheet";
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = List;
    SourceTable = 50020;
    SourceTableView = SORTING("No.")
                      WHERE(Status = FILTER(Open | "Under Test"),
                            Approval = FILTER("Under Approval"),
                            "QA Reviewed" = FILTER(False));

    ApplicationArea = all;
    UsageCategory = Lists;

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
                    Caption = 'AR No.';
                    ApplicationArea = all;
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
                    ApplicationArea = all;
                }
                field("Inspected By"; "Inspected By")
                {
                    ApplicationArea = all;
                }
                field("Pending Inspection"; "Pending Inspection")
                {
                    ApplicationArea = all;
                }
                field("Approved By"; "Approved By")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Report)
            {
                Caption = 'Report';
                action("File Export")
                {

                    trigger OnAction();
                    begin
                        /*
                        //created Action button File Export.....PCPL/AZHAR
                        
                        //CALCFIELDS("File Attach");
                        
                        IF NOT "File Attach".HASVALUE THEN
                          ERROR('file does not exist');
                        
                        TempBlob.Blob := "File Attach";
                        filemanag.BLOBExport(TempBlob,FORMAT('*' + Extension + ''),TRUE);
                        */

                    end;
                }
            }
        }
    }

    trigger OnFindRecord(Which: Text): Boolean;
    begin
        EXIT(FindFirstAllowedRec(Which));
    end;

    trigger OnNextRecord(Steps: Integer): Integer;
    begin
        EXIT(FindNextAllowedRec(Steps));
    end;

    trigger OnOpenPage();
    begin
        ErrorIfUserIsNotWhseEmployee;
    end;

    var
        "FileAttach var": Record 50011;
}

