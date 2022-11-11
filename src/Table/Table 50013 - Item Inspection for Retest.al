table 50013 "Item Inspection for Retest"
{
    // version PCPL/QC/V3/001


    fields
    {
        field(1; "No."; Code[20])
        {
            Editable = false;
            NotBlank = true;
        }
        field(2; "Document Type"; Option)
        {
            Editable = false;
            OptionCaption = 'Purch. Order,Prod. Order,Transfer,Sales Return,Code-to-Code';
            OptionMembers = "Purch. Order","Prod. Order",Transfer,"Sales Return","Code-to-Code";
        }
        field(3; "Document No."; Code[20])
        {
            Editable = false;
        }
        field(4; "Posting Date"; Date)
        {
            Editable = false;
        }
        field(5; "Location Code"; Code[20])
        {
            Editable = false;
        }
        field(6; "Bin Code"; Code[10])
        {
            TableRelation = Bin.Code WHERE("Location Code" = FIELD("Location Code"));
        }
        field(10; "Item No."; Code[20])
        {
            Editable = false;
        }
        field(12; "Retest Date"; Date)
        {
            Editable = false;
        }
        field(15; "Lot No."; Code[20])
        {
            Editable = false;
        }
        field(25; "AR No."; Code[50])
        {
            Editable = false;
        }
        field(100; "Send for Retest"; Boolean)
        {
        }
        field(50000; "Item Description"; Text[100])
        {
        }
        field(50001; "Mfg.Date"; Date)
        {
        }
        field(50002; "Exp.Date"; Date)
        {
        }
        field(50003; "Remaining Quantity"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
    }

    fieldgroups
    {
    }
}

