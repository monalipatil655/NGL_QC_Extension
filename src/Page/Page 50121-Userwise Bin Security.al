page 50121 "User-wise Bin Security"
{
    Caption = 'User-wise Bin Security';
    DelayedInsert = true;
    PageType = List;
    SourceTable = 50070;
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("User ID"; "User ID")
                {
                    ApplicationArea = All;
                }
                field("Location Code"; "Location Code")
                {
                    ApplicationArea = All;
                }
                field(Bin; Bin)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}
