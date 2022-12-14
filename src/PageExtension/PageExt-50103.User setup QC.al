pageextension 50103 "User Setup QC" extends "User Setup" //OriginalId
{
    layout
    {
        addafter("User ID")
        {
            field("QC Approver"; "QC Approver")
            {
                ApplicationArea = All;
            }
            field(QA; QA)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }
}