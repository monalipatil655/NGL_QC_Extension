page 50041 "Specification Header"
{
    // version PCPL/QC/V3/001

    PageType = ListPlus;
    SourceTable = 50015;
    SourceTableView = SORTING("Specs ID")
                      ORDER(Ascending);

    layout
    {
        area(content)
        {
            group(General)
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
                field("Active Version"; activeVersion)
                {
                    Caption = 'Active Version';
                    Editable = false;
                    ApplicationArea = all;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        recVersionHdr.RESET;
                        recVersionHdr.FILTERGROUP(2);
                        recVersionHdr.SETRANGE(recVersionHdr."Specs ID", "Specs ID");
                        recVersionHdr.SETRANGE(recVersionHdr."Version Code", activeVersion);
                        recVersionHdr.FILTERGROUP(0);
                        CLEAR(pgVersion);
                        pgVersion.SETTABLEVIEW(recVersionHdr);
                        pgVersion.RUN;
                    end;
                }
            }
            part(specsline; 50042)
            {
                SubPageLink = "Specs ID" = FIELD("Specs ID"),
                              "Version Code" = CONST();
                SubPageView = SORTING("Specs ID", "Line No.")
                              ORDER(Ascending);
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Version)
            {
                Image = Versions;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page 50043;
                RunPageLink = "Specs ID" = FIELD("Specs ID");

                trigger OnAction();
                begin
                    TESTFIELD(Status, Status::Certified);
                end;
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        IF Status = Status::Certified THEN
            editSubForm := FALSE
        ELSE
            editSubForm := TRUE;

        activeVersion := GetVersion("Specs ID");
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean;
    begin
        IF Status = Status::Certified THEN
            editSubForm := FALSE
        ELSE
            editSubForm := TRUE;
    end;

    trigger OnModifyRecord(): Boolean;
    begin
        IF Status = Status::Certified THEN
            editSubForm := FALSE
        ELSE
            editSubForm := TRUE;
        "Last Date Modified" := WORKDATE;
    end;

    trigger OnOpenPage();
    begin
        IF Status = Status::Certified THEN
            editSubForm := FALSE
        ELSE
            editSubForm := TRUE;
    end;

    var
        editSubForm: Boolean;
        activeVersion: Code[50];
        recVersionHdr: Record 50017;
        pgVersion: Page 50043;
        pgVersionSpecs: Page 50043;
}

