pageextension 50104 "Released Prod Ord Line Sub_EXt" extends "Released Prod. Order Lines" //OriginalId
{
    layout
    {
        addafter("Location Code")
        {
            field("Qty Accepted"; "Qty Accepted")
            {
                ApplicationArea = All;
            }
            field("Qty in Quality"; "Qty in Quality")
            {
                ApplicationArea = All;
            }
            field("Qty Send to Quality"; "Qty Send to Quality")
            {
                ApplicationArea = All;
            }
            field("Qty Rejected"; "Qty Rejected")
            {
                ApplicationArea = All;
            }
            field("Quality Check"; "Quality Check")
            {
                ApplicationArea = All;
            }
            field("Specification Type"; "Specification Type")
            {
                ApplicationArea = All;
            }

        }
    }

    actions
    {
    }
}