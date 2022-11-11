table 50020 "Inspection Data Receipt"
{
    // version PCPL/QC/V3/001

    Permissions =;

    fields
    {
        field(1; "No."; Code[20])
        {
            NotBlank = true;
        }
        field(2; "Document Type"; Option)
        {
            OptionCaption = 'Purch. Order,Prod. Order,Transfer,Sales Return,Code-to-Code';
            OptionMembers = "Purch. Order","Prod. Order",Transfer,"Sales Return","Code-to-Code";
        }
        field(3; "Document No."; Code[20])
        {
        }
        field(4; "Posting Date"; Date)
        {
        }
        field(5; Quantity; Decimal)
        {
        }
        field(6; "Ref ID"; Integer)
        {
        }
        field(7; "Specs ID"; Code[50])
        {
        }
        field(9; "Document Date"; Date)
        {
        }
        field(11; "Prod. Order Date"; Date)
        {
        }
        field(15; "Lot No."; Code[20])
        {
            TableRelation = "Lot No. Information"."Lot No." WHERE("Lot No." = FIELD("Lot No."),
                                                                   "Item No." = FIELD("Item No."));
        }
        field(16; "Purch. Order Quantity"; Decimal)
        {
        }
        field(18; "Location Code"; Code[20])
        {
            Editable = false;
            TableRelation = Location;
        }
        field(19; "Bin Code"; Code[20])
        {
            Editable = false;
            TableRelation = Bin.Code WHERE("Location Code" = FIELD("Location Code"));
        }
        field(20; "Vendor No."; Code[20])
        {
            TableRelation = Vendor."No.";
        }
        field(21; "Vendor Name"; Text[50])
        {
        }
        field(25; "Item No."; Code[20])
        {
            TableRelation = Item."No.";
        }
        field(26; "Item Description"; Text[50])
        {
        }
        field(27; "Item Description 2"; Text[50])
        {
        }
        field(28; "Unit of Messure"; Code[10])
        {
            TableRelation = "Unit of Measure".Code;
        }
        field(30; "Item Tracking"; Boolean)
        {
        }
        field(35; Remarks; Text[250])
        {
        }
        field(50; "Certificate No."; Code[50])
        {
            Editable = false;
        }
        field(55; "GRN No."; Code[20])
        {
            TableRelation = "Purch. Rcpt. Header"."No.";
        }
        field(56; "GRN Date"; Date)
        {
        }
        field(57; "GRN Quantity"; Decimal)
        {
        }
        field(60; "Prod. Order Quantity"; Decimal)
        {
        }
        field(65; "Before GRN"; Boolean)
        {
        }
        field(70; "Transfer Receipt No."; Code[20])
        {
            Description = 'TR0001';
            Editable = false;
        }
        field(71; "Transfer Receipt Quantity"; Decimal)
        {
            Description = 'TR0001';
            Editable = false;
        }
        field(72; "Transfer Receipt Date"; Date)
        {
            Description = 'TR0001';
            Editable = false;
        }
        field(80; "Return Receipt No."; Code[20])
        {
            Description = 'RET001';
            Editable = false;
        }
        field(81; "Return Receipt Quantity"; Decimal)
        {
            Description = 'RET001';
            Editable = false;
        }
        field(82; "Return Receipt Date"; Date)
        {
            Description = 'RET001';
            Editable = false;
        }
        field(85; "Customer No."; Code[20])
        {
            Description = 'RET001';
            Editable = false;
        }
        field(86; "Customer Name"; Text[50])
        {
            Description = 'RET001';
            Editable = false;
        }
        field(90; Approval; Option)
        {
            Description = 'IRLQC/CUST/004';
            OptionCaption = 'WIP,Under Approval,Approved,Rejected,Partially Approved';
            OptionMembers = WIP,"Under Approval",Approved,Rejected,"Partially Approved";
        }
        field(100; Status; Option)
        {
            OptionCaption = 'Open,Release,Under Test';
            OptionMembers = Open,Release,"Under Test";
        }
        field(101; "QA Reviewed"; Boolean)
        {
        }
        field(102; "Reviewed By"; Code[30])
        {
        }
        field(103; "Reviewed On"; Date)
        {
        }
        field(120; "Approved Quantity"; Decimal)
        {
            DecimalPlaces = 5 : 5;
            MinValue = 0;
        }
        field(125; "Rejected Quantity"; Decimal)
        {
            DecimalPlaces = 5 : 5;
            MinValue = 0;
        }
        field(130; "Inspection Sheet No."; Code[20])
        {
        }
        field(150; "Sample Drawn Quantity"; Decimal)
        {
            MinValue = 0;
        }
        field(151; "Mfg. Date"; Date)
        {
            Editable = false;
        }
        field(152; "Analyzed on"; Date)
        {
        }
        field(153; "Retest on"; Date)
        {
            Editable = false;
        }
        field(154; "Sample Drawn On"; Date)
        {
        }
        field(155; "Manufacturer Code"; Code[20])
        {
            //TableRelation = Table50092.Field2 WHERE(Field1 = FIELD("Item No."));

            trigger OnValidate();
            begin
                IF "Manufacturer Code" <> '' THEN
                    recVendor.GET("Manufacturer Code");

                "Manufacturer Name" := recVendor.Name;
            end;
        }
        field(156; "Manufacturer Name"; Text[50])
        {
            Editable = false;
        }
        field(157; "Control Sample Quantity"; Decimal)
        {
        }
        field(158; "Posted Sample Quanity"; Decimal)
        {
            CalcFormula = - Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("Item No."),
                                                                   "Document No." = FIELD("Inspection Sheet No."),
                                                                   "Lot No." = FIELD("Lot No."),
                                                                   "Location Code" = FIELD("Location Code")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(160; "Sample UOM"; Code[20])
        {
            Editable = false;
            TableRelation = "Unit of Measure";
        }
        field(180; "COA Printed"; Boolean)
        {
        }
        field(190; "Whse. Document No."; Code[20])
        {
        }
        field(199; "Inspected By"; Code[30])
        {
        }
        field(200; "Approved By"; Code[30])
        {
        }
        field(220; "Retest Document"; Boolean)
        {
            Editable = false;
        }
        field(221; "Retest from Doc No"; Code[20])
        {
            Editable = false;
        }
        field(250; "Replanned Prod. Order"; Code[20])
        {
            TableRelation = "Production Order"."No." WHERE(Status = FILTER(Released));
        }
        field(251; "Replanned Item No."; Code[20])
        {
            TableRelation = Item;
        }
        field(252; "File Attach"; BLOB)
        {
            Description = '//PCPL/BRB';
        }
        field(253; Extension; Text[250])
        {
            Description = '//for extension';
        }
        field(300; "Pending Inspection"; Integer)
        {
            CalcFormula = Count("Inspection Data Sheet" WHERE("Certificate No." = FIELD("Certificate No."),
                                                               "Item No." = FIELD("Item No."),
                                                               "Lot No." = FIELD("Lot No."),
                                                               Approval = FILTER(WIP)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(301; "Total Inspection"; Integer)
        {
            CalcFormula = Count("Inspection Data Sheet" WHERE("Certificate No." = FIELD("Certificate No."),
                                                               "Item No." = FIELD("Item No.")));
            FieldClass = FlowField;
        }
        field(50001; "EXP Date"; Date)
        {
            Description = '//PCPL/BRB';
            Editable = false;
        }
        field(50002; "External Lot No."; Code[35])
        {
            CalcFormula = Lookup("Lot No. Information"."External Lot No." WHERE("Item No." = FIELD("Item No."),
                                                                                 "Lot No." = FIELD("Lot No.")));
            Description = 'PCPL/QC/V3/001';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50003; "Outer Package"; Text[30])
        {
        }
        field(50004; "Inner Package"; Text[30])
        {
        }
        field(50005; SampleUOM; Text[30])
        {
        }
        field(50006; "No. Container Sample"; Text[30])
        {
        }
        field(50007; "Sample By"; Text[30])
        {
        }
        field(50008; "Prod. Packing Detail"; Text[250])
        {
        }
        field(50009; "RM Packing Detail"; Text[250])
        {
            Description = 'PCPL-BRB';
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
        key(Key2; "Lot No.")
        {
        }
        key(Key3; "Document No.", "Ref ID", "Item No.", Approval)
        {
            SumIndexFields = Quantity;
        }
    }

    fieldgroups
    {
    }

    var
        recVendor: Record 23;
        Text001: TextConst ENU = 'You must first set up user %1 as a warehouse employee.', ENN = 'You must first set up user %1 as a warehouse employee.';

    procedure FindFirstAllowedRec(Which: Text[1024]): Boolean;
    var
        InspectionDataReceipt: Record 50020;
        WMSManagement: Codeunit 7302;
    begin
        IF FIND(Which) THEN BEGIN
            InspectionDataReceipt := Rec;
            WHILE TRUE DO BEGIN
                IF WMSManagement.LocationIsAllowedToView("Location Code") THEN
                    EXIT(TRUE);

                IF NEXT(1) = 0 THEN BEGIN
                    Rec := InspectionDataReceipt;
                    IF FIND(Which) THEN
                        WHILE TRUE DO BEGIN
                            IF WMSManagement.LocationIsAllowedToView("Location Code") THEN
                                EXIT(TRUE);

                            IF NEXT(-1) = 0 THEN
                                EXIT(FALSE);
                        END;
                END;
            END;
        END;
        EXIT(FALSE);
    end;

    procedure FindNextAllowedRec(Steps: Integer): Integer;
    var
        InspectionDataReceipt: Record 50020;
        WMSManagement: Codeunit 7302;
        RealSteps: Integer;
        NextSteps: Integer;
    begin
        RealSteps := 0;
        IF Steps <> 0 THEN BEGIN
            InspectionDataReceipt := Rec;
            REPEAT
                NextSteps := NEXT(Steps / ABS(Steps));
                IF WMSManagement.LocationIsAllowedToView("Location Code") THEN BEGIN
                    RealSteps := RealSteps + NextSteps;
                    InspectionDataReceipt := Rec;
                END;
            UNTIL (NextSteps = 0) OR (RealSteps = Steps);
            Rec := InspectionDataReceipt;
            IF NOT FIND THEN;
        END;
        EXIT(RealSteps);
    end;

    procedure ErrorIfUserIsNotWhseEmployee();
    var
        WhseEmployee: Record 7301;
    begin
        IF USERID <> '' THEN BEGIN
            WhseEmployee.SETRANGE("User ID", USERID);
            IF NOT WhseEmployee.FINDFIRST THEN
                ERROR(Text001, USERID);
        END;
    end;

    procedure GetUserLocation(): Code[10];
    var
        WarehouseEmployee: Record 7301;
    begin
        WarehouseEmployee.SETCURRENTKEY(Default);
        WarehouseEmployee.SETRANGE("User ID", USERID);
        WarehouseEmployee.SETRANGE(Default, TRUE);
        IF WarehouseEmployee.FINDFIRST THEN
            EXIT(WarehouseEmployee."Location Code");

        WarehouseEmployee.SETRANGE(Default);
        WarehouseEmployee.FINDFIRST;
        EXIT(WarehouseEmployee."Location Code");
    end;
}

