unit SignupPage;

interface

uses
  Windows, Messages, SysUtils, StrUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, jpeg, ExtCtrls, StdCtrls, DB, ADODB;

type
  TSignupForm = class(TForm)
    imgQuit: TImage;
    imgBg: TImage;
    imgbgfromLook: TImage;
    imgBackbtn: TImage;
    edtEmail: TEdit;
    lblEmail: TLabel;
    edtPassword: TEdit;
    lblPassword: TLabel;
    edtName: TEdit;
    edtDOB: TEdit;
    lblWrongDOB: TLabel;
    imgLoginbtn: TImage;
    lblName: TLabel;
    lblDOB: TLabel;
    lblSignUp: TLabel;
    lblDetailEntry: TLabel;
    qrySignup: TADOQuery;
    lblPassInfo: TLabel;
    lblPassCapitalLetter: TLabel;
    lblPassLenght: TLabel;
    lblPassNumber: TLabel;
    lblPassSpecialChar: TLabel;
    imgpassbg: TImage;
    lblSubmit: TLabel;
    imgTeacherbtn: TImage;
    imgStudentbtn: TImage;
    lblEnterTorS: TLabel;
    lblTeacherSelected: TLabel;
    lblStudentSelected: TLabel;
    lblTeacherBtn: TLabel;
    lblStudentBtn: TLabel;
    lblOr: TLabel;
    lblTeacherQ: TLabel;
    qryUserID: TADOQuery;
    conSignUp: TADOConnection;
    procedure FormCreate(Sender: TObject);
    procedure imgQuitClick(Sender: TObject);
    procedure imgBackbtnClick(Sender: TObject);
    procedure edtDOBKeyPress(Sender: TObject; var Key: Char);
    procedure DOBValidityconditions;
    procedure imgLoginbtnClick(Sender: TObject);
    procedure EmailValidityconditions;
    procedure FullNameValidityconditions;
    procedure PasswordValidityconditions;
    procedure CreateNewAcc;
    procedure imgTeacherbtnClick(Sender: TObject);
    procedure imgStudentbtnClick(Sender: TObject);
    procedure UpdateStudentTeacherTable(TeacherSelected: Boolean);
    procedure RetrieveUserID(EmailEntered: String);
  private
    { Private declarations }
    procedure AddFontResourceAndBroadcast;
  public
    { Public declarations }
  end;

var
  SignupForm: TSignupForm;
  ScaleFactor: Double;
  edtNameLeft, edtNameTop : Integer;
  edtDOBLeft, edtDOBTop : Integer;
  lblWrongDOBLeft, lblWrongDOBTop: Integer;
  lblNameLeft, lblNameTop: Integer;
  lblDOBLeft, lblDOBTop: Integer;
  lblDetailEntryLeft, lblDetailEntryTop: Integer;
  lblSignUpLeft, lblSignUpTop: Integer ;
  lblPassInfoLeft, lblPassInfoTop: Integer;
  lblPassCapitalLetterLeft, lblPassCapitalLetterTop: Integer;
  lblPassLenghtLeft, lblPassLenghtTop: Integer;
  lblPassNumberLeft, lblPassNumberTop: Integer;
  lblPassSpecialCharLeft, lblPassSpecialCharTop: Integer;
  PasswordInfoBgTop, PasswordInfoBgLeft: Integer;
  imgpassbgTop , imgpassbgLeft: Integer;
  imgTeacherBtnLeft, imgTeacherBtnTop: Integer;
  imgStudentbtnTop, imgStudentbtnLeft: Integer;
  TeacherSelected, StudentSelected: Boolean;
  lblEnterTorSLeft, lblEnterTorSTop: Integer;
  lblTeacherSelectedTop, lblTeacherSelectedLeft: Integer;
  lblStudentSelectedTop, lblStudentSelectedLeft: Integer;
  lblTeacherQTop, lblTeacherQLeft: Integer ;
  lblOrLeft, lblOrTop: Integer;
  SelectedTorS: Boolean;
  HashedPassword: string;
  DOBValid: Boolean;
  NameValid: Boolean;
  EmailGreenwoodValid: Boolean;
  PasswordValid: Boolean ;
  HasCapitalLetter: Boolean;
  HasNumber: Boolean;
  HasSpecialChar: Boolean;
  PasswordLenght: Boolean;
  MainUserID: Integer;
  EmailEntered: String;
  SignupSuccesfull: Boolean;
  AccountCreated: Boolean;

implementation

