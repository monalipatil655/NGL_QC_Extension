page 50050 "Quality Unit of Measure"
{
    // version PCPL/QC/V3/001

    PageType = List;
    SourceTable = 50027;
    ApplicationArea = all;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("UOM Code"; "UOM Code")
                {
                    Applicationarea = all;
                }
                field(Description; Description)
                {
                    Applicationarea = all;
                }
            }
        }
    }

    actions
    {
    }
}

