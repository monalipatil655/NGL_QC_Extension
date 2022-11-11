page 50051 "Quality Measure"
{
    // version PCPL/QC/V3/001

    SourceTable = 99000785;
    ApplicationArea = all;
    UsageCategory = Documents;

    layout
    {
        area(content)
        {
            group(Control001)
            {
                field(Code; Code)
                {
                    Applicationarea = all;
                }
                field(Description; Description)
                {
                    Applicationarea = all;
                }
                field("Unit of Measure"; "Unit of Measure")
                {
                    Applicationarea = all;
                }
            }
            part("Quality measure Subform"; 50052)
            {
                SubPageLink = Code = FIELD(Code);
            }
        }
    }

    actions
    {
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean;
    begin
        RecQML.INIT;
        RecQML.Code := Code;
        RecQML.INSERT;
    end;

    var
        RecQML: Record 50024;
}

