codeunit 50030 "QC Codeunit Extension"
{
    trigger OnRun()
    begin
        //Codeunit List-22,80,90,240,241,242,5704,5705,6501
    end;
    //<<CODUNIT 22 START
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnAfterInitItemLedgEntry', '', false, false)]
    local procedure OnAfterInitItemLedgEntry(var NewItemLedgEntry: Record "Item Ledger Entry"; var ItemJournalLine: Record "Item Journal Line"; var ItemLedgEntryNo: Integer)
    begin
        //PCPLQC 2.0
        NewItemLedgEntry."QC Status" := ItemJournalLine."Quality Status";
        //PCPLQC 2.0
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnBeforeInsertItemLedgEntry', '', false, false)]
    local procedure OnBeforeInsertItemLedgEntry(var ItemLedgerEntry: Record "Item Ledger Entry"; ItemJournalLine: Record "Item Journal Line"; TransferItem: Boolean; OldItemLedgEntry: Record "Item Ledger Entry")
    var
        recItem: Record 27;
        Specifications: Record 50016;
        InsertQC: Codeunit 50003;
    begin
        ItemLedgerEntry."Create QC Inspection" := ItemJournalLine."Create QC Inspection"; //QC2.0
        //PCPL0041-Start-04022020
        //PCPLQC2.0
        IF ItemJournalLine."Entry Type" = ItemJournalLine."Entry Type"::Transfer THEN BEGIN
            //PCPL-25 16Dec21
            IF ItemLedgerEntry."Document Type" = ItemLedgerEntry."Document Type"::"Transfer Receipt" THEN
                ItemLedgerEntry."QC Status" := ItemLedgerEntry."QC Status"::WIP
            ELSE
                //PCPL-25 16Dec21 
                ItemLedgerEntry."QC Status" := ItemLedgerEntry."QC Status"::Approved;
        END;
        //PCPLQC2.0

        //PCPLQC2.0
        IF recItem.GET(ItemLedgerEntry."Item No.") THEN;
        Specifications.RESET;
        Specifications.SETRANGE("Specs ID", recItem."Specs ID");
        IF Specifications.FINDSET THEN;

        IF ItemJournalLine."Entry Type" = ItemJournalLine."Entry Type"::"Positive Adjmt." THEN BEGIN
            IF ItemLedgerEntry."Create QC Inspection" THEN
                InsertQC.InitItmJnrlInspection(ItemLedgerEntry, ItemLedgerEntry.Quantity, ItemLedgerEntry."Lot No.", Specifications);

        END;
        //PCPLQC2.0
    end;
    //>>CODUNIT 22 END

    //<<CODUNIT 80 START
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeReturnRcptHeaderInsert', '', false, false)]
    local procedure OnBeforeReturnRcptHeaderInsert(var ReturnRcptHeader: Record "Return Receipt Header"; SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean)
    var
        QCInsertion: Codeunit "Purch/Sale Inspection Creation";
        QCSetup: Record "Quality Setup QC";
    begin
        //PCPL QC 2.0
        IF SalesHeader.Receive THEN BEGIN
            QCSetup.GET;
            IF QCSetup."Split Inspection Group Wise" THEN
                QCInsertion.fctSalesRetSplitEntry(SalesHeader)
            ELSE
                QCInsertion.fctSalesRetEntry(SalesHeader);
            QCInsertion.UpdateReturnReceipt(SalesHeader, ReturnRcptHeader);
        END;
        //PCPL QC 2.0
    end;
    //>>CODUNIT 80 END

    //<<CODUNIT 90 START
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePostLines', '', false, false)]
    local procedure OnBeforePostLines(var PurchLine: Record "Purchase Line"; PurchHeader: Record "Purchase Header"; PreviewMode: Boolean; CommitIsSupressed: Boolean)
    var
        recPurchLine: record 39;
        SKU: record 5700;
    begin
        //PCPL QC 2.0
        IF PurchHeader."Document Type" = PurchHeader."Document Type"::Order THEN BEGIN
            IF PurchHeader.Receive THEN BEGIN
                recPurchLine.RESET;
                recPurchLine.SETRANGE(recPurchLine."Document No.", PurchHeader."No.");
                recPurchLine.SETRANGE(recPurchLine.Type, recPurchLine.Type::Item);
                recPurchLine.SETRANGE(recPurchLine."Quality Check", recPurchLine."Quality Check"::"Before GRN");
                IF recPurchLine.FINDSET THEN
                    REPEAT
                        //>>PCPL/CUST/QC/IRL/002
                        SKU.RESET;
                        SKU.SETRANGE(SKU."Item No.", recPurchLine."No.");
                        SKU.SETRANGE(SKU."Location Code", recPurchLine."Location Code");
                        SKU.SETRANGE(SKU."QC Check", TRUE);
                        IF SKU.FINDFIRST THEN BEGIN
                            //<<PCPL/CUST/QC/IRL/002
                            recPurchLine.CALCFIELDS("Qty Accepted");
                            IF recPurchLine."Qty Accepted" < (recPurchLine."Qty. to Receive" + recPurchLine."Quantity Received") THEN
                                ERROR('You can not receive more than %1 qty for %2 Line', recPurchLine."Qty Accepted", recPurchLine."Line No.");
                        END;
                    UNTIL recPurchLine.NEXT = 0;
            END;
        END;
        //PCPL QC 2.0

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterReturnShptLineInsert', '', false, false)]
    local procedure OnAfterReturnShptLineInsert(var ReturnShptLine: Record "Return Shipment Line"; ReturnShptHeader: Record "Return Shipment Header"; PurchLine: Record "Purchase Line"; ItemLedgShptEntryNo: Integer; WhseShip: Boolean; WhseReceive: Boolean; CommitIsSupressed: Boolean; var TempWhseShptHeader: Record "Warehouse Shipment Header" temporary; PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.")
    var
        PH: Record 38;
        recPurchLine: Record 39;
        recItem: Record 27;
        recPurchRcptLine: Record "Purch. Rcpt. Line";
        recItemLedger: Record 32;
        recInspection: Record 50011;
    begin
        //<<PCPL/NSW/MIG 20July22 New code addeddue to Event not find 
        PH.Reset();
        ph.SetRange("No.", PurchLine."Document No.");
        ph.SetRange("Document Type", PurchLine."Document Type");
        IF ph.FindFirst() then;
        //>>PCPL/NSW/MIG
        //PCPL QC 2.0
        IF ph.Receive THEN BEGIN
            recPurchLine.RESET;
            recPurchLine.SETRANGE(recPurchLine."Document No.", PH."No.");
            recPurchLine.SETRANGE(recPurchLine."Quality Check", recPurchLine."Quality Check"::"After GRN");
            recPurchLine.SETRANGE(recPurchLine.Type, recPurchLine.Type::Item);
            IF recPurchLine.FINDSET THEN
                REPEAT
                    recItem.GET(recPurchLine."No.");
                    IF recItem."QC Check" THEN BEGIN
                        recPurchRcptLine.RESET;
                        recPurchRcptLine.SETRANGE(recPurchRcptLine."Order No.", recPurchLine."Document No.");
                        recPurchRcptLine.SETRANGE(recPurchRcptLine."No.", recPurchLine."No.");
                        IF recPurchRcptLine.FINDFIRST THEN
                            REPEAT
                                recItemLedger.RESET;
                                recItemLedger.SETRANGE(recItemLedger."Document No.", recPurchRcptLine."Document No.");
                                IF recItemLedger.FINDSET THEN
                                    REPEAT
                                        recInspection.RESET;
                                        recInspection.SETRANGE(recInspection."Item No.", recItemLedger."Item No.");
                                        recInspection.SETRANGE(recInspection."Lot No.", recItemLedger."Lot No.");
                                        IF recInspection.FINDSET THEN
                                            REPEAT
                                                recInspection."GRN No." := recItemLedger."Document No.";
                                                recInspection."GRN Quantity" := recItemLedger.Quantity;
                                                recInspection."GRN Date" := recItemLedger."Posting Date";
                                                recInspection.Quantity := recItemLedger.Quantity;      //PCPL/BRB- As per Pallavi Mam requirement
                                                recItemLedger."QC Retest Date" := recInspection."Retest on";
                                                recInspection.MODIFY;
                                            UNTIL recInspection.NEXT = 0;
                                        //recItemLedger."QC Status":=recItemLedger."QC Status"::Approved;
                                        recItemLedger.MODIFY;
                                    UNTIL recItemLedger.NEXT = 0;
                            UNTIL recPurchRcptLine.NEXT = 0;
                    END
                    //PCPL-25
                    ELSE BEGIN
                        //CompanyInfo1.GET;
                        IF COMPANYNAME = 'NGL Testing' THEN
                            recPurchRcptLine.RESET;
                        recPurchRcptLine.SETRANGE(recPurchRcptLine."Order No.", recPurchLine."Document No.");
                        recPurchRcptLine.SETRANGE(recPurchRcptLine."No.", recPurchLine."No.");
                        IF recPurchRcptLine.FINDFIRST THEN
                            REPEAT
                                recItemLedger.RESET;
                                recItemLedger.SETRANGE(recItemLedger."Document No.", recPurchRcptLine."Document No.");
                                IF recItemLedger.FINDSET THEN
                                    REPEAT
                                        recItemLedger."QC Status" := recItemLedger."QC Status"::Approved;
                                        recItemLedger.MODIFY(TRUE);
                                    UNTIL recItemLedger.NEXT = 0;
                            UNTIL recPurchRcptLine.NEXT = 0;
                    END;
                ////PCPL-25
                UNTIL recPurchLine.NEXT = 0;
        END;

        //PCPL QC 2.0
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterInsertReceiptHeader', '', false, false)]
    local procedure OnAfterInsertReceiptHeader(var PurchHeader: Record "Purchase Header"; var PurchRcptHeader: Record "Purch. Rcpt. Header"; var TempWhseRcptHeader: Record "Warehouse Receipt Header" temporary; WhseReceive: Boolean; CommitIsSuppressed: Boolean)
    var
        QCSetup: Record 50010;
        QCInsertion: Codeunit 50003;
    begin
        //PCPL QC 2.0
        IF PurchHeader.Receive THEN BEGIN
            QCSetup.GET;
            IF QCSetup."Split Inspection Group Wise" THEN
                QCInsertion.fctPurchSplitEntry(PurchHeader, PurchRcptHeader, TempWhseRcptHeader."Receiving No.")
            ELSE
                QCInsertion.fctPurchEntry(PurchHeader, PurchRcptHeader, TempWhseRcptHeader."Receiving No.");
        END;
        //PCPL QC 2.0
    end;
    //>>CODUNIT 90 END


    //<<CODUNIT 240 START
    [EventSubscriber(ObjectType::Codeunit, Codeunit::ItemJnlManagement, 'OnBeforeLookupName', '', false, false)]
    local procedure OnBeforeLookupName(var ItemJnlBatch: Record "Item Journal Batch"; var IsHandled: Boolean)
    begin
        //IRL/QC/CUST/0008
        ItemJnlBatch.SETRANGE(ItemJnlBatch."QC Retest Batch", FALSE);
        //IRL/QC/CUST/0008

    end;
    //>>CODUNIT 240 END

    //<<CODUNIT 241 START
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post", 'OnCodeOnBeforeItemJnlPostBatchRun', '', false, false)]
    local procedure OnCodeOnBeforeItemJnlPostBatchRun(var ItemJournalLine: Record "Item Journal Line")
    var

        recItemJnlLine: Record 83;
        recItem: record 27;
        recReservation: Record 337;
        recILE: Record 32;
        QCSetup: Record 50010;
        QCInsertion: codeunit 50004;

    begin
        //PCPL QC 2.0
        recItemJnlLine.COPY(ItemJournalLine);
        IF recItemJnlLine.FINDFIRST THEN
            REPEAT
                IF (recItemJnlLine."Order Type" = recItemJnlLine."Order Type"::Production) AND (recItemJnlLine."Order No." <> '') AND
                (recItemJnlLine."Entry Type" = recItemJnlLine."Entry Type"::Consumption) AND (recItemJnlLine.Quantity <> 0) THEN BEGIN
                    recItem.GET(recItemJnlLine."Item No.");
                    IF recItem."QC Check" THEN BEGIN
                        recReservation.RESET;
                        recReservation.SETRANGE(recReservation."Source Type", 83);
                        recReservation.SETRANGE(recReservation."Source Ref. No.", recItemJnlLine."Line No.");
                        recReservation.SETRANGE(recReservation."Item No.", recItemJnlLine."Item No.");
                        recReservation.SETRANGE(recReservation."Source ID", recItemJnlLine."Journal Template Name");
                        IF recReservation.FINDFIRST THEN BEGIN
                            recILE.RESET;
                            recILE.SETRANGE(recILE."Entry Type", recILE."Entry Type"::Purchase);
                            recILE.SETRANGE(recILE."Lot No.", recReservation."Lot No.");
                            recILE.SETRANGE(recILE."Item No.", recReservation."Item No.");
                            recILE.SETRANGE(recILE."QC Status", recILE."QC Status"::Approved);
                            IF NOT recILE.FINDFIRST THEN;
                            //  ERROR('The QC for the lot %1 is not approved for the line %2',recReservation."Lot No.",recItemJnlLine."Line No.");
                        END;
                    END;
                END;
                //
                IF ItemJournalLine.ItemPosting THEN BEGIN
                    QCSetup.GET;
                    IF QCSetup."Split Inspection Group Wise" THEN
                        QCInsertion.fctProdSplitEntry(recItemJnlLine)
                    ELSE
                        QCInsertion.fctProdEntry(recItemJnlLine);
                END;
            UNTIL recItemJnlLine.NEXT = 0;
        //PCPL QC 2.0
    end;

    //>>CODUNIT 241 END

    //<<CODUNIT 242 START
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post+Print", 'OnAfterPostJournalBatch', '', false, false)]
    local procedure OnAfterPostJournalBatch(var ItemJournalLine: Record "Item Journal Line");
    var
        recReservation: record 337;
        recILE: Record 32;
        QCSetup: Record 50010;
        QCInsertion: Codeunit 50004;
    begin
        //PCPL QC 2.0
        IF (ItemJournalLine."Order Type" = ItemJournalLine."Order Type"::Production) AND (ItemJournalLine."Order No." <> '') AND (ItemJournalLine."Entry Type" = ItemJournalLine."Entry Type"::Consumption) AND (ItemJournalLine.Quantity <> 0) THEN BEGIN
            recReservation.RESET;
            recReservation.SETRANGE(recReservation."Source Type", 83);
            recReservation.SETRANGE(recReservation."Source Ref. No.", ItemJournalLine."Line No.");
            recReservation.SETRANGE(recReservation."Item No.", ItemJournalLine."Item No.");
            recReservation.SETRANGE(recReservation."Source ID", ItemJournalLine."Journal Template Name");
            IF recReservation.FINDFIRST THEN BEGIN
                recILE.RESET;
                recILE.SETRANGE(recILE."Entry Type", recILE."Entry Type"::Purchase);
                recILE.SETRANGE(recILE."Lot No.", recReservation."Lot No.");
                recILE.SETRANGE(recILE."Item No.", recReservation."Item No.");
                recILE.SETRANGE(recILE."QC Status", recILE."QC Status"::Approved);
                IF NOT recILE.FINDFIRST THEN
                    ERROR('The QC for the lot %1 is not approved for the line %2', recReservation."Lot No.", ItemJournalLine."Line No.");
            END;
        END;

        IF ItemJournalLine.ItemPosting THEN BEGIN
            QCSetup.GET;
            IF QCSetup."Split Inspection Group Wise" THEN
                QCInsertion.fctProdSplitEntry(ItemJournalLine)
            ELSE
                QCInsertion.fctProdEntry(ItemJournalLine);
        END;
        //PCPL QC 2.0
    end;
    //>>CODUNIT 242 END

    //<<CODUNIT 5704 START
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Shipment", 'OnBeforeInsertTransShptHeader', '', false, false)]
    local procedure OnBeforeInsertTransShptHeader(var TransShptHeader: Record "Transfer Shipment Header"; TransHeader: Record "Transfer Header"; CommitIsSuppressed: Boolean)
    begin
        //PCPL/QC/V3/001
        TransShptHeader."QC Document" := TransHeader."QC Document";
        TransShptHeader."QC Document No." := TransHeader."QC Document No.";
        //PCPL/QC/V3/001
    end;
    //>>CODUNIT 5704 END

    //<<CODUNIT 5705 START
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Receipt", 'OnBeforeTransRcptHeaderInsert', '', false, false)]
    local procedure OnBeforeTransRcptHeaderInsert(var TransferReceiptHeader: Record "Transfer Receipt Header"; TransferHeader: Record "Transfer Header")
    begin
        //PCPL/QC/V3/001
        TransferReceiptHeader."QC Document" := TransferHeader."QC Document";
        TransferReceiptHeader."QC Document No." := TransferHeader."QC Document No.";
        //TransferReceiptHeader."User ID" := USERID;    //PCPL-BRB-20211129 
        //PCPL/QC/V3/001
    end;
    //>>CODUNIT 5705 END

    //<<CODUNIT 6501 START
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Tracking Data Collection", 'OnRetrieveLookupDataOnBeforeTransferToTempRec', '', false, false)]
    local procedure OnRetrieveLookupDataOnBeforeTransferToTempRec(var TempTrackingSpecification: Record "Tracking Specification" temporary; var TempReservationEntry: Record "Reservation Entry" temporary; var ItemLedgerEntry: Record "Item Ledger Entry"; var FullDataSet: Boolean)
    Var
        recItem: record 27;
    begin
        //PCPL QC 2.0
        IF recItem.GET(TempTrackingSpecification."Item No.") THEN BEGIN
            IF recItem."QC Check" THEN
                ItemLedgerEntry.SETRANGE(ItemLedgerEntry."QC Status", ItemLedgerEntry."QC Status"::Approved);
        END;
        //PCPL QC 2.0

    end;
    //>>CODUNIT 6501 END
}