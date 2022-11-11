tableextension 50121 Production_order extends "Production Order"
{


    fields
    {


        field(50000; "Lot No."; Text[35])
        {
            CalcFormula = Lookup("Item Ledger Entry"."Lot No." WHERE("Document No." = FIELD("No."),
                                                                      "Entry Type" = CONST(Output)));
            FieldClass = FlowField;
        }

    }


}

