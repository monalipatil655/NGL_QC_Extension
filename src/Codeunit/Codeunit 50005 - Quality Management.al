codeunit 50005 "Quality Management"
{
    // version PCPL/QC/V3/001,QC3.0,PCPL QC/ 03/BRB,PCPLYSR

    // //PCPL QC/ 03/BRB Code added for UOM
    // //PCPL/BRB/03 -29Jan18 code added for file attach

    Permissions = TableData 32 = rm,
                  TableData 6550 = rimd;
    // TableData 50127=rimd,
    //TableData 50128=rimd,
    //TableData 50136=rimd,
    //TableData 50137=rimd;

    trigger OnRun();
    begin
    end;

    var
        LotInfo: Record 6505;
        QCSetup: Record 50010;
        NoSeriesMgmt: Codeunit 396;
        recItem: Record 27;
        SKU: Record 5700;

    procedure CreateReceiptEntry(var InspectionDS: Record 50011);
    var
        recInspectionReceipt: Record 50020;
        tempInspectionReceipt: Record 50020;
        recInspectionSheetLine: Record 50012;
        InspectionLedger: Record 50014;
    begin
        WITH InspectionDS DO BEGIN
            QCSetup.GET;
            QCSetup.TESTFIELD("Inspection Receipt No. Series");
            recInspectionReceipt.RESET;
            recInspectionReceipt.SETRANGE(recInspectionReceipt."Item No.", "Item No.");
            recInspectionReceipt.SETRANGE(recInspectionReceipt."Lot No.", "Lot No.");
            recInspectionReceipt.SETRANGE(recInspectionReceipt."Certificate No.", "Certificate No.");
            IF recInspectionReceipt.FINDFIRST THEN BEGIN
                CreateReceiptLine(InspectionDS, recInspectionReceipt);
                InspectionLedger.RESET;
                InspectionLedger.SETRANGE(InspectionLedger."No.", "No.");
                IF InspectionLedger.FINDFIRST THEN BEGIN
                    InspectionLedger."Inspection Receipt No." := recInspectionReceipt."No.";
                    InspectionLedger.MODIFY;
                END;
            END
            ELSE BEGIN
                tempInspectionReceipt.INIT;
                tempInspectionReceipt.TRANSFERFIELDS(InspectionDS);
                tempInspectionReceipt."No." := NoSeriesMgmt.GetNextNo(QCSetup."Inspection Receipt No. Series", WORKDATE, TRUE);
                tempInspectionReceipt."Inspected By" := USERID;
                //tempInspectionReceipt."Analyzed on":=WORKDATE;    //PCPL 38
                CALCFIELDS("File Attach");
                tempInspectionReceipt."File Attach" := "File Attach";     //PCPL/BRB/03 -29Jan18
                tempInspectionReceipt.Approval := tempInspectionReceipt.Approval::"Under Approval";
                tempInspectionReceipt."Inspection Sheet No." := "No.";
                CreateReceiptLine(InspectionDS, tempInspectionReceipt);
                CreateReceiptLedger(tempInspectionReceipt);
                InspectionLedger.RESET;
                InspectionLedger.SETRANGE(InspectionLedger."No.", "No.");
                IF InspectionLedger.FINDFIRST THEN BEGIN
                    InspectionLedger."Inspection Receipt No." := tempInspectionReceipt."No.";
                    InspectionLedger.MODIFY;
                END;
                tempInspectionReceipt.INSERT;
            END;
            recInspectionSheetLine.RESET;
            recInspectionSheetLine.SETRANGE(recInspectionSheetLine."No.", "No.");
            IF recInspectionSheetLine.FINDSET THEN
                recInspectionSheetLine.DELETEALL;
            DELETE;
        END;
    end;

    procedure CreateReceiptLine(var InspectionDataSheet: Record 50011; var InspectionDataReceipt: Record 50020);
    var
        InspectionDSL: Record 50012;
        InspectionRL: Record 50021;
        vLineNo: Integer;
        tempInspectionRL: Record 50021;
        recItem: Record 27;
    begin
        InspectionDSL.RESET;
        InspectionDSL.SETRANGE(InspectionDSL."No.", InspectionDataSheet."No.");
        IF InspectionDSL.FINDSET THEN
            REPEAT
                InspectionRL.RESET;
                InspectionRL.SETRANGE(InspectionRL."No.", InspectionDataReceipt."No.");
                IF InspectionRL.FINDLAST THEN
                    vLineNo := InspectionRL."Line No.";
                tempInspectionRL.INIT;
                tempInspectionRL.TRANSFERFIELDS(InspectionDSL);
                tempInspectionRL."No." := InspectionDataReceipt."No.";
                tempInspectionRL."Line No." := vLineNo + 10000;
                tempInspectionRL.INSERT;
            UNTIL InspectionDSL.NEXT = 0;
    end;

    procedure CreatePostedEntry(var InspectionRS: Record 50020);
    var
        insertPostedInspection: Record 50022;
        InspectionLedger: Record 50014;
        recInspectionRcptLine: Record 50021;
        recILE: Record 32;
        recReservationEntry: Record 337;
        recItem: Record 27;
    begin
        WITH InspectionRS DO BEGIN
            QCSetup.GET;
            QCSetup.TESTFIELD(QCSetup."Posted Inspection No. Series");
            recItem.GET("Item No.");
            insertPostedInspection.INIT;
            insertPostedInspection.TRANSFERFIELDS(InspectionRS);
            insertPostedInspection."No." := NoSeriesMgmt.GetNextNo(QCSetup."Posted Inspection No. Series", WORKDATE, TRUE);
            insertPostedInspection."Approved By" := USERID;
            insertPostedInspection."Retest on" := CALCDATE(recItem."Retest Duration", "Posting Date"); // Replace (recItem."Retesting Frequency") with (recItem."Retesting Frequency")
            insertPostedInspection."Inspection Receipt No." := "No.";
            CALCFIELDS("File Attach");
            insertPostedInspection."File Attach" := "File Attach";     //PCPL/BRB/03 -29Jan18
            CreatePostedLine(InspectionRS, insertPostedInspection);
            CreatePostedLedger(insertPostedInspection, InspectionRS);
            CreateItemMovement(InspectionRS);
            IF "Before GRN" THEN BEGIN
                recReservationEntry.RESET;
                recReservationEntry.SETRANGE(recReservationEntry."Lot No.", "Lot No.");
                recReservationEntry.SETRANGE(recReservationEntry."Source ID", "Document No.");
                recReservationEntry.SETRANGE(recReservationEntry."Source Ref. No.", "Ref ID");
                IF recReservationEntry.FINDFIRST THEN BEGIN
                    recReservationEntry.VALIDATE("Quantity (Base)", "Approved Quantity");
                    recReservationEntry.VALIDATE(Quantity, "Approved Quantity");
                    recReservationEntry.VALIDATE(recReservationEntry."Qty. to Handle (Base)", "Approved Quantity");
                    recReservationEntry.VALIDATE(recReservationEntry."Qty. to Invoice (Base)", "Approved Quantity");
                    recReservationEntry.MODIFY;
                END;
            END;
            //Updating ILE
            IF "Item Tracking" THEN BEGIN
                //PCPL-25 16Dec21
                IF InspectionRS."Document Type" = InspectionRS."Document Type"::Transfer THEN BEGIN
                    recILE.RESET;
                    recILE.SETRANGE(recILE."Item No.", "Item No.");
                    recILE.SETRANGE(recILE."Lot No.", "Lot No.");
                    recILE.SETRANGE("Order No.", "Document No.");
                    recILE.SETRANGE("Order Type", "Document Type");
                    recILE.SETRANGE("Document No.", "Transfer Receipt No.");
                    IF recILE.FINDLAST THEN BEGIN
                        UpdateLotInfo(recILE."Lot No.", recILE."Item No.", Approval = Approval::Rejected, Quantity);
                        IF Approval <> Approval::Rejected THEN
                            recILE."QC Status" := recILE."QC Status"::Approved
                        ELSE
                            recILE."QC Status" := recILE."QC Status"::Rejected;
                        recILE.MODIFY;
                    END;
                END
                ELSE BEGIN
                    //PCPL-25 16Dec21
                    recILE.RESET;
                    recILE.SETRANGE(recILE."Item No.", "Item No.");
                    recILE.SETRANGE(recILE."Lot No.", "Lot No.");
                    IF recILE.FINDFIRST THEN BEGIN
                        UpdateLotInfo(recILE."Lot No.", recILE."Item No.", Approval = Approval::Rejected, Quantity);
                        IF Approval <> Approval::Rejected THEN BEGIN
                            recILE."QC Status" := recILE."QC Status"::Approved;
                            //recILE."QC Retest Date":=CALCDATE(recItem."Retesting Frequency","Posting Date");  // Replace (recItem."Retesting Frequency") with (recItem."Retesting Frequency")
                        END
                        ELSE BEGIN
                            recILE."QC Status" := recILE."QC Status"::Rejected;
                        END;
                        recILE.MODIFY;
                    END;
                END;      //PCPL-25 16Dec21
            END;
            insertPostedInspection.INSERT;
            recInspectionRcptLine.RESET;
            recInspectionRcptLine.SETRANGE(recInspectionRcptLine."No.", InspectionRS."No.");
            IF recInspectionRcptLine.FINDSET THEN
                recInspectionRcptLine.DELETEALL;
            DELETE;
        END;
    end;

    procedure CreatePstdEntrywithCondRel(var InspectionRS: Record 50020);
    var
        insertPostedInspection: Record 50022;
        InspectionLedger: Record 50014;
        recInspectionRcptLine: Record 50021;
        recILE: Record 32;
        recReservationEntry: Record 337;
        recItem: Record 27;
    begin
        WITH InspectionRS DO BEGIN
            QCSetup.GET;
            QCSetup.TESTFIELD(QCSetup."Posted Inspection No. Series");
            recItem.GET("Item No.");
            insertPostedInspection.INIT;
            insertPostedInspection.TRANSFERFIELDS(InspectionRS);
            insertPostedInspection."No." := NoSeriesMgmt.GetNextNo(QCSetup."Posted Inspection No. Series", WORKDATE, TRUE);
            insertPostedInspection."Approved By" := USERID;
            //insertPostedInspection."Retest on":=CALCDATE(recItem."Retesting Frequency","Posting Date");  // Replace (recItem."Retesting Frequency") with (recItem."Retesting Frequency")
            insertPostedInspection."Inspection Receipt No." := "No.";
            insertPostedInspection."Conditional Released" := TRUE;
            CreatePostedLine(InspectionRS, insertPostedInspection);
            CreatePostedLedger(insertPostedInspection, InspectionRS);
            CreateItemMovement(InspectionRS);
            IF "Before GRN" THEN BEGIN
                recReservationEntry.RESET;
                recReservationEntry.SETRANGE(recReservationEntry."Lot No.", "Lot No.");
                recReservationEntry.SETRANGE(recReservationEntry."Source ID", "Document No.");
                recReservationEntry.SETRANGE(recReservationEntry."Source Ref. No.", "Ref ID");
                IF recReservationEntry.FINDFIRST THEN BEGIN
                    recReservationEntry.VALIDATE("Quantity (Base)", "Approved Quantity");
                    recReservationEntry.VALIDATE(Quantity, "Approved Quantity");
                    recReservationEntry.VALIDATE(recReservationEntry."Qty. to Handle (Base)", "Approved Quantity");
                    recReservationEntry.VALIDATE(recReservationEntry."Qty. to Invoice (Base)", "Approved Quantity");
                    recReservationEntry.MODIFY;
                END;
            END;
            //Updating ILE
            IF "Item Tracking" THEN BEGIN
                recILE.RESET;
                recILE.SETRANGE(recILE."Item No.", "Item No.");
                recILE.SETRANGE(recILE."Lot No.", "Lot No.");
                IF recILE.FINDFIRST THEN BEGIN
                    UpdateLotInfo(recILE."Lot No.", recILE."Item No.", Approval = Approval::Rejected, Quantity);
                    IF Approval <> Approval::Rejected THEN BEGIN
                        recILE."QC Status" := recILE."QC Status"::Approved;
                        //recILE."QC Retest Date":=CALCDATE(recItem."Retesting Frequency","Posting Date"); // Replace (recItem."Retesting Frequency") with (recItem."Retesting Frequency")
                    END
                    ELSE BEGIN
                        recILE."QC Status" := recILE."QC Status"::Rejected;
                    END;
                    recILE.MODIFY;
                END;
            END;
            insertPostedInspection.INSERT;
            recInspectionRcptLine.RESET;
            recInspectionRcptLine.SETRANGE(recInspectionRcptLine."No.", InspectionRS."No.");
            IF recInspectionRcptLine.FINDSET THEN
                recInspectionRcptLine.DELETEALL;
            DELETE;
        END;
    end;

    procedure CreatePostedLine(var InspectionDataReceipt: Record 50020; var PostedInspection: Record 50022);
    var
        InspectionRL: Record 50021;
        vLineNo: Integer;
        insertPostedInspectLine: Record 50023;
    begin
        InspectionRL.RESET;
        InspectionRL.SETRANGE(InspectionRL."No.", InspectionDataReceipt."No.");
        IF InspectionRL.FINDSET THEN
            REPEAT
                insertPostedInspectLine.INIT;
                insertPostedInspectLine.TRANSFERFIELDS(InspectionRL);
                insertPostedInspectLine."No." := PostedInspection."No.";
                insertPostedInspectLine.INSERT;
            UNTIL InspectionRL.NEXT = 0;
    end;

    procedure CreateEntryLedger(var InspectionDS: Record 50011);
    var
        InspectionLedger: Record 50014;
    begin
        WITH InspectionDS DO BEGIN
            InspectionLedger.INIT;
            InspectionLedger."No." := "No.";
            InspectionLedger."Document Type" := "Document Type";
            InspectionLedger."Document No." := "Document No.";
            InspectionLedger."Lot No." := "Lot No.";
            InspectionLedger."Ref ID" := "Ref ID";
            InspectionLedger."Document Date" := "Document Date";
            InspectionLedger."Posting Date" := WORKDATE;
            InspectionLedger."Location Code" := "Location Code";
            InspectionLedger."Bin Code" := "Bin Code";
            InspectionLedger.Quantity := Quantity;
            InspectionLedger."Item No." := "Item No.";
            InspectionLedger."Item Description" := "Item Description";
            InspectionLedger."Item Description 2" := "Item Description 2";
            InspectionLedger."Unit of Messure" := "Unit of Messure";
            InspectionLedger."Item Tracking" := "Item Tracking";
            InspectionLedger."Certificate No." := "Certificate No.";
            InspectionLedger."GRN No." := "GRN No.";
            InspectionLedger."GRN Date" := "GRN Date";
            InspectionLedger."GRN Quantity" := "GRN Quantity";
            InspectionLedger."Prod. Order Quantity" := "Prod. Order Quantity";
            InspectionLedger.Approval := Approval;
            InspectionLedger."Transaction Type" := InspectionLedger."Transaction Type"::Entry;
            InspectionLedger."Retest Document" := "Retest Document";
            InspectionLedger.INSERT;
        END;
    end;

    procedure CreateReceiptLedger(var InspectionDR: Record 50020);
    var
        InspectionLedger: Record 50014;
    begin
        WITH InspectionDR DO BEGIN
            InspectionLedger.INIT;
            InspectionLedger."No." := "No.";
            InspectionLedger."Document Type" := "Document Type";
            InspectionLedger."Document No." := "Document No.";
            InspectionLedger."Lot No." := "Lot No.";
            InspectionLedger."Ref ID" := "Ref ID";
            InspectionLedger."Document Date" := "Document Date";
            InspectionLedger."Posting Date" := WORKDATE;
            InspectionLedger."Location Code" := "Location Code";
            InspectionLedger."Bin Code" := "Bin Code";
            InspectionLedger.Quantity := Quantity;
            InspectionLedger."Item No." := "Item No.";
            InspectionLedger."Item Description" := "Item Description";
            InspectionLedger."Item Description 2" := "Item Description 2";
            InspectionLedger."Unit of Messure" := "Unit of Messure";
            InspectionLedger."Item Tracking" := "Item Tracking";
            InspectionLedger."Certificate No." := "Certificate No.";
            InspectionLedger."GRN No." := "GRN No.";
            InspectionLedger."GRN Date" := "GRN Date";
            InspectionLedger."GRN Quantity" := "GRN Quantity";
            InspectionLedger."Prod. Order Quantity" := "Prod. Order Quantity";
            InspectionLedger.Approval := InspectionDR.Approval;
            InspectionLedger."Transaction Type" := InspectionLedger."Transaction Type"::Receipt;
            InspectionLedger."Retest Document" := "Retest Document";
            InspectionLedger.INSERT;
        END;
    end;

    procedure CreatePostedLedger(var recPostedInspection: Record 50022; var recInspectionReceipt: Record 50020);
    var
        InspectionLedger: Record 50014;
    begin
        WITH recPostedInspection DO BEGIN
            //Creating ledger having partial approved and rejected qty
            IF Approval <> Approval::"Partially Approved" THEN BEGIN
                InspectionLedger.INIT;
                InspectionLedger."No." := "No.";
                InspectionLedger."Document Type" := "Document Type";
                InspectionLedger."Document No." := "Document No.";
                InspectionLedger."Lot No." := "Lot No.";
                InspectionLedger."Ref ID" := "Ref ID";
                InspectionLedger."Document Date" := "Document Date";
                InspectionLedger."Posting Date" := WORKDATE;
                InspectionLedger."Location Code" := "Location Code";
                InspectionLedger."Bin Code" := "Bin Code";
                InspectionLedger.Quantity := Quantity;
                InspectionLedger."Item No." := "Item No.";
                InspectionLedger."Item Description" := "Item Description";
                InspectionLedger."Item Description 2" := "Item Description 2";
                InspectionLedger."Unit of Messure" := "Unit of Messure";
                InspectionLedger."Item Tracking" := "Item Tracking";
                InspectionLedger."Certificate No." := "Certificate No.";
                InspectionLedger."GRN No." := "GRN No.";
                InspectionLedger."GRN Date" := "GRN Date";
                InspectionLedger."GRN Quantity" := "GRN Quantity";
                InspectionLedger."Prod. Order Quantity" := "Prod. Order Quantity";
                InspectionLedger.Approval := recPostedInspection.Approval;
                InspectionLedger.Status := Status;
                InspectionLedger."Inspection Receipt No." := recInspectionReceipt."No.";
                InspectionLedger."Transaction Type" := InspectionLedger."Transaction Type"::Posted;
                InspectionLedger."Retest Document" := "Retest Document";
                InspectionLedger.INSERT;
            END
            ELSE BEGIN
                //Creating approved ledger entry
                InspectionLedger.INIT;
                InspectionLedger."No." := "No.";
                InspectionLedger."Document Type" := "Document Type";
                InspectionLedger."Document No." := "Document No.";
                InspectionLedger."Lot No." := "Lot No.";
                InspectionLedger."Ref ID" := "Ref ID";
                InspectionLedger."Document Date" := "Document Date";
                InspectionLedger."Posting Date" := WORKDATE;
                InspectionLedger."Location Code" := "Location Code";
                InspectionLedger."Bin Code" := "Bin Code";
                InspectionLedger.Quantity := "Approved Quantity";
                InspectionLedger."Item No." := "Item No.";
                InspectionLedger."Item Description" := "Item Description";
                InspectionLedger."Item Description 2" := "Item Description 2";
                InspectionLedger."Unit of Messure" := "Unit of Messure";
                InspectionLedger."Item Tracking" := "Item Tracking";
                InspectionLedger."Certificate No." := "Certificate No.";
                InspectionLedger."GRN No." := "GRN No.";
                InspectionLedger."GRN Date" := "GRN Date";
                InspectionLedger."GRN Quantity" := "GRN Quantity";
                InspectionLedger."Prod. Order Quantity" := "Prod. Order Quantity";
                InspectionLedger.Approval := InspectionLedger.Approval::Approved;
                InspectionLedger.Status := Status;
                InspectionLedger."Inspection Receipt No." := recInspectionReceipt."No.";
                InspectionLedger."Transaction Type" := InspectionLedger."Transaction Type"::Posted;
                InspectionLedger."Retest Document" := "Retest Document";
                InspectionLedger.INSERT;

                //Creating rejected ledger entry
                InspectionLedger.INIT;
                InspectionLedger."No." := "No.";
                InspectionLedger."Document Type" := "Document Type";
                InspectionLedger."Document No." := "Document No.";
                InspectionLedger."Lot No." := "Lot No.";
                InspectionLedger."Ref ID" := "Ref ID";
                InspectionLedger."Document Date" := "Document Date";
                InspectionLedger."Posting Date" := WORKDATE;
                InspectionLedger."Location Code" := "Location Code";
                InspectionLedger."Bin Code" := "Bin Code";
                InspectionLedger.Quantity := "Rejected Quantity";
                InspectionLedger."Item No." := "Item No.";
                InspectionLedger."Item Description" := "Item Description";
                InspectionLedger."Item Description 2" := "Item Description 2";
                InspectionLedger."Unit of Messure" := "Unit of Messure";
                InspectionLedger."Item Tracking" := "Item Tracking";
                InspectionLedger."Certificate No." := "Certificate No.";
                InspectionLedger."GRN No." := "GRN No.";
                InspectionLedger."GRN Date" := "GRN Date";
                InspectionLedger."GRN Quantity" := "GRN Quantity";
                InspectionLedger."Prod. Order Quantity" := "Prod. Order Quantity";
                InspectionLedger.Approval := InspectionLedger.Approval::Rejected;
                InspectionLedger.Status := Status;
                InspectionLedger."Inspection Receipt No." := recInspectionReceipt."No.";
                InspectionLedger."Transaction Type" := InspectionLedger."Transaction Type"::Posted;
                InspectionLedger."Retest Document" := "Retest Document";
                InspectionLedger.INSERT;
            END;
        END;
    end;

    procedure CreateLotInfo(LotNo: Code[20]; ItemCode: Code[20]; Cert: Code[20]);
    var
        recLot: Record 6505;
    begin
        LotInfo.RESET;
        LotInfo.SETRANGE(LotInfo."Item No.", ItemCode);
        LotInfo.SETRANGE(LotInfo."Lot No.", LotNo);
        IF NOT LotInfo.FINDFIRST THEN BEGIN
            recLot.INIT;
            recLot."Item No." := ItemCode;
            recLot."Lot No." := LotNo;
            recLot."Certificate Number" := Cert;
            recLot.INSERT
        END
        ELSE BEGIN
            LotInfo."Certificate Number" := Cert;
            LotInfo.MODIFY;
        END;
    end;

    procedure UpdateLotInfo(Lot: Code[20]; ItemCode: Code[20]; Blocked: Boolean; Quantity: Decimal);
    begin
        LotInfo.RESET;
        LotInfo.SETRANGE(LotInfo."Item No.", ItemCode);
        LotInfo.SETRANGE(LotInfo."Lot No.", Lot);
        IF LotInfo.FINDFIRST THEN BEGIN
            LotInfo.Blocked := Blocked;
            IF NOT Blocked THEN BEGIN
                LotInfo."Test Quality" := LotInfo."Test Quality"::Bad;
            END
            ELSE BEGIN
                LotInfo."Test Quality" := LotInfo."Test Quality"::Good;

            END;
            LotInfo.MODIFY;
        END;
    end;

    procedure CreateInspectionForRetest(PostedInspection: Record 50022; itemRetest: Record 50013);
    var
        Specs: Record 50015;
        SpecsDetails: Record 50016;
        SpecsDetailsBuffer: Record 50016;
        InspectionData: Record 50011;
        recItem: Record 27;
    begin
        QCSetup.GET;
        IF QCSetup."Split Inspection Group Wise" THEN BEGIN
            SKU.RESET;
            SKU.SETRANGE(SKU."Item No.", PostedInspection."Item No.");
            SKU.SETRANGE(SKU."Location Code", PostedInspection."Location Code");
            IF SKU.FINDSET THEN BEGIN
                Specs.GET(SKU."Specs ID");
                SpecsDetails.RESET;
                SpecsDetails.SETRANGE(SpecsDetails."Specs ID", Specs."Specs ID");
                SpecsDetails.SETRANGE(SpecsDetails."Version Code", '');
                SpecsDetails.SETRANGE(SpecsDetails."Account Type", SpecsDetails."Account Type"::"Begin");
                IF SpecsDetails.FINDSET THEN
                    REPEAT
                        InspectionData.INIT;
                        InspectionData.TRANSFERFIELDS(PostedInspection);
                        InspectionData."No." := NoSeriesMgmt.GetNextNo(QCSetup."Inspection Sheet No. Series", WORKDATE, TRUE);
                        InspectionData."Retest Document" := TRUE;
                        InspectionData."Retest from Doc No" := PostedInspection."No.";
                        InspectionData."Certificate No." := NoSeriesMgmt.GetNextNo(QCSetup."AR No. Series", WORKDATE, TRUE);
                        //InspectionData."Retest on":=CALCDATE(recItem."Retesting Frequency",WORKDATE); // Replace (recItem."Retesting Frequency") with (recItem."Retesting Frequency")
                        InspectionData."Posting Date" := WORKDATE;
                        //InspectionData.Quantity:=calcAvailableInventory(recItem."No.",PostedInspection."Location Code",itemRetest."Bin Code",itemRetest."Lot No.");   //PCPL-25 temp
                        InspectionData.Quantity := itemRetest."Remaining Quantity";     //PCPL-25
                        InspectionData."Bin Code" := itemRetest."Bin Code";
                        InspectionData.Approval := InspectionData.Approval::WIP;
                        InspectionData.Status := InspectionData.Status::Open;
                        InspectionData."Reviewed On" := 0D;
                        InspectionData."Reviewed By" := '';
                        InspectionData."QA Reviewed" := FALSE;
                        InspectionData."Sample Drawn Quantity" := 0;
                        InspectionData."Sample Drawn On" := 0D;
                        InspectionData."Approved Quantity" := 0;
                        InspectionData."Rejected Quantity" := 0;
                        InspectionData."Control Sample Quantity" := 0;
                        InspectionData."COA Printed" := FALSE;
                        InspectionData."Specs ID" := Specs."Specs ID";
                        CreateInsLineForRetest(SpecsDetails, InspectionData);
                        CreateEntryLedger(InspectionData);
                        InspectionData.INSERT;
                        SpecsDetailsBuffer.RESET;
                    UNTIL SpecsDetails.NEXT = 0;
            END;
        END
        ELSE BEGIN
            /*
             SKU.RESET;
            SKU.SETRANGE(SKU."Item No.",PostedInspection."Item No.");
            SKU.SETRANGE(SKU."Location Code",PostedInspection."Location Code");
            */
            IF recItem.GET(PostedInspection."Item No.") THEN BEGIN
                Specs.GET(recItem."Specs ID");
                SpecsDetails.RESET;
                SpecsDetails.SETRANGE(SpecsDetails."Specs ID", Specs."Specs ID");
                SpecsDetails.SETRANGE(SpecsDetails."Version Code", '');
                IF SpecsDetails.FINDSET THEN BEGIN
                    InspectionData.INIT;
                    InspectionData.TRANSFERFIELDS(PostedInspection);
                    InspectionData."No." := NoSeriesMgmt.GetNextNo(QCSetup."Inspection Sheet No. Series", WORKDATE, TRUE);
                    InspectionData."Retest Document" := TRUE;
                    InspectionData."Retest from Doc No" := PostedInspection."No.";
                    InspectionData."Certificate No." := GetCertificate(InspectionData);
                    InspectionData."Retest on" := CALCDATE(recItem."Retest Duration", WORKDATE); // Replace (recItem."Retesting Frequency") with (recItem."Retesting Frequency")
                    InspectionData."Posting Date" := WORKDATE;
                    InspectionData."Bin Code" := PostedInspection."Bin Code";
                    InspectionData.Quantity := calcAvailableInventory(recItem."No.", PostedInspection."Location Code", itemRetest."Bin Code", PostedInspection."Lot No.");  //PCPL-25 temp comment
                                                                                                                                                                            //InspectionData.Quantity:=PostedInspection."Approved Quantity";
                    InspectionData.Quantity := itemRetest."Remaining Quantity";   //PCPL-25
                    InspectionData."Bin Code" := itemRetest."Bin Code";
                    InspectionData.Approval := InspectionData.Approval::WIP;
                    InspectionData.Status := InspectionData.Status::Open;
                    InspectionData."Reviewed On" := 0D;
                    InspectionData."Reviewed By" := '';
                    InspectionData."QA Reviewed" := FALSE;
                    InspectionData."Sample Drawn Quantity" := 0;
                    InspectionData."Sample Drawn On" := 0D;
                    InspectionData."Approved Quantity" := 0;
                    InspectionData."Rejected Quantity" := 0;
                    InspectionData."Control Sample Quantity" := 0;
                    InspectionData."COA Printed" := FALSE;
                    InspectionData."Specs ID" := Specs."Specs ID";
                    CreateInsLineForRetest(SpecsDetails, InspectionData);
                    CreateEntryLedger(InspectionData);
                    InspectionData.INSERT;
                    SpecsDetailsBuffer.RESET;
                END;
            END;
        END;

    end;

    procedure CreateInsLineForRetest(var SpecsDetails: Record 50016; var InspectionDS: Record 50011);
    var
        tempSpecsDetails: Record 50016;
        tempInspectionLine: Record 50012;
        vLine: Integer;
        recInspectionLine: Record 50012;
    begin
        tempSpecsDetails.RESET;
        tempSpecsDetails.SETRANGE(tempSpecsDetails."Specs ID", SpecsDetails."Specs ID");
        tempSpecsDetails.SETRANGE(tempSpecsDetails."Version Code", SpecsDetails."Version Code");
        tempSpecsDetails.SETRANGE(tempSpecsDetails."Parent Group Code", SpecsDetails."Group Code");
        tempSpecsDetails.SETRANGE(tempSpecsDetails.Retest, TRUE);
        IF tempSpecsDetails.FINDSET THEN
            REPEAT
                tempInspectionLine.RESET;
                tempInspectionLine.SETRANGE(tempInspectionLine."No.", InspectionDS."No.");
                IF tempInspectionLine.FINDLAST THEN
                    vLine := tempInspectionLine."Line No.";
                recInspectionLine.INIT;
                recInspectionLine."No." := InspectionDS."No.";
                recInspectionLine."Line No." := vLine + 10000;
                recInspectionLine."Document Type" := InspectionDS."Document Type";
                recInspectionLine."Document No." := InspectionDS."Document No.";
                recInspectionLine."Item No." := InspectionDS."Item No.";
                recInspectionLine."Qc Description" := tempSpecsDetails.Description;
                recInspectionLine."Parent Group Code" := tempSpecsDetails."Parent Group Code";
                recInspectionLine."Qlty Measure Code" := tempSpecsDetails."Qlty Measure Code";
                recInspectionLine."Account Type" := tempSpecsDetails."Account Type";
                recInspectionLine."Posting Date" := WORKDATE;
                recInspectionLine."Min. Value" := tempSpecsDetails."Min. Value";
                recInspectionLine."Max. Value" := tempSpecsDetails."Max. Value";
                recInspectionLine."Text Value" := tempSpecsDetails."Text Value";
                recInspectionLine."Unit of Measure" := tempSpecsDetails."Unit of Measure";
                recInspectionLine."Test Mandatory" := tempSpecsDetails."Test Manadatory";
                recInspectionLine.Qualitative := tempSpecsDetails.Qualitative;
                //>>QC3.0
                recInspectionLine."Additional Text Value" := tempSpecsDetails."Additional Text Value";
                recInspectionLine."Additional Text Value 2" := tempSpecsDetails."Additional Text Value 2";
                recInspectionLine."Additional Text Value 3" := tempSpecsDetails."Additional Text Value 3";
                //<<QC3.0
                recInspectionLine.INSERT;
            UNTIL tempSpecsDetails.NEXT = 0;
    end;

    procedure GetCertificate(var InspectionDataSheet: Record 50011) Certificate: Code[20];
    var
        recInsDataSheet: Record 50011;
        NoSeriesMgmt: Codeunit 396;
        QCSetup: Record 50010;
        Location: Record 14;
        recItem: Record 27;
    begin
        //IRLQC/CUST/003
        Location.GET(InspectionDataSheet."Location Code");
        recItem.GET(InspectionDataSheet."Item No.");

        recInsDataSheet.RESET;
        recInsDataSheet.SETRANGE(recInsDataSheet."Lot No.", InspectionDataSheet."Lot No.");
        recInsDataSheet.SETRANGE(recInsDataSheet."Item No.", InspectionDataSheet."Item No.");
        IF NOT recInsDataSheet.FINDFIRST THEN BEGIN
            IF recItem."Inventory Posting Group" = 'FG' THEN BEGIN
                Location.TESTFIELD(Location."FG AR No. Series");
                EXIT(NoSeriesMgmt.GetNextNo(Location."FG AR No. Series", WORKDATE, TRUE))
            END
            ELSE
                IF recItem."Inventory Posting Group" = 'RM' THEN BEGIN
                    Location.TESTFIELD(Location."RM AR No. Series");
                    EXIT(NoSeriesMgmt.GetNextNo(Location."RM AR No. Series", WORKDATE, TRUE))
                END
                ELSE
                    IF recItem."Inventory Posting Group" = 'PM' THEN BEGIN
                        Location.TESTFIELD(Location."PM AR No. Series");
                        EXIT(NoSeriesMgmt.GetNextNo(Location."PM AR No. Series", WORKDATE, TRUE))
                    END
                    ELSE BEGIN
                        Location.TESTFIELD(Location."Others AR No. Series");
                        EXIT(NoSeriesMgmt.GetNextNo(Location."Others AR No. Series", WORKDATE, TRUE))
                    END;
        END
        ELSE
            EXIT(recInsDataSheet."Certificate No.");
        //IRLQC/CUST/003
    end;

    procedure CreateSampleEntry(InspectionDS: Record 50011);
    var
        WhseBatch: Record 7310;
        insertWhseJournal: Record 7311;
        tempItemJnlLine: Record 83;
        NoSeriesMgmt: Codeunit 396;
        ItemBatch: Record 233;
        ItemJournalLine: Record 83;
        repCalWhseAdjmt: Report 7315;
        tempWhseItemTracking: Record 6550;
        whseItemTracking: Record 6550;
        vEntry: Integer;
        recLocation: Record 14;
        recReserveEntry: Record 337;
        tempReservation: Record 337;
        whseActivityLine: Record 5767;
        Unit_measure: Record 5404;
        Qtyconversion: Decimal;
    begin
        WITH InspectionDS DO BEGIN
            recLocation.GET("Location Code");
            QCSetup.GET;
            //Creating whse item journal
            IF recLocation."Directed Put-away and Pick" THEN BEGIN
                /*//Reduce Qty to handle from the Put-away created
                  whseActivityLine.RESET;
                  whseActivityLine.SETRANGE("Whse. Document Type",whseActivityLine."Whse. Document Type"::Receipt);
                  whseActivityLine.SETRANGE("Item No.","Item No.");
                  whseActivityLine.SETRANGE("Location Code","Location Code");
                  whseActivityLine.SETRANGE("Lot No.","Lot No.");
                  IF whseActivityLine.FINDSET THEN REPEAT
                    whseActivityLine.VALIDATE("Qty. (Base)",whseActivityLine."Qty. (Base)"-"Sample Drawn Quantity");
                    whseActivityLine.VALIDATE("Qty. to Handle",whseActivityLine."Qty. to Handle"-"Sample Drawn Quantity");
                    whseActivityLine.MODIFY;
                  UNTIL whseActivityLine.NEXT=0; */
                WhseBatch.RESET;
                WhseBatch.SETRANGE(WhseBatch.Name, QCSetup."Whse. Item Batch");
                IF WhseBatch.FINDFIRST THEN;
                insertWhseJournal.RESET;
                insertWhseJournal.SETRANGE("Journal Template Name", WhseBatch."Journal Template Name");
                insertWhseJournal.SETRANGE("Journal Batch Name", QCSetup."Whse. Item Batch");
                insertWhseJournal.DELETEALL;

                insertWhseJournal.INIT;
                insertWhseJournal."Journal Template Name" := WhseBatch."Journal Template Name";
                insertWhseJournal."Journal Batch Name" := QCSetup."Whse. Item Batch";
                insertWhseJournal."Entry Type" := insertWhseJournal."Entry Type"::"Negative Adjmt.";
                insertWhseJournal."Line No." := 10000;
                insertWhseJournal."Registering Date" := WORKDATE;
                insertWhseJournal.VALIDATE("Location Code", "Location Code");
                insertWhseJournal.VALIDATE("Bin Code", "Bin Code");
                insertWhseJournal.VALIDATE("From Bin Code", "Bin Code");
                insertWhseJournal.VALIDATE("To Bin Code", "Bin Code");
                insertWhseJournal.VALIDATE("Item No.", "Item No.");
                insertWhseJournal."Source Code" := 'WHITEM';
                insertWhseJournal."Whse. Document No." := "No.";
                insertWhseJournal."Whse. Document Type" := insertWhseJournal."Whse. Document Type"::"Whse. Journal";
                insertWhseJournal.VALIDATE(Quantity, ("Sample Drawn Quantity"));
                insertWhseJournal."To Bin Code" := recLocation."Adjustment Bin Code";
                insertWhseJournal."To Zone Code" := '';
                insertWhseJournal."User ID" := USERID;
                insertWhseJournal."Reason Code" := QCSetup."Sampling Reason Code";
                insertWhseJournal.INSERT(TRUE);
                whseItemTracking.INIT;
                tempWhseItemTracking.RESET;
                IF tempWhseItemTracking.FINDLAST THEN
                    vEntry := tempWhseItemTracking."Entry No.";
                whseItemTracking."Entry No." := vEntry + 1;
                whseItemTracking.VALIDATE("Item No.", "Item No.");
                whseItemTracking."Location Code" := "Location Code";
                whseItemTracking."Quantity (Base)" := "Sample Drawn Quantity";
                whseItemTracking."Source Type" := 7311;
                whseItemTracking."Source Subtype" := 0;
                whseItemTracking."Source ID" := insertWhseJournal."Journal Batch Name";
                whseItemTracking."Source Batch Name" := insertWhseJournal."Journal Template Name";
                whseItemTracking."Source Ref. No." := insertWhseJournal."Line No.";
                whseItemTracking."Qty. to Handle (Base)" := "Sample Drawn Quantity";
                whseItemTracking."Qty. to Handle" := "Sample Drawn Quantity";
                whseItemTracking."Lot No." := "Lot No.";
                whseItemTracking."Expiration Date" := GetExpiration("Item No.", "Lot No.");
                whseItemTracking."New Expiration Date" := GetExpiration("Item No.", "Lot No.");
                whseItemTracking.INSERT;
                CODEUNIT.RUN(CODEUNIT::"Whse. Jnl.-Register", insertWhseJournal);
                ItemBatch.RESET;
                ItemBatch.SETRANGE(ItemBatch.Name, QCSetup."Item Journal Batch");
                IF ItemBatch.FINDFIRST THEN;
                ItemJournalLine.RESET;
                ItemJournalLine.SETRANGE("Journal Template Name", ItemBatch."Journal Template Name");
                ItemJournalLine.SETRANGE("Journal Batch Name", QCSetup."Item Journal Batch");
                ItemJournalLine.DELETEALL;
                ItemJournalLine.INIT;
                ItemJournalLine.VALIDATE("Journal Template Name", ItemBatch."Journal Template Name");
                ItemJournalLine.VALIDATE("Journal Batch Name", QCSetup."Item Journal Batch");
                ItemJournalLine."Line No." := 0;
                ItemJournalLine."Document No." := "No.";
                CLEAR(repCalWhseAdjmt);
                repCalWhseAdjmt.SetItemJnlLine(ItemJournalLine);
                recItem.GET(InspectionDS."Item No.");
                repCalWhseAdjmt.InitializeRequest(WORKDATE, "No.");
                repCalWhseAdjmt.itemParam("Item No.");
                repCalWhseAdjmt.SETTABLEVIEW(recItem);
                repCalWhseAdjmt.USEREQUESTPAGE(FALSE);
                repCalWhseAdjmt.RUN;
                ItemJournalLine.RESET;
                ItemJournalLine.SETRANGE("Journal Template Name", ItemBatch."Journal Template Name");
                ItemJournalLine.SETRANGE("Journal Batch Name", QCSetup."Item Journal Batch");
                IF ItemJournalLine.FINDFIRST THEN
                    ItemJournalLine."Dimension Set ID" := updateDimension(ItemJournalLine."Dimension Set ID", QCSetup."Resons Dimension");
                ItemJournalLine.MODIFY;
                CODEUNIT.RUN(CODEUNIT::"Item Jnl.-Post", ItemJournalLine);
            END
            ELSE BEGIN
                //Creating item negative adjustment
                tempItemJnlLine.RESET;
                tempItemJnlLine.SETRANGE(tempItemJnlLine."Journal Template Name", 'ITEM');
                tempItemJnlLine.SETRANGE(tempItemJnlLine."Journal Batch Name", 'QC-SAMPLE');
                tempItemJnlLine.DELETEALL;
                ItemJournalLine.INIT;
                ItemJournalLine.VALIDATE("Journal Template Name", 'ITEM');
                ItemJournalLine.VALIDATE("Journal Batch Name", 'QC-SAMPLE');
                ItemJournalLine."Posting Date" := WORKDATE;
                ItemJournalLine."Line No." := 10000;
                ItemJournalLine."Entry Type" := ItemJournalLine."Entry Type"::"Negative Adjmt.";
                ItemJournalLine."Document No." := "No.";
                ItemJournalLine."Location Code" := "Location Code";

                ItemJournalLine.VALIDATE("Item No.", "Item No.");
                ItemJournalLine."Bin Code" := "Bin Code";

                //PCPL QC/ 03/BRB
                Qtyconversion := 0;
                //IF Unit_measure.GET("Item No.","Sample UOM") THEN
                // Qtyconversion := "Sample Drawn Quantity" * Unit_measure."Qty. per Unit of Measure";

                ItemJournalLine.VALIDATE(Quantity, "Sample Drawn Quantity");
                ItemJournalLine.VALIDATE("Unit of Measure Code", InspectionDS."Sample UOM");

                //PCPL QC/ 03/BRB
                IF InspectionDS."Item Tracking" THEN BEGIN
                    tempReservation.RESET;
                    IF tempReservation.FINDLAST THEN;
                    recReserveEntry.INIT;
                    recReserveEntry."Source Type" := 83;
                    recReserveEntry."Source ID" := 'ITEM';
                    recReserveEntry."Entry No." := tempReservation."Entry No." + 1;
                    recReserveEntry."Source Ref. No." := ItemJournalLine."Line No.";
                    recReserveEntry."Source Subtype" := recReserveEntry."Source Subtype"::"3";
                    recReserveEntry."Reservation Status" := recReserveEntry."Reservation Status"::Prospect;
                    recReserveEntry."Creation Date" := WORKDATE;
                    recReserveEntry."Source Batch Name" := 'QC-SAMPLE';
                    recReserveEntry.VALIDATE(recReserveEntry."Item No.", "Item No.");

                    recReserveEntry.VALIDATE(recReserveEntry."Quantity (Base)", -ABS(ItemJournalLine."Quantity (Base)"));//YSR
                    recReserveEntry."Location Code" := "Location Code";
                    recReserveEntry."Lot No." := "Lot No.";
                    recReserveEntry."Item Tracking" := recReserveEntry."Item Tracking"::"Lot No.";
                    recReserveEntry.INSERT;
                END;
                ItemJournalLine.INSERT;
                CODEUNIT.RUN(CODEUNIT::"Item Jnl.-Post", ItemJournalLine);
            END;
            Status := Status::"Under Test";
            MODIFY;
        END;

    end;

    procedure UpdateQlyStatus(var inspectionDR: Record 50020);
    begin
        WITH inspectionDR DO BEGIN
            Status := Status::Release;
            IF ("Approved Quantity" > 0) AND ("Rejected Quantity" > 0) THEN
                Approval := Approval::"Partially Approved"
            ELSE
                IF ("Approved Quantity" > 0) THEN
                    Approval := Approval::Approved
                ELSE
                    IF ("Rejected Quantity" > 0) THEN
                        Approval := Approval::Rejected;
            MODIFY;
        END;
    end;

    procedure calcAvailableInventory(itemCode: Code[20]; vLocation: Code[20]; vBin: Code[20]; prLotNo: Code[20]): Decimal;
    var
        itemBinContent: Record 7302;
    begin
        itemBinContent.RESET;
        itemBinContent.SETRANGE(itemBinContent."Location Code", vLocation);
        itemBinContent.SETRANGE(itemBinContent."Bin Code", vBin);
        itemBinContent.SETRANGE(itemBinContent."Item No.", itemCode);
        itemBinContent.SETFILTER("Lot No. Filter", prLotNo);  //PCPLYSR

        IF itemBinContent.FINDFIRST THEN
            itemBinContent.CALCFIELDS(itemBinContent.Quantity);
        EXIT(itemBinContent.Quantity);
    end;

    procedure CreateItemMovement(InspectionRS: Record 50020);
    var
        insertActivityHdr: Record 5766;
        recLocation: Record 14;
    begin
        //Creating Inventory Movement for Approved and Rejected Qty
        WITH InspectionRS DO BEGIN
            QCSetup.GET;
            //Inventory movement for Approved qty
            IF "Approved Quantity" > 0 THEN BEGIN
                QCSetup.TESTFIELD(QCSetup."Apprvd. Inv. Mvmt. No. Series");
                CreateActivityHdr("Location Code", 0, "Item No.", "Approved Quantity", "Lot No.", "Bin Code", "No.")
            END;
            //Inventory movement for Rejected Qty
            IF "Rejected Quantity" > 0 THEN BEGIN
                QCSetup.TESTFIELD(QCSetup."Rjctd. Inv. Mvmt. No. Series");
                CreateActivityHdr("Location Code", 1, "Item No.", "Rejected Quantity", "Lot No.", "Bin Code", "No.")
            END;
            //Moving Control Sample Qty
            IF InspectionRS."Control Sample Quantity" > 0 THEN BEGIN
                QCSetup.TESTFIELD("Sampling Location");
                CreateSamplingTransfer(InspectionRS);
            END;

        END;
    end;

    procedure CreateActivityHdr(vLocCode: Code[20]; movType: Option Approved,Rejected; vItem: Code[20]; vQty: Decimal; vLot: Code[20]; vfromBin: Code[20]; vQCDoc: Code[20]);
    var
        insertActivityHdr: Record 5766;
        recWhseSetup: Record 5769;
    begin
        WITH insertActivityHdr DO BEGIN
            recWhseSetup.GET;
            INIT;
            Type := Type::"Invt. Movement";
            "No." := NoSeriesMgmt.GetNextNo(QCSetup."Apprvd. Inv. Mvmt. No. Series", WORKDATE, TRUE);
            insertActivityHdr."QC Document" := TRUE;
            VALIDATE("Location Code", vLocCode);
            IF movType = movType::Approved THEN
                "QC Document Type" := "QC Document Type"::"Approval Movement"
            ELSE
                "QC Document Type" := "QC Document Type"::"Rejection Movement";
            insertActivityHdr."QC Document No." := vQCDoc;
            "Posting Date" := WORKDATE;
            "Registering No. Series" := recWhseSetup."Registered Whse. Movement Nos.";
            CreateActivityLine(insertActivityHdr, vItem, vQty, vLot, vfromBin);
            INSERT(TRUE);
        END;
    end;

    procedure CreateActivityLine(var ActivityHdr: Record 5766; vItem: Code[20]; vQty: Decimal; vLot: Code[20]; vfromBin: Code[20]);
    var
        insertWhseActivityLine: Record 5767;
    begin
        WITH insertWhseActivityLine DO BEGIN
            INIT;
            "Activity Type" := ActivityHdr.Type;
            "No." := ActivityHdr."No.";
            "Line No." := 10000;
            "Location Code" := ActivityHdr."Location Code";
            VALIDATE("Item No.", vItem);
            VALIDATE(Quantity, vQty);
            VALIDATE("Qty. to Handle", vQty);
            "Shipping Advice" := insertWhseActivityLine."Shipping Advice"::Partial;
            "Due Date" := WORKDATE;
            "Lot No." := vLot;
            "Expiration Date" := GetExpiration(vItem, vLot);
            "Bin Code" := vfromBin;
            "Action Type" := "Action Type"::Take;
            INSERT(TRUE);
            INIT;
            "Activity Type" := ActivityHdr.Type;
            "No." := ActivityHdr."No.";
            "Line No." := 20000;
            "Location Code" := ActivityHdr."Location Code";
            VALIDATE("Item No.", vItem);
            VALIDATE(Quantity, vQty);
            VALIDATE("Qty. to Handle", vQty);
            "Shipping Advice" := insertWhseActivityLine."Shipping Advice"::Partial;
            "Due Date" := WORKDATE;
            "Lot No." := vLot;
            "Expiration Date" := GetExpiration(vItem, vLot);
            "Bin Code" := '';
            "Action Type" := "Action Type"::Place;
            INSERT(TRUE);
        END;
    end;

    procedure CreateSamplingTransfer(InspectionRS: Record 50020);
    var
        recLocation: Record 14;
        toLocation: Record 14;
        ItemJournalLine: Record 83;
        tempItemJnlLine: Record 83;
        tempReservation: Record 337;
        recReserEntry: Record 337;
    begin
        WITH InspectionRS DO BEGIN
            recLocation.GET("Location Code");
            toLocation.GET(QCSetup."Sampling Location");
            toLocation.TESTFIELD(toLocation."Default Cont. Sample Bin");
            IF NOT recLocation."Directed Put-away and Pick" THEN BEGIN
                tempItemJnlLine.RESET;
                tempItemJnlLine.SETRANGE(tempItemJnlLine."Journal Template Name", 'ITEM');
                tempItemJnlLine.SETRANGE(tempItemJnlLine."Journal Batch Name", 'QC-SAMPLE');
                tempItemJnlLine.DELETEALL;

                ItemJournalLine.INIT;
                ItemJournalLine.VALIDATE("Journal Template Name", 'TRANSFER');
                ItemJournalLine.VALIDATE("Journal Batch Name", 'QC-SAMPLE');
                ItemJournalLine."Posting Date" := WORKDATE;
                ItemJournalLine."Line No." := 10000;
                ItemJournalLine."Entry Type" := ItemJournalLine."Entry Type"::Transfer;
                ItemJournalLine."Document No." := "No.";
                ItemJournalLine."Location Code" := "Location Code";
                ItemJournalLine."Bin Code" := "Bin Code";
                ItemJournalLine.VALIDATE("Item No.", "Item No.");
                ItemJournalLine.VALIDATE(Quantity, "Sample Drawn Quantity");
                ItemJournalLine."New Location Code" := QCSetup."Sampling Location";
                ItemJournalLine."New Bin Code" := toLocation."Default Cont. Sample Bin";
                IF "Item Tracking" THEN BEGIN
                    tempReservation.RESET;
                    IF tempReservation.FINDLAST THEN;
                    recReserEntry.INIT;
                    recReserEntry."Source Type" := 83;
                    recReserEntry."Source ID" := 'TRANSFER';
                    recReserEntry."Entry No." := tempReservation."Entry No." + 1;
                    recReserEntry."Source Ref. No." := ItemJournalLine."Line No.";
                    recReserEntry."Source Subtype" := recReserEntry."Source Subtype"::"4";
                    recReserEntry."Reservation Status" := recReserEntry."Reservation Status"::Prospect;
                    recReserEntry."Creation Date" := WORKDATE;
                    recReserEntry."Source Batch Name" := 'QC-SAMPLE';
                    recReserEntry.VALIDATE(recReserEntry."Item No.", "Item No.");
                    recReserEntry.VALIDATE(recReserEntry."Quantity (Base)", "Sample Drawn Quantity" * -1);
                    recReserEntry."Location Code" := "Location Code";
                    recReserEntry."Lot No." := "Lot No.";
                    recReserEntry."New Lot No." := "Lot No.";
                    recReserEntry."Item Tracking" := recReserEntry."Item Tracking"::"Lot No.";
                    recReserEntry."Expiration Date" := GetExpiration("Item No.", "Lot No.");
                    recReserEntry."New Expiration Date" := GetExpiration("Item No.", "Lot No.");
                    recReserEntry.INSERT;
                END;
                ItemJournalLine.INSERT;
                CODEUNIT.RUN(CODEUNIT::"Item Jnl.-Post", ItemJournalLine);
            END
            ELSE BEGIN
                CreateTransEntry(InspectionRS);
            END;
        END;
    end;

    procedure GetExpiration(ItemNo: Code[20]; LotNo: Code[20]): Date;
    var
        recItemLedger: Record 32;
    begin
        recItemLedger.RESET;
        recItemLedger.SETRANGE(recItemLedger."Item No.", ItemNo);
        recItemLedger.SETRANGE(recItemLedger."Lot No.", LotNo);
        IF recItemLedger.FINDFIRST THEN
            EXIT(recItemLedger."Expiration Date");
    end;

    procedure CreateTransEntry(InspectionRS: Record 50020);
    var
        recLocation: Record 14;
        insertTransferHdr: Record 5740;
        insertTransferLine: Record 5741;
    begin
        WITH InspectionRS DO BEGIN
            insertTransferHdr.INIT;
            insertTransferHdr.INSERT(TRUE);
            insertTransferHdr.VALIDATE("Transfer-from Code", "Location Code");
            insertTransferHdr.VALIDATE(insertTransferHdr."Transfer-to Code", QCSetup."Sampling Location");
            recLocation.RESET;
            recLocation.SETRANGE(recLocation."Use As In-Transit", TRUE);
            IF recLocation.FINDFIRST THEN
                insertTransferHdr.VALIDATE("In-Transit Code", recLocation.Code);
            insertTransferHdr.VALIDATE("Posting Date", WORKDATE);
            insertTransferHdr."QC Document" := TRUE;
            insertTransferHdr."QC Document No." := "No.";
            insertTransferHdr.MODIFY;
            insertTransferLine.INIT;
            insertTransferLine."Document No." := insertTransferHdr."No.";
            insertTransferLine."Line No." := 10000;
            insertTransferLine.VALIDATE("Item No.", "Item No.");
            insertTransferLine.VALIDATE(Quantity, "Control Sample Quantity");
            insertTransferLine."In-Transit Code" := insertTransferHdr."In-Transit Code";
            insertTransferLine."Transfer-from Code" := insertTransferHdr."Transfer-from Code";
            insertTransferLine."Transfer-to Code" := insertTransferHdr."Transfer-to Code";
            insertTransferLine."Shipment Date" := insertTransferHdr."Shipment Date";
            insertTransferLine."Receipt Date" := insertTransferHdr."Receipt Date";
            insertTransferLine."Shipping Agent Code" := insertTransferHdr."Shipping Agent Code";
            insertTransferLine."Shipping Agent Service Code" := insertTransferHdr."Shipping Agent Service Code";
            insertTransferLine."Shipping Time" := insertTransferHdr."Shipping Time";
            insertTransferLine."Outbound Whse. Handling Time" := insertTransferHdr."Outbound Whse. Handling Time";
            insertTransferLine."Inbound Whse. Handling Time" := insertTransferHdr."Inbound Whse. Handling Time";
            //insertTransferLine."Excise Bus. Posting Group" := insertTransferHdr."Excise Bus. Posting Group"; //PCPL/NSW/MIG 20July22
            insertTransferLine.Status := insertTransferHdr.Status;
            insertTransferLine.INSERT;
        END;
    end;

    procedure updateDimension(DimSetID: Integer; DimValue: Text[50]) NewDimSet: Integer;
    var
        TempDimEntry: Record 480 temporary;
        DimMgmt: Codeunit 408;
        DimSetEntry: Record 480;
    begin
        TempDimEntry.DELETEALL;
        DimSetEntry.RESET;
        DimSetEntry.SETRANGE(DimSetEntry."Dimension Set ID", DimSetID);
        IF DimSetEntry.FINDSET THEN
            REPEAT
                TempDimEntry.COPY(DimSetEntry);
                TempDimEntry.INSERT;
            UNTIL DimSetEntry.NEXT = 0;
        TempDimEntry.INIT;
        TempDimEntry."Dimension Set ID" := DimSetID;
        TempDimEntry.VALIDATE("Dimension Code", 'REASONS');
        TempDimEntry.VALIDATE("Dimension Value Code", DimValue);
        TempDimEntry.INSERT;
        NewDimSet := DimMgmt.GetDimensionSetID(TempDimEntry);
        EXIT(NewDimSet);
    end;

    procedure fctSplitCTCEntry(var whseItemJnl: Record 7311; Bin: Code[20]);
    var
        specs: Record 50015;
        SpecsDetails: Record 50016;
        specsVersion: Record 50017;
        recItem: Record 27;
        whseItemTracking: Record 6550;
    begin
        WITH whseItemJnl DO BEGIN
            recItem.GET("New Item No.");
            IF recItem."QC Check" THEN BEGIN
                whseItemTracking.RESET;
                whseItemTracking.SETRANGE(whseItemTracking."Source Type", 7311);
                whseItemTracking.SETRANGE(whseItemTracking."Source ID", "Journal Batch Name");
                whseItemTracking.SETRANGE(whseItemTracking."Item No.", "Item No.");
                whseItemTracking.SETRANGE(whseItemTracking."Location Code", "Location Code");
                IF whseItemTracking.FINDSET THEN
                    REPEAT
                        specs.GET(recItem."Specs ID");
                        specs.TESTFIELD(specs.Status, specs.Status::Certified);
                        specsVersion.RESET;
                        specsVersion.SETRANGE(specsVersion."Specs ID", specs."Specs ID");
                        specsVersion.SETRANGE(specsVersion."Starting Date", 0D, "Registering Date");
                        IF specsVersion.FINDLAST THEN BEGIN
                            SpecsDetails.RESET;
                            SpecsDetails.SETRANGE(SpecsDetails."Specs ID", specs."Specs ID");
                            SpecsDetails.SETRANGE(SpecsDetails."Version Code", specsVersion."Version Code");
                            SpecsDetails.SETRANGE(SpecsDetails."Account Type", SpecsDetails."Account Type"::"Begin");
                            IF SpecsDetails.FINDSET THEN
                                REPEAT
                                    InitCTCInspection(whseItemJnl, whseItemTracking."Quantity (Base)", whseItemTracking."Lot No.", SpecsDetails, Bin);
                                UNTIL SpecsDetails.NEXT = 0;
                        END
                        ELSE BEGIN
                            SpecsDetails.RESET;
                            SpecsDetails.SETRANGE(SpecsDetails."Specs ID", specs."Specs ID");
                            SpecsDetails.SETRANGE(SpecsDetails."Version Code", '');
                            SpecsDetails.SETRANGE(SpecsDetails."Account Type", SpecsDetails."Account Type"::"Begin");
                            IF SpecsDetails.FINDSET THEN
                                REPEAT
                                    InitCTCInspection(whseItemJnl, whseItemTracking."Quantity (Base)", whseItemTracking."Lot No.", SpecsDetails, Bin);
                                UNTIL SpecsDetails.NEXT = 0;
                        END;
                    UNTIL whseItemTracking.NEXT = 0;
            END;
        END;
    end;

    procedure fctCTCEntry(var whseItemJnl: Record 7311; Bin: Code[20]);
    var
        specs: Record 50015;
        SpecsDetails: Record 50016;
        specsVersion: Record 50017;
        recItem: Record 27;
        whseItemTracking: Record 6550;
    begin
        WITH whseItemJnl DO BEGIN
            recItem.GET("New Item No.");
            IF recItem."QC Check" THEN BEGIN
                whseItemTracking.RESET;
                whseItemTracking.SETRANGE(whseItemTracking."Source Type", 7311);
                whseItemTracking.SETRANGE(whseItemTracking."Source ID", "Journal Batch Name");
                whseItemTracking.SETRANGE(whseItemTracking."Item No.", "Item No.");
                whseItemTracking.SETRANGE(whseItemTracking."Location Code", "Location Code");
                IF whseItemTracking.FINDSET THEN
                    REPEAT
                        specs.GET(recItem."Specs ID");
                        specs.TESTFIELD(specs.Status, specs.Status::Certified);
                        specsVersion.RESET;
                        specsVersion.SETRANGE(specsVersion."Specs ID", specs."Specs ID");
                        specsVersion.SETRANGE(specsVersion."Starting Date", 0D, whseItemJnl."Registering Date");
                        IF specsVersion.FINDLAST THEN BEGIN
                            SpecsDetails.RESET;
                            SpecsDetails.SETRANGE(SpecsDetails."Specs ID", specs."Specs ID");
                            SpecsDetails.SETRANGE(SpecsDetails."Version Code", specsVersion."Version Code");
                            IF SpecsDetails.FINDSET THEN
                                InitCTCInspection(whseItemJnl, whseItemTracking."Quantity (Base)", whseItemTracking."Lot No.", SpecsDetails, Bin);
                        END
                        ELSE BEGIN
                            SpecsDetails.RESET;
                            SpecsDetails.SETRANGE(SpecsDetails."Specs ID", specs."Specs ID");
                            SpecsDetails.SETRANGE(SpecsDetails."Version Code", '');
                            IF SpecsDetails.FINDSET THEN
                                InitCTCInspection(whseItemJnl, whseItemTracking."Quantity (Base)", whseItemTracking."Lot No.", SpecsDetails, Bin);
                        END;
                    UNTIL whseItemTracking.NEXT = 0;
            END;
        END;
    end;

    procedure InitCTCInspection(var WhseItemJnl: Record 7311; Qty: Decimal; Lot: Code[20]; var Specs: Record 50016; Bin: Code[20]);
    var
        TempInspectionDataSheet: Record 50011;
        TempInspectionDataSheetLine: Record 50012;
        QltySetup: Record 50010;
        recItem: Record 27;
        SpecsDetails: Record 50016;
    begin
        WITH WhseItemJnl DO BEGIN
            TempInspectionDataSheet.INIT;
            QltySetup.GET;
            QltySetup.TESTFIELD(QltySetup."Inspection Sheet No. Series");
            TempInspectionDataSheet."No." := NoSeriesMgmt.GetNextNo(QltySetup."Inspection Sheet No. Series", WORKDATE, TRUE);
            TempInspectionDataSheet."Document Type" := TempInspectionDataSheet."Document Type"::"Code-to-Code";
            TempInspectionDataSheet."Document No." := "Whse. Document No.";
            TempInspectionDataSheet."Ref ID" := "Line No.";
            TempInspectionDataSheet."Posting Date" := "Registering Date";
            TempInspectionDataSheet.Quantity := Qty;
            TempInspectionDataSheet."Document Date" := WORKDATE;
            TempInspectionDataSheet."Prod. Order Date" := 0D;
            TempInspectionDataSheet."Lot No." := Lot;
            TempInspectionDataSheet."Location Code" := "Location Code";
            TempInspectionDataSheet."Bin Code" := Bin;

            TempInspectionDataSheet."Item No." := "New Item No.";
            IF recItem.GET("New Item No.") THEN BEGIN
                TempInspectionDataSheet."Item Description" := recItem.Description;
                TempInspectionDataSheet."Item Description 2" := recItem."Description 2";
                TempInspectionDataSheet."Unit of Messure" := recItem."Base Unit of Measure";
                TempInspectionDataSheet."Sample UOM" := recItem."Base Unit of Measure";
            END;
            IF TempInspectionDataSheet."Lot No." <> '' THEN
                TempInspectionDataSheet."Item Tracking" := TRUE
            ELSE
                TempInspectionDataSheet."Item Tracking" := FALSE;
            TempInspectionDataSheet."Certificate No." := GetCertificate(TempInspectionDataSheet);
            TempInspectionDataSheet."Prod. Order Quantity" := 0;
            TempInspectionDataSheet.Approval := TempInspectionDataSheet.Approval::WIP;
            TempInspectionDataSheet.Status := TempInspectionDataSheet.Status::Open;
            //TempInspectionDataSheet."Retest on":=CALCDATE(recItem."Retesting Frequency",WORKDATE);  // Replace (recItem."Retesting Frequency") with (recItem."Retesting Frequency")
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
                    TempInspectionDataSheetLine."Document No." := "Whse. Document No.";
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
            CreateEntryLedger(TempInspectionDataSheet);
            CreateLotInfo(TempInspectionDataSheet."Lot No.", TempInspectionDataSheet."Item No.", TempInspectionDataSheet."Certificate No.");
            TempInspectionDataSheet.INSERT;
        END;
    end;

    procedure CreateInspectionForRejRetest(var InspectionDR: Record 50020; var InspectionDRLine: Record 50021);
    var
        InspectionDataSheet: Record 50011;
        InspectionSheetLine: Record 50012;
    begin
        WITH InspectionDR DO BEGIN
            QCSetup.GET;
            InspectionDataSheet.INIT;
            InspectionDataSheet.TRANSFERFIELDS(InspectionDR);
            InspectionDataSheet."No." := NoSeriesMgmt.GetNextNo(QCSetup."Inspection Sheet No. Series", WORKDATE, TRUE);
            InspectionDRLine.FINDFIRST;
            REPEAT
                InspectionSheetLine.INIT;
                InspectionSheetLine.TRANSFERFIELDS(InspectionDRLine);
                InspectionSheetLine."No." := InspectionDataSheet."No.";
                InspectionSheetLine."Reject QC Receipt No." := "No.";
                InspectionSheetLine.INSERT;
            UNTIL InspectionDRLine.NEXT = 0;
            CreateEntryLedger(InspectionDataSheet);
            InspectionDataSheet.Approval := InspectionDataSheet.Approval::WIP;
            InspectionDataSheet."Transferred to Quarantine Bin" := TRUE;
            InspectionDataSheet.INSERT;
            InspectionDRLine.DELETEALL;
        END;
    end;
}

