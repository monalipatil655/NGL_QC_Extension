page 50141 "Quality Measures QC"
{
    Caption = 'Quality Measures';
    PageType = List;
    SourceTable = "Quality Measure";
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Code"; Code)
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the quality measure code.';
                }
                field(Description; Description)
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies a description for the quality measure.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
                Visible = false;
            }
        }
    }

    actions
    {
    }
}

