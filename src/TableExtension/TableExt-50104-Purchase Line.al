tableextension 50104 Purchase_Line_Ext extends "Purchase Line"
{


    fields
    {

        modify("No.")
        {
            trigger Onaftervalidate()
            Begin
                //PCPL/CUST/QC
                IF Type = Type::Item THEN BEGIN
                    recItem.GET("No.");
                    IF recItem."QC Check" THEN BEGIN
                        recSpecs.GET(recItem."Specs ID");
                        recSpecs.TESTFIELD(recSpecs.Status, recSpecs.Status::Certified);
                    END;
                END;
                //PCPL/CUST/QC
            End;
        }

        field(50030; "Qty Send to Quality"; Decimal)
        {
            Description = 'PCPL QC 2.0';

            trigger OnValidate();
            begin
                /*//QC New
                IF "Qty Send to Quality"<>0 THEN
                BEGIN
                  recItem.GET("No.");
                  recItem.TESTFIELD(recItem."Item Tracking Code",'');
                  TESTFIELD("Quality Check","Quality Check"::"Before GRN");
                END;
                 */
                TESTFIELD("Quality Check", "Quality Check"::"Before GRN");
                IF "Qty Send to Quality" + "Qty Accepted" + "Qty Rejected" + "Qty in Quality" > Quantity THEN
                    ERROR('Quanity to check can not be greater than total quantity');
                //Qc New

            end;
        }
        field(50031; "Qty in Quality"; Decimal)
        {
            CalcFormula = Average("Inspection Data Sheet".Quantity WHERE("No." = FILTER(<> ''),
                                                                          "Document Type" = FILTER("Purch. Order"),
                                                                          "Document No." = FIELD("Document No."),
                                                                          "Ref ID" = FIELD("Line No."),
                                                                          "Item No." = FIELD("No."),
                                                                          Approval = FILTER('WIP' | "Under Approval")));
            Description = 'PCPL QC 2.0';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50032; "Qty Accepted"; Decimal)
        {
            CalcFormula = Sum("Posted Inspection".Quantity WHERE("No." = FILTER(<> ''),
                                                                  "Document Type" = FILTER("Purch. Order"),
                                                                  "Document No." = FIELD("Document No."),
                                                                  "Ref ID" = FIELD("Line No."),
                                                                  "Item No." = FIELD("No."),
                                                                  Approval = FILTER(Approved)));
            Description = 'PCPL QC 2.0';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50033; "Qty Rejected"; Decimal)
        {
            CalcFormula = Sum("Posted Inspection".Quantity WHERE("No." = FILTER(<> ''),
                                                                  "Document Type" = FILTER("Purch. Order"),
                                                                  "Document No." = FIELD("Document No."),
                                                                  "Ref ID" = FIELD("Line No."),
                                                                  "Item No." = FIELD("No."),
                                                                  Approval = FILTER(Rejected)));
            Description = 'PCPL QC 2.0';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50034; "Quality Check"; Option)
        {
            Caption = 'Quality Check Type';
            Description = 'PCPL QC 2.0';
            OptionCaption = 'After GRN,Before GRN';
            OptionMembers = "After GRN","Before GRN";

            trigger OnValidate();
            begin
                IF "Quality Check" = "Quality Check"::"Before GRN" THEN BEGIN
                    VALIDATE("Qty. to Receive", 0);
                    VALIDATE("Qty. to Invoice", 0);
                END;
            end;
        }
    }


    var
        recVend: Record 23;
        recVLE: Record 25;
        NONTDSPreviousAmount: Decimal;
        TotalPOAmount: Decimal;
        PurchHeaderRec: Record 38;
        //IPO : Record 50005;  
        TotalAmountqtyrecieve: Decimal;
        recSpecs: Record 50015;
        recItem: Record 27;

}

