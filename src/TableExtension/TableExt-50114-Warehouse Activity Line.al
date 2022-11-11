tableextension 50114 Warehouse_Activity_Line_QC extends "Warehouse Activity Line"
{
    // version NAVW19.00.00.47444,PCPL/QC/V3/001

    fields
    {


    }




    trigger OnBeforeDelete()
    begin

        //PCPL/QC/V3/001
        recWhseActivityHdr.GET("Activity Type", "No.");
        IF recWhseActivityHdr."QC Document" THEN
            ERROR('QC Document can not be deleted');
        //PCPL/QC/V3/001
    end;

    //Unsupported feature: PropertyChange. Please convert manually.


    var
        recWhseActivityHdr: Record 5766;
}

