table 50022 "Posted Inspection"
{
    // version PCPL/QC/V3/001,PCPL/PosIns/INCDoc,PCPL/FinishedProd/INCDoc

    DrillDownPageID = 50048;
    LookupPageID = 50048;

    fields
    {
        field(1; "No."; Code[20])
        {
            NotBlank = true;
        }
        field(2; "Document Type"; Option)
        {
            OptionCaption = 'Purch. Order,Prod. Order,Transfer,Sales Return,Code-to-Code,Positive Adjmnt';
            OptionMembers = "Purch. Order","Prod. Order",Transfer,"Sales Return","Code-to-Code","Positive Adjmnt";
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
            MinValue = 0;
        }
        field(125; "Rejected Quantity"; Decimal)
        {
            MinValue = 0;
        }
        field(130; "Inspection Sheet No."; Code[20])
        {
        }
        field(131; "Inspection Receipt No."; Code[20])
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
            // TableRelation = Table50092.Field2 WHERE (Field1=FIELD("Item No.")); //PCPL/NSW/MIG   19July22

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
                                                                   "Document No." = FIELD("No."),
                                                                   "Lot No." = FIELD("Lot No."),
                                                                   "Location Code" = FIELD("Location Code")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(160; "Sample UOM"; Code[20])
        {
            TableRelation = "Unit of Measure";
        }
        field(180; "COA Printed"; Boolean)
        {
        }
        field(188; "Conditional Released"; Boolean)
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
        field(210; "Sent for Retest"; Boolean)
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
                                                               Approval = FILTER("Under Approval")));
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
        field(50020; "Incoming Document Entry No."; Integer)
        {
            Description = 'PCPL/PosIns/INCDoc';
        }
        field(50021; "Incoming Document Attached"; Boolean)
        {
            Description = 'PCPL50';
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
}

