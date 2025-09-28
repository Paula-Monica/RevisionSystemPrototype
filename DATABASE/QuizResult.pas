unit QuizResult;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, jpeg, ExtCtrls, StdCtrls, DB, ADODB;

type
  TQuizOutcome = class(TForm)
    imgBg: TImage;
    imgQuit: TImage;
    lblScore: TLabel;
    lblPredictedGrade: TLabel;
    lblUserScore: TLabel;
    qryGetPredictedGrade: TADOQuery;
    lblUserPredictedGrade: TLabel;
    lblTimeSpent: TLabel;
    lblUserTimeSpent: TLabel;
    qryUpdateDatabase: TADOQuery;
    qrySubID: TADOQuery;
    qryStudentID: TADOQuery;
    imgNavigationPagebtn: TImage;
    lblNavigationPagebtn: TLabel;
    imgRedoQuestions: TImage;
    lblRedoQuestions: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure AddFontResourceAndBroadcast;
    procedure imgQuitClick(Sender: TObject);
    procedure OnShow(Sender: TObject);
    procedure GetPredictedGrade();
    procedure UpdateDatabase;
    procedure imgNavigationPagebtnClick(Sender: TObject);
    procedure imgRedoQuestionsClick(Sender: TObject);

  private
    { Private declarations }
    FCorrectCount: Integer;
    FCurrentUserID: Integer;
    FQuizTime: string;
    FQuizTimeSeconds: Integer;
    FQuizID: Integer;
  public
    { Public declarations }
    property CorrectCount: Integer read FCorrectCount write FCorrectCount;
    property CurrentUserID: Integer read FCurrentUserID write FCurrentUserID;
    property QuizTime: string read FQuizTime write FQuizTime;
    property QuizTimeSeconds: Integer read FQuizTimeSeconds write FQuizTimeSeconds;
    property QuizID: Integer read FQuizID write FQuizID;
  end;

var
  QuizOutcome: TQuizOutcome;
  ScaleFactor: Double;
  PredictedGrade:string;
  Redo: Boolean;

implementation

uses CustomDialog, NavigationPageStudent, QuizCompletion;

{$R *.dfm}

