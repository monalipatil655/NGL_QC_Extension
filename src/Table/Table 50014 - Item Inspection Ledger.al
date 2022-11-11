table 50014 "Item Inspection Ledger"
{
    // version PCPL/QC/V3/001


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
        field(4; "Line No."; Integer)
        {
        }
        field(5; "Document Date"; Date)
        {
        }
        field(6; "Ref ID"; Integer)
        {
        }
        field(10; "Posting Date"; Date)
        {
        }
        field(11; Quantity; Decimal)
        {
        }
        field(15; "Lot No."; Code[20])
        {
        }
        field(18; "Location Code"; Code[20])
        {
            TableRelation = Location;
        }
        field(19; "Bin Code"; Code[10])
        {
            Editable = false;
            TableRelation = Bin.Code WHERE("Location Code" = FIELD("Location Code"));
        }
        field(20; "Transaction Type"; Option)
        {
            OptionCaption = 'Entry,Receipt,Posted';
            OptionMembers = Entry,Receipt,Posted;
        }
        field(25; "Item No."; Code[20])
        {
        }
        field(26; "Item Description"; Text[50])
        {
        }
        field(27; "Item Description 2"; Text[50])
        {
        }
        field(28; "Unit of Messure"; Code[10])
        {
        }
        field(30; "Item Tracking"; Boolean)
        {
        }
        field(31; "Qty Accepted"; Decimal)
        {
        }
        field(32; "Qty Rejected"; Decimal)
        {
        }
        field(35; "Inspection Receipt No."; Code[20])
        {
        }
        field(50; "Certificate No."; Code[50])
        {
        }
        field(55; "GRN No."; Code[20])
        {
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
        field(90; Approval; Option)
        {
            OptionCaption = 'WIP,Under Approval,Approved,Rejected';
            OptionMembers = WIP,"Under Approval",Approved,Rejected;
        }
        field(100; Status; Option)
        {
            OptionCaption = 'Open,Release,Under Test';
            OptionMembers = Open,Release,"Under Test";
        }
        field(150; "Retest Document"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "No.", "Transaction Type", Approval)
        {
        }
    }

    fieldgroups
    {
    }
}

