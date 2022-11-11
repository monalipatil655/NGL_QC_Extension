tableextension 50122 Vendor_Ledger_Entry_QC extends "Vendor Ledger Entry"
{
    fields
    {

        field(50001; "Vendor Invoice No."; Code[35])
        {
            CalcFormula = Lookup("Purch. Inv. Header"."Vendor Invoice No." WHERE("No." = FIELD("Document No.")));
            Description = 'Sanjay 25/01/2017';
            FieldClass = FlowField;
        }

    }




}

