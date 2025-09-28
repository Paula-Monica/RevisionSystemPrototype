unit LoginPage;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, jpeg, ExtCtrls, StdCtrls, Buttons, DB, ADODB;

type
  TLoginForm = class(TForm)
    lblLogin: TLabel;
    lblWelcome: TLabel;
    lblEmail: TLabel;
    lblPassword: TLabel;
    lblForgot: TLabel;
    edtEmail: TEdit;
    edtPassword: TEdit;
    imgQuit: TImage;
    imgBg: TImage;
    imgLoginbtn: TImage;
    lblLoginbtn: TLabel;
    imgSignup: TImage;
    lblAccountQ: TLabel;
    lblSignup: TLabel;
    lblInfo: TLabel;
    imgfrombglook: TImage;
    qryLogin: TADOQuery;
    lblWrongEmail: TLabel;
    lblWrongPassword: TLabel;
    imgClickLogin: TImage;
    imgClickSignup: TImage;
    procedure FormCreate(Sender: TObject);
    procedure imgQuitClick(Sender: TObject);
    procedure imgClickLoginClick(Sender: TObject);
    procedure imgClickSignupClick(Sender: TObject);
    procedure CheckDatabaseInfoCompletion;
    procedure lblForgotClick(Sender: TObject);
    procedure CheckIfTeacher;

  private
    { Private declarations }
    procedure AddFontResourceAndBroadcast;
  public
    { Public declarations }
  end;

var
  LoginForm: TLoginForm;
  ScaleFactor: Double;
  lblLoginTop, lblLoginLeft: Integer;
  lblWelcomeTop, lblWelcomeLeft: Integer;
  lblEmailTop, lblEmailLeft: Integer;
  edtPasswordTop, edtPasswordLeft: Integer;
  edtEmailTop, edtEmailLeft : Integer;
  lblPasswordTop, lblPasswordLeft : Integer;
  lblForgotTop, lblForgotLeft: Integer;
  imgLoginbtnTop, imgLoginbtnLeft: Integer;
  lblLoginbtnTop, lblLoginbtnLeft: Integer;
  imgSignupTop, imgSignupLeft: Integer;
  lblAccountQTop, lblAccountQLeft: Integer;
  lblInfoTop, lblInfoLeft: Integer;
  lblWrongEmailTop, lblWrongEmailLeft: Integer;
  lblWrongPasswordTop, lblWrongPasswordLeft: Integer;
  imgClickLoginTop, imgClickLoginLeft: Integer;
  imgClickSignupTop, imgClickSignupLeft : Integer;
  CaretPos: Integer;
  ActualPassword: string;
  LoggedIn: Boolean;
  InfoComplete: Boolean;
  TeacherAccount: Boolean;
  CurrentUserID: Integer;
  ForgotOpened: Boolean;
implementation

uses CustomDialog, SignupPage, UserFillInDetails, UserFillInDetailsTeacher,
  ForgotPassword, NavigationPageTeacher, NavigationPageStudent, QuizResult,
  EditDetails, StudentPerformance;

{$R *.dfm}


//Executed the moment the form is open to create the desired appearance of the page

