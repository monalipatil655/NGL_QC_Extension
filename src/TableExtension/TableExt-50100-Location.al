tableextension 50100 Location_QC_ext extends Location
{


    fields
    {


        field(50050; "RM AR No. Series"; Code[10])
        {
            Description = 'IRLQC/CUST/0003';
            TableRelation = "No. Series";
        }
        field(50051; "FG AR No. Series"; Code[10])
        {
            Description = 'IRLQC/CUST/0003';
            TableRelation = "No. Series";
        }
        field(50052; "PM AR No. Series"; Code[10])
        {
            Description = 'IRLQC/CUST/0003';
            TableRelation = "No. Series";
        }
        field(50053; "Others AR No. Series"; Code[10])
        {
            Description = 'IRLQC/CUST/0003';
            TableRelation = "No. Series";
        }
        field(50054; "Default Cont. Sample Bin"; Code[10])
        {
            Description = 'IRLQC/CUST/0003';
            TableRelation = Bin.Code WHERE("Location Code" = FIELD(Code));
        }
        field(50055; "Default Approved Bin"; Code[10])
        {
            Description = 'IRLQC/CUST/0003';
            TableRelation = Bin.Code WHERE("Location Code" = FIELD(Code));
        }
        field(50056; "Default Rejected Bin"; Code[10])
        {
            Description = 'IRLQC/CUST/0003';
            TableRelation = Bin.Code WHERE("Location Code" = FIELD(Code));
        }

    }

}

