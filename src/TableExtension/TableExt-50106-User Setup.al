tableextension 50106 User_Setup_QC extends "User Setup"
{


    fields
    {
        field(50013; "QC Approver"; Code[30])
        {
            Description = 'PCPL QC 2.0';
            TableRelation = "User Setup";
        }
        field(50016; QA; Boolean)
        {
            Description = 'PCPL QC 2.0';
        }

    }

    //Unsupported feature: PropertyChange. Please convert manually.

}

