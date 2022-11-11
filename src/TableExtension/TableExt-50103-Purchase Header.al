tableextension 50103 Purchase_header_QC extends "Purchase Header"
{


    fields
    {


        modify("Expected Receipt Date")
        {
            trigger OnAfterValidate()
            begin
                //**IRL3.03**QC- Points**001**260312**SP
                IF "Expected Receipt Date" < "Order Date" THEN
                    ERROR('This date can not be less than Order Date');
                //**IRL3.03**QC- Points**001**260312**SP
            end;
        }
        modify("Requested Receipt Date")
        {
            trigger OnAfterValidate()
            begin
                //**IRL3.03**QC- Points**001**260312**SP
                IF "Requested Receipt Date" < "Order Date" THEN
                    ERROR('This date can not be less than Order Date');
                //**IRL3.03**QC- Points**001**260312**SP

            end;
        }
        modify("Promised Receipt Date")
        {
            trigger OnAfterValidate()
            begin
                //**IRL3.03**QC- Points**001**260312**SP
                IF "Promised Receipt Date" < "Order Date" THEN
                    ERROR('This date can not be less than Order Date');
                //**IRL3.03**QC- Points**001**260312**SP

            end;
        }
    }
}
