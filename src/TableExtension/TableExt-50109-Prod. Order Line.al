tableextension 50109 tableextension50340 extends "Prod. Order Line"
{

    fields
    {
        field(50017; "Qty Send to Quality"; Decimal)
        {
            Description = 'PCPL QC 2.0';
        }
        field(50018; "Qty in Quality"; Decimal)
        {
            CalcFormula = Average("Inspection Data Sheet".Quantity WHERE(Approval = FILTER('WIP' | "Under Approval"),
                                                                          "Document Type" = FILTER("Prod. Order"),
                                                                          "Document No." = FIELD("Prod. Order No."),
                                                                          "Ref ID" = FIELD("Line No.")));
            Description = 'PCPL QC 2.0';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50019; "Qty Accepted"; Decimal)
        {
            CalcFormula = Sum("Inspection Data Sheet".Quantity WHERE(Approval = FILTER(Approved),
                                                                      "Document Type" = FILTER("Purch. Order"),
                                                                      "Document No." = FIELD("Prod. Order No."),
                                                                      "Ref ID" = FIELD("Line No.")));
            Description = 'PCPL QC 2.0';
            FieldClass = FlowField;
        }
        field(50020; "Qty Rejected"; Decimal)
        {
            CalcFormula = Sum("Inspection Data Sheet".Quantity WHERE(Approval = FILTER(Rejected),
                                                                      "Document Type" = FILTER("Purch. Order"),
                                                                      "Document No." = FIELD("Prod. Order No."),
                                                                      "Ref ID" = FIELD("Line No.")));
            Description = 'PCPL QC 2.0';
            FieldClass = FlowField;
        }
        field(50021; "Quality Check"; Option)
        {
            Description = 'PCPL QC 2.0';
            OptionCaption = 'After GRN,Before GRN';
            OptionMembers = "After GRN","Before GRN";
        }
        field(50022; "Specification Type"; Option)
        {
            Description = '//PCPL QC 03/BRB';
            OptionCaption = '" ,IP,BP,USP"';
            OptionMembers = " ",IP,BP,USP;
        }
    }


    //Unsupported feature: CodeModification on "OnRename". Please convert manually.

    //trigger OnRename();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    ERROR(Text99000001,TABLECAPTION);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    //Temp Comment
    //ERROR(Text99000001,TABLECAPTION);
    */
    //end;

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.


    var
        "----------QC------------------": Integer;
        recItem: Record 27;
}

