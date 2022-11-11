tableextension 50102 Item_Led_Entry_QC extends "Item Ledger Entry"
{


    fields
    {
        field(50046; "QC Status"; Option)
        {
            Description = 'PCPL QC 2.0';
            OptionCaption = 'Quarantine,Approved,Rejected';
            OptionMembers = WIP,Approved,Rejected;
        }
        field(50047; "QC Retest Date"; Date)
        {
            Description = 'PCPL QC 2.0';
        }

        field(50107; "Create QC Inspection"; Boolean)
        {

        }
    }
    keys
    {

        //Unsupported feature: PropertyChange on ""Item No.,Open,Variant Code,Positive,Location Code,Posting Date"(Key)". Please convert manually.


        //Unsupported feature: PropertyChange on ""Item No.,Open,Variant Code,Positive,Location Code,Posting Date,Expiration Date,Lot No.,Serial No."(Key)". Please convert manually.


        //Unsupported feature: PropertyChange on ""Country/Region Code,Entry Type,Posting Date"(Key)". Please convert manually.


        //Unsupported feature: PropertyChange on ""Item No.,Entry Type,Variant Code,Drop Shipment,Global Dimension 1 Code,Global Dimension 2 Code,Location Code,Posting Date"(Key)". Please convert manually.


        //Unsupported feature: PropertyChange on ""Order Type,Order No.,Order Line No.,Entry Type,Prod. Order Comp. Line No."(Key)". Please convert manually.


        //Unsupported feature: PropertyChange on ""Item No.,Applied Entry to Adjust"(Key)". Please convert manually.

    }

    //Unsupported feature: PropertyChange. Please convert manually.

}

