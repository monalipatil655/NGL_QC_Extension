table 50021 "Inspection Receipt Line"
{
    // version PCPL/QC/V3/001,QC3.0


    fields
    {
        field(1; "No."; Code[20])
        {
        }
        field(2; "Document Type"; Option)
        {
            OptionCaption = 'Purch. Order,Prod. Order,Transfer,Sales Return,Code-to-Code';
            OptionMembers = "Purch. Order","Prod. Order",Transfer,"Sales Return","Code-to-Code";
        }
        field(3; "Document No."; Code[20])
        {
        }
        field(4; "Item No."; Code[10])
        {
        }
        field(5; "Qc Description"; Text[250])
        {
            Caption = 'Description';
            Description = 'QC3.0';
        }
        field(6; "Qlty Measure Code"; Code[10])
        {
            Caption = 'QC Measure Code';
            TableRelation = "Quality Measure".Code;

            trigger OnValidate();
            begin
                IF "Qlty Measure Code" = '' THEN
                    EXIT;

                QltyMeasure.GET("Qlty Measure Code");
                "Qc Description" := QltyMeasure.Description;
            end;
        }
        field(7; "Account Type"; Option)
        {
            OptionCaption = 'Begin,Posting,End';
            OptionMembers = "Begin",Posting,"End";
        }
        field(9; "Posting Date"; Date)
        {
        }
        field(10; "Min. Value"; Decimal)
        {
            Caption = 'Min. Value';
            DecimalPlaces = 0 : 5;
        }
        field(11; "Max. Value"; Decimal)
        {
            Caption = 'Max. Value';
            DecimalPlaces = 0 : 5;
        }
        field(12; "Actual Value"; Decimal)
        {
            DecimalPlaces = 5 : 5;

            trigger OnValidate();
            begin
                QltyMeasure.GET("Qlty Measure Code");
                IF QltyMeasure.Qualitative THEN
                    ERROR('You can not enter quantitative value in place of qualitative measure');
            end;
        }
        field(13; "Text Value"; Text[250])
        {
        }
        field(15; "Unit of Measure"; Code[10])
        {
            TableRelation = "Unit of Measure";
        }
        field(16; "Test Mandatory"; Boolean)
        {
        }
        field(17; Qualitative; Boolean)
        {
        }
        field(18; Complies; Boolean)
        {
        }
        field(19; "Actual Text Value"; Text[250])
        {
        }
        field(21; "Parent Group Code"; Code[20])
        {
            Editable = false;
            TableRelation = "Specification Group";
        }
        field(25; Remark; Text[80])
        {
        }
        field(31; "Purchase Order No."; Code[20])
        {
        }
        field(32; "Purchase Line No."; Integer)
        {
        }
        field(33; "Chemist Code"; Code[10])
        {
            TableRelation = Employee."No.";
        }
        field(50; "Line No."; Integer)
        {
        }
        field(100; Status; Option)
        {
            OptionCaption = 'Open,Release';
            OptionMembers = Open,Release;
        }
        field(50000; "Reject/Retest QC"; Boolean)
        {
        }
        field(50002; "Additional Text Value"; Text[250])
        {
            Description = 'QC3.0';
        }
        field(50003; "Additional Text Value 2"; Text[250])
        {
            Description = 'QC3.0';
        }
        field(50004; "Additional Text Value 3"; Text[250])
        {
            Description = 'QC3.0';
        }
        field(50005; "Actual Additional Text"; Text[250])
        {
            Description = 'QC3.0';
        }
        field(50006; "Actual Additional Text 2"; Text[250])
        {
            Description = 'QC3.0';
        }
        field(50007; "Actual Additional Text 3"; Text[250])
        {
            Description = 'QC3.0';
        }
    }

    keys
    {
        key(Key1; "No.", "Line No.")
        {
        }
        key(Key2; "Posting Date")
        {
        }
    }

    fieldgroups
    {
    }

    var
        QltyMeasure: Record 99000785;
}

