tableextension 50116 Quality_Measure_QC extends "Quality Measure"
{
    // version NAVW17.00,PCPL/QC/V3/001,QC3.0

    fields
    {
        field(50000; Qualitative; Boolean)
        {
            Description = 'PCPL QC 2.0';
        }
        field(50001; "Unit of Measure"; Code[10])
        {
            Description = 'PCPL QC 2.0';
            TableRelation = "Unit of Measure";
        }
        field(50002; URL; Text[50])
        {
            Description = 'PCPL QC 2.0';
        }
    }
    keys
    {
        key(Key2; Description)
        {
        }
    }




    var
        QCSetup: Record 50010;
        NoSeriesMgmt: Codeunit 396;
}

