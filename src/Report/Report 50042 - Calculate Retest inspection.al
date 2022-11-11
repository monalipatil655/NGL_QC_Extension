report 50042 "Calculate Retest inspection"
{
    // version RSPL/QC/V3/001

    ProcessingOnly = true;

    dataset
    {
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                field("Location Code"; cdLocation)
                {
                    TableRelation = Location;
                }
                field("Starting Date"; startDate)
                {
                }
                field("Date Formula"; DateCalc)
                {
                }
            }
        }

        actions
        {
        }

        trigger OnInit();
        begin
            startDate := WORKDATE;
        end;
    }

    labels
    {
    }

    trigger OnPostReport();
    begin
        PostedInspection.RESET;
        PostedInspection.SETFILTER(PostedInspection.Approval, '%1|%2', PostedInspection.Approval::Approved, PostedInspection.Approval::"Partially Approved");
        PostedInspection.SETFILTER(PostedInspection."Document Type", '%1|%2|%3', PostedInspection."Document Type"::"Prod. Order", PostedInspection."Document Type"::"Purch. Order", PostedInspection."Document Type"::Transfer); //PCPl-25
        PostedInspection.SETRANGE(PostedInspection."Retest on", startDate, toDate);
        PostedInspection.SETRANGE(PostedInspection."Location Code", cdLocation);
        IF PostedInspection.FINDSET THEN
            REPEAT
                //PCPL-25
                ILE.RESET;
                ILE.SETRANGE(ILE."Item No.", PostedInspection."Item No.");
                ILE.SETRANGE(ILE."Lot No.", PostedInspection."Lot No.");
                ILE.SETRANGE(ILE."Location Code", cdLocation);
                ILE.SETFILTER(ILE."Remaining Quantity", '<>%1', 0);
                IF ILE.FINDFIRST THEN BEGIN
                    BinContent.RESET;
                    BinContent.SETRANGE("Item No.", ILE."Item No.");
                    BinContent.SETRANGE("Location Code", cdLocation);
                    BinContent.SETFILTER(Quantity, '<>%1', 0);
                    IF BinContent.FINDFIRST THEN BEGIN
                        //PCPL-25
                        InspectionRetest.INIT;
                        InspectionRetest."No." := PostedInspection."No.";
                        InspectionRetest."Document Type" := PostedInspection."Document Type";
                        InspectionRetest."Document No." := PostedInspection."Document No.";
                        InspectionRetest."Posting Date" := PostedInspection."Posting Date";
                        InspectionRetest."Location Code" := cdLocation;
                        InspectionRetest."Item No." := PostedInspection."Item No.";
                        InspectionRetest."Retest Date" := PostedInspection."Retest on";
                        InspectionRetest."Lot No." := PostedInspection."Lot No.";
                        InspectionRetest."AR No." := PostedInspection."Certificate No.";
                        InspectionRetest."Send for Retest" := FALSE;
                        //PCPL-25
                        IF REcItem.GET(InspectionRetest."Item No.") THEN
                            InspectionRetest.VALIDATE("Item Description", REcItem.Description);
                        InspectionRetest.VALIDATE("Mfg.Date", PostedInspection."Mfg. Date");
                        InspectionRetest.VALIDATE("Exp.Date", PostedInspection."EXP Date");
                        InspectionRetest.VALIDATE("Remaining Quantity", ILE."Remaining Quantity");
                        InspectionRetest.VALIDATE("Bin Code", BinContent."Bin Code");
                        //PCPL-25
                        InspectionRetest.INSERT;
                    END;
                END;
            UNTIL PostedInspection.NEXT = 0;
    end;

    trigger OnPreReport();
    begin
        toDate := CALCDATE(DateCalc, startDate);
        IF cdLocation = '' THEN
            ERROR('Location code must not be blank');
    end;

    var
        startDate: Date;
        DateCalc: DateFormula;
        cdLocation: Code[20];
        toDate: Date;
        PostedInspection: Record 50022;
        InspectionRetest: Record 50013;
        BinContent: Record 7302;
        ILE: Record 32;
        REcItem: Record 27;
        WarehouseEntry: Record 7312;
}

