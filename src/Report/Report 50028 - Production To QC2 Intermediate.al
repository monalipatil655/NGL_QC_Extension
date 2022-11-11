report 50028 "Production To QC2 Intermediate"
{
    // version SANJAY NGL

    DefaultLayout = RDLC;
    RDLCLayout = 'src/Production To QC2 Intermediate.rdl';

    dataset
    {
        dataitem("Production Order"; "Production Order")
        {
            column(Prod_No; "Production Order"."No.")
            {
            }
            column(Item_Name; "Production Order".Description)
            {
            }
            column(Posting_Date; "Production Order"."Finished Date")
            {
            }
            column(Location_Name; "Production Order"."Location Code")
            {
            }
            column(Bin_Code; "Production Order"."Bin Code")
            {
            }
            column(Qty; "Production Order".Quantity)
            {
            }
            column(Batch_No; "Production Order"."Lot No.")
            {
            }
            column(Locname; RecLoc.Name)
            {
            }
            column(mfgdate1; mfgdate)
            {
            }
            column(expdate1; expdate)
            {
            }
            column(packing1; packing)
            {
            }
            column(Givenby; "Production Order"."Assigned User ID")
            {
            }
            column(arno; arno)
            {
            }
            column(Analysed_By; anlaysedby)
            {
            }
            column(Approved_By; Approvedby)
            {
            }
            column(ARNO_Date; ARPostingdt)
            {
            }
            column(Company_Name; company.Name)
            {
            }
            column(comp_Pict; company.Picture)
            {
            }
            column(Loca_name; loca.Name)
            {
            }
            column(Loca_Address; company.Name + ', ' + loca.Address + ' ' + loca."Address 2" + ' ' + loca.City)
            {
            }
            column(Result; Result1)
            {
            }
            column(retestdate1; retestdate)
            {
            }
            column(uom1; uom)
            {
            }

            trigger OnAfterGetRecord();
            begin
                Recqc.RESET;
                Recqc.SETRANGE(Recqc."Document No.", "Production Order"."No.");
                IF Recqc.FINDFIRST THEN
                    mfgdate := Recqc."Mfg. Date";
                //              expdate :=Recqc.Expiry_Date;
                //           packing :=Recqc."Prod. Packing Detail";
                arno := Recqc."Certificate No.";
                anlaysedby := Recqc."Inspected By";
                Approvedby := Recqc."Approved By";
                ARPostingdt := Recqc."Posting Date";
                Result1 := Recqc.Remarks;
                retestdate := Recqc."Retest on";
                uom := Recqc."Unit of Messure";

                IF loca.GET("Production Order"."Location Code") THEN;
            end;

            trigger OnPreDataItem();
            begin
                company.GET;
                company.CALCFIELDS(Picture);
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
        RecLoc: Record 14;
        RecComp: Record 79;
        Recqc: Record 50011;
        mfgdate: Date;
        expdate: Date;
        packing: Text[250];
        arno: Text[50];
        anlaysedby: Text[30];
        Approvedby: Text[30];
        ARPostingdt: Date;
        company: Record 79;
        loca: Record 14;
        Result1: Text[100];
        retestdate: Date;
        uom: Text;
}

