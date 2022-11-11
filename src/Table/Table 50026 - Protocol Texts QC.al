table 50026 "Protocol Texts QC"
{
    // version PCPL/QC/V3/001


    fields
    {
        field(1;"Protocol No.";Integer)
        {
            TableRelation = Protocol."Protocol No.";
        }
        field(2;"Line No.";Integer)
        {
        }
        field(3;Textline;Text[250])
        {
        }
        field(4;Seperator;Option)
        {
            OptionMembers = " ",Space,"Carriage Return";
        }
    }

    keys
    {
        key(Key1;"Protocol No.","Line No.")
        {
        }
    }

    fieldgroups
    {
    }
}

