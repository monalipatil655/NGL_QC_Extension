tableextension 50113 Warehouse_Activity_Header_QC extends "Warehouse Activity Header"
{
    // version NAVW19.00.00.47256,PCPL/QC/V3/001

    fields
    {
        field(50050; "QC Document"; Boolean)
        {
            Description = 'PCPL/QC/V3/001';
            Editable = false;
        }
        field(50051; "QC Document Type"; Option)
        {
            Description = 'PCPL/QC/V3/001';
            Editable = false;
            OptionCaption = '" ,Approval Movement,Rejection Movement,Cont. Sample Movement"';
            OptionMembers = " ","Approval Movement","Rejection Movement","Cont. Sample Movement";
        }
        field(50052; "QC Document No."; Code[20])
        {
            Description = 'PCPL/QC/V3/001';
            Editable = false;
        }
    }

    //Unsupported feature: PropertyChange. Please convert manually.

}

