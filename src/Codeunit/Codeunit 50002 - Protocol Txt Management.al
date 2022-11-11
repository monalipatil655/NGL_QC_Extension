
codeunit 50002 "Protocol Txt Management"
{
    // version PCPL/QC/V3/001


    trigger OnRun();
    begin
    end;

    var
        // NavPad: Automation "{334309EB-4AA6-497C-BABF-2AFDA61317EC} 1.0:{1B883E97-B2CB-48CF-8B47-87AAA589C289}:Unknown Automation Server.Unknown Class";

        TextLine: Text[250];
        Seperator: Integer;
        OKText: TextConst ENU = '&Save', NLD = '&Opslaan', NLB = '&Opslaan';
        CancelText: TextConst ENU = '&Cancel', NLD = '&Annuleren', FRB = '&Annuler', NLB = '&Annuleren';
        ChangedText: TextConst ENU = 'The text has been changed.  Are you sure?', NLD = 'De tekst werd gewijzigd. Ben je zeker?', NLB = 'De tekst werd gewijzigd. Ben je zeker?';
        ChangedTitleText: TextConst ENU = 'Text changed!', NLD = 'Text Gewijziged!', NLB = 'Text Gewijziged!';
        ErrorInstall: Label 'Please run the setup of WaldoNavPad.';

    /*
    procedure Init(TextFieldLength: Integer; FormTitle: Text[1024]);
    begin
        //Initialization of the default values for the properties
        //creation of the dll...

        IF ISCLEAR(NavPad) THEN
            IF NOT CREATE(NavPad, TRUE, TRUE) THEN
                ERROR(ErrorInstall);

        NavPad.TextFieldLength := TextFieldLength;
        NavPad.FormTitle := FormTitle;

        NavPad.OKButtonText := OKText;
        NavPad.CancelButtonText := CancelText;
        NavPad.ChangedWarningText := ChangedText;
        NavPad.ChangedWarningTitleText := ChangedTitleText;

        NavPad.FontSize := 12;
        NavPad.FontName := 'Times New Roman';
    end;

    procedure AppendText(ptxtText: Text[1024]);
    begin
        //Append piece of text to (probably) be displayed in the textpad
        NavPad.AppendText(ptxtText);
    end;

    procedure GetNextTextField(var ReturnText: Text[1024]; var ReturnSeparator: Integer);
    begin
        //Get next piece of text (taking the max field length into account)
        NavPad.GetNextTextField(ReturnText, ReturnSeparator);
    end;

    procedure ShowDialog();
    begin
        NavPad.ShowDialog;
    end;

    procedure GetEOS(): Boolean;
    begin
        //Used when looping to check if end of string
        EXIT(NavPad.EOS);
    end;

    procedure GetCount(): Integer;
    begin
        //Returns number of characters
        EXIT(NavPad.Count);
    end;

    procedure GetTextChanged(): Boolean;
    begin
        //Returns wether text was changed or not
        //Beware: it's a good idea to use the DialogResultOK instead of this property.  Read comment on GetDialogResultOK.
        EXIT(NavPad.TextChanged);
    end;

    procedure GetDialogResultOK(): Boolean;
    begin
        //If pressed "OK".
        //When nothing changed, and pressed OK, the DialogResultOK WILL be false!  This case, you don't have to worry about an extra check
        //on "TextChanged"
        EXIT(NavPad.DialogResultOK);
    end;

    procedure SetReadOnly(ReadOnly: Boolean);
    begin
        //Set pane to ReadOnly to just display the text
        NavPad.ReadonlyPane := ReadOnly;
    end;

    procedure SetFontSize(FontSize: Integer);
    begin
        //Set Font Size: Default = 20
        NavPad.FontSize := FontSize;
    end;

    procedure SetFontName(FontName: Text[1024]);
    begin
        //Set Font Name: Default = Times New Roman
        NavPad.FontName := FontName;
    end;

    procedure SetButtonText(OKButtonText: Text[1024]; CancelButtonText: Text[1024]);
    begin
        //To change the text on the OK-button and Cancel-button
        NavPad.OKButtonText := OKButtonText;
        NavPad.CancelButtonText := CancelButtonText;
    end;

    procedure SetChangedWarningText(ChangedWarningTitle: Text[1024]; ChangedWarningText: Text[1024]);
    begin
        //To change the title and text of the warning message.
        NavPad.ChangedWarningText := ChangedWarningText;
        NavPad.ChangedWarningTitleText := ChangedWarningTitle;
    end;

    procedure ResetText();
    begin
        //Empty the text
        NavPad.Text := '';
    end;
    */
}

