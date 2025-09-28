unit NavigationPageStudent;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, jpeg, ExtCtrls, StdCtrls, DB, ADODB;

type
  TStudentNavigation = class(TForm)
    imgBg: TImage;
    imgLeftBg: TImage;
    imgUserImg: TImage;
    lblFirstName: TLabel;
    lblUserFN: TLabel;
    lblLastName: TLabel;
    lblEmail: TLabel;
    qryStudentDetails: TADOQuery;
    qryStudentID: TADOQuery;
    lblUserLN: TLabel;
    imgEditDetails: TImage;
    lblUserEmail: TLabel;
    lblEditDetails: TLabel;
    lblWelcome: TLabel;
    imgQuiz: TImage;
    imgQuit: TImage;
    imgPerformance: TImage;
    lblQuiz: TLabel;
    lblPerformance: TLabel;
  procedure FormCreate(Sender: TObject);
  procedure AddFontResourceAndBroadcast;
  procedure imgQuitClick(Sender: TObject);
  procedure FindStudentID;
  procedure FirstName;
  procedure UpdateDetails;
  procedure OnShow(Sender: TObject);
  procedure LastName;
  procedure Email;
  procedure SetLabelMaxWidth(LabelControl: TLabel; MaxWidth: Integer);
  procedure imgQuizClick(Sender: TObject);
  procedure imgEditDetailsClick(Sender: TObject);
    procedure imgPerformanceClick(Sender: TObject);


  private
    { Private declarations }
    FCurrentUserID: Integer;
  public
    { Public declarations }
    property CurrentUserID: Integer read FCurrentUserID write FCurrentUserID;

  end;

var
  StudentNavigation: TStudentNavigation;
  ScaleFactor: Double;
  lblFirstNameTop, lblFirstNameLeft: Integer;
  lblLastNameTop, lblLastNameLeft: Integer;
  lblEmailTop, lblEmailLeft: Integer;
  lblUserFNTop, lblUserFNLeft: Integer;
  lblUserLNTop, lblUserLNLeft: Integer;
  imgEditDetailsLeft, imgEditDetailsTop: Integer;
  lblUserEmailTop, lblUserEmailLeft: Integer;
  imgQuizLeft, imgQuizTop: Integer;
  imgPerformanceLeft, imgPerformanceTop: Integer;
  CurrentStudentID: string;
  StudentFN: string;
  StudentSN: string;
  StudentEmail: string;
  MaxWidth: Integer;

implementation

uses CustomDialog, QuizSelection, EditDetails, StudentPerformance;

{$R *.dfm}


