codeunit 50007 "Protocol Mgt"
{
    // version PCPL/QC/V3/001

    // //As you can see, I commented out some code.  You'll see it gets the default values.
    // //If you uncomment the code, you can see how to use the different properties.

    //Permissions = TableData 50142=rimd;

    trigger OnRun();
    begin
    end;

    var
        NavPadMgt: Codeunit 50002;
        txtTextLine: Text[250];
        intSeperator: Integer;
        OKText: TextConst ENU = '&Save', NLB = '&Opslaan';
        CancelText: TextConst ENU = '&Cancel', FRB = '&Annuler', NLB = '&Annuleren';
        ChangedText: TextConst ENU = 'The text has been changed.  Are you sure?', NLB = 'De tekst werd gewijzigd. Ben je zeker?';
        ChangedTitleText: TextConst ENU = 'Text changed!', NLB = 'Text Gewijziged!';
    /*
    procedure EditContactText(var precContact: Record 50025; Readable: Boolean);
    begin
        NavPadMgt.Init(300, STRSUBSTNO('Texts - %1', precContact."Protocol No.", precContact."Specs ID"));

        //*** GET THE TEXT FROM THE TABLE ***
        GetContactTexts(precContact."Protocol No.");

        //*** SET FORM PROPERTIES
        //NavPadMgt.SetButtonText(OKText,CancelText);
        //NavPadMgt.SetChangedWarningText(ChangedTitleText,ChangedText);

        //*** IF YOU WANT THE PAD TO BE READONLY
        IF Readable THEN
            NavPadMgt.SetReadOnly := TRUE;

        //*** SET FONT
        //NavPadMgt.SetFontSize := 10;
        //NavPadMgt.SetFontName := 'Courier New';

        //*** OPEN FORM TO EDIT THE TEXT  ***
        NavPadMgt.ShowDialog;

        IF NavPadMgt.GetDialogResultOK THEN BEGIN
            //MESSAGE('Number of characters: ' + FORMAT(NavPadMgt.GetCount));

            //*** SAVE THE EDITED TEXT        ***
            //First delete all text-lines in the tabel
            DeleteContactTexts(precContact."Protocol No.");

            //Insert the Texts
            SaveContactTexts(precContact."Protocol No.");
        END;
    */

    //  CLEAR(NavPadMgt);
    //end;
    /*
    local procedure GetContactTexts(pcodContactNo: Integer);
    var
        lrecContactTexts: Record 50026;
        char13: Char;
        char10: Char;
    begin
        // This function gets the text form te table, and puts it in the text-property of WaldoNavPad
        char13 := 13;
        char10 := 10;
        CLEAR(lrecContactTexts);
        lrecContactTexts.SETRANGE("Protocol No.", pcodContactNo);
        IF lrecContactTexts.FIND('-') THEN BEGIN
            REPEAT
                NavPadMgt.AppendText(lrecContactTexts.Textline);
                CASE lrecContactTexts.Seperator OF
                    lrecContactTexts.Seperator::Space:
                        NavPadMgt.AppendText(' ');
                    lrecContactTexts.Seperator::"Carriage Return":
                        NavPadMgt.AppendText(FORMAT(char13) + FORMAT(char10));
                END;
            UNTIL lrecContactTexts.NEXT = 0;
        END
        ELSE BEGIN
            NavPadMgt.ResetText;
        END;
    end;

    local procedure DeleteContactTexts(pcodContactNo: Integer);
    var
        lrecContactTexts: Record 50026;
    begin
        // Before Inserting all lines, the current lines need to be deleted
        CLEAR(lrecContactTexts);
        lrecContactTexts.SETRANGE("Protocol No.", pcodContactNo);
        IF lrecContactTexts.FIND('-') THEN
            lrecContactTexts.DELETEALL(TRUE);
    end;

    local procedure SaveContactTexts(pcodContactNo: Integer);
    var
        lrecContactTexts: Record 50026;
        lintLineNo: Integer;
    begin
        lintLineNo := 0;

        WHILE NOT (NavPadMgt.GetEOS) DO BEGIN
            NavPadMgt.GetNextTextField(txtTextLine, intSeperator);
            lintLineNo += 10000;

            lrecContactTexts.INIT;

            lrecContactTexts."Protocol No." := pcodContactNo;
            lrecContactTexts."Line No." := lintLineNo;
            lrecContactTexts.Textline := txtTextLine;
            lrecContactTexts.Seperator := intSeperator;

            lrecContactTexts.INSERT(TRUE);

        END;
    end;
    */
}

