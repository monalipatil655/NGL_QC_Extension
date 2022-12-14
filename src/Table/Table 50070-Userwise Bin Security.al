table 50070 "User-wise Bin Security"
{
    LookupPageID = 50121;

    fields
    {
        field(1; "User ID"; Code[50])
        {
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(2; "Location Code"; Code[10])
        {
            TableRelation = Location;
        }
        field(3; Bin; Code[10])
        {
            TableRelation = Bin.Code WHERE("Location Code" = FIELD("Location Code"));
        }
    }

    keys
    {
        key(Key1; "User ID", "Location Code", Bin)
        {
            Clustered = true;
        }
        key(Key2; "Location Code")
        {
        }
    }

    fieldgroups
    {
    }
}

