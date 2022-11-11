table 50025 Protocol
{
    // version PCPL/QC/V3/001


    fields
    {
        field(1; "Specs ID"; Code[50])
        {
            NotBlank = true;
            TableRelation = "Specification Header"."Specs ID";
        }
        field(2; "Version Code"; Code[50])
        {
            TableRelation = "Specification Version Header"."Version Code" WHERE("Specs ID" = FIELD("Specs ID"));
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
            Editable = false;
        }
        field(5; "Protocol No."; Integer)
        {
        }
        field(10; "Protocol Creation Date"; Date)
        {
        }
        field(11; "Protocol Created By"; Code[30])
        {
        }
        field(15; "Approved On"; Date)
        {
        }
        field(16; "Approved By"; Code[30])
        {
        }
    }

    keys
    {
        key(Key1; "Specs ID", "Version Code", "Line No.", "Protocol No.")
        {
        }
    }

    fieldgroups
    {
    }
}

