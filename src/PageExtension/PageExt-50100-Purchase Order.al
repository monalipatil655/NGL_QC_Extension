pageextension 50100 Purchase_Order_QC extends "Purchase Order"
{


    layout
    {

    }
    actions
    {
        addafter("Post and &Print")
        {
            action("Create Inspection Sheet")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction();
                begin
                    IF CONFIRM('Do you want to send for QC Inspection', TRUE) THEN BEGIN
                        QCSetup.GET;
                        IF QCSetup."Split Inspection Group Wise" THEN
                            QSInsertion.fctPurchSplitEntryBeforeGRN(Rec)
                        ELSE
                            QSInsertion.fctPurchEntryBeforeGRN(Rec);
                    END;
                end;
            }
        }
    }




    var

        PurchLine: Record 39;
        QCSetup: Record 50010;
        QSInsertion: Codeunit 50003;
        ApprovalMgt: Codeunit 1535;
        item: Record 27;
        RecVendor: Record 23;
        SalesHeader1: Record 38;
        UserSetup5: Record 91;
        UserSetup4: Record 91;
        UserSetup3: Record 91;
        UserSetup2: Record 91;
        UserSetup: Record 91;
        // SMTP: Codeunit 400;
        RecPurchLinen: Record 39;
        RecVendorn: Record 23;
        txtLink: Text[1000];
        VarFinalDes: Text[150];
        VarFinalDesVariant: Text[150];
        RecVariantn: Record 5401;
        FinalAmount: Decimal;
        recPaymentTerms: Record 3;
        VarPayment: Text[150];
        VarRecipaintMail: Text[50];
        VarSenderMail: Text[50];
        RecUsers: Record 2000000120;
        PurchaseHeader: Record 38;
        recVend: Record 23;

        Attachpdf: Text;
        PdfDocPath: Text;
        path: Text;
        PdfDocPath1: Text;
        Path1: Text;

        varuserid: Code[50];
        recpurchheadr: Record 38;

        vardocno: Code[30];
        varsendoname: Code[150];

        recpurchseline: Record 39;

        sr: Integer;
        pdfname: Text[150];

        reccomment: Record 43;
        VerComment: Text[250];
        RecApprovecpmentline: Record 455;
        VerApprCommLine: Text[250];
        TEMP: Text[250];
        IncomingDocumentAttachment: Record 133;
        IncoPath: Text;

    procedure QualityCheck();
    var
        RecSKU: Record 5700;
        QCcheck: Boolean;
        PurchLineItem: Code[10];
    begin
        CLEAR(PurchLineItem);
        PurchLine.RESET;
        PurchLine.SETCURRENTKEY("Document Type", "Document No.", Type, "No.");
        PurchLine.SETRANGE(PurchLine."Document Type", PurchLine."Document Type"::Order);
        PurchLine.SETRANGE(PurchLine."Document No.", Rec."No.");
        PurchLine.SETRANGE(PurchLine.Type, PurchLine.Type::Item);
        IF PurchLine.FINDSET THEN BEGIN
            REPEAT
                PurchLineItem := PurchLine."No.";

                RecSKU.RESET;
                RecSKU.SETRANGE(RecSKU."Item No.", PurchLineItem);
                RecSKU.SETRANGE(RecSKU."Location Code", "Location Code");
                IF RecSKU.FINDSET THEN
                    IF (RecSKU."QC Check" <> TRUE) OR (RecSKU."Specs ID" = '') THEN BEGIN
                        ERROR('Specification Details are required for Item' + ' ' + PurchLine."No." + ' ' + 'for Location' + ' ' + "Location Code");
                    END;
            UNTIL PurchLine.NEXT = 0;
        END;
    end;



}

