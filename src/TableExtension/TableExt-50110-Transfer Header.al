tableextension 50110 Transfer_Header_QC extends "Transfer Header"
{


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




    trigger OnDelete();
    begin

        //PCPL/QC/V3/001
        IF "QC Document" THEN
            ERROR('QC Document can not be deleted');
        //PCPL/QC/V3/001    
    end;

    //Unsupported feature: PropertyChange. Please convert manually.


    var
        recTLine: Record 5741;
}

