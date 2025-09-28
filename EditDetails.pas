unit EditDetails;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, jpeg, ExtCtrls, StdCtrls, DB, ADODB;

type
  TChangeDetails = class(TForm)
    imgBg: TImage;
    imgQuit: TImage;
    imgBackbtn: TImage;
    lblPassSpecialChar: TLabel;
    lblPassNumber: TLabel;
    lblPassLenght: TLabel;
    lblPassInfo: TLabel;
    lblPassCapitalLetter: TLabel;
    edtFirstName: TEdit;
    edtLastName: TEdit;
    edtDOB: TEdit;
    edtEmail: TEdit;
    edtPassword: TEdit;
    lblFirstName: TLabel;
    lblLastName: TLabel;
    lblDOB: TLabel;
    lblEmail: TLabel;
    lblPassword: TLabel;
    lblDOBFormat: TLabel;
    qryGetAccountType: TADOQuery;
    qryGetFirstAndLastName: TADOQuery;
    lblFirstNameCurrentUser: TLabel;
    lblFirstNameCurrent: TLabel;
    lblLastNameCurrent: TLabel;
    lblLastNameCurrentUser: TLabel;
    lblDOBCurrent: TLabel;
    lblEmailCurrent: TLabel;
    lblDOBCurrentUser: TLabel;
    lblEmailCurrentUser: TLabel;
    qryGetDOBEmail: TADOQuery;
    qryUpdateDatabase: TADOQuery;
    qryUpdateFullName: TADOQuery;
    qryEmail: TADOQuery;
    imgSubmit: TImage;
    lblSubmit: TLabel;
    lblCurrentDetails: TLabel;
    lblEditDetails: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure AddFontResourceAndBroadcast;
    procedure imgQuitClick(Sender: TObject);
    procedure imgBackbtnClick(Sender: TObject);
    procedure GetAccountType;
    procedure OnShow(Sender: TObject);
    procedure GetFirstAndLastNameStudent;
    procedure GetFirstAndLastNameTeacher;
    procedure GetDOBAndEmail;
    procedure edtDOBKeyPress(Sender: TObject; var Key: Char);
    procedure DOBValidityconditions;
    procedure EmailValidityconditions;
    procedure btnSubmitClick(Sender: TObject);
    procedure PasswordValidityconditions;
    procedure FirstNameValidity;
    procedure LastNameValidity;
    function  AllFieldsAreValid: Boolean;
    procedure UpdateDatabaseIfValid;
    procedure UpdateEmailDatabase;
    procedure UpdateFirstNameDatabase;
    procedure UpdateLastNameDatabase;
    procedure UpdateFullNameConditions;
    procedure UpdateFullName(FullName: string);
    procedure UpdateDOBDatabase;
    procedure UpdatePasswordDatabase;


  private
    { Private declarations }
    FCurrentUserID: Integer;
  public
    { Public declarations }
    property CurrentUserID: Integer read FCurrentUserID write FCurrentUserID;
  end;

var
  ChangeDetails: TChangeDetails;
  lblPassInfoTop, lblPassInfoLeft: Integer;
  lblPassCapitalLetterTop, lblPassCapitalLetterLeft: Integer;
  lblPassLenghtTop, lblPassLenghtLeft: Integer;
  lblPassNumberTop, lblPassNumberLeft: Integer;
  lblPassSpecialCharTop, lblPassSpecialCharLeft: Integer;
  AccountType: string;
  DOBValid: Boolean;
  EmailGreenwoodValid: Boolean;
  PasswordValid: Boolean;
  FirstNameValid: Boolean;
  LastNameValid: Boolean;
  UpdateEmail:Boolean;
  UpdatePassword: Boolean;
  UpdateFirstName: Boolean;
  UpdateLastName: Boolean;
  UpdateDOB: Boolean;
  EmailValidFinal, PasswordValidFinal, FirstNameValidFinal, LastNameValidFinal, DOBValidFinal: Boolean;
  FirstName: string;
  LastName: string;
implementation

uses CustomDialog, NavigationPageStudent, NavigationPageTeacher;

{$R *.dfm}

