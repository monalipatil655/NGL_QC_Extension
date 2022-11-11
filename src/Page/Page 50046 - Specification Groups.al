page 50046 "Specification Groups"
{
    // version PCPL/QC/V3/001

    PageType = List;
    SourceTable = 50019;
    ApplicationArea=all;
    UsageCategory=Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Group Code"; "Group Code")
                {
                    ApplicationArea = all;
                }
                field(Description; Description)
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
    }
}