procedure TStudentNavigation.FormCreate(Sender: TObject);
var
  DesiredWidth: Integer ;
  DesiredHeight: Integer;
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
  imgQuit.Constraints.MinWidth := Round(ClientWidth * 0.05);
  imgQuit.Constraints.MinHeight := Round(ClientWidth * 0.05);

  //imgLeftBg: appearance on page

  imgLeftBg.Left := 0;
  imgLeftBg.Top := 0;
  imgLeftBg.Constraints.MinHeight := Screen.Monitors[0].Height;
  imgLeftBg.Constraints.MaxHeight := Screen.Monitors[0].Height;
  imgLeftBg.Constraints.MinWidth := Round(ClientWidth * 0.35);
  imgLeftBg.Constraints.MaxWidth := Round(ClientWidth * 0.35);

  //imgUserImg: appearance on page
  DesiredWidth := Round(imgLeftBg.Width * 0.5); // Half the width of imgLeftBg
  DesiredHeight := Round(imgLeftBg.Height * 0.4); // One third of the height of imgLeftBg
  imgUserImg.Left := 70; // Align to the left of imgLeftBg
  imgUserImg.Top := -40; // Align to the top of imgLeftBg
  imgUserImg.Width := DesiredWidth;
  imgUserImg.Height := DesiredHeight;

  //lblFirstName: appearance on page
  lblFirstName.Font.Name := 'Arial Rounded MT Bold';
  lblFirstName.Font.Size := Round(imgLeftBg.Width * 0.05);
  lblFirstName.Transparent := True;
  lblFirstName.Font.Color := RGB(0, 0, 0);
  lblFirstNameTop := imgLeftBg.Top + Round(imgLeftBg.Height * 0.28);
  lblFirstNameLeft := imgLeftBg.Left + Round(imgLeftBg.Width * 0.05);
  lblFirstName.Left := lblFirstNameLeft;
  lblFirstName.Top := lblFirstNameTop;

  //lblUserFN: appearance on page
  lblUserFN.Font.Name := 'Arial Rounded MT Bold';
  lblUserFN.Font.Size := Round(imgLeftBg.Width * 0.045);
  lblUserFN.Transparent := True;
  lblUserFN.Font.Color := RGB(61, 61, 61);
  lblUserFNTop := imgLeftBg.Top + Round(imgLeftBg.Height * 0.36);
  lblUserFNLeft := imgLeftBg.Left + Round(imgLeftBg.Width * 0.05);
  lblUserFN.Left := lblUserFNLeft;
  lblUserFN.Top := lblUserFNTop;

  //lblUserLN: appearance on page
  lblUserLN.Font.Name := 'Arial Rounded MT Bold';
  lblUserLN.Font.Size := Round(imgLeftBg.Width * 0.045);
  lblUserLN.Transparent := True;
  lblUserLN.Font.Color := RGB(61, 61, 61);
  lblUserLNTop := imgLeftBg.Top + Round(imgLeftBg.Height * 0.535);
  lblUserLNLeft := imgLeftBg.Left + Round(imgLeftBg.Width * 0.05);
  lblUserLN.Left := lblUserLNLeft;
  lblUserLN.Top := lblUserLNTop;

  //lblUserEmail: appearance on page
  lblUserEmail.Font.Name := 'Arial Rounded MT Bold';
  lblUserEmail.Font.Size := Round(imgLeftBg.Width * 0.045);
  lblUserEmail.Transparent := True;
  lblUserEmail.Font.Color := RGB(61, 61, 61);
  lblUserEmailTop := imgLeftBg.Top + Round(imgLeftBg.Height * 0.72);
  lblUserEmailLeft := imgLeftBg.Left + Round(imgLeftBg.Width * 0.05);
  lblUserEmail.Left := lblUserEmailLeft;
  lblUserEmail.Top := lblUserEmailTop;
  SetLabelMaxWidth(lblUserEmail, MaxWidth);

  //lblLastName: appearance on page
  lblLastName.Font.Name := 'Arial Rounded MT Bold';
  lblLastName.Font.Size := Round(imgLeftBg.Width * 0.05);
  lblLastName.Transparent := True;
  lblLastName.Font.Color := RGB(0, 0, 0);
  lblLastNameTop := imgLeftBg.Top + Round(imgLeftBg.Height * 0.45);
  lblLastNameLeft := imgLeftBg.Left + Round(imgLeftBg.Width * 0.05);
  lblLastName.Left := lblLastNameLeft;
  lblLastName.Top := lblLastNameTop;

  //lblEmail: appearance on page
  lblEmail.Font.Name := 'Arial Rounded MT Bold';
  lblEmail.Font.Size := Round(imgLeftBg.Width * 0.05);
  lblEmail.Transparent := True;
  lblEmail.Font.Color := RGB(0, 0, 0);
  lblEmailTop := imgLeftBg.Top + Round(imgLeftBg.Height * 0.62);
  lblEmailLeft := imgLeftBg.Left + Round(imgLeftBg.Width * 0.05);
  lblEmail.Left := lblEmailLeft;
  lblEmail.Top := lblEmailTop;

  //imgEditDetails : appereace on page
  imgEditDetailsTop := imgLeftBg.Top + Round(imgLeftBg.Height * 0.8);
  imgEditDetailsLeft := imgLeftBg.Left + Round(imgLeftBg.Width * 0.02);
  imgEditDetails.Left := imgEditDetailsLeft;
  imgEditDetails.Top := imgEditDetailsTop;
  imgEditDetails.Constraints.MaxWidth := Round(ClientWidth * 0.23);
  imgEditDetails.Constraints.MaxHeight := Round(ClientWidth * 0.08);
  imgEditDetails.Constraints.MinWidth := Round(ClientWidth * 0.23);
  imgEditDetails.Constraints.MinHeight := Round(ClientWidth * 0.08);

  // lblEditDetails : apperance on page
  lblEditDetails.Font.Name := 'Arial Rounded MT Bold';
  lblEditDetails.Font.Size := Round(imgLeftBg.Width * 0.04);;
  lblEditDetails.Transparent := True;
  lblEditDetails.Font.Color := RGB(157, 179 , 128);
  lblEditDetails.Left := imgEditDetails.Left + (imgEditDetails.Width - lblEditDetails.Width) div 2;
  lblEditDetails.Top := imgEditDetails.Top + (imgEditDetails.Height - lblEditDetails.Height) div 2;

  //lblWelcome : apperance on page
  lblWelcome.Font.Name := 'Arial Rounded MT Bold';
  lblWelcome.Font.Size := Round(imgLeftBg.Width * 0.08);
  lblWelcome.Transparent := True;
  lblWelcome.Font.Color := RGB(0, 0 , 0);
  lblWelcome.Left := Round(ClientWidth * 0.53);
  lblWelcome.Top := Round(ClientHeight * 0.05);

  //imgQuiz : appereace on page
  imgQuizTop := imgLeftBg.Top + Round(ClientHeight * 0.28);
  imgQuizLeft := imgLeftBg.Left + Round(ClientWidth * 0.42);
  imgQuiz.Left := imgQuizLeft;
  imgQuiz.Top := imgQuizTop;
  imgQuiz.Constraints.MaxWidth := Round(ClientWidth * 0.4);
  imgQuiz.Constraints.MaxHeight := Round(ClientWidth * 0.13);
  imgQuiz.Constraints.MinWidth := Round(ClientWidth * 0.4);
  imgQuiz.Constraints.MinHeight := Round(ClientWidth * 0.13);

  //imgPerformance : appereace on page
  imgPerformanceTop := imgLeftBg.Top + Round(ClientHeight * 0.55);
  imgPerformanceLeft := imgLeftBg.Left + Round(ClientWidth * 0.42);
  imgPerformance.Left := imgPerformanceLeft;
  imgPerformance.Top := imgPerformanceTop;
  imgPerformance.Constraints.MaxWidth := Round(ClientWidth * 0.4);
  imgPerformance.Constraints.MaxHeight := Round(ClientWidth * 0.13);
  imgPerformance.Constraints.MinWidth := Round(ClientWidth * 0.4);
  imgPerformance.Constraints.MinHeight := Round(ClientWidth * 0.13);

   // lblQuiz : apperance on page
  lblQuiz.Font.Name := 'Arial Rounded MT Bold';
  lblQuiz.Font.Size := Round(imgLeftBg.Width * 0.09);;
  lblQuiz.Transparent := True;
  lblQuiz.Font.Color := RGB(227, 227 , 227);
  lblQuiz.Left := imgQuiz.Left + (imgQuiz.Width - lblQuiz.Width) div 2;
  lblQuiz.Top := imgQuiz.Top + (imgQuiz.Height - lblQuiz.Height) div 2;

   // lblPerformance : apperance on page
  lblPerformance.Font.Name := 'Arial Rounded MT Bold';
  lblPerformance.Font.Size := Round(imgLeftBg.Width * 0.09);;
  lblPerformance.Transparent := True;
  lblPerformance.Font.Color := RGB(227, 227 , 227);
  lblPerformance.Left := imgPerformance.Left + (imgPerformance.Width - lblPerformance.Width) div 2;
  lblPerformance.Top := imgPerformance.Top + (imgPerformance.Height - lblPerformance.Height) div 2;



 end;

 procedure TStudentNavigation.OnShow(Sender: TObject);
 begin
    UpdateDetails;
 end;

 procedure TStudentNavigation.UpdateDetails;
 begin;
    FirstName;
    lblUserFN.Caption := StudentFN;
    LastName;
    lblUserLN.Caption := StudentSN;
    Email;
    MaxWidth:= Round(imgLeftBg.Width * 0.035);
    lblUserEmail.Caption := StudentEmail;
    SetLabelMaxWidth(lblUserEmail, MaxWidth);
 end;