procedure TQuizOutcome.FormCreate(Sender: TObject);
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

  //lblScore: appereance on page

  lblScore.Font.Name := 'Arial Rounded MT Bold';
  lblScore.Font.Size := Round(ClientWidth * 0.03);
  lblScore.Transparent := True;
  lblScore.Font.Color := RGB(227, 227 , 227);
  lblScore.Top := Round(ClientHeight*0.15);
  lblScore.Left := Round((ClientWidth - lblScore.Width) / 3.8);

  //lblUserScore: appereance on page

  lblUserScore.Font.Name := 'Arial Rounded MT Bold';
  lblUserScore.Font.Size := Round(ClientWidth * 0.027);
  lblUserScore.Transparent := True;
  lblUserScore.Font.Color := RGB(227, 227 , 227);
  lblUserScore.Top := Round(ClientHeight*0.3);
  lblUserScore.Left := (ClientWidth - lblUserScore.Width) div 4;

  //lblPredictedGrade: appereance on page

  lblPredictedGrade.Font.Name := 'Arial Rounded MT Bold';
  lblPredictedGrade.Font.Size := Round(ClientWidth * 0.028);
  lblPredictedGrade.Transparent := True;
  lblPredictedGrade.Font.Color := RGB(227, 227 , 227);
  lblPredictedGrade.Top := Round(ClientHeight*0.45);
  lblPredictedGrade.Left := (ClientWidth - lblPredictedGrade.Width) div 5;

  //lblUserPredictedGrade: appereance on page

  lblUserPredictedGrade.Font.Name := 'Arial Rounded MT Bold';
  lblUserPredictedGrade.Font.Size := Round(ClientWidth * 0.026);
  lblUserPredictedGrade.Transparent := True;
  lblUserPredictedGrade.Font.Color := RGB(227, 227 , 227);
  lblUserPredictedGrade.Top := Round(ClientHeight*0.6);
  lblUserPredictedGrade.Left := Round((ClientWidth - lblUserPredictedGrade.Width) / 3.5);

  //lblTimeSpent: appereance on page

  lblTimeSpent.Font.Name := 'Arial Rounded MT Bold';
  lblTimeSpent.Font.Size := Round(ClientWidth * 0.028);
  lblTimeSpent.Transparent := True;
  lblTimeSpent.Font.Color := RGB(155, 178, 127);
  lblTimeSpent.Top := Round(ClientHeight*0.15);
  lblTimeSpent.Left := Round((ClientWidth - lblTimeSpent.Width) / 1.2);

  //lblUserTimeSpent: appereance on page

  lblUserTimeSpent.Font.Name := 'Arial Rounded MT Bold';
  lblUserTimeSpent.Font.Size := Round(ClientWidth * 0.023);
  lblUserTimeSpent.Transparent := True;
  lblUserTimeSpent.Font.Color := RGB(155, 178, 127);
  lblUserTimeSpent.Top := Round(ClientHeight*0.3);
  lblUserTimeSpent.Left := Round((ClientWidth - lblUserTimeSpent.Width) /1.6);

  //imgNavigationPagebtn: apperreance on page
  imgNavigationPagebtn.Height:=Round(ClientHeight*0.23);
  imgNavigationPagebtn.Width:=Round(ClientWidth*0.27);
  imgNavigationPagebtn.Left:=Round(ClientWidth  * 0.58);
  imgNavigationPagebtn.Top:=Round(ClientHeight  * 0.4);

  //lblNavigationPagebtn: appearance on page

  lblNavigationPagebtn.Font.Name := 'Arial Rounded MT Bold';
  lblNavigationPagebtn.Font.Size := Round(ClientWidth * 0.015);;
  lblNavigationPagebtn.Width :=Round(ClientWidth*0.2);
  lblNavigationPagebtn.Transparent := True;
  lblNavigationPagebtn.Font.Color := RGB(232, 232, 232);
  lblNavigationPagebtn.Left := imgNavigationPagebtn.Left + (imgNavigationPagebtn.Width - lblNavigationPagebtn.Width) div 2;
  lblNavigationPagebtn.Top := imgNavigationPagebtn.Top + (imgNavigationPagebtn.Height - lblNavigationPagebtn.Height) div 2;

  //imgRedoQuestions: apperreance on page
  imgRedoQuestions.Height:=Round(ClientHeight*0.23);
  imgRedoQuestions.Width:=Round(ClientWidth*0.27);
  imgRedoQuestions.Left:=Round(ClientWidth  * 0.58);
  imgRedoQuestions.Top:=Round(ClientHeight  * 0.6);
  imgRedoQuestions.Visible:= False;
  imgRedoQuestions.Hint:= 'Re-attempting questions you got incorrect aims to help you improve and therefore will not count towards your statistics';
  imgRedoQuestions.ShowHint := True;

  //lblRedoQuestions: appearance on page
  lblRedoQuestions.Font.Name := 'Arial Rounded MT Bold';
  lblRedoQuestions.Font.Size := Round(ClientWidth * 0.015);;
  lblRedoQuestions.Width :=Round(ClientWidth*0.2);
  lblRedoQuestions.Transparent := True;
  lblRedoQuestions.Font.Color := RGB(232, 232, 232);
  lblRedoQuestions.Left := imgRedoQuestions.Left + (imgRedoQuestions.Width - lblRedoQuestions.Width) div 2;
  lblRedoQuestions.Top := imgRedoQuestions.Top + (imgRedoQuestions.Height - lblRedoQuestions.Height) div 2;
  lblRedoQuestions.Visible:= False;
  lblRedoQuestions.Hint:= 'Re-attempting questions you got incorrect aims to help you improve and therefore will not count towards your statistics';
  lblRedoQuestions.ShowHint := True;

  end;

  procedure TQuizOutcome.AddFontResourceAndBroadcast;
begin
  if AddFontResource('Revision System Project\FONTS\arial-rounded-mt-bold.ttf"') > 0 then
    SendMessage(HWND_BROADCAST, WM_FONTCHANGE, 0, 0);
