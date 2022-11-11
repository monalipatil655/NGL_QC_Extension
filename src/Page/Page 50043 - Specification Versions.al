page 50043 "Specification Versions"
{
    // version PCPL/QC/V3/001

    CardPageID = "Specification Version Header";
    Editable = false;
    PageType = List;
    SourceTable = 50017;
    ApplicationArea=all;
    UsageCategory=Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Version Code"; "Version Code")
                {
                    ApplicationArea = all;
                }
                field("Specs ID"; "Specs ID")
                {
                    ApplicationArea = all;
                }
                field("Starting Date"; "Starting Date")
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

