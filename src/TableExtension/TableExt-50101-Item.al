tableextension 50101 Item_QC_Ext extends Item
{


    fields
    {


        field(50029; "Inspection Sample Quantity"; Decimal)
        {
            Description = 'PCPL QC 2.0';
        }
        field(50054; "Retesting Frequency Required"; Boolean)
        {
            Description = 'PCPL QC 2.0';
        }
        field(50055; "QC Check"; Boolean)
        {
            Description = 'PCPL QC 2.0';
            Enabled = true;
        }
        field(50056; Synonym; Text[50])
        {
            Description = 'PCPL QC 2.0';
        }
        field(50057; "CAS No."; Code[20])
        {
            Description = 'PCPL QC 2.0';
        }
        field(50058; "Mol. Formula"; Text[50])
        {
            Description = 'PCPL QC 2.0';
        }
        field(50059; "Mol. Weight"; Decimal)
        {
            Description = 'PCPL QC 2.0';
        }
        field(50060; "Mol. Structure"; BLOB)
        {
            Description = 'PCPL QC 2.0';
        }
        field(50061; "Rejected Inventory"; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry"."Remaining Quantity" WHERE("Item No." = FIELD("No."),
                                                                              Positive = FILTER(True),
                                                                              "QC Status" = FILTER(Rejected)));
            Description = 'PCPL QC 2.0';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50062; "Accepted Inventory"; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry"."Remaining Quantity" WHERE("Item No." = FIELD("No."),
                                                                              Positive = FILTER(true),
                                                                              "QC Status" = FILTER(Approved)));
            Description = 'PCPL QC 2.0';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50063; "Quarantine Inventory"; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry"."Remaining Quantity" WHERE("Item No." = FIELD("No."),
                                                                              Positive = FILTER(True),
                                                                              "QC Status" = FILTER(WIP)));
            Description = 'PCPL QC 2.0';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50064; "Specs ID"; Code[10])
        {
            Description = 'PCPL QC 2.0';
            TableRelation = "Specification Header";
        }
        field(50065; "Retest Duration"; DateFormula)
        {
            Description = 'PCPL QC 2.0';
        }

    }




    var
        PurchOrderLine: Record 39;
        SalesOrderLine: Record 37;
}