uses CustomDialog, LoginPage;

{$R *.dfm}

//Run this on creation of the page to display all elements correctly
procedure TSignupForm.FormCreate(Sender: TObject);
begin
  BorderStyle := bsNone;

  //Ensuring the form appears as full screen

  Left := Screen.Monitors[0].Left;
  Top := Screen.Monitors[0].Top;
  Width := Screen.Monitors[0].Width;
  Height := Screen.Monitors[0].Height;

  ScaleFactor := 0.9;

  AddFontResourceAndBroadcast;
  //imgbgfromLook: appearance on page

  imgbgfromLook.Constraints.MaxWidth := Round(ClientWidth * ScaleFactor);
  imgbgfromLook.Constraints.MaxHeight := Round(ClientHeight * ScaleFactor);
  imgbgfromLook.Constraints.MinWidth := Round(ClientWidth * ScaleFactor);
  imgbgfromLook.Constraints.MinHeight := Round(ClientHeight * ScaleFactor);
  imgbgfromLook.left := (ClientWidth - imgbgfromLook.Width) div 2;
  imgbgfromLook.Top := (ClientHeight - imgbgfromLook.Height) div 2;

  //imgQuit: appearance on page

  imgQuit.Top := 20;
  imgQuit.Constraints.MaxWidth := Round(ClientWidth * 0.07);
  imgQuit.Constraints.MaxHeight := Round(ClientWidth * 0.07);
  imgQuit.Left := ClientWidth - imgQuit.Width - 20;

  //imgBackbtn: appearance on page

  imgBackbtn.Top := 20;
  imgBackbtn.Constraints.MaxWidth := Round(ClientWidth * 0.06);
  imgBackbtn.Constraints.MaxHeight := Round(ClientWidth * 0.06);
  imgBackbtn.Left := Left + imgBackbtn.Width - 40;

  //lblEmail: appearance on page

  lblEmail.Font.Name := 'Arial Rounded MT Bold';
  lblEmail.Font.Size := Round(imgbgfromLook.Width * 0.014);
  lblEmail.Transparent := True;
  lblEmail.Font.Color := RGB(50, 50, 50);
  lblEmailTop := imgbgfromLook.Top + Round(imgbgfromLook.Height * 0.22);
  lblEmailLeft := imgbgfromLook.Left + Round(imgbgfromLook.Width * 0.578);
  lblEmail.Left :=  lblEmailLeft;
  lblEmail.Top := lblEmailTop ;

  //lblPassword: appearance on page

  lblPassword.Font.Name := 'Arial Rounded MT Bold';
  lblPassword.Font.Size := Round(imgbgfromLook.Width * 0.014);
  lblPassword.Transparent := True;
  lblPassword.Font.Color := RGB(50, 50, 50);
  lblPasswordTop := imgbgfromLook.Top + Round(imgbgfromLook.Height * 0.352);
  lblPasswordLeft := imgbgfromLook.Left + Round(imgbgfromLook.Width * 0.578);
  lblPassword.Left :=  lblPasswordLeft;
  lblPassword.Top := lblPasswordTop ;

  //lblName: appearance on page

  lblName.Font.Name := 'Arial Rounded MT Bold';
  lblName.Font.Size := Round(imgbgfromLook.Width * 0.014);
  lblName.Transparent := True;
  lblName.Font.Color := RGB(50, 50, 50);
  lblNameTop := imgbgfromLook.Top + Round(imgbgfromLook.Height * 0.48);
  lblNameLeft := imgbgfromLook.Left + Round(imgbgfromLook.Width * 0.578);
  lblName.Left :=  lblNameLeft;
  lblName.Top := lblNameTop;

   //lblDOB: appearance on page

  lblDOB.Font.Name := 'Arial Rounded MT Bold';
  lblDOB.Font.Size := Round(imgbgfromLook.Width * 0.014);
  lblDOB.Transparent := True;
  lblDOB.Font.Color := RGB(50, 50, 50);
  lblDOBTop := imgbgfromLook.Top + Round(imgbgfromLook.Height * 0.608);
  lblDOBLeft := imgbgfromLook.Left + Round(imgbgfromLook.Width * 0.578);
  lblDOB.Left :=  lblDOBLeft;
  lblDOB.Top := lblDOBTop;

  //lblOr: appearance on page

  lblOr.Font.Name := 'Arial Rounded MT Bold';
  lblOr.Font.Size := Round(imgbgfromLook.Width * 0.02);
  lblOr.Transparent := True;
  lblOr.Font.Color := RGB(232, 232, 232);
  lblOrTop := imgbgfromLook.Top + Round(imgbgfromLook.Height * 0.30559);
  lblOrLeft := imgbgfromLook.Left + Round(imgbgfromLook.Width * 0.265);
  lblOr.Left :=  lblOrLeft;
  lblOr.Top := lblOrTop;

  //lblTeacherQ: appearance on page
  lblTeacherQ.Font.Name := 'Arial Rounded MT Bold';
  lblTeacherQ.Font.Size := Round(imgbgfromLook.Width * 0.026);
  lblTeacherQ.Transparent := True;
  lblTeacherQ.Font.Color := RGB(232, 232, 232);
  lblTeacherQTop := imgbgfromLook.Top + Round(imgbgfromLook.Height * 0.1);
  lblTeacherQLeft := imgbgfromLook.Left + Round(imgbgfromLook.Width * 0.12);
  lblTeacherQ.Left :=  lblTeacherQLeft;
  lblTeacherQ.Top := lblTeacherQTop;


  //edt: appereance of edit Boxes for Email, Password, Full name and DOB aimed to blend them into the background

  edtEmail.Font.Name := 'Arial Rounded MT Bold';
  edtEmail.Width := Round(imgbgfromLook.Width * 0.315);
  edtEmailTop := imgbgfromLook.Top + Round(imgbgfromLook.Height * 0.285);
  edtEmailLeft := imgbgfromLook.Left + Round(imgbgfromLook.Width * 0.574);
  edtEmail.Left :=  edtEmailLeft;
  edtEmail.Top := edtEmailTop ;

  edtPassword.Font.Name := 'Arial Rounded MT Bold';
  edtPassword.Width := Round(imgbgfromLook.Width * 0.315);
  edtPasswordTop := imgbgfromLook.Top + Round(imgbgfromLook.Height * 0.415);
  edtPasswordLeft := imgbgfromLook.Left + Round(imgbgfromLook.Width * 0.574);
  edtPassword.Left :=  edtPasswordLeft;
  edtPassword.Top := edtPasswordTop ;

  edtName.Font.Name := 'Arial Rounded MT Bold';
  edtName.Width := Round(imgbgfromLook.Width * 0.315);
  edtNameTop := imgbgfromLook.Top + Round(imgbgfromLook.Height * 0.54);
  edtNameLeft := imgbgfromLook.Left + Round(imgbgfromLook.Width * 0.574);
  edtName.Left :=  edtNameLeft;
  edtName.Top := edtNameTop ;

  edtDOB.Font.Name := 'Arial Rounded MT Bold';
  edtDOB.Width := Round(imgbgfromLook.Width * 0.315);
  edtDOBTop := imgbgfromLook.Top + Round(imgbgfromLook.Height * 0.67);
  edtDOBLeft := imgbgfromLook.Left + Round(imgbgfromLook.Width * 0.574);
  edtDOB.Left :=  edtDOBLeft;
  edtDOB.Top := edtDOBTop ;

  //lblWrongDOB: appearance on page

  lblWrongDOB.Font.Name := 'Arial Rounded MT Bold';
  lblWrongDOB.Font.Size := Round(imgbgfromLook.Width * 0.008);
  lblWrongDOB.Transparent := True;
  lblWrongDOB.Font.Color := RGB(114, 114, 114);
  lblWrongDOBTop := imgbgfromLook.Top + Round(imgbgfromLook.Height * 0.735);
  lblWrongDOBLeft := imgbgfromLook.Left + Round(imgbgfromLook.Width * 0.575);
  lblWrongDOB.Left := lblWrongDOBLeft;
  lblWrongDOB.Top := lblWrongDOBTop;
  lblWrongDOB.Visible := False;

  //lblEnterTorS: appearance on page

  lblEnterTorS.Font.Name := 'Arial Rounded MT Bold';
  lblEnterTorS.Font.Size := Round(imgbgfromLook.Width * 0.008);
  lblEnterTorS.Transparent := True;
  lblEnterTorS.Font.Color := RGB(114, 114, 114);
  lblEnterTorSTop := imgbgfromLook.Top + Round(imgbgfromLook.Height * 0.48);
  lblEnterTorSLeft := imgbgfromLook.Left + Round(imgbgfromLook.Width * 0.2);
  lblEnterTorS.Left := lblEnterTorSLeft;
  lblEnterTorS.Top := lblEnterTorSTop;
  lblEnterTorS.Visible := False;

  //lblTeacherSelected: appearance on page

  lblTeacherSelected.Font.Name := 'Arial Rounded MT Bold';
  lblTeacherSelected.Font.Size := Round(imgbgfromLook.Width * 0.008);
  lblTeacherSelected.Transparent := True;
  lblTeacherSelected.Font.Color := RGB(114, 114, 114);
  lblTeacherSelectedTop := imgbgfromLook.Top + Round(imgbgfromLook.Height * 0.48);
  lblTeacherSelectedLeft := imgbgfromLook.Left + Round(imgbgfromLook.Width * 0.235);
  lblTeacherSelected.Left := lblTeacherSelectedLeft;
  lblTeacherSelected.Top := lblTeacherSelectedTop;
  lblTeacherSelected.Visible := False;

  //lblTeacherSelected: appearance on page

  lblStudentSelected.Font.Name := 'Arial Rounded MT Bold';
  lblStudentSelected.Font.Size := Round(imgbgfromLook.Width * 0.008);
  lblStudentSelected.Transparent := True;
  lblStudentSelected.Font.Color := RGB(114, 114, 114);
  lblStudentSelectedTop := imgbgfromLook.Top + Round(imgbgfromLook.Height * 0.48);
  lblStudentSelectedLeft := imgbgfromLook.Left + Round(imgbgfromLook.Width * 0.235);
  lblStudentSelected.Left := lblStudentSelectedLeft;
  lblStudentSelected.Top := lblStudentSelectedTop;
  lblStudentSelected.Visible := False;

  //imgLoginbtn: appearance on page

  imgLoginbtnTop := imgbgfromLook.Top + Round(imgbgfromLook.Height * 0.76);
  imgLoginbtnLeft := imgbgfromLook.Left + Round(imgbgfromLook.Width * 0.613);
  imgLoginbtn.Left := imgLoginbtnLeft;
  imgLoginbtn.Top := imgLoginbtnTop;
  imgLoginbtn.Constraints.MinWidth := Round(imgbgfromLook.Width * 0.23);
  imgLoginbtn.Constraints.MaxWidth := Round(imgbgfromLook.Width * 0.23);
  imgLoginbtn.Constraints.MinHeight := Round(imgbgfromLook.Height * 0.16);
  imgLoginbtn.Constraints.MaxHeight := Round(imgbgfromLook.Height * 0.16);

  //lblSignUp: appearance on page

  lblSignUp.Font.Name := 'Arial Rounded MT Bold';
  lblSignUp.Font.Size := Round(imgbgfromlook.Width * 0.028);
  lblSignUp.Transparent := True;
  lblSignUp.Font.Color := RGB(50, 50, 50);
  lblSignUpTop := imgbgfromlook.Top + Round(imgbgfromlook.Height * 0.075);
  lblSignUpLeft := imgbgfromlook.Left + Round(imgbgfromlook.Width * 0.665);
  lblSignUp.Left := lblSignUpLeft;
  lblSignUp.Top := lblSignUpTop;

  //lblDetailEntry: appearance on page

  lblDetailEntry.Font.Name := 'Arial Rounded MT Bold';
  lblDetailEntry.Font.Size := Round(imgbgfromlook.Width * 0.016);
  lblDetailEntry.Transparent := True;
  lblDetailEntry.Font.Color := RGB(50, 50, 50);
  lblDetailEntryTop := imgbgfromlook.Top + Round(imgbgfromlook.Height * 0.16);
  lblDetailEntryLeft := imgbgfromlook.Left + Round(imgbgfromlook.Width * 0.64);
  lblDetailEntry.Left := lblDetailEntryLeft;
  lblDetailEntry.Top := lblDetailEntryTop;

  //lblPassInfo: appearance on page

  lblPassInfo.Font.Name := 'Arial Rounded MT Bold';
  lblPassInfo.Font.Size := Round(imgbgfromLook.Width * 0.015);
  lblPassInfo.Transparent := True;
  lblPassInfo.Font.Color := RGB(50, 50, 50);
  lblPassInfoTop := imgbgfromLook.Top + Round(imgbgfromLook.Height * 0.57);
  lblPassInfoLeft := imgbgfromLook.Left + Round(imgbgfromLook.Width * 0.13);
  lblPassInfo.Left := lblPassInfoLeft;
  lblPassInfo.Top := lblPassInfoTop;

  //lblPassCapitalLetter: appearance on page

  lblPassCapitalLetter.Font.Name := 'Arial Rounded MT Bold';
  lblPassCapitalLetter.Font.Size := Round(imgbgfromLook.Width * 0.01);
  lblPassCapitalLetter.Transparent := True;
  lblPassCapitalLetter.Font.Color := RGB(114, 114, 114);
  lblPassCapitalLetterTop := imgbgfromLook.Top + Round(imgbgfromLook.Height * 0.62);
  lblPassCapitalLetterLeft := imgbgfromLook.Left + Round(imgbgfromLook.Width * 0.13);
  lblPassCapitalLetter.Left := lblPassCapitalLetterLeft;
  lblPassCapitalLetter.Top := lblPassCapitalLetterTop;

  //lblPassLenght: appearance on page

  lblPassLenght.Font.Name := 'Arial Rounded MT Bold';
  lblPassLenght.Font.Size := Round(imgbgfromLook.Width * 0.01);
  lblPassLenght.Transparent := True;
  lblPassLenght.Font.Color := RGB(114, 114, 114);
  lblPassLenghtTop := imgbgfromLook.Top + Round(imgbgfromLook.Height * 0.65);
  lblPassLenghtLeft := imgbgfromLook.Left + Round(imgbgfromLook.Width * 0.13);
  lblPassLenght.Left := lblPassLenghtLeft;
  lblPassLenght.Top := lblPassLenghtTop;

  //lblPassNumber: appearance on page

  lblPassNumber.Font.Name := 'Arial Rounded MT Bold';
  lblPassNumber.Font.Size := Round(imgbgfromLook.Width * 0.01);
  lblPassNumber.Transparent := True;
  lblPassNumber.Font.Color := RGB(114, 114, 114);
  lblPassNumberTop := imgbgfromLook.Top + Round(imgbgfromLook.Height * 0.68);
  lblPassNumberLeft := imgbgfromLook.Left + Round(imgbgfromLook.Width * 0.13);
  lblPassNumber.Left := lblPassNumberLeft;
  lblPassNumber.Top := lblPassNumberTop;

  //lblPassSpecialChar: appearance on page

  lblPassSpecialChar.Font.Name := 'Arial Rounded MT Bold';
  lblPassSpecialChar.Font.Size := Round(imgbgfromLook.Width * 0.01);
  lblPassSpecialChar.Transparent := True;
  lblPassSpecialChar.Font.Color := RGB(114, 114, 114);
  lblPassSpecialCharTop := imgbgfromLook.Top + Round(imgbgfromLook.Height * 0.71);
  lblPassSpecialCharLeft := imgbgfromLook.Left + Round(imgbgfromLook.Width * 0.13);
  lblPassSpecialChar.Left := lblPassSpecialCharLeft;
  lblPassSpecialChar.Top := lblPassSpecialCharTop;

  //imgPassBg: appearance on page

  imgpassbgTop := imgbgfromLook.Top + Round(imgbgfromLook.Height * 0.535);
  imgpassbgLeft := imgbgfromLook.Left + Round(imgbgfromLook.Width * 0.105);
  imgpassbg.Left := imgpassbgLeft;
  imgpassbg.Top := imgpassbgTop;
  imgpassbg.Constraints.MaxWidth := Round(ClientWidth * 0.31);
  imgpassbg.Constraints.MaxHeight := Round(ClientWidth * 0.16);
  imgpassbg.Constraints.MinWidth := Round(ClientWidth * 0.31);
  imgpassbg.Constraints.MinHeight := Round(ClientWidth * 0.16);

  //lblSubmit: appearance on page

  lblSubmit.Font.Name := 'Arial Rounded MT Bold';
  lblSubmit.Font.Size := Round(imgbgfromLook.Width * 0.023);;
  lblSubmit.Transparent := True;
  lblSubmit.Font.Color := RGB(232, 232, 232);
  lblSubmit.Left := imgLoginbtn.Left + (imgLoginbtn.Width - lblSubmit.Width) div 2;
  lblSubmit.Top := imgLoginbtn.Top + (imgLoginbtn.Height - lblSubmit.Height) div 2;

  //imgTeacherBtn: appearance on page

  imgTeacherBtnTop := imgbgfromLook.Top + Round(imgbgfromLook.Height * 0.18);
  imgTeacherBtnLeft := imgbgfromLook.Left + Round(imgbgfromLook.Width * 0.2);
  imgTeacherBtn.Left := imgTeacherBtnLeft;
  imgTeacherBtn.Top := imgTeacherBtnTop;
  imgTeacherBtn.Constraints.MaxWidth := Round(ClientWidth * 0.15);
  imgTeacherBtn.Constraints.MaxHeight := Round(ClientWidth * 0.07);
  imgTeacherBtn.Constraints.MinWidth := Round(ClientWidth * 0.15);
  imgTeacherBtn.Constraints.MinHeight := Round(ClientWidth * 0.07);

  //lblTeacherBtn: appearance on page

  lblTeacherBtn.Font.Name := 'Arial Rounded MT Bold';
  lblTeacherBtn.Font.Size := Round(imgbgfromLook.Width * 0.02);;
  lblTeacherBtn.Transparent := True;
  lblTeacherBtn.Font.Color := RGB(155, 178, 127);
  lblTeacherBtn.Left := imgTeacherbtn.Left + (imgTeacherbtn.Width - lblTeacherBtn.Width) div 2;
  lblTeacherBtn.Top := imgTeacherbtn.Top + (imgTeacherbtn.Height - lblTeacherBtn.Height) div 2;

  //imgStudentBtn: appearance on page

  imgStudentbtnTop := imgbgfromLook.Top + Round(imgbgfromLook.Height * 0.36);
  imgStudentbtnLeft := imgbgfromLook.Left + Round(imgbgfromLook.Width * 0.2);
  imgStudentbtn.Left := imgStudentbtnLeft;
  imgStudentbtn.Top := imgStudentbtnTop;
  imgStudentbtn.Constraints.MaxWidth := Round(ClientWidth * 0.15);
  imgStudentbtn.Constraints.MaxHeight := Round(ClientWidth * 0.07);
  imgStudentbtn.Constraints.MinWidth := Round(ClientWidth * 0.15);
  imgStudentbtn.Constraints.MinHeight := Round(ClientWidth * 0.07);

  //lblStudentBtn: appearance on page

  lblStudentBtn.Font.Name := 'Arial Rounded MT Bold';
  lblStudentBtn.Font.Size := Round(imgbgfromLook.Width * 0.02);;
  lblStudentBtn.Transparent := True;
  lblStudentBtn.Font.Color := RGB(155, 178, 127);
  lblStudentBtn.Left := imgStudentBtn.Left + (imgStudentbtn.Width - lblStudentBtn.Width) div 2;
  lblStudentBtn.Top := imgStudentBtn.Top + (imgStudentbtn.Height - lblStudentBtn.Height) div 2;

  //Ensuring the CustomDialog form can only be opened once until it's closed to prevent errors.
  CustomDialogOpened:= False;

