pageextension 50102 Inventory_Movment_QC extends "Inventory Movement"
{
    // version NAVW17.00,PCPL/QC/V3/001

    layout
    {
        addafter("Sorting Method")
        {
            field("QC Document"; "QC Document")
            {
                ApplicationArea = all;
            }
            field("QC Document No."; "QC Document No.")
            {
                ApplicationArea = all;
            }
            field("QC Document Type"; "QC Document Type")
            {
                ApplicationArea = all;
            }
        }
    }


    trigger OnDeleteRecord(): Boolean
    begin
        //PCPL/QC/V3/001
        IF "QC Document" THEN
            ERROR('QC Document can not be deleted');
        //PCPL/QC/V3/001
    end;

}