end;

procedure TQuizOutcome.imgQuitClick(Sender: TObject);
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

procedure TQuizOutcome.OnShow(Sender: TObject);
begin
  lblUserScore.Caption:= (IntToStr(CorrectCount) + '/10');
  GetPredictedGrade();
  lblUserTimeSpent.Caption := QuizTime;

  if CorrectCount <> 10 then
  begin
  imgRedoQuestions.Visible:= True;
  lblRedoQuestions.Visible:= True;
  end

end;

procedure TQuizOutcome.GetPredictedGrade();
begin
  qryGetPredictedGrade.SQL.Text := 'SELECT PredictedGrade FROM Grades WHERE AverageMark = :MarkAchievedByUser';
  qryGetPredictedGrade.Parameters.ParamByName('MarkAchievedByUser').Value:= CorrectCount;
  qryGetPredictedGrade.Open;
  PredictedGrade:=qryGetPredictedGrade.FieldByName('PredictedGrade').AsString;

  lblUserPredictedGrade.caption := (PredictedGrade);
end;

procedure TQuizOutcome.UpdateDatabase;
var
  CurrentPercentage: Extended;
  CurrentTimeSpent: Integer;
  CurrentGrade: string;
  CurrentScore: Integer;
  CurrentStudentID: Integer;
  CurrentQuizID : Integer;
  CurrentSubID : string;
  CurrentDate : TDateTime;
begin
    CurrentPercentage:= (CorrectCount/10) * 100;
    CurrentTimeSpent := QuizTimeSeconds;
    CurrentGrade:= PredictedGrade;
    CurrentScore:= CorrectCount;
    CurrentQuizID := QuizID;
    CurrentDate := Now;

    qrySubID.SQL.Text := 'SELECT SubjectID FROM Quiz WHERE QuizID = :QuizID';
    qrySubID.Parameters.ParamByName('QuizID').Value:= CurrentQuizID;
    qrySubID.Open;
    CurrentSubID:=qrySubID.FieldByName('SubjectID').AsString;

    qryStudentID.SQL.Text := 'SELECT StudentID FROM Student WHERE MainUserID = :UserID';
    qryStudentID.Parameters.ParamByName('UserID').Value:= CurrentUserID;
    qryStudentID.Open;
    CurrentStudentID:=qryStudentID.FieldByName('StudentID').AsInteger;

    qryUpdateDatabase.SQL.Text := 'INSERT INTO Result (StudentID, QuizID, DateDone, Score, Percentage, SubjectID, TimeSpent, Grade) ' +
                                 'VALUES (:StudentID, :QuizID, :DateDone, :Score, :Percentage, :SubjectID, :TimeSpent, :Grade)';
    qryUpdateDatabase.Parameters.ParamByName('StudentID').Value := CurrentStudentID;
    qryUpdateDatabase.Parameters.ParamByName('QuizID').Value := CurrentQuizID;
    qryUpdateDatabase.Parameters.ParamByName('DateDone').Value := CurrentDate;
    qryUpdateDatabase.Parameters.ParamByName('Score').Value := CurrentScore;
    qryUpdateDatabase.Parameters.ParamByName('Percentage').Value := CurrentPercentage;
    qryUpdateDatabase.Parameters.ParamByName('SubjectID').Value := CurrentSubID;
    qryUpdateDatabase.Parameters.ParamByName('TimeSpent').Value := CurrentTimeSpent;
    qryUpdateDatabase.Parameters.ParamByName('Grade').Value := CurrentGrade;
    qryUpdateDatabase.ExecSQL;

end;



procedure TQuizOutcome.imgNavigationPagebtnClick(Sender: TObject);
begin
   UpdateDatabase;
   StudentNavigation.show;
   QuizOutcome.Hide;
   StackTop := -1;
end;


procedure TQuizOutcome.imgRedoQuestionsClick(Sender: TObject);
begin
UpdateDatabase;
Redo:= True;
CompleteQuiz.Show;
QuizOutcome.Hide;
end;

end.