end;

//run upon pressing back button returning user to login page
procedure TSignupForm.imgBackbtnClick(Sender: TObject);
begin
SignupForm.Hide;
LoginForm.Show;
LoginForm.BringToFront;
end;


///run upon pressing exit button bringing up the exit form
procedure TSignupForm.imgQuitClick(Sender: TObject);
begin
if CustomDialogOpened = False then
  begin

    begin

    CustomDialogOpened := True;
    CustomDialogForm := TCustomDialogForm.Create(nil);
    SetWindowPos(CustomDialogForm.Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE);
    CustomDialogForm.Show;
  end;
  end
else
end;


//Adds custom font
procedure TSignupForm.AddFontResourceAndBroadcast;
begin
  if AddFontResource('Revision System Project\FONTS\arial-rounded-mt-bold.ttf"') > 0 then
    SendMessage(HWND_BROADCAST, WM_FONTCHANGE, 0, 0);
end;

//enforces the correct format when entering DOB
procedure TSignupForm.edtDOBKeyPress(Sender: TObject; var Key: Char);

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
procedure TSignupForm.DOBValidityconditions;

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
procedure TSignupForm.EmailValidityconditions;
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
       qrySignup.SQL.Text := 'SELECT Email FROM Account WHERE Email = :Email';
       qrySignup.Parameters.ParamByName('Email').Value := edtEmail.Text;
    qrySignup.Open;

    // Check if the query returned any records (if the email already exists in database)
    if not qrySignup.IsEmpty then
    begin
      // Email already exists in the database
      ShowMessage('This email is already registered. Please use a different email.');
      EmailGreenwoodValid := False;
      // Set focus back to the email field for correction
      edtEmail.SetFocus;
    end;
    end;