procedure TLoginForm.FormCreate(Sender: TObject);

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

  //imgfrombglook: appearance on page

  imgfrombglook.Constraints.MaxWidth := Round(ClientWidth * ScaleFactor);
  imgfrombglook.Constraints.MaxHeight := Round(ClientHeight * ScaleFactor);
  imgfrombglook.Constraints.MinWidth := Round(ClientWidth * ScaleFactor);
  imgfrombglook.Constraints.MinHeight := Round(ClientHeight * ScaleFactor);
  imgfrombglook.left := (ClientWidth - imgfrombglook.Width) div 2;
  imgfrombglook.Top := (ClientHeight - imgfrombglook.Height) div 2;


  //imgQuit: appearance on page

  imgQuit.Top := 20;
  imgQuit.Constraints.MaxWidth := Round(ClientWidth * 0.07);
  imgQuit.Constraints.MaxHeight := Round(ClientWidth * 0.07);
  imgQuit.Left := ClientWidth - imgQuit.Width - 20;

  //lblLogin: appearance on page

  lblLogin.Font.Name := 'Arial Rounded MT Bold';
  lblLogin.Font.Size := Round(imgfrombglook.Width * 0.03);
  lblLogin.Transparent := True;
  lblLogin.Font.Color := RGB(50, 50, 50);
  lblLoginTop := imgfrombglook.Top + Round(imgfrombglook.Height * 0.13);
  lblLoginLeft := imgfrombglook.Left + Round(imgfrombglook.Width * 0.678);
  lblLogin.Left := lblLoginLeft;
  lblLogin.Top := lblLoginTop;


  //lblWelcome: appearance on page

  lblWelcome.Font.Name := 'Arial Rounded MT Bold';
  lblWelcome.Font.Size := Round(imgfrombglook.Width * 0.018);
  lblWelcome.Transparent := True;
  lblWelcome.Font.Color := RGB(50, 50, 50);
  lblWelcomeTop := imgfrombglook.Top + Round(imgfrombglook.Height * 0.22);
  lblWelcomeLeft := imgfrombglook.Left + Round(imgfrombglook.Width * 0.645);
  lblWelcome.Left := lblWelcomeLeft;
  lblWelcome.Top := lblWelcomeTop;

  //lblEmail: appearance on page

  lblEmail.Font.Name := 'Arial Rounded MT Bold';
  lblEmail.Font.Size := Round(imgfrombglook.Width * 0.014);
  lblEmail.Transparent := True;
  lblEmail.Font.Color := RGB(50, 50, 50);
  lblEmailTop := imgfrombglook.Top + Round(imgfrombglook.Height * 0.3);
  lblEmailLeft := imgfrombglook.Left + Round(imgfrombglook.Width * 0.57);
  lblEmail.Left :=  lblEmailLeft;
  lblEmail.Top := lblEmailTop ;

  //lblPassword: appearance on page

  lblPassword.Font.Name := 'Arial Rounded MT Bold';
  lblPassword.Font.Size := Round(imgfrombglook.Width * 0.014);
  lblPassword.Transparent := True;
  lblPassword.Font.Color := RGB(50, 50, 50);
  lblPasswordTop := imgfrombglook.Top + Round(imgfrombglook.Height * 0.518);
  lblPasswordLeft := imgfrombglook.Left + Round(imgfrombglook.Width * 0.575);
  lblPassword.Left :=  lblPasswordLeft;
  lblPassword.Top := lblPasswordTop;

  //lblForgot: appearance on page

  lblForgot.Font.Name := 'Arial Rounded MT Bold';
  lblForgot.Font.Size := Round(imgfrombglook.Width * 0.01);
  lblForgot.Font.Style := lblLogin.Font.Style + [fsUnderline];
  lblForgot.Transparent := True;
  lblForgot.Font.Color := RGB(50, 50, 50);
  lblForgotTop := imgfrombglook.Top + Round(imgfrombglook.Height * 0.69);
  lblForgotLeft := imgfrombglook.Left + Round(imgfrombglook.Width * 0.575);
  lblForgot.Left :=  lblForgotLeft;
  lblForgot.Top := lblForgotTop;

  //edt: appereance of edit Boxes for Email and password aimed to blend them into the background

  edtEmail.Font.Name := 'Arial Rounded MT Bold';
  edtEmail.Width := Round(imgfrombglook.Width * 0.315);
  edtEmailTop := imgfrombglook.Top + Round(imgfrombglook.Height * 0.37);
  edtEmailLeft := imgfrombglook.Left + Round(imgfrombglook.Width * 0.574);
  edtEmail.Left :=  edtEmailLeft;
  edtEmail.Top := edtEmailTop ;

  edtPassword.Font.Name := 'Arial Rounded MT Bold';
  edtPassword.Width := Round(imgfrombglook.Width * 0.315);
  edtPasswordTop := imgfrombglook.Top + Round(imgfrombglook.Height * 0.59);
  edtPasswordLeft := imgfrombglook.Left + Round(imgfrombglook.Width * 0.58);
  edtPassword.Left :=  edtPasswordLeft;
  edtPassword.Top := edtPasswordTop ;

  //imgLoginbtn: appearance on page

  imgLoginbtnTop := imgfrombglook.Top + Round(imgfrombglook.Height * 0.72);
  imgLoginbtnLeft := imgfrombglook.Left + Round(imgfrombglook.Width * 0.613);
  imgLoginbtn.Left := imgLoginbtnLeft;
  imgLoginbtn.Top := imgLoginbtnTop;
  imgLoginbtn.Constraints.MinWidth := Round(imgfrombglook.Width * 0.25);
  imgLoginbtn.Constraints.MaxWidth := Round(imgfrombglook.Width * 0.25);
  imgLoginbtn.Constraints.MinHeight := Round(imgfrombglook.Height * 0.16);
  imgLoginbtn.Constraints.MaxHeight := Round(imgfrombglook.Height * 0.16);


  //lblLoginbtn: appearance on page

  lblLoginbtn.Font.Name := 'Arial Rounded MT Bold';
  lblLoginbtn.Font.Size := Round(imgfrombglook.Width * 0.023);;
  lblLoginbtn.Transparent := True;
  lblLoginbtn.Font.Color := RGB(232, 232, 232);
  lblLoginbtn.Left := imgLoginbtn.Left + (imgLoginbtn.Width - lblLoginbtn.Width) div 2;
  lblLoginbtn.Top := imgLoginbtn.Top + (imgLoginbtn.Height - lblLoginbtn.Height) div 2;

  //lblAccountQ: appearance on page

  lblAccountQ.Font.Name := 'Arial Rounded MT Bold';
  lblAccountQ.Font.Size := Round(imgfrombglook.Width * 0.03);
  lblAccountQ.Transparent := True;
  lblAccountQ.Font.Color := RGB(232, 232, 232);
  lblAccountQTop := imgfrombglook.Top + Round(imgfrombglook.Height * 0.13);
  lblAccountQLeft := imgfrombglook.Left + Round(imgfrombglook.Width * 0.145);
  lblAccountQ.Left := lblAccountQLeft;
  lblAccountQ.Top := lblAccountQTop;

  //imgSignup: appearance on page

  imgSignupTop := imgfrombglook.Top + Round(imgfrombglook.Height * 0.305);
  imgSignupLeft := imgfrombglook.Left + Round(imgfrombglook.Width * 0.148);
  imgSignup.Left := imgSignupLeft;
  imgSignup.Top := imgSignupTop;
  imgSignup.Constraints.MinWidth := Round(imgfrombglook.Width * 0.25);
  imgSignup.Constraints.MaxWidth := Round(imgfrombglook.Width * 0.25);
  imgSignup.Constraints.MinHeight := Round(imgfrombglook.Height * 0.16);
  imgSignup.Constraints.MaxHeight := Round(imgfrombglook.Height * 0.16);

  //lblSignup: appearance on page

  lblSignup.Font.Name := 'Arial Rounded MT Bold';
  lblSignup.Font.Size :=  Round(imgfrombglook.Width * 0.023);
  lblSignup.Transparent := True;
  lblSignup.Font.Color := RGB(155, 178, 127);
  lblSignup.Left := imgSignup.Left + (imgSignup.Width - lblSignup.Width) div 2;
  lblSignup.Top := imgSignup.Top + (imgSignup.Height - lblSignup.Height) div 2;

  //lblInfo: appearance on page

  lblInfo.Font.Name := 'Arial Rounded MT Bold';
  lblInfo.Font.Size :=  Round(imgfrombglook.Width * 0.018);
  lblInfo.Transparent := True;
  lblInfo.Font.Color := RGB(232, 232, 232);
  lblInfoTop := imgfrombglook.Top + Round(imgfrombglook.Height * 0.5);
  lblInfoLeft := imgfrombglook.Left + Round(imgfrombglook.Width * 0.1);
  lblInfo.Left := lblInfoLeft;
  lblInfo.Top := lblInfoTop;

  //lblWrongEmail: appearance on page

  lblWrongEmail.Font.Name := 'Arial Rounded MT Bold';
  lblWrongEmail.Font.Size := Round(imgfrombglook.Width * 0.009);
  lblWrongEmail.Transparent := True;
  lblWrongEmail.Font.Color := RGB(114, 114, 114);
  lblWrongEmailTop := imgfrombglook.Top + Round(imgfrombglook.Height * 0.45);
  lblWrongEmailLeft := imgfrombglook.Left + Round(imgfrombglook.Width * 0.574);
  lblWrongEmail.Left := lblWrongEmailLeft;
  lblWrongEmail.Top := lblWrongEmailTop;
  lblWrongEmail.Visible := False;

  //lblWrongPassword: appearance on page

  lblWrongPassword.Font.Name := 'Arial Rounded MT Bold';
  lblWrongPassword.Font.Size := Round(imgfrombglook.Width * 0.009);
  lblWrongPassword.Transparent := True;
  lblWrongPassword.Font.Color := RGB(114, 114, 114);
  lblWrongPasswordTop := imgfrombglook.Top + Round(imgfrombglook.Height * 0.665);
  lblWrongPasswordLeft := imgfrombglook.Left + Round(imgfrombglook.Width * 0.574);
  lblWrongPassword.Left := lblWrongPasswordLeft;
  lblWrongPassword.Top := lblWrongPasswordTop;
  lblWrongPassword.Visible := False;

  //imgClickLogin: appearance on page

  imgClickLoginTop := imgfrombglook.Top + Round(imgfrombglook.Height * 0.72);
  imgClickLoginLeft := imgfrombglook.Left + Round(imgfrombglook.Width * 0.613);
  imgClickLogin.Left := imgClickLoginLeft;
  imgClickLogin.Top := imgClickLoginTop;
  imgClickLogin.Constraints.MinWidth := Round(imgfrombglook.Width * 0.25);
  imgClickLogin.Constraints.MaxWidth := Round(imgfrombglook.Width * 0.25);
  imgClickLogin.Constraints.MinHeight := Round(imgfrombglook.Height * 0.16);
  imgClickLogin.Constraints.MaxHeight := Round(imgfrombglook.Height * 0.16);

  //imgClickSignup: appearance on page

  imgClickSignupTop := imgfrombglook.Top + Round(imgfrombglook.Height * 0.305);
  imgClickSignupLeft := imgfrombglook.Left + Round(imgfrombglook.Width * 0.148);
  imgClickSignup.Left := imgClickSignupLeft;
  imgClickSignup.Top := imgClickSignupTop;
  imgClickSignup.Constraints.MinWidth := Round(imgfrombglook.Width * 0.25);
  imgClickSignup.Constraints.MaxWidth := Round(imgfrombglook.Width * 0.25);
  imgClickSignup.Constraints.MinHeight := Round(imgfrombglook.Height * 0.16);
  imgClickSignup.Constraints.MaxHeight := Round(imgfrombglook.Height * 0.16);


  //Concealing the Password for security
  edtPassword.PasswordChar := '•';

  //Ensuring the CustomDialog form can only be opened once until it's closed to prevent errors.
  CustomDialogOpened:= False;

   ForgotOpened := False;



