page 50049 "Posted Inspection Subform"
{
    // version PCPL/QC/V3/001

    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = 50023;
    SourceTableView = SORTING("No.", "Line No.")
                      ORDER(Ascending);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                IndentationColumn = QltyIndent;
                IndentationControls = "Qc Description";
                field("Account Type"; "Account Type")
                {
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                    Applicationarea = all;
                }
                field("Qlty Measure Code"; "Qlty Measure Code")
                {
                    Editable = false;
                    Style = Strong;
                    StyleExpr = NameEmphasize;
                    Applicationarea = all;
                }
                field("Qc Description"; "Qc Description")
                {
                    Editable = false;
                    Style = Attention;
                    StyleExpr = FailQCEmphasize;
                    Applicationarea = all;
                }
                field("Test Mandatory"; "Test Mandatory")
                {
                    Editable = false;
                    Applicationarea = all;
                }
                field("Unit of Measure"; "Unit of Measure")
                {
                    Editable = false;
                    Applicationarea = all;
                }
                field(Qualitative; Qualitative)
                {
                    Applicationarea = all;
                }
                field("Posting Date"; "Posting Date")
                {
                    Editable = false;
                    Applicationarea = all;
                }
                field("Max. Value"; "Max. Value")
                {
                    Editable = false;
                    Style = Attention;
                    StyleExpr = FailQCEmphasize;
                    Applicationarea = all;
                }
                field("Min. Value"; "Min. Value")
                {
                    Editable = false;
                    Style = Attention;
                    StyleExpr = FailQCEmphasize;
                    Applicationarea = all;
                }
                field("Text Value"; "Text Value")
                {
                    Editable = false;
                    Style = Attention;
                    StyleExpr = FailQCEmphasize;
                    Applicationarea = all;
                }
                field("Actual Value"; "Actual Value")
                {
                    DecimalPlaces = 0 : 5;
                    Style = Attention;
                    StyleExpr = FailQCEmphasize;
                    Applicationarea = all;
                }
                field("Actual Text Value"; "Actual Text Value")
                {
                    Applicationarea = all;
                }
                field(Complies; Complies)
                {
                    Applicationarea = all;
                }
                field(Remark; Remark)

                {
                    Style = Attention;
                    StyleExpr = FailQCEmphasize;
                    Applicationarea = all;
                }
                field("Chemist Code"; "Chemist Code")
                {
                    Applicationarea = all;
                }

            }
        }
    }

    actions
    {
        area(processing)

        {
            action("Record Link")
            {
                Image = Links;
                Promoted = true;
                PromotedCategory = Process;
                ShortCutKey = 'F5';
                Applicationarea = all;

                trigger OnAction();
                begin
                    RecordLink.RESET;
                    RecordLink.SETFILTER("Record ID", 'Quality Measure: ' + "Qlty Measure Code");
                    IF RecordLink.FINDSET(TRUE) THEN
                        HYPERLINK(RecordLink.URL1);
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
        FailQCEmphasize := FALSE;
        fctQCfails;
    end;

    trigger OnModifyRecord(): Boolean;
    begin
        fctQCfails;
    end;

    trigger OnOpenPage();
    begin
        NameEmphasize := "Account Type" <> "Account Type"::Posting;
        MinMaxeditable := "Account Type" = "Account Type"::Posting;
        IF "Account Type" = "Account Type"::Posting THEN
            QltyIndent := 1
        ELSE
            QltyIndent := 0;

        fctQCfails;
    end;

    var
        QltyIndent: Integer;
        NameEmphasize: Boolean;
        MinMaxeditable: Boolean;
        FailQCEmphasize: Boolean;
        RecordLink: Record 2000000068;

    procedure fctQCfails();
    begin
        IF "Account Type" = "Account Type"::Posting THEN BEGIN
            IF ("Min. Value" <> 0) AND ("Max. Value" <> 0) THEN BEGIN
                IF "Actual Value" > "Max. Value" THEN
                    FailQCEmphasize := TRUE
                ELSE
                    IF "Actual Value" < "Min. Value" THEN
                        FailQCEmphasize := TRUE
                    ELSE
                        FailQCEmphasize := FALSE;

            END;
        END;
    end;
}

