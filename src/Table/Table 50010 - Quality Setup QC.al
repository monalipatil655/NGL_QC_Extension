table 50010 "Quality Setup QC"
{
    // version PCPL/QC/V3/001


    fields
    {
        field(1; PK; Code[10])
        {
        }
        field(2; "Inspection Sheet No. Series"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(3; "Approved/Reject Qty Manual"; Boolean)
        {
            Caption = 'Approved/Rejected Qty Manual Update';
        }
        field(4; "AR No. Series"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(5; "Specification No. Series"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(6; "Sampling Cost to be Loaded"; Boolean)
        {
        }
        field(8; "QC Measure No. Series"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(10; "Inspection Receipt No. Series"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(11; "Posted Inspection No. Series"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(12; "Split Inspection Group Wise"; Boolean)
        {
        }
        field(15; "Specs Version No. Series"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(16; "Sampling Location"; Code[20])
        {
            TableRelation = Location;
        }
        field(17; "Sampl. Trnsf. Batch"; Code[10])
        {
            TableRelation = "Item Journal Batch".Name WHERE("Journal Template Name" = FILTER('ITEM'));
        }
        field(20; "Apprvd. Inv. Mvmt. No. Series"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(21; "Rjctd. Inv. Mvmt. No. Series"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(22; "Cont. Sample Mvmt. No. Series"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(50; "Whse. Item Batch"; Code[10])
        {
            TableRelation = "Warehouse Journal Batch".Name;
        }
        field(51; "Item Journal Batch"; Code[10])
        {
            TableRelation = "Item Journal Batch".Name;
        }
        field(55; "Sampling Reason Code"; Code[10])
        {
            TableRelation = "Reason Code".Code;
        }
        field(56; "Resons Dimension"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = FILTER('REASONS'),
                                                          "Dimension Value Type" = FILTER(Standard));
        }
    }

    keys
    {
        key(Key1; PK)
        {
        }
    }

    fieldgroups
    {
    }
}

