tableextension 50120 Warehouse_Receipt_Header extends "Warehouse Receipt Header"
{
    // version NAVW19.00.00.45778

    fields
    {

        //Unsupported feature: PropertyDeletion on ""Assigned User ID"(Field 3)". Please convert manually.        
        field(50004; "Manufacturing Date"; Date)
        {
            Description = 'sanjay 07/July/2015';
        }
        field(50005; "Expairy Date"; Date)
        {
            Description = 'sanjay 07/July/2015';
        }

        field(50008; "Packing details"; Text[250])
        {
            Description = 'sanjay 26/12/2016';
        }

    }




}

