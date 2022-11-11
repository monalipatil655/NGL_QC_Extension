tableextension 50108 Tracking_Specification_QC extends "Tracking Specification"
{
    fields
    {
        modify("Lot No.")
        {
            trigger OnAfterValidate()
            begin
                //PCPL QC 2.0
                recILE.RESET;
                recILE.SETRANGE(recILE."Lot No.", "Lot No.");
                recILE.SETRANGE(recILE.Positive, TRUE);
                recILE.SETRANGE(recILE."QC Status", recILE."QC Status"::Rejected);
                IF recILE.FINDFIRST THEN
                    ERROR('The lot you are selecting is rejected by QC inspection team,please contact administrator');

                //PCPL QC

            end;
        }
    }

    var
        recILE: record 32;

}