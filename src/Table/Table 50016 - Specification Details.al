table 50016 "Specification Details"
{
    // version PCPL/QC/V3/001,QC3.0


    fields
    {
        field(1; "Specs ID"; Code[50])
        {
            NotBlank = true;
            TableRelation = "Specification Header"."Specs ID";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Account Type"; Option)
        {
            OptionCaption = 'Begin,Posting,End';
            OptionMembers = "Begin",Posting,"End";
        }
        field(4; "Qlty Measure Code"; Code[10])
        {
            Caption = 'Quality Measure Code';
            NotBlank = true;
            TableRelation = IF ("Account Type" = FILTER(Posting)) "Quality Measure";

            trigger OnValidate();
            begin
                //PCPL

                IF "Account Type" = "Account Type"::Posting THEN BEGIN
                    QltyMeasure.GET("Qlty Measure Code");
                    Description := QltyMeasure.Description;
                    Qualitative := QltyMeasure.Qualitative;
                    "Unit of Measure" := QltyMeasure."Unit of Measure";
                END;
            end;
        }
        field(5; Description; Text[250])
        {
            Caption = 'Description';
            Description = 'QC3.0';
        }
        field(6; "Min. Value"; Decimal)
        {
            Caption = 'Min. Value';
            DecimalPlaces = 0 : 5;

            trigger OnValidate();
            begin
                //PCPL
                TESTFIELD(Qualitative, FALSE);
            end;
        }
        field(7; "Max. Value"; Decimal)
        {
            Caption = 'Max. Value';
            DecimalPlaces = 0 : 5;

            trigger OnValidate();
            begin
                //PCPL
                TESTFIELD(Qualitative, FALSE);
            end;
        }
        field(8; "Mean Tolerance"; Decimal)
        {
            Caption = 'Mean Tolerance';
            DecimalPlaces = 0 : 5;

            trigger OnValidate();
            begin
                //PCPL
                TESTFIELD(Qualitative, FALSE);
            end;
        }
        field(9; "Text Value"; Text[250])
        {

            trigger OnValidate();
            begin
                //TESTFIELD(Qualitative);     IRLQC/CUST/004
            end;
        }
        field(10; "Unit of Measure"; Code[10])
        {
            TableRelation = "Quality Unit of Measure";
        }
        field(11; Qualitative; Boolean)
        {
        }
        field(12; "Test Manadatory"; Boolean)
        {
        }
        field(13; "Test Method"; Text[50])
        {
        }
        field(14; "Laboratory Details"; Text[50])
        {
        }
        field(16; "Specification Reference"; Text[50])
        {
        }
        field(17; "Protocol No."; Integer)
        {
            Editable = false;
        }
        field(20; "Group Code"; Code[20])
        {
            TableRelation = IF ("Account Type" = FILTER(Begin | End)) "Specification Group";

            trigger OnValidate();
            begin
                //PCPL

                IF "Account Type" = "Account Type"::"Begin" THEN BEGIN
                    recGroup.GET("Group Code");
                    Description := recGroup.Description;
                END
                ELSE
                    IF "Account Type" = "Account Type"::"End" THEN BEGIN
                        recGroup.GET("Group Code");
                        Description := recGroup.Description + ' END';
                    END
                    ELSE
                        ERROR('Account Type must not be posting');
                //PCPL
            end;
        }
        field(21; "Parent Group Code"; Code[20])
        {
            TableRelation = "Specification Group";
        }
        field(25; Retest; Boolean)
        {
        }
        field(30; "Version Code"; Code[50])
        {
            TableRelation = "Specification Version Header"."Version Code" WHERE("Specs ID" = FIELD("Specs ID"));
        }
        field(50000; "Additional Text Value"; Text[250])
        {
            Description = 'QC3.0';
        }
        field(50001; "Additional Text Value 2"; Text[250])
        {
            Description = 'QC3.0';
        }
        field(50002; "Additional Text Value 3"; Text[250])
        {
            Description = 'QC3.0';
        }
    }

    keys
    {
        key(Key1; "Specs ID", "Version Code", "Line No.")
        {
        }
        key(Key2; "Parent Group Code")
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


        //PCPL
        /*//210218
        IF "Account Type"="Account Type"::"Begin" THEN
          Description:='BEGIN'
        ELSE
        
        IF "Account Type"="Account Type"::"End" THEN
          Description:='END';
        */

        recSpecification.RESET;
        recSpecification.SETCURRENTKEY("Specs ID", "Version Code", "Line No.");
        recSpecification.SETRANGE(recSpecification."Specs ID", "Specs ID");
        recSpecification.SETRANGE(recSpecification."Version Code", "Version Code");
        recSpecification.SETFILTER(recSpecification."Line No.", '<=%1', "Line No.");
        recSpecification.SETRANGE(recSpecification."Account Type", recSpecification."Account Type"::"Begin");
        IF recSpecification.FINDLAST THEN
            "Parent Group Code" := recSpecification."Group Code";

        IF "Account Type" = "Account Type"::"Begin" THEN BEGIN
            recGroup.GET("Group Code");
            Description := recGroup.Description;
            "Parent Group Code" := "Group Code";
        END
        ELSE
            IF "Account Type" = "Account Type"::"End" THEN BEGIN
                recGroup.GET("Parent Group Code");
                Description := recGroup.Description + ' END';
            END;
        //PCPL

    end;

    trigger OnModify();
    begin
        //PermissionCheck;

        //IF RoleAccess = FALSE THEN BEGIN
        //   ERROR('You Do Not have Permission to Modify Records');
        //END;


        /*IF "Account Type"="Account Type"::"Begin" THEN
          Description:='BEGIN'
        ELSE
        IF "Account Type"="Account Type"::"End" THEN
          Description:='END'
        */

        //PCPL

        IF "Account Type" = "Account Type"::"Begin" THEN BEGIN
            recGroup.GET("Group Code");
            Description := recGroup.Description;
            "Parent Group Code" := "Group Code";
        END
        ELSE
            IF "Account Type" = "Account Type"::"End" THEN BEGIN
                recGroup.GET("Parent Group Code");
                Description := recGroup.Description + ' END';
            END;
        recSpecification.RESET;
        recSpecification.SETCURRENTKEY("Specs ID", "Version Code", "Line No.");
        recSpecification.SETRANGE(recSpecification."Specs ID", "Specs ID");
        recSpecification.SETRANGE(recSpecification."Version Code", "Version Code");
        recSpecification.SETFILTER(recSpecification."Line No.", '<=%1', "Line No.");
        recSpecification.SETRANGE(recSpecification."Account Type", recSpecification."Account Type"::"Begin");
        IF recSpecification.FINDLAST THEN
            "Parent Group Code" := recSpecification."Group Code";
        //PCPL

    end;

    trigger OnRename();
    begin
        //PermissionCheck;

        //IF RoleAccess = FALSE THEN BEGIN
        //   ERROR('You Do Not have Permission to Rename Records');
        //END;
    end;

    var
        QltyMeasure: Record 99000785;
        recGroup: Record 50019;
        recSpecification: Record 50016;
        recUserSetup: Record 91;
        RecUserPermission: Record 2000000053;
        USID: Text;
        RoleAccess: Boolean;

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

