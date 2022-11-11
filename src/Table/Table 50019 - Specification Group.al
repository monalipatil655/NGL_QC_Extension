table 50019 "Specification Group"
{
    // version PCPL/QC/V3/001

    Caption = 'Specification Group';
    LookupPageID = 50046;

    fields
    {
        field(1;"Group Code";Code[20])
        {
            Caption = 'Specificaton Group Code';
        }
        field(2;Description;Text[250])
        {
        }
    }

    keys
    {
        key(Key1;"Group Code")
        {
        }
    }

    fieldgroups
    {
    }
}