end;

//Runs check to ensure full name is correctly formated, automatically enforces certain formatting rules.
procedure TSignupForm.FullNameValidityconditions;
var
  Name: string;
  SpacePos: Integer;
  I: Integer;
  SpaceCount: Integer;
  NameValidEmpty: Boolean;
  NameValidSpace: Boolean;
  NameValidWords: Boolean;
begin
  // Get the text from the edtName field
   Name := Trim(edtName.Text);

  // Check if the name field is empty
  if Name = '' then
  begin
    ShowMessage('Please enter your full name.');
    edtName.SetFocus;
    NameValidEmpty:=False ;
  end
  else
    begin
      NameValidEmpty:=True;
    end;


  // Check if the name contains at least two words

  if NameValidEmpty then
  begin
  SpacePos := Pos(' ', Name);
  if SpacePos = 0 then
  begin
    ShowMessage('Please enter your full name (both first and last names).');
    edtName.SetFocus;
    NameValidWords:= False;
  end
  else
    begin
      NameValidWords:= True;
    end;
  end;


  // Ensure there are two separate words with ONLY one space between them

  if NameValidWords then
  begin
  SpaceCount := 0;
  for I := 1 to Length(Name) do
  begin
    if Name[I] = ' ' then
    begin
      Inc(SpaceCount);
      // Check if there are more than one consecutive space
      if (I > 1) and (Name[I - 1] = ' ') then
      begin
        ShowMessage('Please enter your full name with only one space between the words.');
        NameValidSpace:= False;
      end
      else
        begin
          NameValidSpace:= True;
        end;
    end;
  end;
   // Capitalize the first letter of each word
  for I := 1 to Length(Name) do
    begin
    if (I = 1) or (Name[I - 1] = ' ') then
      Name[I] := UpCase(Name[I])
    else
     // Forces the remaining characters to be in lowercase
      Name[I] := LowerCase(Name[I])[1];
  end;
  end;

  edtName.Text := Name;

  if NameValidSpace and NameValidWords and NameValidEmpty then
    begin
    NameValid := True;
    end
  else
    begin
      NameValid:=False;
    end;
