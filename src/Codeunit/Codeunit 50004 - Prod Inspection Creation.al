codeunit 50004 "Prod Inspection Creation"
{
    // version PCPL/QC/V3/001,PCPL/CUST/QC/IRL/002,QC3.0,PCPL QC/03/BRB

    // //PCPL QC/03/BRB  Code added for  IP/BP/USP wise.

    Permissions = TableData 6550 = rimd;
    //TableData 50129 = rimd;

    trigger OnRun();
    begin
    end;

    var
        recProdOrder: Record 5405;
        recProdLine: Record 5406;
        recReservationEntry: Record 337;
        NoSeriesMgmt: Codeunit 396;
        cduQltyMgmt: Codeunit 50005;
        ReservationEntry: Record 337;
        SKU: Record 5700;

    procedure fctProdSplitEntry(var ItemJnlLine: Record 83);
    var
        recReservation: Record 337;
        specs: Record 50015;
        specsVersion: Record 50017;
        SpecsDetails: Record 50016;
    begin
        WITH ItemJnlLine DO BEGIN
            IF ("Order Type" = "Order Type"::Production) AND ("Order No." <> '') AND ("Entry Type" = "Entry Type"::Output) AND ("Output Quantity" <> 0) THEN BEGIN
                SKU.RESET;
                SKU.SETRANGE(SKU."Item No.", "Item No.");
                SKU.SETRANGE(SKU."Location Code", "Location Code");
                SKU.SETRANGE(SKU."QC Check", TRUE);
                IF SKU.FINDFIRST THEN BEGIN
                    recReservation.RESET;
                    recReservation.SETRANGE(recReservation."Source Type", 83);
                    recReservation.SETRANGE(recReservation."Source Ref. No.", "Line No.");
                    recReservation.SETRANGE(recReservation."Item No.", "Item No.");
                    recReservation.SETRANGE(recReservation."Source ID", "Journal Template Name");
                    IF recReservation.FINDSET THEN
                        REPEAT
                            recProdOrder.GET(recProdOrder.Status::Released, "Order No.");
                            recProdLine.RESET;
                            recProdLine.SETRANGE(recProdLine."Prod. Order No.", recProdOrder."No.");
                            recProdLine.SETRANGE(recProdLine."Line No.", "Order Line No.");
                            IF recProdLine.FINDFIRST THEN BEGIN
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
                                            InitProdInspection(recProdOrder, recProdLine, recReservation."Lot No.", recReservation."Qty. to Handle (Base)", SpecsDetails);
                                        UNTIL SpecsDetails.NEXT = 0;
                                END
                                ELSE BEGIN
                                    SpecsDetails.RESET;
                                    SpecsDetails.SETRANGE(SpecsDetails."Specs ID", specs."Specs ID");
                                    SpecsDetails.SETRANGE(SpecsDetails."Version Code", '');
                                    SpecsDetails.SETRANGE(SpecsDetails."Account Type", SpecsDetails."Account Type"::"Begin");
                                    IF SpecsDetails.FINDSET THEN
                                        REPEAT
                                            InitProdInspection(recProdOrder, recProdLine, recReservation."Lot No.", recReservation."Qty. to Handle (Base)", SpecsDetails);
                                        UNTIL SpecsDetails.NEXT = 0;
                                END;
                            END;
                        UNTIL recReservation.NEXT = 0;
                END;
            END;
        END;
    end;

    procedure fctProdEntry(var ItemJnlLine: Record 83);
    var
        recReservation: Record 337;
        specs: Record 50015;
        specsVersion: Record 50017;
        SpecsDetails: Record 50016;
        recItem: Record 27;
    begin
        WITH ItemJnlLine DO BEGIN
            IF ("Order Type" = "Order Type"::Production) AND ("Order No." <> '') AND ("Entry Type" = "Entry Type"::Output) AND ("Output Quantity" <> 0) THEN BEGIN
                recItem.GET("Item No.");
                IF NOT recItem."QC Check" THEN
                    EXIT;
                recReservation.RESET;
                recReservation.SETRANGE(recReservation."Source Type", 83);
                recReservation.SETRANGE(recReservation."Source Ref. No.", "Line No.");
                recReservation.SETRANGE(recReservation."Item No.", "Item No.");
                recReservation.SETRANGE(recReservation."Source ID", "Journal Template Name");
                IF recReservation.FINDSET THEN
                    REPEAT
                        recProdOrder.GET(recProdOrder.Status::Released, "Order No.");
                        recProdLine.RESET;
                        recProdLine.SETRANGE(recProdLine."Prod. Order No.", recProdOrder."No.");
                        recProdLine.SETRANGE(recProdLine."Line No.", "Order Line No.");
                        IF recProdLine.FINDFIRST THEN BEGIN
                            specs.GET(recItem."Specs ID");
                            specs.TESTFIELD(specs.Status, specs.Status::Certified);
                            specsVersion.RESET;
                            specsVersion.SETRANGE(specsVersion."Specs ID", specs."Specs ID");
                            specsVersion.SETRANGE(specsVersion."Starting Date", 0D, "Posting Date");
                            specsVersion.SETRANGE("Specification Type", recProdLine."Specification Type");  //PCPL QC/03/BRB
                            IF specsVersion.FINDLAST THEN BEGIN
                                SpecsDetails.RESET;
                                SpecsDetails.SETRANGE(SpecsDetails."Specs ID", specs."Specs ID");
                                SpecsDetails.SETRANGE(SpecsDetails."Version Code", specsVersion."Version Code");
                                IF SpecsDetails.FINDSET THEN
                                    InitProdInspection(recProdOrder, recProdLine, recReservation."Lot No.", recReservation."Qty. to Handle (Base)", SpecsDetails);
                            END
                            ELSE BEGIN
                                SpecsDetails.RESET;
                                SpecsDetails.SETRANGE(SpecsDetails."Specs ID", specs."Specs ID");
                                SpecsDetails.SETRANGE(SpecsDetails."Version Code", '');
                                IF SpecsDetails.FINDSET THEN
                                    InitProdInspection(recProdOrder, recProdLine, recReservation."Lot No.", recReservation."Qty. to Handle (Base)", SpecsDetails);
                            END;
                        END;
                    UNTIL recReservation.NEXT = 0
                ELSE BEGIN
                    recReservation.RESET;
                    recReservation.SETRANGE(recReservation."Source Type", 5406);
                    recReservation.SETRANGE(recReservation."Item No.", "Item No.");
                    recReservation.SETRANGE(recReservation."Source ID", "Order No.");
                    IF recReservation.FINDSET THEN
                        REPEAT
                            recProdOrder.GET(recProdOrder.Status::Released, "Order No.");
                            recProdLine.RESET;
                            recProdLine.SETRANGE(recProdLine."Prod. Order No.", recProdOrder."No.");
                            recProdLine.SETRANGE(recProdLine."Line No.", "Order Line No.");
                            IF recProdLine.FINDFIRST THEN BEGIN
                                specs.GET(recItem."Specs ID");
                                specs.TESTFIELD(specs.Status, specs.Status::Certified);
                                specsVersion.RESET;
                                specsVersion.SETRANGE(specsVersion."Specs ID", specs."Specs ID");
                                specsVersion.SETRANGE(specsVersion."Starting Date", 0D, "Posting Date");
                                specsVersion.SETRANGE("Specification Type", recProdLine."Specification Type");  //PCPL QC/03/BRB
                                IF specsVersion.FINDLAST THEN BEGIN
                                    SpecsDetails.RESET;
                                    SpecsDetails.SETRANGE(SpecsDetails."Specs ID", specs."Specs ID");
                                    SpecsDetails.SETRANGE(SpecsDetails."Version Code", specsVersion."Version Code");
                                    IF SpecsDetails.FINDSET THEN
                                        InitProdInspection(recProdOrder, recProdLine, recReservation."Lot No.", recReservation."Qty. to Handle (Base)", SpecsDetails);
                                END
                                ELSE BEGIN
                                    SpecsDetails.RESET;
                                    SpecsDetails.SETRANGE(SpecsDetails."Specs ID", specs."Specs ID");
                                    SpecsDetails.SETRANGE(SpecsDetails."Version Code", '');
                                    IF SpecsDetails.FINDSET THEN
                                        InitProdInspection(recProdOrder, recProdLine, recReservation."Lot No.", recReservation."Qty. to Handle (Base)", SpecsDetails);
                                END;
                            END;
                        UNTIL recReservation.NEXT = 0;
                END;
            END;
        END;
    end;

    procedure InitProdInspection(var ProdOrder: Record 5405; var ProdLine: Record 5406; Lot: Code[20]; Qty: Decimal; var Specs: Record 50016);
    var
        TempInspectionDataSheet: Record 50011;
        TempInspectionDataSheetLine: Record 50012;
        QltySetup: Record 50010;
        recItem: Record 27;
        SpecsDetails: Record 50016;
    begin
        WITH recProdOrder DO BEGIN
            TempInspectionDataSheet.RESET;
            TempInspectionDataSheet.INIT;
            QltySetup.GET;
            QltySetup.TESTFIELD(QltySetup."Inspection Sheet No. Series");
            TempInspectionDataSheet."No." := NoSeriesMgmt.GetNextNo(QltySetup."Inspection Sheet No. Series", WORKDATE, TRUE);
            TempInspectionDataSheet."Document Type" := TempInspectionDataSheet."Document Type"::"Prod. Order";
            TempInspectionDataSheet."Document No." := "No.";
            TempInspectionDataSheet."Ref ID" := ProdLine."Line No.";
            TempInspectionDataSheet."Posting Date" := "Finished Date";
            TempInspectionDataSheet.Quantity := Qty;//PCPL0041-04022020
                                                    //TempInspectionDataSheet.Quantity:=ProdLine.Quantity;    //PCPl/BRB-As per mam requirement//PCPL0041-04022020
            TempInspectionDataSheet."Document Date" := WORKDATE;
            TempInspectionDataSheet."Prod. Order Date" := "Due Date";
            TempInspectionDataSheet."Lot No." := Lot;
            TempInspectionDataSheet."Location Code" := "Location Code";
            TempInspectionDataSheet."Bin Code" := ProdLine."Bin Code";
            TempInspectionDataSheet."Purch. Order Quantity" := 0;
            TempInspectionDataSheet."Vendor No." := '';
            TempInspectionDataSheet."Vendor Name" := '';
            TempInspectionDataSheet."Item No." := ProdLine."Item No.";
            TempInspectionDataSheet."Specs ID" := Specs."Specs ID";
            IF recItem.GET(ProdLine."Item No.") THEN BEGIN
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
            TempInspectionDataSheet."GRN Quantity" := 0;
            //TempInspectionDataSheet."Prod. Order Quantity":=ProdLine.Quantity;//PCPL0041-04022020
            TempInspectionDataSheet."Prod. Order Quantity" := Qty;//PCPL0041-04022020
            TempInspectionDataSheet.Approval := TempInspectionDataSheet.Approval::WIP;
            TempInspectionDataSheet.Status := TempInspectionDataSheet.Status::Open;
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
                    TempInspectionDataSheetLine."Document Type" := TempInspectionDataSheetLine."Document Type"::"Prod. Order";
                    TempInspectionDataSheetLine."Document No." := "No.";
                    TempInspectionDataSheetLine."Line No." := SpecsDetails."Line No.";
                    TempInspectionDataSheetLine."Qlty Measure Code" := SpecsDetails."Qlty Measure Code";
                    TempInspectionDataSheetLine."Account Type" := SpecsDetails."Account Type";
                    TempInspectionDataSheetLine."Item No." := recItem."No.";
                    TempInspectionDataSheetLine."Parent Group Code" := SpecsDetails."Parent Group Code";
                    TempInspectionDataSheetLine."Qc Description" := SpecsDetails.Description;
                    TempInspectionDataSheetLine."Unit of Measure" := SpecsDetails."Unit of Measure";
                    TempInspectionDataSheetLine."Test Mandatory" := SpecsDetails."Test Manadatory";
                    TempInspectionDataSheetLine."Posting Date" := WORKDATE;
                    TempInspectionDataSheetLine."Min. Value" := SpecsDetails."Min. Value";
                    TempInspectionDataSheetLine."Max. Value" := SpecsDetails."Max. Value";
                    TempInspectionDataSheetLine."Text Value" := SpecsDetails."Text Value";
                    TempInspectionDataSheetLine."Actual Value" := 0;
                    TempInspectionDataSheetLine.Remark := '';
                    TempInspectionDataSheetLine."Purchase Order No." := "No.";
                    TempInspectionDataSheetLine."Purchase Line No." := recProdLine."Line No.";
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
        //PCPL QC 2.0
    end;
}

