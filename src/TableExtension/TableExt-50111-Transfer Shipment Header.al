tableextension 50111 Transfer_Shipment_Header_QC extends "Transfer Shipment Header"
{
    // version NAVW19.00.00.45778,NAVIN9.00.00.45778,SUBCON1.0,PCPL/QC/V3/001

    fields
    {
        field(50050; "QC Document"; Boolean)
        {
            Description = 'PCPL/QC/V3/001';
        }
        field(50051; "QC Document No."; Code[20])
        {
            Description = 'PCPL/QC/V3/001';
        }
    }

    //Unsupported feature: PropertyChange. Please convert manually.

}

