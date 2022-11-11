table 50024 "Quality Measure Line"
{
    // version PCPL/QC/V3/001


    fields
    {
        field(1;"Code";Code[20])
        {
        }
        field(2;"Line No.";Integer)
        {
        }
        field(3;"Location Code";Code[20])
        {
            TableRelation = Location;
        }
        field(4;Attachment;Text[200])
        {
        }
    }

    keys
    {
        key(Key1;"Code","Line No.")
        {
        }
    }

    fieldgroups
    {
    }
}

