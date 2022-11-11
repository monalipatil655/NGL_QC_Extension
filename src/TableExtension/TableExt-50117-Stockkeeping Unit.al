tableextension 50117 Stockkeeping_Unit_QC extends "Stockkeeping Unit"
{
    // version NAVW19.00.00.48316

    fields
    {


        field(50003; "Specs ID"; Code[50])
        {
            Description = 'RSPL/CUST/QC/IRL/001';
            //TableRelation = Table50131.Field1;  //PCPL/NSW/MIG 19july22 Table not exist which table releation
        }
        field(50004; "QC Check"; Boolean)
        {
            Description = 'RSPL/CUST/QC/IRL/002';
        }
    }

    //Unsupported feature: PropertyChange. Please convert manually.

}

