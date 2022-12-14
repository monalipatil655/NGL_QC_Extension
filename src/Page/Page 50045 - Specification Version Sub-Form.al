page 50045 "Specification Version Sub-Form"
{
    // version PCPL/QC/V3/001

    AutoSplitKey = true;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = 50016;
    SourceTableView = SORTING("Specs ID", "Line No.")
                      ORDER(Ascending);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Editable = Allfalse;
                IndentationColumn = QltyIndent;
                IndentationControls = Description;
                field("Account Type"; "Account Type")
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        NameEmphasize := "Account Type" <> "Account Type"::Posting;
                        MinMaxeditable := "Account Type" = "Account Type"::Posting;
                        IF "Account Type" = "Account Type"::Posting THEN
                            QltyIndent := 1
                        ELSE
                            QltyIndent := 0;
                    end;
                }
                field("Group Code"; "Group Code")
                {
                    ApplicationArea = All;
                }
                field("Qlty Measure Code"; "Qlty Measure Code")
                {
                    Editable = MinMaxeditable;
                    Style = Strong;
                    StyleExpr = NameEmphasize;
                    ApplicationArea = All;
                }
                field("Test Manadatory"; "Test Manadatory")
                {
                    Editable = MinMaxeditable;
                    ApplicationArea = All;
                }
                field("Unit of Measure"; "Unit of Measure")
                {
                    Editable = MinMaxeditable;
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    Style = Strong;
                    StyleExpr = NameEmphasize;
                    ApplicationArea = All;
                }
                field("Specification Reference"; "Specification Reference")
                {
                }
                field("Protocol No."; "Protocol No.")
                {
                    ApplicationArea = All;
                }
                field("Test Method"; "Test Method")
                {
                    ApplicationArea = All;
                }
                field(Qualitative; Qualitative)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Text Value"; "Text Value")
                {
                    Editable = MinMaxeditable;
                    ApplicationArea = All;
                }
                field("Laboratory Details"; "Laboratory Details")
                {
                    ApplicationArea = All;
                }
                field("Min. Value"; "Min. Value")
                {
                    Editable = MinMaxeditable;
                    ApplicationArea = All;
                }
                field("Max. Value"; "Max. Value")
                {
                    Editable = MinMaxeditable;
                    ApplicationArea = All;
                }
                field("Mean Tolerance"; "Mean Tolerance")
                {
                    Editable = MinMaxeditable;
                    ApplicationArea = All;
                }
                field("Parent Group Code"; "Parent Group Code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Edit Protocol")
            {
                Image = Edit;
                Promoted = true;
                PromotedCategory = Process;
                ShortCutKey = 'F6';

                trigger OnAction();
                begin
                    recUserSetup.RESET;
                    recUserSetup.SETRANGE(recUserSetup."QC Approver", USERID);
                    IF NOT recUserSetup.FINDFIRST THEN
                        ERROR('You do not have the rights to edit Protocol');
                    TESTFIELD("Account Type", "Account Type"::Posting);
                    recProtocol.RESET;
                    recProtocol.SETRANGE(recProtocol."Specs ID", "Specs ID");
                    recProtocol.SETRANGE(recProtocol."Version Code", "Version Code");
                    recProtocol.SETRANGE(recProtocol."Line No.", "Line No.");
                    recProtocol.SETRANGE(recProtocol."Protocol No.", "Protocol No.");
                    IF NOT recProtocol.FINDFIRST THEN BEGIN
                        recProtocol.INIT;
                        recProtocol."Specs ID" := "Specs ID";
                        recProtocol."Version Code" := "Version Code";
                        recProtocol."Line No." := "Line No.";
                        recProtocol."Protocol No." := getProtocolNo;
                        recProtocol."Protocol Creation Date" := WORKDATE;
                        recProtocol."Protocol Created By" := USERID;
                        recProtocol.INSERT;
                        // ProtocolTextMgt.EditContactText(recProtocol, FALSE); //PCPL/NSW/MIG  21July22
                        "Protocol No." := recProtocol."Protocol No.";
                        MODIFY;
                    END
                    //ELSE //PCPL/NSW/MIG  21July22
                    //  ProtocolTextMgt.EditContactText(recProtocol, FALSE); //PCPL/NSW/MIG  21July22
                end;
            }
            action("Preview Protocol")
            {
                Image = PreviewChecks;
                Promoted = true;

                trigger OnAction();
                begin
                    TESTFIELD("Account Type", "Account Type"::Posting);
                    recProtocol.RESET;
                    recProtocol.SETRANGE(recProtocol."Specs ID", "Specs ID");
                    recProtocol.SETRANGE(recProtocol."Version Code", "Version Code");
                    recProtocol.SETRANGE(recProtocol."Line No.", "Line No.");
                    recProtocol.SETRANGE(recProtocol."Protocol No.", "Protocol No.");
                    IF recProtocol.FINDFIRST THEN BEGIN
                        //ProtocolTextMgt.EditContactText(recProtocol, TRUE); //PCPL/NSW/MIG  21July22
                    END
                    ELSE
                        ERROR('No protocol is defined');
                end;
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        NameEmphasize := "Account Type" <> "Account Type"::Posting;
        MinMaxeditable := "Account Type" = "Account Type"::Posting;
        IF "Account Type" = "Account Type"::Posting THEN
            QltyIndent := 1
        ELSE
            QltyIndent := 0;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean;
    begin
        NameEmphasize := "Account Type" <> "Account Type"::Posting;
        MinMaxeditable := "Account Type" = "Account Type"::Posting;
        IF "Account Type" = "Account Type"::Posting THEN
            QltyIndent := 1
        ELSE
            QltyIndent := 0;
    end;

    trigger OnModifyRecord(): Boolean;
    begin
        NameEmphasize := "Account Type" <> "Account Type"::Posting;
        MinMaxeditable := "Account Type" = "Account Type"::Posting;
        IF "Account Type" = "Account Type"::Posting THEN
            QltyIndent := 1
        ELSE
            QltyIndent := 0;
    end;

    trigger OnOpenPage();
    begin
        NameEmphasize := "Account Type" <> "Account Type"::Posting;
        MinMaxeditable := "Account Type" = "Account Type"::Posting;
        IF "Account Type" = "Account Type"::Posting THEN
            QltyIndent := 1
        ELSE
            QltyIndent := 0;
        Allfalse := TRUE;
    end;

    var
        ProdBOMHeader: Record 99000771;
        ProdBOMWhereUsed: Page 99000811;
        ProductionBOMCopy: Codeunit 99000768;
        VersionMgt: Codeunit 99000756;
        ActiveVersionCode: Code[20];
        [InDataSet]
        "Min. ValueEditable": Boolean;
        [InDataSet]
        "Max. ValueEditable": Boolean;
        [InDataSet]
        "Mean ToleranceEditable": Boolean;
        QltyIndent: Integer;
        NameEmphasize: Boolean;
        MinMaxeditable: Boolean;
        recProtocol: Record 50025;
        ProtocolTextMgt: Codeunit 50007;
        recUserSetup: Record 91;
        SpecificationVersionHeader: Record 50017;
        Allfalse: Boolean;

    procedure getProtocolNo() ProtocolNo: Integer;
    var
        tempProtocolTxt: Record 50026;
    begin
        tempProtocolTxt.RESET;
        IF tempProtocolTxt.FINDLAST THEN
            EXIT(tempProtocolTxt."Protocol No." + 1)
        ELSE
            EXIT(1);
    end;
}

