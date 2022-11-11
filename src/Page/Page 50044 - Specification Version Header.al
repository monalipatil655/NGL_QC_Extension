page 50044 "Specification Version Header"
{
    // version PCPL/QC/V3/001,PCPL QC/03/BRB

    PageType = ListPlus;
    SourceTable = 50017;
    SourceTableView = SORTING("Specs ID")
                      ORDER(Ascending);

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Version Code"; "Version Code")
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
                field("Starting Date"; "Starting Date")
                {
                    ApplicationArea = all;
                }
                field("Last Date Modified"; "Last Date Modified")
                {
                    ApplicationArea = all;
                }
                field("Specification Type"; "Specification Type")
                {
                    ApplicationArea = all;
                }
            }
            part(specsline; 50045)
            {
                Editable = editSubForm;
                SubPageLink = "Specs ID" = FIELD("Specs ID"),
                              "Version Code" = FIELD("Version Code");
                SubPageView = SORTING("Specs ID", "Line No.")
                              ORDER(Ascending);
            }
        }
    }

    actions
    {
        area(processing)
        {
        }
    }

    trigger OnAfterGetRecord();
    begin
        IF Status = Status::Certified THEN
            editSubForm := FALSE
        ELSE
            editSubForm := TRUE;
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
        activeVersion: Code[20];
}

