page 50052 "Quality measure Subform"
{
    // version PCPL/QC/V3/001

    AutoSplitKey = true;
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = 50024;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Location Code"; "Location Code")
                {
                    ApplicationArea = all;
                }
                field(Attachment; Attachment)
                {
                    Editable = false;
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Option)
            {
                action(Browse)
                {

                    trigger OnAction();
                    var
                        FileName: Text[250];
                        NVInStream: InStream;
                        Path: Text[250];
                        i: Integer;
                        FileN: Text[100];
                        //  FSO: Automation "{420B2830-E718-11CF-893D-00A0C9054228} 1.0:{0D43FE01-F093-11CF-8940-00A0C9054228}:'Microsoft Scripting Runtime'.FileSystemObject";
                        Dt: Integer;
                        FolderName: Text[100];
                    begin
                        FileName := '';

                        UPLOADINTOSTREAM('Import', '', ' All Files (*.*)|*.*', FileName, NVInStream);

                        /*
                        //create folder
                        Dt := DATE2DMY(TODAY,2);
                        IF Dt = 1 THEN
                        FolderName := 'January '+FORMAT(DATE2DMY(TODAY,3));
                        IF Dt = 2 THEN
                        FolderName := 'February '+FORMAT(DATE2DMY(TODAY,3));
                        IF Dt = 3 THEN
                        FolderName := 'March '+FORMAT(DATE2DMY(TODAY,3));
                        IF Dt = 4 THEN
                        FolderName := 'April '+FORMAT(DATE2DMY(TODAY,3));
                        IF Dt = 5 THEN
                        FolderName := 'May '+FORMAT(DATE2DMY(TODAY,3));
                        IF Dt = 6 THEN
                        FolderName := 'June '+FORMAT(DATE2DMY(TODAY,3));
                        IF Dt = 7 THEN
                        FolderName := 'July '+FORMAT(DATE2DMY(TODAY,3));
                        IF Dt = 8 THEN
                        FolderName := 'August '+FORMAT(DATE2DMY(TODAY,3));
                        IF Dt = 9 THEN
                        FolderName := 'September '+FORMAT(DATE2DMY(TODAY,3));
                        IF Dt = 10 THEN
                        FolderName := 'October '+FORMAT(DATE2DMY(TODAY,3));
                        IF Dt = 11 THEN
                        FolderName := 'November '+FORMAT(DATE2DMY(TODAY,3));
                        IF Dt = 12 THEN
                        FolderName := 'December '+FORMAT(DATE2DMY(TODAY,3));
                        
                        CLEAR(FSO);
                        IF CREATE(FSO,TRUE,TRUE) THEN;
                        IF NOT FSO.FolderExists('E:\PU New Project\Documents\'+FolderName) THEN
                        FSO.CreateFolder('E:\PU New Project\Documents\'+FolderName);
                        */

                        //copy file
                        FOR i := STRLEN(FileName) DOWNTO 1 DO BEGIN
                            IF COPYSTR(FileName, i, 1) = '\' THEN BEGIN
                                Path := COPYSTR(FileName, 1, i);
                                FileN := COPYSTR(FileName, i + 1);
                                i := 0;
                            END;
                        END;

                        FILE.COPY(FileName, 'E:\QC\' + Code + '_' + "Location Code" + '.pdf');

                        Attachment := 'E:\QC\' + Code + '_' + "Location Code" + '.pdf';

                        MESSAGE('File uploaded successfully');

                    end;
                }
            }
        }
    }
}

