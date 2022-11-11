pageextension 50101 Item_Card_QC extends "Item Card"
{
    layout
    {
        addafter("Assembly Policy")
        {
            field("QC Check"; "QC Check")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }
    trigger OnQueryClosePage(CloseAction: Action): Boolean
    Begin
        //**IRL2.98**QC- Points**001**210312**SP
        TESTFIELD("Base Unit of Measure");
        TESTFIELD("Item Category Code");
        TESTFIELD(Description);
        //**IRL2.98**QC- Points**001**210312**SP
    End;

    var
        myInt: Integer;
}