end;


//Checks if all validity conditions are met required to make a strong password
procedure TSignupForm.PasswordValidityconditions;
var
  Password: string;
  I: Integer;

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

end;

 //Creation of new account

procedure TSignupForm.CreateNewAcc;
begin
    //Selects all necessary fields from the Accounts table to add a new account to the database
    conSignUp.Open;
    conSignUp.BeginTrans;
  qrySignup.SQL.Text :=
    'INSERT INTO Account (Email, DOB, FullName, AccPassword) ' +
    'VALUES (:email, :dob, :fullname, :accpassword)';
  qrySignup.Parameters.ParamByName('email').Value := edtEmail.Text;
  qrySignup.Parameters.ParamByName('dob').Value := edtDOB.Text;
  qrySignup.Parameters.ParamByName('fullname').Value := edtName.Text;
  qrySignup.Parameters.ParamByName('accpassword').Value := HashedPassword;
  qrySignup.ExecSQL;

       //teacher account is set as true if user selected they are a teacher
     if TeacherSelected = True then
     begin
       qrySignup.SQL.Text :=
       'UPDATE Account ' +
       'SET TeacherAccount = TRUE ' +
       'WHERE Email = :email';
      qrySignup.Parameters.ParamByName('email').Value := edtEmail.Text;
      qrySignup.ExecSQL;
      end;
  conSignUp.CommitTrans;
  conSignUp.Close;
  qrySignup.Close;
  AccountCreated := True;
