unit ForgotPassword;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, jpeg, ExtCtrls, StdCtrls, DB, ADODB, IdMessage, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdMessageClient, IdSMTP;

type
  TForgotPasswordForm = class(TForm)
    imgBg: TImage;
    imgQuit: TImage;
    lblResetPasswordInfo: TLabel;
    edtEmail: TEdit;
    btnTest: TButton;
    qryEmail: TADOQuery;
    IdSMTPPasswordReset: TIdSMTP;
    IdMessagePasswordReset: TIdMessage;
    OpenDialogPasswordReset: TOpenDialog;
    qryUpdatePass: TADOQuery;
  procedure FormCreate(Sender: TObject);
  procedure imgQuitClick(Sender: TObject);
  procedure EmailValidityconditions;
  procedure btnSubmitClick(Sender: TObject);
  procedure GenerateRandomPassword;
  procedure SendEmail;
  procedure UpdatePassInDatabase;

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ForgotPasswordForm: TForgotPasswordForm;
  EmailGreenwoodValid: Boolean;
  NewPassword: string;
  HashedPassword: string;

implementation

uses LoginPage;

{$R *.dfm}

procedure TForgotPasswordForm.FormCreate(Sender: TObject);
 begin
//Form size and position

    BorderStyle := bsSingle;
    FormStyle := fsStayOnTop;

    Width := Round(LoginForm.Width * 0.5);
    Height := Round(LoginForm.Height * 0.5);

    Position := poMainFormCenter;

    //imgQuit: appearance on page

  imgQuit.Top := 20;
  imgQuit.Constraints.MaxWidth := Round(Width * 0.05);
  imgQuit.Constraints.MaxHeight := Round(Width * 0.05);
  imgQuit.Left := Width - imgQuit.Width - 60;
  imgQuit.Constraints.MinWidth := Round(Width * 0.08);
  imgQuit.Constraints.MinHeight := Round(Width * 0.08);

  lblResetPasswordInfo.Font.Name := 'Arial Rounded MT Bold';
  lblResetPasswordInfo.Font.Size :=  Round(ClientWidth * 0.02);
  lblResetPasswordInfo.Width := Round(Width * 0.6);
  lblResetPasswordInfo.Height := Round(Height * 0.5);
  lblResetPasswordInfo.WordWrap := True;
  lblResetPasswordInfo.Left := Round(Width * 0.18);
  lblResetPasswordInfo.Top:= Round(Height * 0.07);

end;

procedure TForgotPasswordForm.imgQuitClick(Sender: TObject);
begin
ForgotPasswordForm.Hide;
edtEmail.Clear;
end;

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

procedure TForgotPasswordForm.EmailValidityconditions;
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
   end
   else
   begin
     ShowMessage('Please enter an email');
   end;

  //run when the domain of email is correct
  if EmailGreenwoodValid = True then
    begin
       qryEmail.SQL.Text := 'SELECT Email FROM Account WHERE Email = :Email';
       qryEmail.Parameters.ParamByName('Email').Value := edtEmail.Text;
    qryEmail.Open;

    // Check if the query returned any records (if the email already exists in database)
    if qryEmail.IsEmpty then
    begin
      // Email already exists in the database
      ShowMessage('This email is not linked to an existing account');
      EmailGreenwoodValid := False;
      // Set focus back to the email field for correction
      edtEmail.SetFocus;
    end;
    end;
end;
procedure TForgotPasswordForm.btnSubmitClick(Sender: TObject);
begin
   EmailValidityconditions;
   if EmailGreenwoodValid = True then
   begin
   GenerateRandomPassword;
   HashedPassword := HashPassword(NewPassword);
   UpdatePassInDatabase;
   //SendEmail;
   ShowMessage('Password successfull reset');
   edtEmail.Clear;
   ForgotPasswordForm.Hide;

   end;
end;

procedure TForgotPasswordForm.GenerateRandomPassword;
var
  i: Integer;
begin
  // Initialize the random number generator
  Randomize;

  // Clear the NewPassword variable
  NewPassword := '';

  // Generate 10 random numbers and append them to NewPassword
  for i := 1 to 10 do
    NewPassword := NewPassword + IntToStr(Random(10)); // Concatenate a random number between 0 and 9

end;

procedure TForgotPasswordForm.SendEmail;
var
  Email: string;
  EmailBody: string;
begin
  // Fetch email address from edtEmail and create the contents of the email
  Email := edtEmail.Text;
  EmailBody := 'Your new temporary password is ' + NewPassword + '. Use this password to log into your account and then change the password.';

  // Set up IdSMTPPasswordReset parameters
  IdSMTPPasswordReset.Host := 'gsmail01.graveney.wandsworth.sch.uk';
  IdSMTPPasswordReset.Port := 25;

  // Set sender email address, recipient email address, subject, and body
  IdMessagePasswordReset.From.Address := 'GreenwoodRevisionSystemSupport@greenwood.org';
  IdMessagePasswordReset.Recipients.EMailAddresses := Email;
  IdMessagePasswordReset.Subject := 'Temporary Password';
  IdMessagePasswordReset.Body.Text := EmailBody; // Set the email body from the EmailBody variable

  // Send the message
  try
    IdSMTPPasswordReset.Connect;
    IdSMTPPasswordReset.Send(IdMessagePasswordReset);
  except
    on E: Exception do
      ShowMessage('Error: ' + E.Message);
  end;
  
  // Disconnect from the server
  if IdSMTPPasswordReset.Connected then
    IdSMTPPasswordReset.Disconnect;
end;

procedure TForgotPasswordForm.UpdatePassInDatabase;
begin
  qryUpdatePass.SQL.Text := 'UPDATE Account SET  AccPassword = :NewPassword WHERE Email = :UserEmail';
  qryUpdatePass.Parameters.ParamByName('NewPassword').Value := HashedPassword;
  qryUpdatePass.Parameters.ParamByName('UserEmail').Value := edtEmail.Text;
  qryUpdatePass.ExecSQL;
  end;
end.