end;



//Adds custom font to Delphi program
procedure TLoginForm.AddFontResourceAndBroadcast;
begin
  if AddFontResource('Revision System Project\FONTS\arial-rounded-mt-bold.ttf"') > 0 then
    SendMessage(HWND_BROADCAST, WM_FONTCHANGE, 0, 0);
end;

//Checks if account has completed the full sign-up process which involves filling in extra details (i.e subjects they study)
procedure TLoginForm.CheckDatabaseInfoCompletion;
begin

  //sets Info Checking Variable to False
  InfoComplete := False;

  //Creates query
  qryLogin.SQL.Text :=

  //Selects boolean box called DataEnreyDone from the Accounts table in the row email is = to an email
  'SELECT DataEntryDone FROM Account WHERE Email = :email';
  qryLogin.Parameters.ParamByName('email').Value := edtEmail.Text;
  qryLogin.Open;

  //Assigns InfoComplte to whatever the DataEntryDone field is (e.g if tick = true)
  InfoComplete := qryLogin.FieldByName('DataEntryDone').AsBoolean;
end;

//Checks if account is a teacher account
procedure TLoginForm.CheckIfTeacher;
begin

  //sets Info Checking Variable to False
  TeacherAccount := False;

  //Creates query
  qryLogin.SQL.Text :=

  //Selects boolean box called DataEnreyDone from the Accounts table in the row email is = to an email
  'SELECT TeacherAccount FROM Account WHERE Email = :email';
  qryLogin.Parameters.ParamByName('email').Value := edtEmail.Text;
  qryLogin.Open;

  //Assigns InfoComplte to whatever the DataEntryDone field is (e.g if tick = true)
  TeacherAccount := qryLogin.FieldByName('TeacherAccount').AsBoolean;
