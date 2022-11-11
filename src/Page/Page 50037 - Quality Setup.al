page 50037 "Quality Setup"
{
    // version PCPL/QC/V3/001

    Caption = 'Quality Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = 50010;
    ApplicationArea = all;
    UsageCategory = History;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Approved/Reject Qty Manual"; "Approved/Reject Qty Manual")
                {
                    ApplicationArea = all;
                }
                field("Sampling Cost to be Loaded"; "Sampling Cost to be Loaded")
                {
                    ApplicationArea = all;
                    Caption = 'Sampling Cost to be Loaded on GRN/Output/FG';
                }
                field("Sampl. Trnsf. Batch"; "Sampl. Trnsf. Batch")
                {
                    ApplicationArea = all;
                }
                field("Split Inspection Group Wise"; "Split Inspection Group Wise")
                {
                    ApplicationArea = all;
                }
                field("Sampling Location"; "Sampling Location")
                {
                    Caption = 'Control Sampling Location';
                    ApplicationArea = all;
                }
                field("Whse. Item Batch"; "Whse. Item Batch")
                {
                    ApplicationArea = all;
                }
                field("Item Journal Batch"; "Item Journal Batch")
                {
                    ApplicationArea = all;
                }
                field("Sampling Reason Code"; "Sampling Reason Code")
                {
                    ApplicationArea = all;
                    
                }
                field("Resons Dimension"; "Resons Dimension")
                {
                    ApplicationArea = all;
                }
            }
            group(Numbering)
            {
                field("QC Measure No. Series"; "QC Measure No. Series")
                {
                    ApplicationArea = all;
                }
                field("AR No. Series"; "AR No. Series")
                {
                    ApplicationArea = all;
                }
                field("Specification No. Series"; "Specification No. Series")
                {
                    ApplicationArea = all;
                }
                field("Inspection Sheet No. Series"; "Inspection Sheet No. Series")
                {
                    ApplicationArea = all;
                }
                field("Inspection Receipt No. Series"; "Inspection Receipt No. Series")
                {
                    ApplicationArea = all;
                }
                field("Posted Inspection No. Series"; "Posted Inspection No. Series")
                {
                    ApplicationArea = all;
                }
                field("Apprvd. Inv. Mvmt. No. Series"; "Apprvd. Inv. Mvmt. No. Series")
                {
                    ApplicationArea = all;
                }
                field("Rjctd. Inv. Mvmt. No. Series"; "Rjctd. Inv. Mvmt. No. Series")
                {
                    ApplicationArea = all;
                }
                field("Cont. Sample Mvmt. No. Series"; "Cont. Sample Mvmt. No. Series")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage();
    begin
        RESET;
        IF NOT GET THEN BEGIN
            INIT;
            INSERT;
        END;
    end;
}

