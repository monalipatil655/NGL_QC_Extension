page 50035 "Inspection Receipt Subform"
{
    // version PCPL/QC/V3/001

    Editable = true;
    PageType = ListPart;
    SourceTable = 50021;
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
                    ApplicationArea = all;
                }
                field("Qlty Measure Code"; "Qlty Measure Code")
                {
                    Editable = false;
                    Style = Strong;
                    StyleExpr = NameEmphasize;
                    ApplicationArea = all;
                }
                field("Qc Description"; "Qc Description")
                {
                    Editable = false;
                    Style = Attention;
                    StyleExpr = FailQCEmphasize;
                    ApplicationArea = all;
                }
                field("Test Mandatory"; "Test Mandatory")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Unit of Measure"; "Unit of Measure")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field(Qualitative; Qualitative)
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Posting Date"; "Posting Date")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Max. Value"; "Max. Value")
                {
                    Editable = false;
                    Style = Attention;
                    StyleExpr = FailQCEmphasize;
                    ApplicationArea = all;
                }
                field("Min. Value"; "Min. Value")
                {
                    Editable = false;
                    Style = Attention;
                    StyleExpr = FailQCEmphasize;
                    ApplicationArea = all;
                }
                field("Actual Value"; "Actual Value")
                {
                    ApplicationArea = all;

                }
                field("Text Value"; "Text Value")
                {
                    ApplicationArea = all;
                    Editable = false;
                    Style = Attention;
                    StyleExpr = FailQCEmphasize;
                }
                field("Actual Text Value"; "Actual Text Value")
                {
                    ApplicationArea = all;
                }
                field(Complies; Complies)
                {
                    Editable = false;
                    HideValue = false;
                    ApplicationArea = all;
                }
                field(Remark; Remark)
                {
                    Style = Attention;
                    StyleExpr = FailQCEmphasize;
                    ApplicationArea = all;
                }
                field("Chemist Code"; "Chemist Code")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Reject/Retest QC"; "Reject/Retest QC")
                {
                    Caption = 'Reject/Retest QC';
                    ApplicationArea = all;
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
                ApplicationArea = all;

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

