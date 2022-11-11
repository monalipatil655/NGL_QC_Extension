page 50036 "Item Inspection Retest"
{
    // version PCPL/QC/V3/001

    InsertAllowed = false;
    PageType = List;
    SourceTable = 50013;
    ApplicationArea=all;
    UsageCategory=Lists;

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
                field("Item No."; "Item No.")
                {
                    ApplicationArea = all;
                }
                field("Bin Code"; "Bin Code")
                {
                    ApplicationArea = all;
                }
                field("Location Code"; "Location Code")
                {
                    ApplicationArea = all;
                }
                field("Retest Date"; "Retest Date")
                {
                    ApplicationArea = all;
                }
                field("Lot No."; "Lot No.")
                {
                    ApplicationArea = all;
                }
                field("AR No."; "AR No.")
                {
                    ApplicationArea = all;
                }
                field("Send for Retest"; "Send for Retest")
                {
                    ApplicationArea = all;
                }
                field("Item Description"; "Item Description")
                {
                    ApplicationArea = all;
                }
                field("Mfg.Date"; "Mfg.Date")
                {
                    ApplicationArea = all;
                }
                field("Exp.Date"; "Exp.Date")
                {
                    ApplicationArea = all;
                }
                field("Remaining Quantity"; "Remaining Quantity")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Retest)
            {
                action("Plan for Retest")
                {
                    Image = TestReport;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Report 50042;
                    ApplicationArea = all;

                    trigger OnAction();
                    var
                    // CalculateRetestInspection: Report 50049;
                    begin
                        CurrPage.UPDATE;
                    end;
                }
            }
            group(Process)
            {
                action("Create Inspection")
                {
                    Image = Route;
                    Promoted = true;
                    PromotedCategory = Process;
                    ApplicationArea = all;

                    trigger OnAction();
                    begin
                        IF CONFIRM('Do you want to confirm the following documents for Retest', TRUE) THEN BEGIN
                            itemRetest.RESET;
                            itemRetest.SETRANGE(itemRetest."Send for Retest", TRUE);
                            IF itemRetest.FINDSET THEN
                                REPEAT
                                    postedInspection.RESET;
                                    postedInspection.SETRANGE(postedInspection."No.", itemRetest."No.");
                                    IF postedInspection.FINDFIRST THEN BEGIN
                                        cduQltyMgmt.CreateInspectionForRetest(postedInspection, itemRetest);
                                        itemRetest.DELETE;
                                    END;
                                UNTIL itemRetest.NEXT = 0;
                        END;
                    end;
                }
            }
            group(Availability)
            {
                action("Bin Content")
                {
                    Image = BinContent;
                    RunObject = Page 7305;
                    RunPageLink = "Location Code" = FIELD("Location Code"),
                                  "Item No." = FIELD("Item No.");
                    RunPageView = SORTING("Location Code", "Item No.", "Variant Code", "Warehouse Class Code", Fixed, "Bin Ranking")
                                  ORDER(Ascending);
                }
            }
        }
    }

    var
        cduQltyMgmt: Codeunit 50005;
        postedInspection: Record 50022;
        itemRetest: Record 50013;
}