end;

procedure TSignupForm.RetrieveUserID(EmailEntered: String);
begin
  // Set up the query to retrieve the UserID
  qrySignup.SQL.Text := 'SELECT MainUserID FROM Account WHERE Email = :Email';
  qrySignup.Parameters.ParamByName('Email').Value := EmailEntered;
  qrySignup.Open;
  qrySignup.Refresh;
  try
    try
      // Check if the query returned any results
      if not qrySignup.IsEmpty then
      begin
        // Retrieve the MainUserID and assign it to the MainUserID variable
        MainUserID := qrySignup.FieldByName('MainUserID').AsInteger;
      end
      else
      begin
        // If no results found, raise exception
        raise Exception.Create('UserID not found for email: ' + EmailEntered);
      end;
    finally
      // Close the query
      qrySignup.Close;
    end;
  except
    on E: Exception do
    begin
      // Handle the exception (e.g., log the error, show a message)
      ShowMessage('Error retrieving UserID: ' + E.Message);
    end;
  end;
end;


procedure TSignupForm.UpdateStudentTeacherTable(TeacherSelected: Boolean);
var
  FirstName, LastName: string;
  SpacePos: Integer;
begin
  // Extract the first and last name from the edtName field
  SpacePos := Pos(' ', edtName.Text);
  if SpacePos > 0 then
  begin
    FirstName := Trim(Copy(edtName.Text, 1, SpacePos - 1));
    LastName := Trim(Copy(edtName.Text, SpacePos + 1, Length(edtName.Text) - SpacePos));
  end;

  // Determine which table to insert into based on the IsTeacher parameter
  if TeacherSelected  = True then
  begin
    qrySignup.SQL.Text :=
      'INSERT INTO Teacher (TName, TSurname, MainUserID) ' +
      'VALUES (:fname, :lname, :mainuserid)';
  end
  else
  begin
    qrySignup.SQL.Text :=
      'INSERT INTO Student (SName, SSurname, MainUserID) ' +
      'VALUES (:fname, :lname, :mainuserid)';
  end;

  // Assign parameter values and execute the query
  qrySignup.Parameters.ParamByName('fname').Value := FirstName;
  qrySignup.Parameters.ParamByName('lname').Value := LastName;
  qrySignup.Parameters.ParamByName('mainuserid').Value := MainUserID;
  qrySignup.ExecSQL;
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


 //Submiting data for signing up

