table 50015 "Specification Header"
{
    // version PCPL/QC/V3/001

    DrillDownPageID = 50040;
    LookupPageID = 50040;
    //Permissions = TableData 50131 = rimd;

    fields
    {
        field(1; "Specs ID"; Code[50])
        {

            trigger OnValidate();
            begin
                IF "Specs ID" <> xRec."Specs ID" THEN BEGIN
                    recQCSetup.GET;
                    recQCSetup.TESTFIELD(recQCSetup."Specification No. Series");
                    NoSeriesMgt.TestManual(recQCSetup."Specification No. Series");
                END;
            end;
        }
        field(2; Description; Text[250])
        {
        }
        field(5; "Version Nos."; Code[50])
        {
            TableRelation = "No. Series";
        }
        field(10; Status; Option)
        {
            OptionCaption = 'New,Under Development,Certified,Closed';
            OptionMembers = New,"Under Development",Certified,Closed;

            trigger OnValidate();
            begin
                /*//pcpl/BRB
                IF Status=Status::Certified THEN
                BEGIN
                  SpecsDetails.RESET;
                  SpecsDetails.SETRANGE(SpecsDetails."Specs ID","Specs ID");
                  SpecsDetails.SETRANGE(SpecsDetails."Version Code",'');
                  SpecsDetails.SETRANGE(SpecsDetails."Account Type",SpecsDetails."Account Type"::Posting);
                  IF SpecsDetails.FINDSET THEN
                  REPEAT
                    SpecsDetails.TESTFIELD(SpecsDetails."Parent Group Code");
                    IF NOT SpecsDetails.Qualitative THEN
                    BEGIN
                      SpecsDetails.TESTFIELD(SpecsDetails."Unit of Measure");
                      SpecsDetails.TESTFIELD(SpecsDetails."Min. Value");
                      SpecsDetails.TESTFIELD(SpecsDetails."Max. Value");
                      SpecsDetails.TESTFIELD(SpecsDetails."Text Value",'')
                    END
                    ELSE
                    BEGIN
                      SpecsDetails.TESTFIELD(SpecsDetails."Unit of Measure",'');
                      SpecsDetails.TESTFIELD(SpecsDetails."Min. Value",0);
                      SpecsDetails.TESTFIELD(SpecsDetails."Max. Value",0);
                      SpecsDetails.TESTFIELD(SpecsDetails."Text Value");
                    END;
                  UNTIL SpecsDetails.NEXT=0;
                END;
                */

            end;
        }
        field(11; "Last Date Modified"; Date)
        {
            Editable = true;
            Enabled = true;
        }
        field(12; "Creation Date"; Date)
        {
        }
        field(13; "Created By"; Code[30])
        {
        }
        field(14; "Modified By"; Code[30])
        {
        }
    }

    keys
    {
        key(Key1; "Specs ID")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        //PermissionCheck;

        //IF RoleAccess = FALSE THEN BEGIN
        //   ERROR('You Do Not have Permission to Delete Records');
        //END;
    end;

    trigger OnInsert();
    begin
        //PermissionCheck;

        //IF RoleAccess = FALSE THEN BEGIN
        //   ERROR('You Do Not have Permission to Insert Records');
        //END;


        recQCSetup.GET;
        recQCSetup.TESTFIELD("Specification No. Series");
        IF "Specs ID" = '' THEN
            "Specs ID" := NoSeriesMgt.GetNextNo(recQCSetup."Specification No. Series", WORKDATE, TRUE);
        "Last Date Modified" := WORKDATE;
        "Creation Date" := WORKDATE;
        "Created By" := USERID;
        "Version Nos." := recQCSetup."Specs Version No. Series";
    end;

    trigger OnModify();
    begin
        //PermissionCheck;

        //IF RoleAccess = FALSE THEN BEGIN
        //   ERROR('You Do Not have Permission to Modify Records');
        //END;


        "Last Date Modified" := WORKDATE;
        "Modified By" := USERID;
    end;

    trigger OnRename();
    begin
        //PermissionCheck;

        //IF RoleAccess = FALSE THEN BEGIN
        //   ERROR('You Do Not have Permission to Rename Records');
        //END;
    end;

    var
        recQCSetup: Record 50010;
        NoSeriesMgt: Codeunit 396;
        SpecsDetails: Record 50016;
        recUserSetup: Record 91;
        RecUserPermission: Record 2000000053;
        USID: Text;
        RoleAccess: Boolean;
        SpecificationSubForm: Page 50042;

    procedure GetVersion(vSpecID: Code[50]) vVersionCode: Code[10];
    var
        recSpecsVersion: Record 50017;
    begin
        recSpecsVersion.RESET;
        recSpecsVersion.SETRANGE(recSpecsVersion."Specs ID", vSpecID);
        recSpecsVersion.SETRANGE(recSpecsVersion."Starting Date", 0D, WORKDATE);
        recSpecsVersion.SETRANGE(recSpecsVersion.Status, recSpecsVersion.Status::Certified);
        IF recSpecsVersion.FINDLAST THEN
            EXIT(recSpecsVersion."Version Code");
    end;

    procedure PermissionCheck();
    begin
        CLEAR(USID);
        RecUserPermission.RESET;
        RecUserPermission.SETRANGE(RecUserPermission."User Security ID", USERSECURITYID);
        IF RecUserPermission.FINDSET THEN BEGIN
            REPEAT
                USID := RecUserPermission."Role ID";
                IF (USID = 'SUPER') OR (USID = 'QC - ROLE') THEN BEGIN  // (USID = 'SUPER') OR
                    RoleAccess := TRUE;
                END;


            UNTIL RecUserPermission.NEXT = 0;
        END;
    end;
}

