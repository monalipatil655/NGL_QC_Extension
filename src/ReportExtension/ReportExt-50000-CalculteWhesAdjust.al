reportextension 50001 Calculate_Whse_Adjustment extends "Calculate Whse. Adjustment"
{
    dataset
    {
        // Add changes to dataitems and columns here
    }

    requestpage
    {
        // Add changes to the requestpage here
    }

    procedure itemParam(itemCode: Code[20])
    begin
        //RSPL QC 2.0
        gItemCode := itemCode;
        //RSPL QC 2.0
    end;

    var
        gItemCode: Code[20];

}