end;




//Procedure for exiting the program upon pressing the exit button

procedure TLoginForm.imgQuitClick(Sender: TObject);
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

//Hashes the entered password using rolling polynomial hash.

function HashPassword(const Input: string): string;
var
  Sum: Cardinal;
  I: Integer;
begin
  // Initialize the sum with a prime number
  Sum := 5381;

  // Calculate the hash using a polynomial rolling hash function
  for I := 1 to Length(Input) do
    Sum := (Sum shl 5) + Sum + Ord(Input[I]);

  // Convert the sum to a hexadecimal string
  Result := IntToHex(Sum, 8);
end;


//Procedure for logging in
procedure TLoginForm.imgClickLoginClick(Sender: TObject);
begin
  // Hash the password entered by the user to compare it with the one saved in the database
  hashedPassword := HashPassword(edtPassword.Text);

  // Retrieves email from the Email entry field and compares it to any in the database
  qryLogin.Close;
  qryLogin.SQL.Clear;
  qryLogin.SQL.Add('SELECT * FROM Account WHERE Email = :Email');
  qryLogin.Parameters.ParamByName('Email').Value := edtEmail.Text;
  qryLogin.Open;

  // Notifies the user if both fields must be filled in if left empty.
  if (edtEmail.Text = '') or (edtPassword.Text = '') then
  begin
    ShowMessage('Please enter both email and password.');
    Exit; // Exit the procedure to prevent further execution
  end;

  // Checks if the email appears in the database; if not, notifies the user that the email entered is incorrect
  if qryLogin.RecordCount = 0 then
  begin
    lblWrongPassword.Visible := False;
    lblWrongEmail.Visible := True;
  end
  else
  begin
    // Checks if the password entered is correct (same hash value as in the database)
    if qryLogin.FieldByName('AccPassword').AsString <> hashedPassword then
    begin
      lblWrongEmail.Visible := False;
      lblWrongPassword.Visible := True;
    end
    else
    begin
      // Reset error labels
      lblWrongEmail.Visible := False;
      lblWrongPassword.Visible := False;

      // Set the LoggedIn flag to indicate successful login
      LoggedIn := True;

      // Check if account information is complete
      CheckDatabaseInfoCompletion;
      CheckIfTeacher;

      //executed upon successful login attempt
      if (LoggedIn=True) then
        begin
          qryLogin.SQL.Text :=

        //Selects MainUserID from the Accounts table in the row email is = to an email
          'SELECT MainUserID FROM Account WHERE Email = :email';
          qryLogin.Parameters.ParamByName('email').Value := edtEmail.Text;
          qryLogin.Open;

          CurrentUserID := qryLogin.FieldByName('MainUserID').AsInteger;
          FillInDetailsFormStudent.CurrentUserID := CurrentUserID;
          FillInDetailsT.CurrentUserID := CurrentUserID;
          TeacherNavigation.CurrentUserID := CurrentUserID;
          StudentNavigation.CurrentUserID := CurrentUserID;
          QuizOutcome.CurrentUserID:= CurrentUserID;
          ChangeDetails.CurrentUserID:= CurrentUserID;
          PerformanceStudent.CurrentUserID:= CurrentUserID;
        end;
      // Redirect based on user type and completion status
      if (LoggedIn = True) and (InfoComplete = False) then
      begin
        if TeacherAccount = True then
        begin
          FillInDetailsT.Show;
          LoginForm.Hide
          end
        else
        begin
          FillInDetailsFormStudent.Show;
          LoginForm.Hide;
          end
      end;

      if (LoggedIn = True) and (InfoComplete = True) then
       begin
        if TeacherAccount = True then
         begin
          TeacherNavigation.show;
          LoginForm.Hide;
          end
        else
        begin
          StudentNavigation.Show;
          LoginForm.Hide;
        end;
      end;
    end;
  end;
end;

//Displays signup page upon pressing sign up button

procedure TLoginForm.imgClickSignupClick(Sender: TObject);
begin
LoginForm.Hide;
SignupForm.Show;
SignupForm.BringToFront;
end;


procedure TLoginForm.lblForgotClick(Sender: TObject);
begin
 ForgotOpened := True;
    ForgotPasswordForm := TForgotPasswordForm.Create(nil);
    //Position of quitting form
    SetWindowPos(ForgotPasswordForm.Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE);
    ForgotPasswordForm.Show;
end;



end.