procedure TSignupForm.imgLoginbtnClick(Sender: TObject);

begin

  //Check if email entered is valid
    EmailValidityconditions;

  //If previous check passed:
    if EmailGreenwoodValid = True then
    begin
      //check if full name entered is valid
       FullNameValidityconditions;
    end;

  //check if DOB entered is valid
  DOBValidityconditions;

  //Displays label to help user if DOB is entered incorrectly
  if DOBValid = False then
    begin
    lblWrongDOB.Visible := True;
    end
  else
    begin
    lblWrongDOB.Visible := False;
    end;


    //checks password valid is entered
    PasswordValidityconditions;

    //Changes colour of password requirements depending on which ones are met and not met.
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

      //User selection of account type

      if SelectedTorS = False then
        begin
          //Displays label asking user to select an account type
          lblEnterTorS.Visible := True ;
        end
        else
        begin
          //Displays labels which tell user if they selected a student or teacher account
          lblEnterTorS.Visible := False ;
           if TeacherSelected = True then
            begin
              lblTeacherSelected.Visible := True;
              lblStudentSelected.Visible := False;
            end
            else
              begin
                lblStudentSelected.Visible := True;
                lblTeacherSelected.Visible := False;
              end;
        end;

        //If all validity conditions are met:

      if (DOBValid = True) and (PasswordValid=True) and (EmailGreenwoodValid=True) and (NameValid = True) and (SelectedTorS=True) then
      begin
        //Hash password
        hashedPassword := HashPassword(edtPassword.Text);
        //Store all entered details in database
        EmailEntered := edtEmail.Text;
        CreateNewAcc;
        if AccountCreated = true then
         begin
          RetrieveUserID(EmailEntered);
          UpdateStudentTeacherTable(TeacherSelected);
          //Clear all fields
          edtName.Text := '';
          edtPassword.Text := '';
          edtEmail.Text := '';
          edtDOB.Text := '';
          LoginForm.Show;
          SignupForm.Hide;


         end

      end;

  end;


//Select Teacher account
procedure TSignupForm.imgTeacherbtnClick(Sender: TObject);
begin
  SelectedTorS:= True;
  TeacherSelected := True;
  StudentSelected := False;
  //Change image of buttons to darker and lighter depending on which one is selected
  imgTeacherBtn.Picture.LoadFromFile('D:\School stuff\Revision System Project\IMG\SignUpPage\SelectedButton.jpg');
  imgStudentBtn.Picture.LoadFromFile('D:\School stuff\Revision System Project\IMG\SignUpPage\unselectedbtn.jpg');
end;


//Select student account
procedure TSignupForm.imgStudentbtnClick(Sender: TObject);
begin
  SelectedTorS:= True;
  TeacherSelected := False;
  StudentSelected := True;
  //Change image of buttons to darker and lighter depending on which one is selected
  imgTeacherBtn.Picture.LoadFromFile('D:\School stuff\Revision System Project\IMG\SignUpPage\unselectedbtn.jpg');
  imgStudentBtn.Picture.LoadFromFile('D:\School stuff\Revision System Project\IMG\SignUpPage\SelectedButton.jpg');

end;

end.
