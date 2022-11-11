tableextension 50105 Item_Journal_Line_QC extends "Item Journal Line"
{


    fields
    {


        field(50050; "Quality Status"; Option)
        {
            Description = 'PCPL QC 2.0';
            OptionCaption = 'Quarantine,Approved,Rejected';
            OptionMembers = Quarantine,Approved,Rejected;
        }

        field(50104; "Create QC Inspection"; Boolean)
        {
        }

    }

    //Unsupported feature: PropertyChange. Please convert manually.


    var
        ProdOrder: Record 5405;
        ProdOrderLine: Record 5406;
        ProdOrderComp: Record 5407;
        ProdOrderRtngLine: Record 5409;


}

