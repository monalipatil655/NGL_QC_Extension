codeunit 50006 "Transfer Inspection Creation"
{
    // version PCPL/QC/V3/001,TR0001,PCPL/CUST/QC/IRL/002,QC3.0


    trigger OnRun();
    begin
    end;

    var
        recTransHeader: Record 5740;
        recTransLine: Record 5741;
        recReservationEntry: Record 337;
        NoSeriesMgmt: Codeunit 396;
        cduQltyMgmt: Codeunit 50005;
        ReservationEntry: Record 337;
        SKU: Record 5700;
        recItem: Record 27;

    procedure fctTransSplitEntry(var TransferHeader: Record 5740; TransferRcpt: Record 5746; Bin: Code[10]);
    var
        specs: Record 50015;
        SpecsDetails: Record 50016;
        specsVersion: Record 50017;
    begin
        recTransHeader := TransferHeader;
        WITH recTransHeader DO BEGIN
            recTransLine.RESET;
            recTransLine.SETRANGE(recTransLine."Document No.", "No.");
            recTransLine.SETFILTER(recTransLine."Qty. to Receive", '<>%1', 0);
            IF recTransLine.FINDSET THEN
                REPEAT
                    SKU.RESET;
                    SKU.SETRANGE(SKU."Item No.", recTransLine."Item No.");
                    SKU.SETRANGE(SKU."Location Code", recTransLine."Transfer-to Code");
                    IF SKU.FINDSET THEN BEGIN
                        recTransLine.TESTFIELD(recTransLine."Transfer-to Code");
                        recReservationEntry.RESET;
                        recReservationEntry.SETRANGE(recReservationEntry."Item No.", recTransLine."Item No.");
                        recReservationEntry.SETRANGE(recReservationEntry."Location Code", recTransLine."Transfer-to Code");
                        recReservationEntry.SETRANGE(recReservationEntry."Source Type", 5741);
                        recReservationEntry.SETRANGE(recReservationEntry."Source ID", "No.");
                        IF recReservationEntry.FINDSET THEN
                            REPEAT
                                SKU.TESTFIELD(SKU."Specs ID");
                                specs.GET(SKU."Specs ID");
                                specs.TESTFIELD(specs.Status, specs.Status::Certified);
                                specsVersion.RESET;
                                specsVersion.SETRANGE(specsVersion."Specs ID", specs."Specs ID");
                                specsVersion.SETRANGE(specsVersion."Starting Date", 0D, "Posting Date");
                                IF specsVersion.FINDLAST THEN BEGIN
                                    SpecsDetails.RESET;
                                    SpecsDetails.SETRANGE(SpecsDetails."Specs ID", specs."Specs ID");
                                    SpecsDetails.SETRANGE(SpecsDetails."Version Code", specsVersion."Version Code");
                                    SpecsDetails.SETRANGE(SpecsDetails."Account Type", SpecsDetails."Account Type"::"Begin");
                                    IF SpecsDetails.FINDSET THEN
                                        REPEAT
                                            InitTransInspection(recTransHeader, recTransLine, recReservationEntry."Qty. to Handle (Base)", recReservationEntry."Lot No.", SpecsDetails, TransferRcpt, Bin);
                                        UNTIL SpecsDetails.NEXT = 0;
                                END
                                ELSE BEGIN
                                    SpecsDetails.RESET;
                                    SpecsDetails.SETRANGE(SpecsDetails."Specs ID", specs."Specs ID");
                                    SpecsDetails.SETRANGE(SpecsDetails."Version Code", '');
                                    SpecsDetails.SETRANGE(SpecsDetails."Account Type", SpecsDetails."Account Type"::"Begin");
                                    IF SpecsDetails.FINDSET THEN
                                        REPEAT
                                            InitTransInspection(recTransHeader, recTransLine, recReservationEntry."Qty. to Handle (Base)", recReservationEntry."Lot No.", SpecsDetails, TransferRcpt, Bin);
                                        UNTIL SpecsDetails.NEXT = 0;
                                END;
                            UNTIL recReservationEntry.NEXT = 0;
                    END;
                UNTIL recTransLine.NEXT = 0;
        END;
    end;

    procedure fctTransEntry(var TransferHeader: Record 5740; TransferRcpt: Record 5746; Bin: Code[10]);
    var
        specs: Record 50015;
        SpecsDetails: Record 50016;
        specsVersion: Record 50017;
    begin
        recTransHeader := TransferHeader;
        WITH recTransHeader DO BEGIN
            recTransLine.RESET;
            recTransLine.SETRANGE(recTransLine."Document No.", "No.");
            recTransLine.SETFILTER(recTransLine."Qty. to Receive", '<>%1', 0);
            recTransLine.SETRANGE("Derived From Line No.", 0);
            IF recTransLine.FINDSET THEN
                REPEAT
                    /*SKU.RESET;
                    SKU.SETRANGE(SKU."Item No.",recTransLine."Item No.");
                    SKU.SETRANGE(SKU."Location Code",recTransLine."Transfer-to Code");
                    IF SKU.FINDSET THEN*/
                    recItem.GET(recTransLine."Item No.");
                    IF recItem."QC Check" THEN BEGIN
                        recTransLine.TESTFIELD(recTransLine."Transfer-to Code");
                        recReservationEntry.RESET;
                        recReservationEntry.SETRANGE(recReservationEntry."Item No.", recTransLine."Item No.");
                        recReservationEntry.SETRANGE(recReservationEntry."Location Code", recTransLine."Transfer-to Code");
                        recReservationEntry.SETRANGE(recReservationEntry."Source Type", 5741);
                        recReservationEntry.SETRANGE(recReservationEntry."Source ID", "No.");
                        IF recReservationEntry.FINDSET THEN
                            REPEAT
                                specs.GET(recItem."Specs ID");
                                specs.TESTFIELD(specs.Status, specs.Status::Certified);
                                specsVersion.RESET;
                                specsVersion.SETRANGE(specsVersion."Specs ID", specs."Specs ID");
                                specsVersion.SETRANGE(specsVersion."Starting Date", 0D, "Posting Date");
                                IF specsVersion.FINDLAST THEN BEGIN
                                    SpecsDetails.RESET;
                                    SpecsDetails.SETRANGE(SpecsDetails."Specs ID", specs."Specs ID");
                                    SpecsDetails.SETRANGE(SpecsDetails."Version Code", specsVersion."Version Code");
                                    IF SpecsDetails.FINDSET THEN
                                        InitTransInspection(recTransHeader, recTransLine, recReservationEntry."Qty. to Handle (Base)", recReservationEntry."Lot No.", SpecsDetails, TransferRcpt, Bin);
                                END
                                ELSE BEGIN
                                    SpecsDetails.RESET;
                                    SpecsDetails.SETRANGE(SpecsDetails."Specs ID", specs."Specs ID");
                                    SpecsDetails.SETRANGE(SpecsDetails."Version Code", '');
                                    IF SpecsDetails.FINDSET THEN
                                        InitTransInspection(recTransHeader, recTransLine, recReservationEntry."Qty. to Handle (Base)", recReservationEntry."Lot No.", SpecsDetails, TransferRcpt, Bin);
                                END;
                            UNTIL recReservationEntry.NEXT = 0;
                    END;
                UNTIL recTransLine.NEXT = 0;
        END;

    end;

    procedure InitTransInspection(var recTransferHeader: Record 5740; var recTLine: Record 5741; Qty: Decimal; Lot: Code[20]; var Specs: Record 50016; TransferRcpt: Record 5746; Bin: Code[10]);
    var
        TempInspectionDataSheet: Record 50011;
        TempInspectionDataSheetLine: Record 50012;
        QltySetup: Record 50010;
        recItem: Record 27;
        SpecsDetails: Record 50016;
        WarehouseReceiptHeader: Record 7316;
        WarehouseReceiptLine: Record 7317;
    begin
        WITH recTransHeader DO BEGIN
            TempInspectionDataSheet.RESET;
            TempInspectionDataSheet.INIT;
            QltySetup.GET;
            QltySetup.TESTFIELD(QltySetup."Inspection Sheet No. Series");
            TempInspectionDataSheet."No." := NoSeriesMgmt.GetNextNo(QltySetup."Inspection Sheet No. Series", WORKDATE, TRUE);
            TempInspectionDataSheet."Document Type" := TempInspectionDataSheet."Document Type"::Transfer;
            TempInspectionDataSheet."Document No." := "No.";
            TempInspectionDataSheet."Ref ID" := recTLine."Line No.";
            TempInspectionDataSheet."Posting Date" := "Posting Date";
            TempInspectionDataSheet.Quantity := Qty;
            TempInspectionDataSheet."Document Date" := WORKDATE;
            TempInspectionDataSheet."Prod. Order Date" := 0D;
            TempInspectionDataSheet."Lot No." := Lot;
            TempInspectionDataSheet."Location Code" := "Transfer-to Code";
            TempInspectionDataSheet."Bin Code" := Bin;
            TempInspectionDataSheet."Transfer Receipt No." := TransferRcpt."No.";
            TempInspectionDataSheet."Transfer Receipt Quantity" := Qty;
            TempInspectionDataSheet."Transfer Receipt Date" := TransferRcpt."Posting Date";
            TempInspectionDataSheet."Specs ID" := Specs."Specs ID";
            TempInspectionDataSheet."Item No." := recTLine."Item No.";
            //PCPL-BRB 20211123
            WarehouseReceiptLine.RESET;
            WarehouseReceiptLine.SETRANGE("Source Document", WarehouseReceiptLine."Source Document"::"Inbound Transfer");
            WarehouseReceiptLine.SETRANGE("Source No.", "No.");
            IF WarehouseReceiptLine.FINDFIRST THEN;
            IF WarehouseReceiptHeader.GET(WarehouseReceiptLine."No.") THEN BEGIN
                TempInspectionDataSheet."RM Packing Detail" := WarehouseReceiptHeader."Packing details";
                TempInspectionDataSheet."Mfg. Date" := WarehouseReceiptHeader."Manufacturing Date";
                TempInspectionDataSheet."EXP Date" := WarehouseReceiptHeader."Expairy Date";    //PCPL-BRB-20211206
            END;
            //PCPL-BRB 20211123
            IF recItem.GET(recTLine."Item No.") THEN BEGIN
                TempInspectionDataSheet."Item Description" := recItem.Description;
                TempInspectionDataSheet."Item Description 2" := recItem."Description 2";
                TempInspectionDataSheet."Unit of Messure" := recItem."Base Unit of Measure";
                TempInspectionDataSheet."Sample UOM" := recItem."Base Unit of Measure";
            END;
            IF TempInspectionDataSheet."Lot No." <> '' THEN
                TempInspectionDataSheet."Item Tracking" := TRUE
            ELSE
                TempInspectionDataSheet."Item Tracking" := FALSE;
            TempInspectionDataSheet."Certificate No." := cduQltyMgmt.GetCertificate(TempInspectionDataSheet);
            TempInspectionDataSheet."Prod. Order Quantity" := 0;
            TempInspectionDataSheet.Approval := TempInspectionDataSheet.Approval::WIP;
            TempInspectionDataSheet.Status := TempInspectionDataSheet.Status::Open;
            TempInspectionDataSheet."Retest on" := CALCDATE(recItem."Retest Duration", WORKDATE);
            //Inserting into Inspection Line
            SpecsDetails.RESET;
            SpecsDetails.SETRANGE(SpecsDetails."Specs ID", Specs."Specs ID");
            SpecsDetails.SETRANGE(SpecsDetails."Version Code", Specs."Version Code");
            SpecsDetails.SETRANGE(SpecsDetails."Parent Group Code", Specs."Group Code");
            IF SpecsDetails.FINDSET THEN
                REPEAT
                    TempInspectionDataSheetLine.RESET;
                    TempInspectionDataSheetLine.INIT;
                    TempInspectionDataSheetLine."No." := TempInspectionDataSheet."No.";
                    TempInspectionDataSheetLine."Document Type" := TempInspectionDataSheetLine."Document Type"::Transfer;
                    TempInspectionDataSheetLine."Document No." := "No.";
                    TempInspectionDataSheetLine."Line No." := SpecsDetails."Line No.";
                    TempInspectionDataSheetLine."Qlty Measure Code" := SpecsDetails."Qlty Measure Code";
                    TempInspectionDataSheetLine."Account Type" := SpecsDetails."Account Type";
                    TempInspectionDataSheetLine."Item No." := recItem."No.";
                    TempInspectionDataSheetLine."Qc Description" := SpecsDetails.Description;
                    TempInspectionDataSheetLine."Parent Group Code" := SpecsDetails."Parent Group Code";
                    TempInspectionDataSheetLine."Unit of Measure" := SpecsDetails."Unit of Measure";
                    TempInspectionDataSheetLine."Test Mandatory" := SpecsDetails."Test Manadatory";
                    TempInspectionDataSheetLine."Posting Date" := WORKDATE;
                    TempInspectionDataSheetLine."Min. Value" := SpecsDetails."Min. Value";
                    TempInspectionDataSheetLine."Max. Value" := SpecsDetails."Max. Value";
                    TempInspectionDataSheetLine."Text Value" := SpecsDetails."Text Value";
                    TempInspectionDataSheetLine."Actual Value" := 0;
                    TempInspectionDataSheetLine.Qualitative := SpecsDetails.Qualitative;
                    TempInspectionDataSheetLine.Remark := '';
                    TempInspectionDataSheetLine.Status := TempInspectionDataSheetLine.Status::Open;
                    //>>QC3.0
                    TempInspectionDataSheetLine."Additional Text Value" := SpecsDetails."Additional Text Value";
                    TempInspectionDataSheetLine."Additional Text Value 2" := SpecsDetails."Additional Text Value 2";
                    TempInspectionDataSheetLine."Additional Text Value 3" := SpecsDetails."Additional Text Value 3";
                    //<<QC3.0
                    TempInspectionDataSheetLine.INSERT;
                UNTIL SpecsDetails.NEXT = 0;
            cduQltyMgmt.CreateEntryLedger(TempInspectionDataSheet);
            cduQltyMgmt.CreateLotInfo(TempInspectionDataSheet."Lot No.", TempInspectionDataSheet."Item No.", TempInspectionDataSheet."Certificate No.");
            TempInspectionDataSheet.INSERT;
        END;
    end;
}