procedure TChangeDetails.FormCreate(Sender: TObject);
begin
  BorderStyle := bsNone;

  //Ensuring the form appears as full screen

  Left := Screen.Monitors[0].Left;
  Top := Screen.Monitors[0].Top;
  Width := Screen.Monitors[0].Width;
  Height := Screen.Monitors[0].Height;

  ScaleFactor := 0.9;

  //Call procedure which loads a custom font
  AddFontResourceAndBroadcast;

  //imgQuit: appearance on page

  imgQuit.Top := 20;
  imgQuit.Constraints.MaxWidth := Round(ClientWidth * 0.05);
  imgQuit.Constraints.MaxHeight := Round(ClientWidth * 0.05);
  imgQuit.Left := ClientWidth - imgQuit.Width - 20;
  imgQuit.Constraints.MinWidth := Round(ClientWidth * 0.04);
  imgQuit.Constraints.MinHeight := Round(ClientWidth * 0.04);

  //imgBackbtn: appearance on page

  imgBackbtn.Top := 20;
  imgBackbtn.Constraints.MaxWidth := Round(ClientWidth * 0.06);
  imgBackbtn.Constraints.MaxHeight := Round(ClientWidth * 0.06);
  imgBackbtn.Left := Left + imgBackbtn.Width - 40;

  //lblPassInfo: appearance on page

  lblPassInfo.Font.Name := 'Arial Rounded MT Bold';
  lblPassInfo.Font.Size := Round(imgBg.Width * 0.015);
  lblPassInfo.Transparent := True;
  lblPassInfo.Font.Color := RGB(50, 50, 50);
  lblPassInfoTop := imgBg.Top + Round(imgBg.Height * 0.67);
  lblPassInfoLeft := imgBg.Left + Round(imgBg.Width * 0.1);
  lblPassInfo.Left := lblPassInfoLeft;
  lblPassInfo.Top := lblPassInfoTop;

  //lblPassCapitalLetter: appearance on page

  lblPassCapitalLetter.Font.Name := 'Arial Rounded MT Bold';
  lblPassCapitalLetter.Font.Size := Round(imgBg.Width * 0.01);
  lblPassCapitalLetter.Transparent := True;
  lblPassCapitalLetter.Font.Color := RGB(114, 114, 114);
  lblPassCapitalLetterTop := imgBg.Top + Round(imgBg.Height * 0.74);
  lblPassCapitalLetterLeft := imgBg.Left + Round(imgBg.Width * 0.11);
  lblPassCapitalLetter.Left := lblPassCapitalLetterLeft;
  lblPassCapitalLetter.Top := lblPassCapitalLetterTop;

  //lblPassLenght: appearance on page

  lblPassLenght.Font.Name := 'Arial Rounded MT Bold';
  lblPassLenght.Font.Size := Round(imgBg.Width * 0.01);
  lblPassLenght.Transparent := True;
  lblPassLenght.Font.Color := RGB(114, 114, 114);
  lblPassLenghtTop := imgBg.Top + Round(imgBg.Height * 0.78);
  lblPassLenghtLeft := imgBg.Left + Round(imgBg.Width * 0.11);
  lblPassLenght.Left := lblPassLenghtLeft;
  lblPassLenght.Top := lblPassLenghtTop;

  //lblPassNumber: appearance on page

  lblPassNumber.Font.Name := 'Arial Rounded MT Bold';
  lblPassNumber.Font.Size := Round(imgBg.Width * 0.01);
  lblPassNumber.Transparent := True;
  lblPassNumber.Font.Color := RGB(114, 114, 114);
  lblPassNumberTop := imgBg.Top + Round(imgBg.Height * 0.82);
  lblPassNumberLeft := imgBg.Left + Round(imgBg.Width * 0.11);
  lblPassNumber.Left := lblPassNumberLeft;
  lblPassNumber.Top := lblPassNumberTop;

  //lblPassSpecialChar: appearance on page

  lblPassSpecialChar.Font.Name := 'Arial Rounded MT Bold';
  lblPassSpecialChar.Font.Size := Round(imgBg.Width * 0.01);
  lblPassSpecialChar.Transparent := True;
  lblPassSpecialChar.Font.Color := RGB(114, 114, 114);
  lblPassSpecialCharTop := imgBg.Top + Round(imgBg.Height * 0.86);
  lblPassSpecialCharLeft := imgBg.Left + Round(imgBg.Width * 0.11);
  lblPassSpecialChar.Left := lblPassSpecialCharLeft;
  lblPassSpecialChar.Top := lblPassSpecialCharTop;

  //edt boxes: appereance on page

  edtFirstName.Font.Name := 'Arial Rounded MT Bold';
  edtFirstName.Font.Size := Round(ClientWidth * 0.015);
  edtFirstName.Top := Round(ClientHeight * 0.21);
  edtFirstName.Left := Round(ClientWidth * 0.665);
  edtFirstName.Width := Round(ClientWidth * 0.23);
  edtFirstName.Height := Round(ClientHeight * 0.048);

  edtLastName.Font.Name := 'Arial Rounded MT Bold';
  edtLastName.Font.Size := Round(ClientWidth * 0.015);
  edtLastName.Top := Round(ClientHeight * 0.34);
  edtLastName.Left := Round(ClientWidth * 0.665);
  edtLastName.Width := Round(ClientWidth * 0.23);
  edtLastName.Height := Round(ClientHeight * 0.048);

  edtDOB.Font.Name := 'Arial Rounded MT Bold';
  edtDOb.Font.Size := Round(ClientWidth * 0.015);
  edtDOB.Top := Round(ClientHeight * 0.465);
  edtDOB.Left := Round(ClientWidth * 0.665);
  edtDOB.Width := Round(ClientWidth * 0.23);
  edtDOB.Height := Round(ClientHeight * 0.048);

  edtEmail.Font.Name := 'Arial Rounded MT Bold';
  edtEmail.Font.Size := Round(ClientWidth * 0.015);
  edtEmail.Top := Round(ClientHeight * 0.59);
  edtEmail.Left := Round(ClientWidth * 0.665);
  edtEmail.Width := Round(ClientWidth * 0.23);
  edtEmail.Height := Round(ClientHeight * 0.048);

  edtPassword.Font.Name := 'Arial Rounded MT Bold';
  edtPassword.Font.Size := Round(ClientWidth * 0.015);
  edtPassword.Top := Round(ClientHeight * 0.735);
  edtPassword.Left := Round(ClientWidth * 0.665);
  edtPassword.Width := Round(ClientWidth * 0.23);
  edtPassword.Height := Round(ClientHeight * 0.048);

  //lblFirstName : Appereance on page
  lblFirstName.Font.Name := 'Arial Rounded MT Bold';
  lblFirstName.Font.Size := Round(ClientWidth * 0.015);
  lblFirstName.Font.Color := RGB(150,173,123);
  lblFirstName.Top := Round(ClientHeight * 0.21);
  lblFirstName.Left := Round(ClientWidth * 0.53);

  //lblLastName : Appereance on page
  lblLastName.Font.Name := 'Arial Rounded MT Bold';
  lblLastName.Font.Size := Round(ClientWidth * 0.015);
  lblLastName.Font.Color := RGB(150,173,123);
  lblLastName.Top := Round(ClientHeight * 0.34);
  lblLastName.Left := Round(ClientWidth * 0.53);

  //lblDOB : Appereance on page
  lblDOB.Font.Name := 'Arial Rounded MT Bold';
  lblDOb.Font.Size := Round(ClientWidth * 0.015);
  lblDOb.Font.Color := RGB(150,173,123);
  lblDOB.Top := Round(ClientHeight * 0.465);
  lblDOB.Left := Round(ClientWidth * 0.53);

  //lblEmail : Appereance on page
  lblEmail.Font.Name := 'Arial Rounded MT Bold';
  lblEmail.Font.Size := Round(ClientWidth * 0.015);
  lblEmail.Font.Color := RGB(150,173,123);
  lblEmail.Top := Round(ClientHeight * 0.59);
  lblEmail.Left := Round(ClientWidth * 0.53);

  //lblPassword : Appereance on page
  lblPassword.Font.Name := 'Arial Rounded MT Bold';
  lblPassword.Font.Size := Round(ClientWidth * 0.015);
  lblPassword.Font.Color := RGB(150,173,123);
  lblPassword.Top := Round(ClientHeight * 0.735);
  lblPassword.Left := Round(ClientWidth * 0.53);

  //lblDOBFormat : Appereance on page
  lblDOBFormat.Font.Name := 'Arial Rounded MT Bold';
  lblDOBFormat.Font.Size := Round(ClientWidth * 0.008);
  lblDOBFormat.Font.Color := RGB(114, 114, 114);
  lblDOBFormat.Top := Round(ClientHeight * 0.53);
  lblDOBFormat.Left := Round(ClientWidth * 0.655);
  lblDOBFormat.Visible := False;

  //lblFirstNameCurrentUser : Appereance on page
  lblFirstNameCurrentUser.Font.Name := 'Arial Rounded MT Bold';
  lblFirstNameCurrentUser.Font.Size := Round(ClientWidth * 0.013);
  lblFirstNameCurrentUser.Font.Color:= RGB(229, 229, 229);
  lblFirstNameCurrentUser.Top := Round(ClientHeight * 0.23);
  lblFirstNameCurrentUser.Left := Round(ClientWidth * 0.1);

  //lblFirstNameCurrent : Appereance on page
  lblFirstNameCurrent.Font.Name := 'Arial Rounded MT Bold';
  lblFirstNameCurrent.Font.Size := Round(ClientWidth * 0.015);
  lblFirstNameCurrent.Font.Color:= RGB(255, 255, 255);
  lblFirstNameCurrent.Top := Round(ClientHeight * 0.16);
  lblFirstNameCurrent.Left := Round(ClientWidth * 0.1);

  //lblLastNameCurrent : Appereance on page
  lblLastNameCurrent.Font.Name := 'Arial Rounded MT Bold';
  lblLastNameCurrent.Font.Size := Round(ClientWidth * 0.015);
  lblLastNameCurrent.Font.Color:= RGB(255, 255, 255);
  lblLastNameCurrent.Top := Round(ClientHeight * 0.3);
  lblLastNameCurrent.Left := Round(ClientWidth * 0.1);

   //lblLastNameCurrentUser : Appereance on page
  lblLastNameCurrentUser.Font.Name := 'Arial Rounded MT Bold';
  lblLastNameCurrentUser.Font.Size := Round(ClientWidth * 0.013);
  lblLastNameCurrentUser.Font.Color:= RGB(229, 229, 229);
  lblLastNameCurrentUser.Top := Round(ClientHeight * 0.37);
  lblLastNameCurrentUser.Left := Round(ClientWidth * 0.1);

  //lblDOBCurrent : Appereance on page
  lblDOBCurrent.Font.Name := 'Arial Rounded MT Bold';
  lblDOBCurrent.Font.Size := Round(ClientWidth * 0.015);
  lblDOBCurrent.Font.Color:= RGB(255, 255, 255);
  lblDOBCurrent.Top := Round(ClientHeight * 0.44);
  lblDOBCurrent.Left := Round(ClientWidth * 0.1);

  //lblDOBCurrentUser : Appereance on page
  lblDOBCurrentUser.Font.Name := 'Arial Rounded MT Bold';
  lblDOBCurrentUser.Font.Size := Round(ClientWidth * 0.013);
  lblDOBCurrentUser.Font.Color:= RGB(229, 229, 229);
  lblDOBCurrentUser.Top := Round(ClientHeight * 0.51);
  lblDOBCurrentUser.Left := Round(ClientWidth * 0.1);

  //lblEmailCurrent : Appereance on page
  lblEmailCurrent.Font.Name := 'Arial Rounded MT Bold';
  lblEmailCurrent.Font.Size := Round(ClientWidth * 0.015);
  lblEmailCurrent.Font.Color:= RGB(255, 255, 255);
  lblEmailCurrent.Top := Round(ClientHeight * 0.58);
  lblEmailCurrent.Left := Round(ClientWidth * 0.1);

  //lblEmailCurrentUser : Appereance on page
  lblEmailCurrentUser.Font.Name := 'Arial Rounded MT Bold';
  lblEmailCurrentUser.Font.Size := Round(ClientWidth * 0.013);
  lblEmailCurrentUser.Font.Color:= RGB(229, 229, 229);
  lblEmailCurrentUser.Top := Round(ClientHeight * 0.583);
  lblEmailCurrentUser.Left := Round(ClientWidth * 0.17);

  //imgSubmit: Appereance on page
  imgSubmit.Width:= Round(ClientWidth * 0.25);
  imgSubmit.Height := Round (ClientHeight * 0.2);
  imgSubmit.Left := Round(ClientWidth * 0.64);
  imgSubmit.Top := Round(ClientHeight * 0.83);

  //lblSubmit: Appereance on page
  lblSubmit.Font.Name := 'Arial Rounded MT Bold';
  lblSubmit.Font.Size := Round(ClientWidth * 0.023);;
  lblSubmit.Transparent := True;
  lblSubmit.Font.Color := RGB(255, 255, 255);
  lblSubmit.Left := imgSubmit.Left + (imgSubmit.Width - lblSubmit.Width) div 2;
  lblSubmit.Top := imgSubmit.Top + (imgSubmit.Height - lblSubmit.Height) div 2;

  //lblCurrentDetails: appreance on page
  lblCurrentDetails.Font.Name := 'Arial Rounded MT Bold';
  lblCurrentDetails.Font.Size := Round(ClientWidth * 0.03);;
  lblCurrentDetails.Transparent := True;
  lblCurrentDetails.Font.Color := RGB(255, 255, 255);
  lblCurrentDetails.Left := Round(ClientWidth * 0.13);
  lblCurrentDetails.Top := Round(ClientWidth * 0.015);

  //lblEditDetails: appreance on page
  lblEditDetails.Font.Name := 'Arial Rounded MT Bold';
  lblEditDetails.Font.Size := Round(ClientWidth * 0.03);;
  lblEditDetails.Transparent := True;
  lblEditDetails.Font.Color := RGB(150,173,123);
  lblEditDetails.Left := Round(ClientWidth * 0.65);
  lblEditDetails.Top := Round(ClientWidth * 0.015);


  end;

 procedure TChangeDetails.AddFontResourceAndBroadcast;
  begin
    if AddFontResource('Revision System Project\FONTS\arial-rounded-mt-bold.ttf"') > 0 then
      SendMessage(HWND_BROADCAST, WM_FONTCHANGE, 0, 0);
  end;

  //Procedure for exiting the program upon pressing the exit button

  procedure TChangeDetails.imgQuitClick(Sender: TObject);
  begin
    //check quitting form isn't already opened
  if CustomDialogOpened = False then
    begin
      begin
      //Marks quitting form as opened, so multiple can not be opened at once
      CustomDialogOpened := True;
      CustomDialogForm := TCustomDialogForm.Create(nil);
      //Position of quitting form
      SetWindowPos(CustomDialogForm.Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE);
      CustomDialogForm.Show;
    end;
    end
  else
  end;

  procedure TChangeDetails.imgBackbtnClick(Sender: TObject);
  begin
    if AccountType = 'Student' then
    StudentNavigation.Show;
    ChangeDetails.Hide;

    if AccountType = 'Teacher' then
    TeacherNavigation.Show;
    ChangeDetails.Hide;

  end;

  procedure TChangeDetails.OnShow(Sender: TObject);
  begin
   GetAccountType;

   if AccountType = 'Student' then
   begin
   GetFirstAndLastNameStudent;
   end
   else
   begin
     GetFirstAndLastNameTeacher;
   end;
   GetDOBAndEmail;
  end;

  procedure TChangeDetails.GetAccountType;
  var
    TeacherAccount:Boolean;
  begin
   qryGetAccountType.SQL.Text := 'SELECT TeacherAccount FROM Account WHERE MainUserID = :UserID';
   qryGetAccountType.Parameters.ParamByName('UserID').Value := CurrentUserID;
   qryGetAccountType.Open;
   TeacherAccount := qryGetAccountType.FieldByName('TeacherAccount').AsBoolean;

   if TeacherAccount =  True then
   begin
   AccountType:= 'Teacher';
   end
   else
   begin
   AccountType:= 'Student';
   end
  end;

  procedure TChangeDetails.GetFirstAndLastNameStudent;
  begin
  qryGetFirstAndLastName.SQl.Text := 'SELECT SName, SSurname FROM Student WHERE MainUserID = :UserID';
  qryGetFirstAndLastName.Parameters.ParamByName('UserID').Value := CurrentUserID;
  qryGetFirstAndLastName.open;
  FirstName := qryGetFirstAndLastName.FieldByName('SName').AsString;
  LastName := qryGetFirstAndLastName.FieldByName('SSurname').AsString;
  lblFirstNameCurrentUser.caption := FirstName;
  lblLastNameCurrentUser.caption := LastName;
  end;

  procedure TChangeDetails.GetFirstAndLastNameTeacher;
  begin
  qryGetFirstAndLastName.SQl.Text := 'SELECT TName, TSurname FROM Teacher WHERE MainUserID = :UserID';
  qryGetFirstAndLastName.Parameters.ParamByName('UserID').Value := CurrentUserID;
  qryGetFirstAndLastName.open;
  FirstName := qryGetFirstAndLastName.FieldByName('TName').AsString;
  LastName := qryGetFirstAndLastName.FieldByName('TSurname').AsString;
  lblFirstNameCurrentUser.caption := FirstName;
  lblLastNameCurrentUser.caption := LastName;
  end;

   procedure TChangeDetails.GetDOBAndEmail;
   var
   DOB: string;
   Email: string;

   begin
    qryGetDOBEmail.SQl.Text := 'SELECT Email, DOB FROM Account WHERE MainUserID = :UserID';
    qryGetDOBEmail.Parameters.ParamByName('UserID').Value := CurrentUserID;
    qryGetDOBEmail.open;
    DOB := qryGetDOBEmail.FieldByName('DOB').AsString;
    Email := qryGetDOBEmail.FieldByName('Email').AsString;
    lblDOBCurrentUser.caption := DOB;
    lblEmailCurrentUser.caption := Email;
   end;

   procedure TChangeDetails.edtDOBKeyPress(Sender: TObject; var Key: Char);

 var
  TextLength: Integer;
  CursorPos: Integer;
