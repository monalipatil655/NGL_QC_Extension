page 50040 "Specifications-PCPL"
{
    // version PCPL/QC/V3/001

    Caption = 'Specifications';
    CardPageID = "Specification Header";
    DeleteAllowed = true;
    Editable = false;
    InsertAllowed = true;
    ModifyAllowed = true;
    PageType = List;
    SourceTable = 50015;
    ApplicationArea = all;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Specs ID"; "Specs ID")
                {
                    ApplicationArea = all;
                }
                field(Description; Description)
                {
                    ApplicationArea = all;
                }
                field(Status; Status)
                {
                    ApplicationArea = all;
                }
                field("Version Nos."; "Version Nos.")
                {
                    ApplicationArea = all;
                }
                field("Last Date Modified"; "Last Date Modified")
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

