unit NavigationPageTeacher;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, jpeg, ExtCtrls, StdCtrls, DB, ADODB;

type
  TTeacherNavigation = class(TForm)
    imgBg: TImage;
    imgQuit: TImage;
    imgLeftBg: TImage;
    imgUserImg: TImage;
    lblFirstName: TLabel;
    lblUserFN: TLabel;
    qryTeacherDetails: TADOQuery;
    qryTeacherID: TADOQuery;
    lblEmail: TLabel;
    lblUserEmail: TLabel;
    lblUserLN: TLabel;
    lblLastName: TLabel;
    imgEditDetails: TImage;
    lblEditDetails: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure imgQuitClick(Sender: TObject);
    procedure AddFontResourceAndBroadcast;
    procedure FindTeacherID;
    procedure FirstName;
    procedure LastName;
    procedure Email;
    procedure SetLabelMaxWidth(LabelControl: TLabel; MaxWidth: Integer);
    procedure UpdateDetails;
    procedure OnShow(Sender: TObject);
    procedure imgEditDetailsClick(Sender: TObject);



  private
    { Private declarations }
    FCurrentUserID: Integer;
  public
    { Public declarations }
    property CurrentUserID: Integer read FCurrentUserID write FCurrentUserID;
  end;

var
  TeacherNavigation: TTeacherNavigation;
  ScaleFactor:  Double;
  lblFirstNameTop, lblFirstNameLeft: Integer;
  lblUserFNTop, lblUserFNLeft: Integer;
  CurrentTeacherID: string;
  TeacherFN: string;
  TeacherSN: string;
  TeacherEmail: string;
  lblUserLNTop, lblUserLNLeft: Integer;
  lblUserEmailTop, lblUserEmailLeft: Integer;
  MaxWidth: Integer;
  lblLastNameTop, lblLastNameLeft: Integer;
  lblEmailTop, lblEmailLeft: Integer;
  imgEditDetailsTop, imgEditDetailsLeft: Integer;

implementation

uses CustomDialog, EditDetails;

{$R *.dfm}

procedure TTeacherNavigation.FormCreate(Sender: TObject);
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

    end;

    procedure TTeacherNavigation.AddFontResourceAndBroadcast;
begin
  if AddFontResource('Revision System Project\FONTS\arial-rounded-mt-bold.ttf"') > 0 then
    SendMessage(HWND_BROADCAST, WM_FONTCHANGE, 0, 0);
end;

//Procedure for exiting the program upon pressing the exit button

procedure TTeacherNavigation.imgQuitClick(Sender: TObject);
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

 procedure TTeacherNavigation.OnShow(Sender: TObject);
 begin
    UpdateDetails;
 end;

procedure TTeacherNavigation.FindTeacherID;
begin
  qryTeacherID.SQL.Text := 'SELECT TeacherID FROM Teacher WHERE MainUserID = :UserID';
  qryTeacherID.Parameters.ParamByName('UserID').Value := CurrentUserID;
  qryTeacherID.Open;
  CurrentTeacherID := qryTeacherID.FieldByName('TeacherID').AsString;
end;

procedure TTeacherNavigation.FirstName;
var
FirstName: string;
begin
  FindTeacherID; // Call FindTeacherID to populate CurrentTeacherID
  qryTeacherDetails.SQL.Text := 'SELECT TName FROM Teacher WHERE TeacherID = :TeacherID';
  qryTeacherDetails.Parameters.ParamByName('TeacherID').Value := CurrentTeacherID;
  qryTeacherDetails.Open;
  if not qryTeacherDetails.IsEmpty then // Check if the query returned any results
    begin
    FirstName := qryTeacherDetails.FieldByName('TName').AsString;
    TeacherFN:= FirstName;
    end
  else
    FirstName := ''; // Set FirstName to empty string if no result found
    TeacherFN:= FirstName;
end;

procedure TTeacherNavigation.LastName;
var
LastName: string;
begin
  qryTeacherDetails.SQL.Text := 'SELECT TSurname FROM Teacher WHERE TeacherID = :TeacherID';
  qryTeacherDetails.Parameters.ParamByName('TeacherID').Value := CurrentTeacherID;
  qryTeacherDetails.Open;
  if not qryTeacherDetails.IsEmpty then // Check if the query returned any results
    begin
    LastName := qryTeacherDetails.FieldByName('TSurname').AsString;
    TeacherSN:= LastName;
    end
  else
    LastName := ''; // Set FirstName to empty string if no result found
    TeacherSN:= LastName;
end;

procedure TTeacherNavigation.Email;
var
Email: string;
begin
  qryTeacherDetails.SQL.Text := 'SELECT Email FROM Account WHERE MainUserID = :UserID';
  qryTeacherDetails.Parameters.ParamByName('UserID').Value := CurrentUserID;
  qryTeacherDetails.Open;
  if not qryTeacherDetails.IsEmpty then // Check if the query returned any results
    begin
    Email := qryTeacherDetails.FieldByName('Email').AsString;
    TeacherEmail:= Email;
    end
  else
    Email := ''; // Set FirstName to empty string if no result found
    TeacherEmail:= Email;
end;

procedure TTeacherNavigation.SetLabelMaxWidth(LabelControl: TLabel; MaxWidth: Integer);
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
    LabelControl.Hint := TeacherEmail; // Set the full text as tooltip
    LabelControl.ShowHint := True; // Enable hint display
  end;
end;

procedure TTeacherNavigation.UpdateDetails;
 begin;
    FirstName;
    lblUserFN.Caption := TeacherFN;
    LastName;
    lblUserLN.Caption := TeacherSN;
    Email;
    MaxWidth:= Round(imgLeftBg.Width * 0.035);
    lblUserEmail.Caption := TeacherEmail;
    SetLabelMaxWidth(lblUserEmail, MaxWidth);
 end;

 procedure TTeacherNavigation.imgEditDetailsClick(Sender: TObject);
begin
ChangeDetails.show;
TeacherNavigation.Hide;
end;
end.