procedure TStudentNavigation.AddFontResourceAndBroadcast;
begin
  if AddFontResource('Revision System Project\FONTS\arial-rounded-mt-bold.ttf"') > 0 then
    SendMessage(HWND_BROADCAST, WM_FONTCHANGE, 0, 0);
end;

//Procedure for exiting the program upon pressing the exit button

procedure TStudentNavigation.imgQuitClick(Sender: TObject);
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

procedure TStudentNavigation.FindStudentID;
begin
  qryStudentID.SQL.Text := 'SELECT StudentID FROM Student WHERE MainUserID = :UserID';
  qryStudentID.Parameters.ParamByName('UserID').Value := CurrentUserID;
  qryStudentID.Open;
  CurrentStudentID := qryStudentID.FieldByName('StudentID').AsString;
end;

procedure TStudentNavigation.FirstName;
var
FirstName: string;
begin
  FindStudentID; // Call FindStudentID to populate CurrentStudentID
  qryStudentDetails.SQL.Text := 'SELECT SName FROM Student WHERE StudentID = :StudentID';
  qryStudentDetails.Parameters.ParamByName('StudentID').Value := CurrentStudentID;
  qryStudentDetails.Open;
  if not qryStudentDetails.IsEmpty then // Check if the query returned any results
    begin
    FirstName := qryStudentDetails.FieldByName('SName').AsString;
    StudentFN:= FirstName;
    end
  else
    FirstName := ''; // Set FirstName to empty string if no result found
    StudentFN:= FirstName;
