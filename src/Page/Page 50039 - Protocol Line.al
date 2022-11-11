page 50039 "Protocol Line"
{
    // version PCPL/QC/V3/001

    PageType = ListPart;
    Permissions = TableData 50026 = rimd;
    SourceTable = 50026;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Textline; Textline)
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

