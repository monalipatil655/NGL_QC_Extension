table 50018 "COA Print Log"
{
    // version PCPL/QC/V3/001

    Caption = 'COA Print Log';

    fields
    {
        field(1;"Inspection No.";Code[20])
        {
        }
        field(2;"Version No.";Integer)
        {
        }
        field(5;"Reason Code";Code[10])
        {
        }
        field(6;Description;Text[50])
        {
        }
        field(15;"User ID";Code[20])
        {
        }
        field(16;"Creation Date Time";DateTime)
        {
        }
    }

    keys
    {
        key(Key1;"Inspection No.","Version No.")
        {
        }
    }

    fieldgroups
    {
    }
}

