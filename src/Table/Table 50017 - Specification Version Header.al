table 50017 "Specification Version Header"
{
    // version PCPL/QC/V3/001,PCPL QC/03/BRB

    // //PCPL QC 03/BRB Field Added

    //DrillDownPageID = 50234;
    //LookupPageID = 50234;

    fields
    {
        field(1; "Specs ID"; Code[50])
        {
            NotBlank = true;
        }
        field(2; Description; Text[250])
        {
        }
        field(5; "Version Code"; Code[50])
        {
        }
        field(6; "Reason Code"; Code[20])
        {
            TableRelation = "Reason Code".Code;
        }
        field(8; "Starting Date"; Date)
        {
        }
        field(10; Status; Option)
        {
            OptionCaption = 'New,Under Development,Certified,Closed';
            OptionMembers = New,"Under Development",Certified,Closed;
        }
        field(11; "Last Date Modified"; Date)
        {
            Editable = false;
        }
        field(13; "Created By"; Code[30])
        {
        }
        field(14; "Modified By"; Code[30])
        {
        }
        field(15; "Specification Type"; Option)
        {
            Description = '//PCPL QC 03/BRB';
            OptionCaption = '" ,IP,BP,USP"';
            OptionMembers = " ",IP,BP,USP;
        }
    }

    keys
    {
        key(Key1; "Specs ID", "Version Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        recSpec.GET("Specs ID");
        IF "Version Code" = '' THEN BEGIN
            recSpec.TESTFIELD("Version Nos.");
            "Version Code" := NoSeriesMgt.GetNextNo(recSpec."Version Nos.", WORKDATE, TRUE);
        END;
        "Last Date Modified" := WORKDATE;
        "Created By" := USERID;
    end;

    trigger OnModify();
    begin
        "Modified By" := USERID;
        "Last Date Modified" := WORKDATE;
    end;

    var
        recSpec: Record 50015;
        NoSeriesMgt: Codeunit 396;
}