begin

  // Current length of the text in the edit box
  TextLength := Length(TEdit(Sender).Text);

  // Current cursor position
  CursorPos := TEdit(Sender).SelStart;

  // Allow only digits, slash, and backspace
  if not (Key in ['0'..'9', #8, '/']) then
    Key := #0;

  // Backspace key to delete characters
  if Key = #8 then
  begin
    if CursorPos > 0 then //check there are characters to delete
    begin
      TEdit(Sender).Text := Copy(TEdit(Sender).Text, 1, CursorPos - 1) +
                             Copy(TEdit(Sender).Text, CursorPos + 1, TextLength - CursorPos); // Update the text without the deleted character
      TEdit(Sender).SelStart := CursorPos - 1; // Set the cursor position back to its original position
    end;
    Key := #0; // Consume backspace key
  end;

   //Automatically insert slashes after day and month
  case CursorPos of
    2, 5:
    begin
      if Key in ['0'..'9'] then
      begin
        TEdit(Sender).Text := TEdit(Sender).Text + '/';
        TEdit(Sender).SelStart := CursorPos + 1; // Move cursor after the slash
      end;
    end;
  end;

  // Prevent typing more characters after the complete date
  if TextLength >= 10 then
    Key := #0;
end;

//checks if validity conditions for DOB are met.
procedure TChangeDetails.DOBValidityconditions;

var
  DOBLength: Integer;
  DayChar1, DayChar2, MonthChar1, MonthChar2: Char;
  DayStr, MonthStr: String;
  DayInt, MonthInt: Integer;
  FieldCompleted: Boolean;
begin
  FieldCompleted := False;
  DOBLength := Length(edtDOB.Text);

  //checks DOB is the correct lenght
  if DOBLength = 10 then
  begin
    FieldCompleted := True;

    //Collects user input
    DayChar1 := edtDOB.Text[1];
    DayChar2 := edtDOB.Text[2];
    MonthChar1 := edtDOB.Text[4];
    MonthChar2 := edtDOB.Text[5];
    DayStr := DayChar1 + DayChar2;
    MonthStr := MonthChar1 + MonthChar2;
    DayInt := StrToIntDef(DayStr, 0);
    MonthInt := StrToIntDef(MonthStr, 0);
  end;

  if FieldCompleted then
  begin
    if (MonthInt > 0) and (MonthInt < 13) then
    begin
      //Ensures even months do not have more than 30 days.
      if MonthInt mod 2 = 0 then
      begin
        if (DayInt >= 1) and (DayInt <= 30) then
          DOBValid := True
        else
          DOBValid := False;
      end
      else
      begin
        //Ensures odd months do not have more than 31 days.
        if (DayInt >= 1) and (DayInt <= 31) then
          DOBValid := True
        else
          DOBValid := False;
      end;
    end
    else
      DOBValid := False;
  end
  else
    DOBValid := False;
end;


//Checks all validity conditions for email entered are met
procedure TChangeDetails.EmailValidityconditions;
begin
  if (edtEmail.Text <> '') then
  begin
    // Check if the email contains "@greenwood.org"
   if Pos('@greenwood.org', edtEmail.Text) = 0 then
    begin
      // If not found, display an error message
      ShowMessage('Please use your school email, must be from "greenwood.org" domain.');
      edtEmail.SetFocus;
     EmailGreenwoodValid := False;
   end
    else
     begin
      EmailGreenwoodValid := True;
    end;
   end;

  //run when the domain of email is correct
  if EmailGreenwoodValid = True then
    begin
       qryEmail.SQL.Text := 'SELECT Email FROM Account WHERE Email = :Email';
       qryEmail.Parameters.ParamByName('Email').Value := edtEmail.Text;
    qryEmail.Open;

    // Check if the query returned any records (if the email already exists in database)
    if not qryEmail.IsEmpty then
    begin
      // Email already exists in the database
      ShowMessage('This email is already registered. Please use a different email.');
      EmailGreenwoodValid := False;
      // Set focus back to the email field for correction
      edtEmail.SetFocus;
    end;
    end;
end;

procedure TChangeDetails.PasswordValidityconditions;
var
  Password: string;
  I: Integer;
  PasswordLenght, HasCapitalLetter,  HasNumber, HasSpecialChar :Boolean;

begin

  PasswordLenght := False;
  HasCapitalLetter := False;
  HasNumber := False;
  HasSpecialChar := False;

  // Get the text from the edtPassword field
  Password := edtPassword.Text;

  // Check if the password meets the minimum length requirement

  if Length(Password) < 8 then
  begin
    PasswordLenght := False;
  end
  else
  begin
    PasswordLenght := True;

  end;

  //Check if password contains a capital letter

  for I := 1 to Length(Password) do
  begin
    if Password[I] in ['A'..'Z'] then
    begin
      HasCapitalLetter := True;

    end;
  end;

  // Check if the password contains at least one number

  for I := 1 to Length(Password) do
  begin
    if Password[I] in ['0'..'9'] then
    begin
      HasNumber := True;
    end;

    end;

  // Check if the password contains at least one special character

  for I := 1 to Length(Password) do
  begin
    if not (Password[I] in ['A'..'Z', 'a'..'z', '0'..'9']) then
    begin
      HasSpecialChar := True;
      end;
  end;

  if HasSpecialChar and HasNumber and HasCapitalLetter and PasswordLenght then
    begin
      PasswordValid:= True;
    end
    else
      begin
        PasswordValid:= False;
      end;

   if PasswordLenght = True then
        begin
          lblPassLenght.Font.Color := RGB(150, 181, 100);
        end
        else
          begin
           lblPassLenght.Font.Color := RGB(181, 105, 100);
          end;

      if HasSpecialChar = True then
        begin
          lblPassSpecialChar.Font.Color := RGB(150, 181, 100);
        end
        else
          begin
           lblPassSpecialChar.Font.Color := RGB(181, 105, 100);
          end;

      if HasNumber = True then
        begin
          lblPassNumber.Font.Color := RGB(150, 181, 100);
        end
        else
          begin
           lblPassNumber.Font.Color := RGB(181, 105, 100);
          end;

       if HasCapitalLetter = True then
        begin
          lblPassCapitalLetter.Font.Color := RGB(150, 181, 100);
        end
        else
          begin
           lblPassCapitalLetter.Font.Color := RGB(181, 105, 100);
          end;

end;

procedure TChangeDetails.FirstNameValidity;
var
  FirstName: string;
  ValidFirstName: Boolean;
begin
  // Get the text from the edtFirstName box
  FirstName := Trim(edtFirstName.Text);

  // Check if the FirstName contains only one word
  ValidFirstName := (Pos(' ', FirstName) = 0) and (Length(FirstName) > 0);

  // Capitalize the first letter and make the rest lowercase
  if Length(FirstName) > 0 then
    FirstName := UpperCase(FirstName[1]) + LowerCase(Copy(FirstName, 2, Length(FirstName) - 1));

  // Update the text in the edtFirstName box
  edtFirstName.Text := FirstName;

  // Set the validity status based on the FirstName
  if ValidFirstName then
    FirstNameValid := True
  else
    FirstNameValid := False;

  // Display a message if the FirstName is invalid
  if not ValidFirstName then
    ShowMessage('First name should contain only one word.');
end;

procedure TChangeDetails.LastNameValidity;
var
  LastName: string;
  ValidLastName: Boolean;
begin
  // Get the text from the edtLastName box
  LastName := Trim(edtLastName.Text);

  // Check if the LastName contains only one word
  ValidLastName := (Pos(' ', LastName) = 0) and (Length(LastName) > 0);

  // Capitalize the first letter and make the rest lowercase
  if Length(LastName) > 0 then
    LastName := UpperCase(LastName[1]) + LowerCase(Copy(LastName, 2, Length(LastName) - 1));

  // Update the text in the edtLastName box
  edtLastName.Text := LastName;

  // Set the validity status based on the LastName
  if ValidLastName then
    LastNameValid := True
  else
    LastNameValid := False;

  // Display a message if the LastName is invalid
  if not ValidLastName then
    ShowMessage('Last name should contain only one word.');
end;

procedure TChangeDetails.btnSubmitClick(Sender: TObject);
begin
  // Check if all fields are empty
  if (edtFirstName.Text = '') and
     (edtLastName.Text = '') and
     (edtEmail.Text = '') and
     (edtDOB.Text = '') and
     (edtPassword.Text = '') then
  begin
    ShowMessage('No changes made to details.');

    if (AccountType = 'Student') then
    begin
    StudentNavigation.Show;
    ChangeDetails.Hide;
    end;

    if (AccountType = 'Teacher') then
    begin
    TeacherNavigation.Show;
    ChangeDetails.Hide;
    end;
    Exit;

  end;

  // Check if any non-empty field requires validation
  if (edtFirstName.Text <> '') then
    FirstNameValidity;

  if (edtLastName.Text <> '') then
    LastNameValidity;

  if (edtEmail.Text <> '') then
    EmailValidityconditions;

  if (edtDOB.Text <> '') then
    DOBValidityconditions;

  if (edtPassword.Text <> '') then
    PasswordValidityconditions;

  // Check if all non-empty fields that require validation are valid
  if ((edtFirstName.Text = '') or FirstNameValid) and
     ((edtLastName.Text = '') or LastNameValid) and
     ((edtEmail.Text = '') or EmailGreenwoodValid) and
     ((edtDOB.Text = '') or DOBValid) and
     ((edtPassword.Text = '') or PasswordValid) then
  begin
    // Update the database with valid fields
    UpdateDatabaseIfValid;
    ShowMessage('Details updated successfully.');
    UpdateFullNameConditions;
    edtEmail.Clear;
    edtFirstName.Clear;
    edtLastName.Clear;
    edtDOB.Clear;
    edtPassword.Clear;
    if AccountType = 'Student' then
    StudentNavigation.Show;
    ChangeDetails.Hide;

    if AccountType = 'Teacher' then
    TeacherNavigation.Show;
    ChangeDetails.Hide;
  end
end;

function TChangeDetails.AllFieldsAreValid: Boolean;
begin
  Result := FirstNameValid and LastNameValid and EmailGreenwoodValid and DOBValid and PasswordValid;
end;

procedure TChangeDetails.UpdateDatabaseIfValid;
begin
  // Check validity for each non-empty field
  if edtEmail.Text <> '' then
    if EmailGreenwoodValid then
     UpdateEmailDatabase;

  if edtFirstName.Text <> '' then
    if FirstNameValid then
      UpdateFirstNameDatabase;

  if edtLastName.Text <> '' then
    if LastNameValid then
     UpdateLastNameDatabase;

  if edtDOB.Text <> '' then
    if DOBValid then
      UpdateDOBDatabase;

 if edtPassword.Text <> '' then
    if PasswordValid then
      UpdatePasswordDatabase;
end;

procedure TChangeDetails.UpdateEmailDatabase;
begin
  qryGetDOBEmail.SQL.Text := 'UPDATE Account SET Email = :NewEmail WHERE MainUserId = :UserId';
  qryGetDOBEmail.Parameters.ParamByName('NewEmail').Value := edtEmail.Text;
  qryGetDOBEmail.Parameters.ParamByName('UserId').Value := CurrentUserID;
  qryGetDOBEmail.ExecSQL;
end;

procedure TChangeDetails.UpdateFirstNameDatabase;
begin
  if AccountType = 'Student' then
  begin
  qryGetFirstandLastName.SQL.Text := 'UPDATE Student SET SName = :NewFirstName WHERE MainUserId = :UserId';
  qryGetFirstandLastName.Parameters.ParamByName('NewFirstName').Value := edtFirstName.Text;
  qryGetFirstandLastName.Parameters.ParamByName('UserId').Value := CurrentUserID;
  qryGetFirstandLastName.ExecSQL;
  end;

  if AccountType = 'Teacher' then
  begin
  qryGetFirstandLastName.SQL.Text := 'UPDATE Teacher SET TName = :NewFirstName WHERE MainUserId = :UserId';
  qryGetFirstandLastName.Parameters.ParamByName('NewFirstName').Value := edtFirstName.Text;
  qryGetFirstandLastName.Parameters.ParamByName('UserId').Value := CurrentUserID;
  qryGetFirstandLastName.ExecSQL;
  end;
end;

procedure TChangeDetails.UpdateLastNameDatabase;
begin
  if AccountType = 'Student' then
  begin
  qryGetFirstandLastName.SQL.Text := 'UPDATE Student SET SSurname = :NewLastName WHERE MainUserId = :UserId';
  qryGetFirstandLastName.Parameters.ParamByName('NewLastName').Value := edtLastName.Text;
  qryGetFirstandLastName.Parameters.ParamByName('UserId').Value := CurrentUserID;
  qryGetFirstandLastName.ExecSQL;
  end;

  if AccountType = 'Teacher' then
  begin
  qryGetFirstandLastName.SQL.Text := 'UPDATE Teacher SET TSurname = :NewLastName WHERE MainUserId = :UserId';
  qryGetFirstandLastName.Parameters.ParamByName('NewLastName').Value := edtLastName.Text;
  qryGetFirstandLastName.Parameters.ParamByName('UserId').Value := CurrentUserID;
  qryGetFirstandLastName.ExecSQL;
  end;
end;

procedure TChangeDetails.UpdateFullNameConditions;
var
  NewFullName: string;
begin

if (edtFirstName.Text <> '')  and (edtLastName.Text <> '') then
begin
  NewFullName := edtFirstName.Text + ' ' + edtLastName.Text;
  UpdateFullName(NewFullName);
end;

 if (edtFirstName.Text <> '') and  (edtLastName.Text = '')  then
 begin
  NewFullName := edtFirstName.Text + ' ' + LastName;
  UpdateFullName(NewFullName);
  end;

 if (edtFirstName.Text = '')  and (edtLastName.Text <> '') then
 begin
 NewFullName := FirstName + ' ' + edtLastName.Text;
 UpdateFullName(NewFullName)
 end;
end;

procedure TChangeDetails.UpdateFullName(FullName: string);
begin
  qryUpdateFullName.SQL.Text := 'UPDATE Account SET FullName = :NewFullName WHERE MainUserId = :UserId';
  qryUpdateFullName.Parameters.ParamByName('NewFullName').Value := FullName;
  qryUpdateFullName.Parameters.ParamByName('UserId').Value := CurrentUserID;
  qryUpdateFullName.ExecSQL;
end;

procedure TChangeDetails.UpdateDOBDatabase;
var
NewDOB:string;
begin
  NewDOB := edtDOB.Text;
  qryGetDOBEmail.SQL.Text := 'UPDATE Account SET DOB = :DOB WHERE MainUserId = :UserId';
  qryGetDOBEmail.Parameters.ParamByName('DOB').Value := NewDOB;
  qryGetDOBEmail.Parameters.ParamByName('UserId').Value := CurrentUserID;
  qryGetDOBEmail.ExecSQL;
end;

//Rolling Polynomial password hashing
function HashPassword(const Input: string): string;
var
  Sum: Cardinal;
  I: Integer;
begin
  // Initialize the sum with a prime number
  Sum := 5381;

  // Calculate hash using a polynomial rolling hash function
  for I := 1 to Length(Input) do
    Sum := (Sum shl 5) + Sum + Ord(Input[I]);

  // Convert the sum to a hexadecimal string
  Result := IntToHex(Sum, 8);
end;

procedure TChangeDetails.UpdatePasswordDatabase;
var
HashedPassword:string;
begin
  hashedPassword := HashPassword(edtPassword.Text);
  qryGetDOBEmail.SQL.Text := 'UPDATE Account SET  AccPassword = :NewPassword WHERE MainUserId = :UserId';
  qryGetDOBEmail.Parameters.ParamByName('NewPassword').Value := hashedPassword;
  qryGetDOBEmail.Parameters.ParamByName('UserId').Value := CurrentUserID;
  qryGetDOBEmail.ExecSQL;
end;
end.
