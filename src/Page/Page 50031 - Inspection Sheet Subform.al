page 50031 "Inspection Sheet Subform"
{
    // version PCPL/QC/V3/001

    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = 50012;
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
                    Style = Strong;
                    StyleExpr = NameEmphasize;
                    ApplicationArea = all;
                }
                field("Qc Description"; "Qc Description")
                {
                    Style = Attention;
                    StyleExpr = FailQCEmphasize;
                    ApplicationArea = all;
                }
                field("Test Mandatory"; "Test Mandatory")
                {
                    ApplicationArea = all;
                }
                field("Unit of Measure"; "Unit of Measure")
                {
                    ApplicationArea = all;
                }
                field("Location Code"; "Location Code")
                {
                    ApplicationArea = all;
                }
                field(Qualitative; Qualitative)
                {
                    ApplicationArea = all;
                }
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = all;
                }
                field("Max. Value"; "Max. Value")
                {
                    ApplicationArea = all;
                    Editable = false;
                    Style = Attention;
                    StyleExpr = FailQCEmphasize;
                }
                field("Min. Value"; "Min. Value")
                {
                    Editable = false;
                    Style = Attention;
                    StyleExpr = FailQCEmphasize;
                    ApplicationArea = all;
                }
                field("Text Value"; "Text Value")
                {
                    Editable = false;
                    Style = Attention;
                    StyleExpr = FailQCEmphasize;
                    ApplicationArea = all;
                }
                field("Actual Value"; "Actual Value")
                {
                    Style = Attention;
                    StyleExpr = FailQCEmphasize;
                    ApplicationArea = all;

                    trigger OnValidate();
                    begin
                        IF ("Actual Value" > "Max. Value") OR ("Actual Value" < "Min. Value") THEN
                            MESSAGE('Actual Value is not between min & Max value');
                    end;
                }
                field("Actual Text Value"; "Actual Text Value")
                {
                    ApplicationArea = all;
                }
                field(Complies; Complies)
                {
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
                    ApplicationArea = all;
                }
                field("Reject/Retest QC"; "Reject/Retest QC")
                {
                    ApplicationArea = all;
                }
                field("Reject QC Receipt No."; "Reject QC Receipt No.")
                {
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

                trigger OnAction();
                begin
                    RecordLink.RESET;
                    RecordLink.SETFILTER("Record ID", 'Quality Measure: ' + "Qlty Measure Code");
                    IF RecordLink.FINDSET(TRUE) THEN
                        HYPERLINK(RecordLink.URL1);
                end;
            }
            action(Download)
            {
                Caption = 'Download';

                trigger OnAction();
                begin
                    //E:\QC\54E345_HHHHHH

                    TempFile.OPEN('E:\QC\' + "Qlty Measure Code" + '_' + "Location Code" + '.pdf');
                    TempFile.CREATEINSTREAM(NVInStream);
                    Filename := 'Test1.pdf';
                    DOWNLOADFROMSTREAM(NVInStream, 'Download', 'D:\', '', Filename);
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
        NVInStream: InStream;
        Filename: Text[100];
        TempFile: File;

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

