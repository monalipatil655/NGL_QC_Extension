codeunit 50003 "Purch/Sale Inspection Creation"
{
    // version PCPL/QC/V3/001,PCPL/CUST/QC/IRL/002,QC3.0

    Permissions = TableData 6550 = rimd;
    // TableData 50129 = rimd;

    trigger OnRun();
    begin
    end;

    var
        recPurchHeader: Record 38;
        recPurchLine: Record 39;
        recSalesHeader: Record 36;
        recSalesLine: Record 37;
        recReservationEntry: Record 337;
        NoSeriesMgmt: Codeunit 396;
        cduQltyMgmt: Codeunit 50005;
        ReservationEntry: Record 337;
        SKU: Record 5700;

    procedure fctPurchSplitEntry(PurchHeader: Record 38; PurchRcptHdr: Record 120; WhseDocNo: Code[20]);
    var
        specs: Record 50015;
        SpecsDetails: Record 50016;
        specsVersion: Record 50017;
    begin
        recPurchHeader := PurchHeader;
        WITH recPurchHeader DO BEGIN
            recPurchLine.RESET;
            recPurchLine.SETRANGE(recPurchLine."Document No.", "No.");
            recPurchLine.SETRANGE(recPurchLine."Quality Check", recPurchLine."Quality Check"::"After GRN");
            recPurchLine.SETRANGE(recPurchLine.Type, recPurchLine.Type::Item);
            recPurchLine.SETFILTER(recPurchLine."Qty. to Receive", '<>%1', 0);
            IF recPurchLine.FINDSET THEN
                REPEAT
                    SKU.RESET;
                    SKU.SETRANGE(SKU."Item No.", recPurchLine."No.");
                    SKU.SETRANGE(SKU."Location Code", recPurchLine."Location Code");
                    SKU.SETRANGE(SKU."QC Check", TRUE);
                    IF SKU.FINDFIRST THEN BEGIN
                        recPurchLine.TESTFIELD("Location Code");
                        recReservationEntry.RESET;
                        recReservationEntry.SETRANGE(recReservationEntry."Item No.", recPurchLine."No.");
                        recReservationEntry.SETRANGE(recReservationEntry."Location Code", recPurchLine."Location Code");
                        recReservationEntry.SETRANGE(recReservationEntry."Source ID", "No.");
                        recReservationEntry.SETRANGE(recReservationEntry."Source Ref. No.", recPurchLine."Line No.");
                        IF recReservationEntry.FINDSET THEN
                            REPEAT
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
                                            InitPurchInspection(recPurchHeader, recPurchLine, recReservationEntry."Qty. to Handle (Base)", recReservationEntry."Lot No.", SpecsDetails, PurchRcptHdr, WhseDocNo);
                                        UNTIL SpecsDetails.NEXT = 0;
                                END ELSE BEGIN
                                    SpecsDetails.RESET;
                                    SpecsDetails.SETRANGE(SpecsDetails."Specs ID", specs."Specs ID");
                                    SpecsDetails.SETRANGE(SpecsDetails."Version Code", '');
                                    SpecsDetails.SETRANGE(SpecsDetails."Account Type", SpecsDetails."Account Type"::"Begin");
                                    IF SpecsDetails.FINDSET THEN
                                        REPEAT
                                            InitPurchInspection(recPurchHeader, recPurchLine, recReservationEntry."Qty. to Handle (Base)", recReservationEntry."Lot No.", SpecsDetails, PurchRcptHdr, WhseDocNo);
                                        UNTIL SpecsDetails.NEXT = 0;
                                END;
                            UNTIL recReservationEntry.NEXT = 0;
                    END;
                UNTIL recPurchLine.NEXT = 0;
        END;
    end;

    procedure fctPurchSplitEntryBeforeGRN(PurchHeader: Record 38);
    var
        specs: Record 50015;
        SpecsDetails: Record 50016;
        specsVersion: Record 50017;
        PurchRcptHdr: Record 120;
        WhseDocNo: Code[20];
    begin
        recPurchHeader := PurchHeader;
        WITH recPurchHeader DO BEGIN
            recPurchLine.RESET;
            recPurchLine.SETRANGE(recPurchLine."Document No.", "No.");
            recPurchLine.SETRANGE(recPurchLine.Type, recPurchLine.Type::Item);
            recPurchLine.SETRANGE(recPurchLine."Quality Check", recPurchLine."Quality Check"::"Before GRN");
            IF recPurchLine.FINDFIRST THEN
                REPEAT
                    SKU.RESET;
                    SKU.SETRANGE(SKU."Item No.", recPurchLine."No.");
                    SKU.SETRANGE(SKU."Location Code", recPurchLine."Location Code");
                    SKU.SETRANGE(SKU."QC Check", TRUE);
                    IF SKU.FINDFIRST THEN BEGIN
                        recPurchLine.TESTFIELD(recPurchLine."Qty Send to Quality");
                        recPurchLine.VALIDATE(recPurchLine."Qty. to Receive", 0);
                        recPurchLine.VALIDATE(recPurchLine."Qty. to Invoice", 0);
                        recReservationEntry.RESET;
                        recReservationEntry.SETRANGE(recReservationEntry."Source Type", 39);
                        recReservationEntry.SETRANGE(recReservationEntry."Source ID", recPurchLine."Document No.");
                        recReservationEntry.SETRANGE(recReservationEntry."Source Ref. No.", recPurchLine."Line No.");
                        IF recReservationEntry.FINDSET THEN
                            REPEAT
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
                                            InitPurchInspection(recPurchHeader, recPurchLine, recReservationEntry."Qty. to Handle (Base)", recReservationEntry."Lot No.", SpecsDetails, PurchRcptHdr, WhseDocNo);
                                        UNTIL SpecsDetails.NEXT = 0;
                                END
                                ELSE BEGIN
                                    SpecsDetails.RESET;
                                    SpecsDetails.SETRANGE(SpecsDetails."Specs ID", specs."Specs ID");
                                    SpecsDetails.SETRANGE(SpecsDetails."Version Code", '');
                                    SpecsDetails.SETRANGE(SpecsDetails."Account Type", SpecsDetails."Account Type"::"Begin");
                                    IF SpecsDetails.FINDSET THEN
                                        REPEAT
                                            InitPurchInspection(recPurchHeader, recPurchLine, recReservationEntry."Qty. to Handle (Base)", recReservationEntry."Lot No.", SpecsDetails, PurchRcptHdr, WhseDocNo);
                                        UNTIL SpecsDetails.NEXT = 0;
                                END;
                            UNTIL recReservationEntry.NEXT = 0;
                    END;
                UNTIL recPurchLine.NEXT = 0;
        END;
    end;

    procedure fctPurchEntry(PurchHeader: Record 38; PurchRcptHdr: Record 120; WhseDocNo: Code[20]);
    var
        specs: Record 50015;
        SpecsDetails: Record 50016;
        specsVersion: Record 50017;
        recItem: Record 27;
    begin
        recPurchHeader := PurchHeader;
        WITH recPurchHeader DO BEGIN
            recPurchLine.RESET;
            recPurchLine.SETRANGE(recPurchLine."Document No.", "No.");
            recPurchLine.SETRANGE(recPurchLine."Quality Check", recPurchLine."Quality Check"::"After GRN");
            recPurchLine.SETRANGE(recPurchLine.Type, recPurchLine.Type::Item);
            recPurchLine.SETFILTER(recPurchLine."Qty. to Receive", '<>%1', 0);
            IF recPurchLine.FINDSET THEN
                REPEAT
                    IF recItem.GET(recPurchLine."No.") THEN
                        IF NOT recItem."QC Check" THEN
                            EXIT;
                    recPurchLine.TESTFIELD("Location Code");
                    recReservationEntry.RESET;
                    recReservationEntry.SETRANGE(recReservationEntry."Item No.", recItem."No.");
                    recReservationEntry.SETRANGE(recReservationEntry."Location Code", recPurchLine."Location Code");
                    recReservationEntry.SETRANGE(recReservationEntry."Source ID", "No.");
                    recReservationEntry.SETRANGE(recReservationEntry."Source Ref. No.", recPurchLine."Line No.");
                    IF recReservationEntry.FINDSET THEN
                        REPEAT
                            specs.GET(recItem."Specs ID");
                            specs.TESTFIELD(specs.Status, specs.Status::Certified);
                            specsVersion.RESET;
                            specsVersion.SETRANGE(specsVersion."Specs ID", specs."Specs ID");
                            specsVersion.SETRANGE(specsVersion."Starting Date", 0D, "Posting Date");
                            IF specsVersion.FINDSET THEN BEGIN
                                SpecsDetails.RESET;
                                SpecsDetails.SETRANGE(SpecsDetails."Specs ID", specs."Specs ID");
                                SpecsDetails.SETRANGE(SpecsDetails."Version Code", specsVersion."Version Code");
                                IF SpecsDetails.FINDSET THEN
                                    InitPurchInspection(recPurchHeader, recPurchLine, recReservationEntry."Qty. to Handle (Base)", recReservationEntry."Lot No.", SpecsDetails, PurchRcptHdr, WhseDocNo);
                            END
                            ELSE BEGIN
                                SpecsDetails.RESET;
                                SpecsDetails.SETRANGE(SpecsDetails."Specs ID", specs."Specs ID");
                                SpecsDetails.SETRANGE(SpecsDetails."Version Code", '');
                                IF SpecsDetails.FINDSET THEN
                                    InitPurchInspection(recPurchHeader, recPurchLine, recReservationEntry."Qty. to Handle (Base)", recReservationEntry."Lot No.", SpecsDetails, PurchRcptHdr, WhseDocNo);
                            END;
                        UNTIL recReservationEntry.NEXT = 0;
                UNTIL recPurchLine.NEXT = 0;
        END;
    end;

    procedure fctPurchEntryBeforeGRN(var PurchHeader: Record 38);
    var
        specs: Record 50015;
        SpecsDetails: Record 50016;
        specsVersion: Record 50017;
        PurchRcptHdr: Record 120;
        WhseDocNo: Code[20];
    begin
        recPurchHeader := PurchHeader;
        WITH recPurchHeader DO BEGIN
            recPurchLine.RESET;
            recPurchLine.SETRANGE(recPurchLine."Document No.", "No.");
            recPurchLine.SETRANGE(recPurchLine.Type, recPurchLine.Type::Item);
            recPurchLine.SETRANGE(recPurchLine."Quality Check", recPurchLine."Quality Check"::"Before GRN");
            IF recPurchLine.FINDFIRST THEN
                REPEAT
                    SKU.RESET;
                    SKU.SETRANGE(SKU."Item No.", recPurchLine."No.");
                    SKU.SETRANGE(SKU."Location Code", recPurchLine."Location Code");
                    SKU.SETRANGE(SKU."QC Check", TRUE);
                    IF SKU.FINDFIRST THEN BEGIN
                        recPurchLine.TESTFIELD(recPurchLine."Qty Send to Quality");
                        recPurchLine.VALIDATE(recPurchLine."Qty. to Receive", 0);
                        recPurchLine.VALIDATE(recPurchLine."Qty. to Invoice", 0);
                        recReservationEntry.RESET;
                        recReservationEntry.SETRANGE(recReservationEntry."Source Type", 39);
                        recReservationEntry.SETRANGE(recReservationEntry."Source ID", recPurchLine."Document No.");
                        recReservationEntry.SETRANGE(recReservationEntry."Source Ref. No.", recPurchLine."Line No.");
                        IF recReservationEntry.FINDSET THEN
                            REPEAT
                                specs.GET(SKU."Specs ID");
                                specs.TESTFIELD(specs.Status, specs.Status::Certified);
                                specsVersion.RESET;
                                specsVersion.SETRANGE(specsVersion."Specs ID", specs."Specs ID");
                                specsVersion.SETRANGE(specsVersion."Starting Date", 0D, "Posting Date");
                                IF specsVersion.FINDSET THEN BEGIN
                                    SpecsDetails.RESET;
                                    SpecsDetails.SETRANGE(SpecsDetails."Specs ID", specs."Specs ID");
                                    SpecsDetails.SETRANGE(SpecsDetails."Version Code", specsVersion."Version Code");
                                    IF SpecsDetails.FINDSET THEN
                                        InitPurchInspection(recPurchHeader, recPurchLine, recReservationEntry."Qty. to Handle (Base)", recReservationEntry."Lot No.", SpecsDetails, PurchRcptHdr, WhseDocNo);
                                END
                                ELSE BEGIN
                                    SpecsDetails.RESET;
                                    SpecsDetails.SETRANGE(SpecsDetails."Specs ID", specs."Specs ID");
                                    SpecsDetails.SETRANGE(SpecsDetails."Version Code", '');
                                    IF SpecsDetails.FINDSET THEN
                                        InitPurchInspection(recPurchHeader, recPurchLine, recReservationEntry."Qty. to Handle (Base)", recReservationEntry."Lot No.", SpecsDetails, PurchRcptHdr, WhseDocNo);
                                END;
                            UNTIL recReservationEntry.NEXT = 0;
                    END;
                UNTIL recPurchLine.NEXT = 0;
        END;
    end;

    procedure InitPurchInspection(recPurchHeader: Record 38; recPLine: Record 39; Qty: Decimal; Lot: Code[20]; Specs: Record 50016; PurchRcptHdr: Record 120; WhseDocNo: Code[20]);
    var
        TempInspectionDataSheet: Record 50011;
        TempInspectionDataSheetLine: Record 50012;
        QltySetup: Record 50010;
        recItem: Record 27;
        SpecsDetails: Record 50016;
        WarehouseReceiptHeader: Record 7316;
        WarehouseReceiptLine: Record 7317;
    begin
        WITH recPurchHeader DO BEGIN
            TempInspectionDataSheet.INIT;
            QltySetup.GET;
            QltySetup.TESTFIELD(QltySetup."Inspection Sheet No. Series");
            TempInspectionDataSheet."No." := NoSeriesMgmt.GetNextNo(QltySetup."Inspection Sheet No. Series", WORKDATE, TRUE);
            TempInspectionDataSheet."Document Type" := TempInspectionDataSheet."Document Type"::"Purch. Order";
            TempInspectionDataSheet."Document No." := "No.";
            TempInspectionDataSheet."Ref ID" := recPLine."Line No.";
            TempInspectionDataSheet."Posting Date" := "Posting Date";
            TempInspectionDataSheet.Quantity := Qty;
            TempInspectionDataSheet."Document Date" := WORKDATE;
            TempInspectionDataSheet."Prod. Order Date" := 0D;
            TempInspectionDataSheet."Lot No." := Lot;
            TempInspectionDataSheet."Location Code" := "Location Code";
            TempInspectionDataSheet."Bin Code" := recPLine."Bin Code";
            TempInspectionDataSheet."Purch. Order Quantity" := recPLine.Quantity;
            TempInspectionDataSheet."Vendor No." := "Buy-from Vendor No.";
            TempInspectionDataSheet."Vendor Name" := "Buy-from Vendor Name";
            TempInspectionDataSheet."Item No." := recPLine."No.";
            TempInspectionDataSheet."Sample Drawn Quantity" := recItem."Inspection Sample Quantity";
            TempInspectionDataSheet."Specs ID" := Specs."Specs ID";
            //PCPL-BRB
            WarehouseReceiptLine.RESET;
            WarehouseReceiptLine.SETRANGE("Source Document", WarehouseReceiptLine."Source Document"::"Purchase Order");
            WarehouseReceiptLine.SETRANGE("Source No.", "No.");
            IF WarehouseReceiptLine.FINDFIRST THEN;
            IF WarehouseReceiptHeader.GET(WarehouseReceiptLine."No.") THEN BEGIN
                TempInspectionDataSheet."RM Packing Detail" := WarehouseReceiptHeader."Packing details";
                TempInspectionDataSheet."Mfg. Date" := WarehouseReceiptHeader."Manufacturing Date";
                TempInspectionDataSheet."EXP Date" := WarehouseReceiptHeader."Expairy Date";    //PCPL-BRB-20211206
            END;
            //<<PCPL-BRB 20211122
            IF recItem.GET(recPLine."No.") THEN BEGIN
                TempInspectionDataSheet."Item Description" := recItem.Description;
                TempInspectionDataSheet."Item Description 2" := recItem."Description 2";
                TempInspectionDataSheet."Unit of Messure" := recItem."Base Unit of Measure";
                TempInspectionDataSheet."Sample UOM" := recItem."Base Unit of Measure";
            END;
            IF TempInspectionDataSheet."Lot No." <> '' THEN
                TempInspectionDataSheet."Item Tracking" := TRUE
            ELSE
                TempInspectionDataSheet."Item Tracking" := FALSE;
            //TempInspectionDataSheet.VALIDATE("Manufacturer Code",recPLine."Approved Manufacturer");
            TempInspectionDataSheet."Certificate No." := cduQltyMgmt.GetCertificate(TempInspectionDataSheet);
            TempInspectionDataSheet."Prod. Order Quantity" := 0;
            TempInspectionDataSheet.Approval := TempInspectionDataSheet.Approval::WIP;
            TempInspectionDataSheet.Status := TempInspectionDataSheet.Status::Open;
            IF recPLine."Quality Check" = recPLine."Quality Check"::"Before GRN" THEN
                TempInspectionDataSheet."Before GRN" := TRUE
            ELSE
                TempInspectionDataSheet."Before GRN" := FALSE;
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
                    TempInspectionDataSheetLine."Document Type" := TempInspectionDataSheetLine."Document Type"::"Purch. Order";
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
                    //>>QC3.0
                    TempInspectionDataSheetLine."Additional Text Value" := SpecsDetails."Additional Text Value";
                    TempInspectionDataSheetLine."Additional Text Value 2" := SpecsDetails."Additional Text Value 2";
                    TempInspectionDataSheetLine."Additional Text Value 3" := SpecsDetails."Additional Text Value 3";
                    //<<QC3.0
                    TempInspectionDataSheetLine."Actual Value" := 0;
                    TempInspectionDataSheetLine.Qualitative := SpecsDetails.Qualitative;
                    TempInspectionDataSheetLine.Remark := '';
                    TempInspectionDataSheetLine."Purchase Order No." := "No.";
                    TempInspectionDataSheetLine."Purchase Line No." := recPLine."Line No.";
                    TempInspectionDataSheetLine.Status := TempInspectionDataSheetLine.Status::Open;
                    TempInspectionDataSheetLine.INSERT;
                UNTIL SpecsDetails.NEXT = 0;
            cduQltyMgmt.CreateEntryLedger(TempInspectionDataSheet);
            cduQltyMgmt.CreateLotInfo(TempInspectionDataSheet."Lot No.", TempInspectionDataSheet."Item No.", TempInspectionDataSheet."Certificate No.");
            TempInspectionDataSheet.INSERT;
        END;
    end;

    procedure fctSalesRetSplitEntry(SalesHeader: Record 36);
    var
        specs: Record 50015;
        SpecsDetails: Record 50016;
        specsVersion: Record 50017;
        recItem: Record 27;
    begin
        //NIKHIL
        recSalesHeader := SalesHeader;
        WITH recSalesHeader DO BEGIN
            recSalesLine.RESET;
            recSalesLine.SETRANGE(recSalesLine."Document No.", "No.");
            recSalesLine.SETRANGE(recSalesLine.Type, recSalesLine.Type::Item);
            recSalesLine.SETFILTER(recSalesLine."Return Qty. to Receive", '<>%1', 0);
            IF recSalesLine.FINDSET THEN
                REPEAT
                    SKU.RESET;
                    SKU.SETRANGE(SKU."Item No.", recSalesLine."No.");
                    SKU.SETRANGE(SKU."Location Code", recSalesLine."Location Code");
                    SKU.SETRANGE(SKU."QC Check", TRUE);
                    IF SKU.FINDFIRST THEN BEGIN
                        recSalesLine.TESTFIELD("Location Code");
                        recReservationEntry.RESET;
                        recReservationEntry.SETRANGE(recReservationEntry."Item No.", recItem."No.");
                        recReservationEntry.SETRANGE(recReservationEntry."Location Code", recSalesLine."Location Code");
                        recReservationEntry.SETRANGE(recReservationEntry."Source ID", "No.");
                        recReservationEntry.SETRANGE(recReservationEntry."Source Ref. No.", recSalesLine."Line No.");
                        IF recReservationEntry.FINDSET THEN
                            REPEAT
                                SKU.RESET;
                                SKU.SETRANGE(SKU."Item No.", recReservationEntry."Item No.");
                                SKU.SETRANGE(SKU."Location Code", recReservationEntry."Location Code");
                                IF SKU.FINDSET THEN BEGIN
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
                                                InitReturnInspection(recSalesHeader, recSalesLine, recReservationEntry.Quantity, recReservationEntry."Lot No.", SpecsDetails);
                                            UNTIL SpecsDetails.NEXT = 0;
                                    END
                                    ELSE BEGIN
                                        SpecsDetails.RESET;
                                        SpecsDetails.SETRANGE(SpecsDetails."Specs ID", specs."Specs ID");
                                        SpecsDetails.SETRANGE(SpecsDetails."Version Code", '');
                                        SpecsDetails.SETRANGE(SpecsDetails."Account Type", SpecsDetails."Account Type"::"Begin");
                                        IF SpecsDetails.FINDSET THEN
                                            REPEAT
                                                InitReturnInspection(recSalesHeader, recSalesLine, recReservationEntry.Quantity, recReservationEntry."Lot No.", SpecsDetails);
                                            UNTIL SpecsDetails.NEXT = 0;
                                    END;
                                END;
                            UNTIL recReservationEntry.NEXT = 0;
                    END;
                UNTIL recSalesLine.NEXT = 0;
        END;
        //NIKHIL
    end;

    procedure fctSalesRetEntry(SalesHeader: Record 36);
    var
        specs: Record 50015;
        SpecsDetails: Record 50016;
        specsVersion: Record 50017;
    begin
        recSalesHeader := SalesHeader;
        WITH recSalesHeader DO BEGIN
            recSalesLine.RESET;
            recSalesLine.SETRANGE(recSalesLine."Document No.", "No.");
            recSalesLine.SETRANGE(recSalesLine.Type, recSalesLine.Type::Item);
            recSalesLine.SETFILTER(recSalesLine."Return Qty. to Receive", '<>%1', 0);
            IF recSalesLine.FINDSET THEN
                REPEAT
                    SKU.RESET;
                    SKU.SETRANGE(SKU."Item No.", recSalesLine."No.");
                    SKU.SETRANGE(SKU."Location Code", recSalesLine."Location Code");
                    SKU.SETRANGE(SKU."QC Check", TRUE);
                    IF SKU.FINDFIRST THEN BEGIN
                        recSalesLine.TESTFIELD("Location Code");
                        recReservationEntry.RESET;
                        recReservationEntry.SETRANGE(recReservationEntry."Item No.", recSalesLine."No.");
                        recReservationEntry.SETRANGE(recReservationEntry."Location Code", recSalesLine."Location Code");
                        recReservationEntry.SETRANGE(recReservationEntry."Source ID", "No.");
                        recReservationEntry.SETRANGE(recReservationEntry."Source Ref. No.", recSalesLine."Line No.");
                        IF recReservationEntry.FINDSET THEN
                            REPEAT
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
                                            InitReturnInspection(recSalesHeader, recSalesLine, recReservationEntry."Qty. to Handle (Base)", recReservationEntry."Lot No.", SpecsDetails);
                                        UNTIL SpecsDetails.NEXT = 0;
                                END
                                ELSE BEGIN
                                    SpecsDetails.RESET;
                                    SpecsDetails.SETRANGE(SpecsDetails."Specs ID", specs."Specs ID");
                                    SpecsDetails.SETRANGE(SpecsDetails."Version Code", '');
                                    SpecsDetails.SETRANGE(SpecsDetails."Account Type", SpecsDetails."Account Type"::"Begin");
                                    IF SpecsDetails.FINDSET THEN
                                        REPEAT
                                            InitReturnInspection(recSalesHeader, recSalesLine, recReservationEntry."Qty. to Handle (Base)", recReservationEntry."Lot No.", SpecsDetails);
                                        UNTIL SpecsDetails.NEXT = 0;
                                END;
                            UNTIL recReservationEntry.NEXT = 0;
                    END;
                UNTIL recSalesLine.NEXT = 0;
        END;
    end;

    procedure InitReturnInspection(var recSalesHeader: Record 36; var recSLine: Record 37; Qty: Decimal; Lot: Code[20]; var Specs: Record 50016);
    var
        TempInspectionDataSheet: Record 50011;
        TempInspectionDataSheetLine: Record 50012;
        QltySetup: Record 50010;
        recItem: Record 27;
        SpecsDetails: Record 50016;
    begin
        WITH recSalesHeader DO BEGIN
            TempInspectionDataSheet.RESET;
            TempInspectionDataSheet.INIT;
            QltySetup.GET;
            QltySetup.TESTFIELD(QltySetup."Inspection Sheet No. Series");
            TempInspectionDataSheet."No." := NoSeriesMgmt.GetNextNo(QltySetup."Inspection Sheet No. Series", WORKDATE, TRUE);
            TempInspectionDataSheet."Document Type" := TempInspectionDataSheet."Document Type"::"Sales Return";
            TempInspectionDataSheet."Document No." := "No.";
            TempInspectionDataSheet."Customer No." := recSalesHeader."Sell-to Customer No.";
            TempInspectionDataSheet."Customer Name" := recSalesHeader."Sell-to Customer Name";
            TempInspectionDataSheet."Ref ID" := recSLine."Line No.";
            TempInspectionDataSheet."Posting Date" := "Posting Date";
            TempInspectionDataSheet.Quantity := Qty;
            TempInspectionDataSheet."Document Date" := WORKDATE;
            TempInspectionDataSheet."Prod. Order Date" := 0D;
            TempInspectionDataSheet."Lot No." := Lot;
            TempInspectionDataSheet."Location Code" := "Location Code";
            TempInspectionDataSheet."Bin Code" := recSLine."Bin Code";
            TempInspectionDataSheet."Purch. Order Quantity" := recSLine.Quantity;
            TempInspectionDataSheet."Item No." := recSLine."No.";
            IF recItem.GET(recSLine."No.") THEN BEGIN
                TempInspectionDataSheet."Item Description" := recItem.Description;
                TempInspectionDataSheet."Item Description 2" := recItem."Description 2";
                TempInspectionDataSheet."Unit of Messure" := recItem."Base Unit of Measure";
                TempInspectionDataSheet."Sample UOM" := recItem."Base Unit of Measure";
            END;
            IF TempInspectionDataSheet."Lot No." <> '' THEN
                TempInspectionDataSheet."Item Tracking" := TRUE
            ELSE
                TempInspectionDataSheet."Item Tracking" := FALSE;
            TempInspectionDataSheet."Specs ID" := Specs."Specs ID";
            TempInspectionDataSheet."Certificate No." := cduQltyMgmt.GetCertificate(TempInspectionDataSheet);
            TempInspectionDataSheet."Prod. Order Quantity" := 0;
            TempInspectionDataSheet.Approval := TempInspectionDataSheet.Approval::WIP;
            TempInspectionDataSheet.Status := TempInspectionDataSheet.Status::Open;
            //TempInspectionDataSheet."Retest on":=CALCDATE(recItem."Retain Sample Quantity",WORKDATE);
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
                    TempInspectionDataSheetLine."Document Type" := TempInspectionDataSheetLine."Document Type"::"Sales Return";
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
                    //>>QC3.0
                    TempInspectionDataSheetLine."Additional Text Value" := SpecsDetails."Additional Text Value";
                    TempInspectionDataSheetLine."Additional Text Value 2" := SpecsDetails."Additional Text Value 2";
                    TempInspectionDataSheetLine."Additional Text Value 3" := SpecsDetails."Additional Text Value 3";
                    //<<QC3.0
                    TempInspectionDataSheetLine."Actual Value" := 0;
                    TempInspectionDataSheetLine.Qualitative := SpecsDetails.Qualitative;
                    TempInspectionDataSheetLine.Remark := '';
                    TempInspectionDataSheetLine."Purchase Order No." := "No.";
                    TempInspectionDataSheetLine."Purchase Line No." := recSLine."Line No.";
                    TempInspectionDataSheetLine.Status := TempInspectionDataSheetLine.Status::Open;
                    TempInspectionDataSheetLine.INSERT;
                UNTIL SpecsDetails.NEXT = 0;
            cduQltyMgmt.CreateEntryLedger(TempInspectionDataSheet);
            cduQltyMgmt.CreateLotInfo(TempInspectionDataSheet."Lot No.", TempInspectionDataSheet."Item No.", TempInspectionDataSheet."Certificate No.");
            TempInspectionDataSheet.INSERT;
        END;
    end;

    procedure UpdateGRN(recPurchDoc: Record 38; InspectionDS: Record 50011; WhseDocNo: Code[20]);
    var
        recPurchLine: Record 121;
        InspectionSheet: Record 50011;
        recItemLedger: Record 32;
        recGRN: Record 120;
        recGRNLine: Record 121;
        GRNQty: Decimal;
    begin
        WITH recPurchDoc DO BEGIN
            GRNQty := 0;
            InspectionSheet.RESET;
            InspectionSheet.SETRANGE(InspectionSheet."Document Type", InspectionSheet."Document Type"::"Purch. Order");
            InspectionSheet.SETRANGE(InspectionSheet."Document No.", "No.");
            InspectionSheet.SETFILTER(InspectionSheet."GRN No.", '%1', '');
            IF InspectionSheet.FINDFIRST THEN
                REPEAT
                    recItemLedger.RESET;
                    recItemLedger.SETRANGE(recItemLedger."Lot No.", InspectionSheet."Lot No.");
                    recItemLedger.SETRANGE(recItemLedger."Item No.", InspectionSheet."Item No.");
                    IF recItemLedger.FINDFIRST THEN BEGIN
                        GRNQty := 0;
                        recGRNLine.RESET;
                        recGRNLine.SETRANGE(recGRNLine."Document No.", recItemLedger."Document No.");
                        IF recGRNLine.FINDFIRST THEN
                            REPEAT
                                GRNQty += recGRNLine.Quantity;
                                InspectionSheet."GRN Date" := recGRNLine."Posting Date"; //PCPL/BRB/03-03-18
                            UNTIL recGRNLine.NEXT = 0;
                        InspectionSheet."GRN No." := recGRNLine."Document No.";
                        InspectionSheet."GRN Date" := recGRNLine."Posting Date";
                        InspectionSheet."GRN Quantity" := GRNQty;
                        InspectionSheet.MODIFY;
                    END;
                UNTIL InspectionSheet.NEXT = 0
        END;
    end;

    procedure UpdateReturnReceipt(SalesDoc: Record 36; SalesRcpt: Record 6660);
    var
        RETQty: Decimal;
        InspectionSheet: Record 50011;
        SalesRcptLine: Record 6661;
    begin
        WITH SalesDoc DO BEGIN
            RETQty := 0;
            InspectionSheet.RESET;
            InspectionSheet.SETRANGE(InspectionSheet."Document Type", InspectionSheet."Document Type"::"Sales Return");
            InspectionSheet.SETRANGE(InspectionSheet."Document No.", "No.");
            InspectionSheet.SETFILTER(InspectionSheet."Return Receipt No.", '%1', '');
            IF InspectionSheet.FINDSET THEN
                REPEAT
                    InspectionSheet."Return Receipt No." := SalesRcpt."No.";
                    InspectionSheet."Return Receipt Date" := SalesRcpt."Posting Date";
                    InspectionSheet."Return Receipt Quantity" := InspectionSheet.Quantity;
                    InspectionSheet.MODIFY;
                UNTIL InspectionSheet.NEXT = 0
        END;
    end;

    procedure InitItmJnrlInspection(ItemLedgerEntry: Record "Item Ledger Entry"; Qty: Decimal; Lot: Code[20]; Specs: Record 50016);
    var
        TempInspectionDataSheet: Record 50011;
        TempInspectionDataSheetLine: Record 50012;
        QltySetup: Record 50010;
        recItem: Record 27;
        SpecsDetails: Record 50016;
        WarehouseEntry: Record 7312;
    begin
        WITH ItemLedgerEntry DO BEGIN
            TempInspectionDataSheet.INIT;
            QltySetup.GET;
            QltySetup.TESTFIELD(QltySetup."Inspection Sheet No. Series");

            TempInspectionDataSheet."No." := NoSeriesMgmt.GetNextNo(QltySetup."Inspection Sheet No. Series", WORKDATE, TRUE);
            TempInspectionDataSheet."Document Type" := TempInspectionDataSheet."Document Type"::"Positive Adjmnt";

            TempInspectionDataSheet."Document No." := "Document No.";
            TempInspectionDataSheet."Ref ID" := "Document Line No.";
            TempInspectionDataSheet."Posting Date" := "Posting Date";
            TempInspectionDataSheet.Quantity := Qty;
            TempInspectionDataSheet."Document Date" := WORKDATE;
            TempInspectionDataSheet."Prod. Order Date" := 0D;
            TempInspectionDataSheet."Lot No." := "Lot No.";
            TempInspectionDataSheet."Location Code" := "Location Code";
            TempInspectionDataSheet."Purch. Order Quantity" := Quantity;
            TempInspectionDataSheet."Item No." := "Item No.";
            TempInspectionDataSheet."Sample Drawn Quantity" := recItem."Inspection Sample Quantity";
            TempInspectionDataSheet."Specs ID" := Specs."Specs ID";
            IF recItem.GET("Item No.") THEN BEGIN
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
            WarehouseEntry.RESET;
            WarehouseEntry.SETRANGE(WarehouseEntry."Reference No.", ItemLedgerEntry."Document No.");
            IF WarehouseEntry.FINDFIRST THEN BEGIN
                TempInspectionDataSheet."Bin Code" := WarehouseEntry."Bin Code";
                // TempInspectionDataSheet.MODIFY;
            END;


            /*
             IF recPLine."Quality Check"=recPLine."Quality Check"::"Before GRN" THEN
               TempInspectionDataSheet."Before GRN":=TRUE
             ELSE
               TempInspectionDataSheet."Before GRN":=FALSE;
             */
            TempInspectionDataSheet."Retest on" := CALCDATE(recItem."Retest Duration", WORKDATE);

            //Inserting into Inspection Line
            SpecsDetails.RESET;
            SpecsDetails.SETRANGE(SpecsDetails."Specs ID", Specs."Specs ID");
            SpecsDetails.SETRANGE(SpecsDetails."Version Code", Specs."Version Code");
            SpecsDetails.SETRANGE(SpecsDetails."Parent Group Code", Specs."Group Code");
            SpecsDetails.SETRANGE(SpecsDetails."Account Type", SpecsDetails."Account Type"::Posting);
            IF SpecsDetails.FINDSET THEN
                REPEAT
                    TempInspectionDataSheetLine.RESET;
                    TempInspectionDataSheetLine.INIT;
                    TempInspectionDataSheetLine."No." := TempInspectionDataSheet."No.";
                    TempInspectionDataSheetLine."Document Type" := TempInspectionDataSheetLine."Document Type"::"Positive Adjmnt";
                    TempInspectionDataSheetLine."Document No." := "Document No.";
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
                    //>>QC3.0
                    TempInspectionDataSheetLine."Additional Text Value" := SpecsDetails."Additional Text Value";
                    TempInspectionDataSheetLine."Additional Text Value 2" := SpecsDetails."Additional Text Value 2";
                    TempInspectionDataSheetLine."Additional Text Value 3" := SpecsDetails."Additional Text Value 3";
                    //<<QC3.0
                    TempInspectionDataSheetLine."Actual Value" := 0;
                    TempInspectionDataSheetLine.Qualitative := SpecsDetails.Qualitative;
                    TempInspectionDataSheetLine.Remark := '';
                    //TempInspectionDataSheetLine."Purchase Order No.":="No.";
                    //TempInspectionDataSheetLine."Purchase Line No.":=recPLine."Line No.";
                    TempInspectionDataSheetLine.Status := TempInspectionDataSheetLine.Status::Open;
                    TempInspectionDataSheetLine.INSERT;
                UNTIL SpecsDetails.NEXT = 0;

            cduQltyMgmt.CreateEntryLedger(TempInspectionDataSheet);
            cduQltyMgmt.CreateLotInfo(TempInspectionDataSheet."Lot No.", TempInspectionDataSheet."Item No.", TempInspectionDataSheet."Certificate No.");
            TempInspectionDataSheet.INSERT;
        END;

    end;
}

