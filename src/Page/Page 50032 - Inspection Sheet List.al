page 50032 "Inspection Sheet List"
{
    // version PCPL/QC/V3/001

    CardPageID = "Inspection Data Sheet";
    Editable = false;
    PageType = List;
    SourceTable = 50011;
    SourceTableView = SORTING("No.")
                      WHERE(Status = FILTER(Open | "Under Test"),
                            Approval = FILTER(WIP),
                            "QA Reviewed" = FILTER(false));
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
                field("Approved By"; "Approved By")
                {
                    ApplicationArea = all;
                }
                field("Location Code"; "Location Code")
                {
                    ApplicationArea = all;
                    Editable = true;
                }
            }
        }
    }

    actions
    {
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
        FILTERGROUP(1);
        IF UserSetup.GET(USERID) THEN;
        IF UserSetup."Location Code" <> '' THEN
            SETFILTER("Location Code", UserSetup."Location Code");
        FILTERGROUP(0);
    end;

    var
        UserSetup: Record 91;
}

