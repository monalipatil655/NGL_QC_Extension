report 50014 "Vendor Billwise Payment"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'src/Vendor Billwise Payment.rdl';

    dataset
    {
        dataitem("Vendor Ledger Entry";"Vendor Ledger Entry")
        {
            DataItemTableView = WHERE("Document Type"=FILTER(Invoice));
            RequestFilterFields = "Document No.","Posting Date";
            column(EntryNo_VendorLedgerEntry;"Vendor Ledger Entry"."Entry No.")
            {
            }
            column(ClosedbyEntryNo_VendorLedgerEntry;"Vendor Ledger Entry"."Closed by Entry No.")
            {
            }
            column(DocumentNo_VendorLedgerEntry;"Vendor Ledger Entry"."Document No.")
            {
            }
            column(PosDate;PosDate)
            {
            }
            column(PostingDate_VendorLedgerEntry;"Vendor Ledger Entry"."Posting Date")
            {
            }
            column(VendorInvoiceNo_VendorLedgerEntry;"Vendor Ledger Entry"."Vendor Invoice No.")
            {
            }
            column(DocDate;DocDate)
            {
            }
            column(VendorNo_VendorLedgerEntry;"Vendor Ledger Entry"."Vendor No.")
            {
            }
            column(VendName;VendName)
            {
            }
            column(Amount_VendorLedgerEntry;"Vendor Ledger Entry".Amount)
            {
            }
            column(PayTermCode;PayTermCode)
            {
            }
            column(DueDate;DueDate)
            {
            }
            dataitem("Detailed Vendor Ledg. Entry";"Detailed Vendor Ledg. Entry")
            {
                DataItemLink = "Vendor Ledger Entry No."=FIELD("Entry No.");
                DataItemTableView = SORTING("Vendor Ledger Entry No.","Posting Date")
                                    WHERE(Unapplied=FILTER(false));
                column(DocumentNo_DetailedVendorLedgEntry;"Detailed Vendor Ledg. Entry"."Document No.")
                {
                }
                column(DPosDate;DPosDate)
                {
                }
                column(Amount_DetailedVendorLedgEntry;"Detailed Vendor Ledg. Entry".Amount)
                {
                }
                column(PayDate;PayDate)
                {
                }
                column(NetDate;NetDate)
                {
                }

                trigger OnAfterGetRecord();
                begin
                    IF "Detailed Vendor Ledg. Entry"."Posting Date" <> 0D THEN
                      DPosDate := FORMAT("Detailed Vendor Ledg. Entry"."Posting Date",10,'<Day,2>/<Month,2>/<Year4>');
                    PayDate := FORMAT("Detailed Vendor Ledg. Entry"."Posting Date" - "Vendor Ledger Entry"."Due Date");
                    NetDate := FORMAT("Detailed Vendor Ledg. Entry"."Posting Date" - "Vendor Ledger Entry"."Document Date");
                end;
            }

            trigger OnAfterGetRecord();
            begin
                IF Vendor.GET("Vendor Ledger Entry"."Vendor No.") THEN
                  VendName := Vendor.Name;
                IF PurchInvHeader.GET("Vendor Ledger Entry"."Document No.") THEN
                  PayTermCode := PurchInvHeader."Payment Terms Code";

                IF "Vendor Ledger Entry"."Posting Date" <> 0D THEN
                  PosDate := FORMAT("Vendor Ledger Entry"."Posting Date",10,'<Day,2>/<Month,2>/<Year4>');
                IF "Vendor Ledger Entry"."Document Date" <> 0D THEN
                  DocDate := FORMAT("Vendor Ledger Entry"."Document Date",10,'<Day,2>/<Month,2>/<Year4>');
                IF "Vendor Ledger Entry"."Due Date" <> 0D THEN
                  DueDate := FORMAT("Vendor Ledger Entry"."Due Date",10,'<Day,2>/<Month,2>/<Year4>');
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        Vendor : Record 23;
        VendName : Text[50];
        PurchInvHeader : Record 122;
        PayTermCode : Code[10];
        PosDate : Text;
        DocDate : Text;
        DueDate : Text;
        PayDate : Text;
        DPosDate : Text;
        NetDate : Text;
}