end;

procedure TStudentNavigation.LastName;
var
LastName: string;
begin
  qryStudentDetails.SQL.Text := 'SELECT SSurname FROM Student WHERE StudentID = :StudentID';
  qryStudentDetails.Parameters.ParamByName('StudentID').Value := CurrentStudentID;
  qryStudentDetails.Open;
  if not qryStudentDetails.IsEmpty then // Check if the query returned any results
    begin
    LastName := qryStudentDetails.FieldByName('SSurname').AsString;
    StudentSN:= LastName;
    end
  else
    LastName := ''; // Set FirstName to empty string if no result found
    StudentSN:= LastName;
end;

procedure TStudentNavigation.Email;
var
Email: string;
begin
  qryStudentDetails.SQL.Text := 'SELECT Email FROM Account WHERE MainUserID = :UserID';
  qryStudentDetails.Parameters.ParamByName('UserID').Value := CurrentUserID;
  qryStudentDetails.Open;
  if not qryStudentDetails.IsEmpty then // Check if the query returned any results
    begin
    Email := qryStudentDetails.FieldByName('Email').AsString;
    StudentEmail:= Email;
    end
  else
    Email := ''; // Set FirstName to empty string if no result found
    StudentEmail:= Email;
end;

procedure TStudentNavigation.SetLabelMaxWidth(LabelControl: TLabel; MaxWidth: Integer);
var
  TextWidth: Integer;
begin
  // Calculate the width of the text
  TextWidth := LabelControl.Canvas.TextWidth(LabelControl.Caption);

  // Check if the text width exceeds the maximum width
  if TextWidth > MaxWidth then
  begin
    // Truncate the text to fit within the maximum width
    LabelControl.Caption := TrimRight(Copy(LabelControl.Caption, 1, MaxWidth - Canvas.TextWidth('...'))) + '...';


    //Display tooltip with full email adress.
    LabelControl.Hint := StudentEmail; // Set the full text as tooltip
    LabelControl.ShowHint := True; // Enable hint display
  end;
end;

procedure TStudentNavigation.imgQuizClick(Sender: TObject);
begin
StudentNavigation.Hide;
QuizSelect.Show;
end;


procedure TStudentNavigation.imgEditDetailsClick(Sender: TObject);
begin
ChangeDetails.show;
StudentNavigation.Hide;
end;

procedure TStudentNavigation.imgPerformanceClick(Sender: TObject);
begin
PerformanceStudent.Show;
StudentNavigation.Hide;
end;

end.


