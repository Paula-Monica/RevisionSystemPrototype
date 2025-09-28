unit QuizCompletion;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, jpeg, DB, ADODB, DateUtils;

type
  TCompleteQuiz = class(TForm)
    imgQuit: TImage;
    imgBg: TImage;
    imgBackbtn: TImage;
    qryQuizQuestions: TADOQuery;
    qryQuizName: TADOQuery;
    lblQuizName: TLabel;
    lblQuestion: TLabel;
    rbA1: TRadioButton;
    rbA2: TRadioButton;
    rbA3: TRadioButton;
    rbA4: TRadioButton;

    qryQuizAnswers: TADOQuery;
    qryWrongAnswer: TADOQuery;
    imgSelect: TImage;
    tmrQuizTime: TTimer;
    lblSelect: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure AddFontResourceAndBroadcast;
    procedure imgQuitClick(Sender: TObject);
    procedure imgBackbtnClick(Sender: TObject);
    procedure LoadQuizName;
    procedure OnShow(Sender: TObject);
    procedure RetriveQuestions;
    procedure DisplayQuiz(I: Integer);
    procedure DisplayAnswers;
    procedure SubmitClick(Sender: TObject);
    procedure CheckIfAnswerIsCorrect(UserInputA: string);
    procedure StartTimer;
    procedure StopTimer;
    procedure PushToStack(IncorrectQuestionID: Integer);
    function  PopFromStack: Integer;
    procedure RetrieveIncorrectQuestion;
    procedure RetrieveRedoAnswers(CurrentQuestionID: Integer);
    procedure SubmitClickOriginalAttempt;
    procedure SubmitClickReattempt;




  private
    { Private declarations }
    Question: array of string;
    FTakeQuizID: Integer;
    FStartTime: TDateTime;
    FQuizTime: Integer;
    FActive: Boolean;
  public
    { Public declarations }
    property TakeQuizID: Integer read FTakeQuizID write FTakeQuizID;
  end;

  const MaxIncorrectQuestionsSize =10;

var
  CompleteQuiz: TCompleteQuiz;
  ScaleFactor: Double;
  CurrentQuestion: string;
  CorrectAnswer: string;
  CorrectCount: Integer;
  QuizTime : String;
  QuizTimeSeconds : Integer;
  StackCreated: Boolean;
  FStackTop: Integer;
  IncorrectQuestionsStack: array [0..MaxIncorrectQuestionsSize - 1] of Integer;
  StackTop: Integer = -1;

implementation

uses CustomDialog, QuizSelection, QuizResult, NavigationPageStudent;

{$R *.dfm}

procedure TCompleteQuiz.FormCreate(Sender: TObject);
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


  //imgBackbtn: appearance on page

  imgBackbtn.Top := 20;
  imgBackbtn.Constraints.MaxWidth := Round(ClientWidth * 0.085);
  imgBackbtn.Constraints.MaxHeight := Round(ClientWidth * 0.06);
  imgBackbtn.Constraints.MinWidth := Round(ClientWidth * 0.085);
  imgBackbtn.Constraints.MinHeight := Round(ClientWidth * 0.06);
  imgQuit.Left := ClientWidth - imgQuit.Width - 20;

  //lblQuizName: apperance on page.
  lblQuizName.Font.Name := 'Arial Rounded MT Bold';
  lblQuizName.Font.Size := Round(ClientWidth * 0.025);
  lblQuizName.Transparent := True;
  lblQuizName.Font.Color := RGB(0, 0 , 0);
  lblQuizName.Width := Round(ClientWidth*0.5);
  lblQuizName.Left := (ClientWidth - lblQuizName.Width) div 2;
  lblQuizName.Top := Round(ClientHeight * 0.05);

  //imgSelect: apperance on page
  imgSelect.Height:= Round(ClientHeight * 0.18);
  imgSelect.Width:= Round(Clientwidth*0.4);
  imgSelect.Top:= Round(ClientHeight * 0.7);
  imgSelect.Left:= Round(ClientWidth*0.3);

  //lblSelect: appearance on page

  lblSelect.Font.Name := 'Arial Rounded MT Bold';
  lblSelect.Font.Size := Round(ClientWidth * 0.035);
  lblSelect.Transparent := True;
  lblSelect.Font.Color := RGB(227, 227 , 227);
  lblSelect.Left := imgSelect.Left + (imgSelect.Width - lblSelect.Width) div 2;
  lblSelect.Top := imgSelect.Top + (imgSelect.Height - lblSelect.Height) div 2;

  //lblQuestion: appereance on page:

  lblQuestion.Font.Name := 'Arial Rounded MT Bold';
  lblQuestion.Font.Size :=  Round(ClientWidth * 0.015);
  lblQuestion.Left := (ClientWidth - lblQuestion.Width) div 2;
  lblQuestion.Top := Round(ClientHeight*0.12);

  //Radiobutton fonts and text size

  rbA1.Font.Name := 'Arial Rounded MT Bold';
  rbA1.Font.Size :=  Round(ClientWidth * 0.01);
  rbA1.Height:= Round(ClientHeight*0.05);
  rbA1.Color := RGB(213, 213, 213);

  rbA2.Font.Name := 'Arial Rounded MT Bold';
  rbA2.Font.Size :=  Round(ClientWidth * 0.01);
  rbA2.Height:= Round(ClientHeight*0.05);
  rbA2.Color := RGB(213, 213, 213);

  rbA3.Font.Name := 'Arial Rounded MT Bold';
  rbA3.Font.Size :=  Round(ClientWidth * 0.01);
  rbA3.Height:= Round(ClientHeight*0.05);
  rbA3.Color := RGB(213, 213, 213);

  rbA4.Font.Name := 'Arial Rounded MT Bold';
  rbA4.Font.Size :=  Round(ClientWidth * 0.01);
  rbA4.Height:= Round(ClientHeight*0.05);
  rbA4.Color := RGB(213, 213, 213);


  end;


procedure TCompleteQuiz.AddFontResourceAndBroadcast;
begin
  if AddFontResource('Revision System Project\FONTS\arial-rounded-mt-bold.ttf"') > 0 then
    SendMessage(HWND_BROADCAST, WM_FONTCHANGE, 0, 0);
end;

//Procedure for exiting the program upon pressing the exit button

  procedure TCompleteQuiz.imgQuitClick(Sender: TObject);
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

  procedure TCompleteQuiz.imgBackbtnClick(Sender: TObject);
  begin
  QuizSelect.Show;
  CompleteQuiz.Hide;
  end;

 procedure TCompleteQuiz.OnShow(Sender: TObject);
 begin

 if (Redo<>True) then
    begin
    CorrectCount:= 0;
    LoadQuizName;
    RetriveQuestions;
    StartTimer;
    I:=0;
    FStackTop := -1;
    DisplayQuiz(I);
    DisplayAnswers;
    end;

    if (Redo= True) then
    begin
    rbA1.Caption := '';
    rbA2.Caption := '';
    rbA3.Caption := '';
    rbA4.Caption := '';

     rbA1.Checked := False;
     rbA2.Checked := False;
     rbA3.Checked := False;
     rbA4.Checked := False;
     RetrieveIncorrectQuestion;
    end;

 end;

 procedure TCompleteQuiz.LoadQuizName;
 begin
  try
    // Set the query parameters and SQL statement
    qryQuizName.SQL.Text := 'SELECT QName FROM Quiz WHERE QuizID = :TakeQuizID';
    qryQuizName.Parameters.ParamByName('TakeQuizID').Value := TakeQuizID;

    // Open the query
    qryQuizName.Open;

    // Check if the query returned any records
    if not qryQuizName.IsEmpty then
    begin
      // Assign the quiz name to the appropriate component (e.g., TLabel)
      lblQuizName.Caption := qryQuizName.FieldByName('QName').AsString;
      lblQuizName.Left := (ClientWidth - lblQuizName.Width) div 2;
    end
    else
    begin
      // Handle the case where no quiz name is found for the given QuizID
      lblQuizName.Caption := 'Quiz Name Not Found';
      lblQuizName.Left := (ClientWidth - lblQuizName.Width) div 2;
    end;
  finally
    // Close the query
    qryQuizName.Close;
  end;
end;

procedure TCompleteQuiz.RetriveQuestions;
begin
  qryQuizQuestions.SQL.Text := 'SELECT Question FROM Questions WHERE QuizID = :TakeQuizID';
  qryQuizQuestions.Parameters.ParamByName('TakeQuizID').Value := TakeQuizID;
  qryQuizQuestions.Open;

  SetLength(Question, qryQuizQuestions.RecordCount);

  // Iterate through the result set and populate the QuizID array
    I := 0;

    if qryQuizQuestions.RecordCount = 0 then
    begin
    Question[I]:= '';
    end;
    while not qryQuizQuestions.Eof do
    begin
      Question[I] := qryQuizQuestions.FieldByName('Question').AsString;
      qryQuizQuestions.Next;
      Inc(I);
    end;
    // Close the query
    qryQuizQuestions.Close;
  end;

procedure TCompleteQuiz.DisplayQuiz(I:Integer);
begin
  lblQuestion.Caption := Question[I];
  lblQuestion.Width:= Round(ClientWidth*0.5);
  lblQuestion.WordWrap := true;
  lblQuestion.Left := (ClientWidth - lblQuestion.Width) div 2;
  lblQuestion.Top := Round(ClientHeight*0.18);

  CurrentQuestion :=  lblQuestion.Caption;
end;

procedure TCompleteQuiz.DisplayAnswers;
var
  Answers: array[0..3] of string;
  RandomIndex, I: Integer;
  Temp: string;
begin
  qryQuizAnswers.SQL.Text := 'SELECT A1, A2, A3, ACorrect FROM Questions WHERE Question = :CurrentQuestion';
  qryQuizAnswers.Parameters.ParamByName('CurrentQuestion').Value := CurrentQuestion;
  qryQuizAnswers.Open;

  if qryQuizAnswers.RecordCount = 0 then
    begin
    Answers[0] := '';
    Answers[1] := '';
    Answers[2] := '';
    Answers[3] := '';
    CorrectAnswer := '';
    end;

  Answers[0] := qryQuizAnswers.FieldByName('A1').AsString;
  Answers[1] := qryQuizAnswers.FieldByName('A2').AsString;
  Answers[2] := qryQuizAnswers.FieldByName('A3').AsString;
  Answers[3] := qryQuizAnswers.FieldByName('ACorrect').AsString;
  CorrectAnswer := qryQuizAnswers.FieldByName('ACorrect').AsString;

    // Randomize the order of the answers
    Randomize;
    for I := 0 to 3 do
    begin
      RandomIndex := Random(4);
      Temp := Answers[I];
      Answers[I] := Answers[RandomIndex];
      Answers[RandomIndex] := Temp;
    end;

    rbA1.Caption := Answers[0];
    rbA1.Width:= Round(ClientWidth*0.3);
    rbA1.WordWrap := true;
    rbA1.Left := (ClientWidth - lblQuestion.Width) div 2;
    rbA1.Top := Round(ClientHeight*0.33);

    rbA2.Caption := Answers[1];
    rbA2.Width:= Round(ClientWidth*0.3);
    rbA2.WordWrap := true;
    rbA2.Left := (ClientWidth - lblQuestion.Width) div 2;
    rbA2.Top := Round(ClientHeight*0.4);

    rbA3.Caption := Answers[2];
    rbA3.Width:= Round(ClientWidth*0.3);
    rbA3.WordWrap := true;
    rbA3.Left := (ClientWidth - lblQuestion.Width) div 2;
    rbA3.Top := Round(ClientHeight*0.47);

    rbA4.Caption := Answers[3];
    rbA4.Width:= Round(ClientWidth*0.3);
    rbA4.WordWrap := true;
    rbA4.Left := (ClientWidth - lblQuestion.Width) div 2;
    rbA4.Top := Round(ClientHeight*0.54);




 end;
procedure TCompleteQuiz.SubmitClick(Sender: TObject);
begin
  if Redo <> True then
  begin
   SubmitClickOriginalAttempt;
  end;

  if Redo = True then
  begin
  SubmitClickReattempt;
  end;
end;

procedure TCompleteQuiz.SubmitClickOriginalAttempt;
var
  UserInputA: string;
begin

  Inc(I);

  if (rbA1.Checked = True) or (rbA2.Checked = True) or (rbA3.Checked = True) or (rbA4.Checked = True) then
   begin
     if rbA1.Checked then
     begin
       UserInputA := rbA1.Caption;
     end
     else if rbA2.Checked then
      begin
       UserInputA := rbA2.Caption;
      end
    else if rbA3.Checked then
      begin
      UserInputA := rbA3.Caption;
      end
        else if rbA4.Checked then
      begin
        UserInputA := rbA4.Caption;
      end;

      if I < Length(Question) then
      begin
      CheckIfAnswerIsCorrect(UserInputA);

      rbA1.Checked := False;
      rbA2.Checked := False;
      rbA3.Checked := False;
      rbA4.Checked := False;
      DisplayQuiz(I);
      DisplayAnswers;
      end
    else
    begin
    CheckIfAnswerIsCorrect(UserInputA);
    QuizOutcome.CorrectCount:= CorrectCount;
    StopTimer;
    QuizOutcome.Show;
    CompleteQuiz.Hide;

    end;


  end
  else
  begin
    ShowMessage('Select an answer');
    rbA1.Checked := False;
      rbA2.Checked := False;
      rbA3.Checked := False;
      rbA4.Checked := False;
  end;
  end;

procedure TCompleteQuiz.SubmitClickReattempt;
var
  UserInputA: string;
begin

  if (rbA1.Checked = True) or (rbA2.Checked = True) or (rbA3.Checked = True) or (rbA4.Checked = True) then
   begin
     if rbA1.Checked then
     begin
       UserInputA := rbA1.Caption;
     end
     else if rbA2.Checked then
      begin
       UserInputA := rbA2.Caption;
      end
    else if rbA3.Checked then
      begin
      UserInputA := rbA3.Caption;
      end
        else if rbA4.Checked then
      begin
        UserInputA := rbA4.Caption;
      end;

      If (StackTop >= 0) then
      begin
      CheckIfAnswerIsCorrect(UserInputA);

      rbA1.Checked := False;
      rbA2.Checked := False;
      rbA3.Checked := False;
      rbA4.Checked := False;
      RetrieveIncorrectQuestion;
      end
      else
      begin
      CheckIfAnswerIsCorrect(UserInputA);
      Redo := False;
      rbA1.Checked := False;
      rbA2.Checked := False;
      rbA3.Checked := False;
      rbA4.Checked := False;
      StudentNavigation.Show;
      CompleteQuiz.Hide;
     end;
    end


  else
  begin
    ShowMessage('Select an answer');
    rbA1.Checked := False;
      rbA2.Checked := False;
      rbA3.Checked := False;
      rbA4.Checked := False;
  end;
  end;




procedure TCompleteQuiz.CheckIfAnswerIsCorrect(UserInputA: string);
var
  CurrentIncorrectQuestionID: Integer;
begin
    if Redo <> True then
    begin
    if UserInputA = CorrectAnswer then
    begin
    ShowMessage('Correct');
    CorrectCount := CorrectCount +1;
    end
    else
    begin
    ShowMessage('Incorrect');
    qryWrongAnswer.SQL.Text := 'SELECT QuestionID FROM Questions WHERE Question = :CurrentQuestion';
    qryWrongAnswer.Parameters.ParamByName('CurrentQuestion').Value := CurrentQuestion;
    qryWrongAnswer.Open;
    CurrentIncorrectQuestionID:=qryWrongAnswer.FieldByName('QuestionID').AsInteger;
    PushToStack(CurrentIncorrectQuestionID);
    end

    end;

    if Redo = True then
    begin
    if UserInputA = CorrectAnswer then
    begin
    ShowMessage('Correct');
    end
    else
    begin
    ShowMessage('Incorrect, Correct Answer: '+ CorrectAnswer);
    end
    end
    end;

procedure TCompleteQuiz.StartTimer;
begin
  FStartTime := Now;
  FQuizTime := 0; // Reset the quiz time
  tmrQuizTime.Enabled := True; // Start the timer
end;

procedure TCompleteQuiz.StopTimer;
begin
  FQuizTime := SecondsBetween(Now, FStartTime);
  QuizTimeSeconds := FQuizTime;
  QuizTime := Format('%d seconds', [FQuizTime]);
  QuizOutcome.QuizTime := QuizTime;
  QuizOutcome.QuizTimeSeconds := QuizTimeSeconds;
  FActive := False;
end;

procedure TCompleteQuiz.PushToStack(IncorrectQuestionID: Integer);
begin
  // Check if the stack is full
  if StackTop = MaxIncorrectQuestionsSize - 1 then
    raise Exception.Create('Stack overflow');

  // Increment the stack top and add the value to the stack
  Inc(StackTop);
  IncorrectQuestionsStack[StackTop] := IncorrectQuestionID;
end;

function TCompleteQuiz.PopFromStack: Integer;
begin
  // Check if the stack is empty
  if StackTop = -1 then
    raise Exception.Create('Stack underflow');

  // Get the value from the top of the stack and decrement the stack top
  Result := IncorrectQuestionsStack[StackTop];
  Dec(StackTop);
end;

procedure TCompleteQuiz.RetrieveIncorrectQuestion;
var
  CurrentQuestionID: Integer;
begin
  CurrentQuestionID := PopFromStack;
  qryQuizQuestions.SQL.Text := 'SELECT Question FROM Questions WHERE QuestionID = :CurrentQuestionID';
  qryQuizQuestions.Parameters.ParamByName('CurrentQuestionID').Value := CurrentQuestionID;
  qryQuizQuestions.Open;
  lblQuestion.Caption := qryQuizQuestions.FieldByName('Question').AsString;
  lblQuestion.Width:= Round(ClientWidth*0.5);
  lblQuestion.WordWrap := true;
  lblQuestion.Left := (ClientWidth - lblQuestion.Width) div 2;
  lblQuestion.Top := Round(ClientHeight*0.18);
  RetrieveRedoAnswers(CurrentQuestionID);

end;

procedure TCompleteQuiz.RetrieveRedoAnswers(CurrentQuestionID: Integer);
var
  Answers: array[0..3] of string;
  RandomIndex, I: Integer;
  Temp: string;
begin
 begin
  qryQuizAnswers.SQL.Text := 'SELECT A1, A2, A3, ACorrect FROM Questions WHERE QuestionID = :CurrentQuestionID';
  qryQuizAnswers.Parameters.ParamByName('CurrentQuestionID').Value := CurrentQuestionID;
  qryQuizAnswers.Open;

  if qryQuizAnswers.RecordCount = 0 then
    begin
    Answers[0] := '';
    Answers[1] := '';
    Answers[2] := '';
    Answers[3] := '';
    CorrectAnswer := '';
    end;

  Answers[0] := qryQuizAnswers.FieldByName('A1').AsString;
  Answers[1] := qryQuizAnswers.FieldByName('A2').AsString;
  Answers[2] := qryQuizAnswers.FieldByName('A3').AsString;
  Answers[3] := qryQuizAnswers.FieldByName('ACorrect').AsString;
  CorrectAnswer := qryQuizAnswers.FieldByName('ACorrect').AsString;

    // Randomize the order of the answers
    Randomize;
    for I := 0 to 3 do
    begin
      RandomIndex := Random(4);
      Temp := Answers[I];
      Answers[I] := Answers[RandomIndex];
      Answers[RandomIndex] := Temp;
    end;

    rbA1.Caption := Answers[0];
    rbA1.Width:= Round(ClientWidth*0.3);
    rbA1.WordWrap := true;
    rbA1.Left := (ClientWidth - lblQuestion.Width) div 2;
    rbA1.Top := Round(ClientHeight*0.33);

    rbA2.Caption := Answers[1];
    rbA2.Width:= Round(ClientWidth*0.3);
    rbA2.WordWrap := true;
    rbA2.Left := (ClientWidth - lblQuestion.Width) div 2;
    rbA2.Top := Round(ClientHeight*0.4);

    rbA3.Caption := Answers[2];
    rbA3.Width:= Round(ClientWidth*0.3);
    rbA3.WordWrap := true;
    rbA3.Left := (ClientWidth - lblQuestion.Width) div 2;
    rbA3.Top := Round(ClientHeight*0.47);

    rbA4.Caption := Answers[3];
    rbA4.Width:= Round(ClientWidth*0.3);
    rbA4.WordWrap := true;
    rbA4.Left := (ClientWidth - lblQuestion.Width) div 2;
    rbA4.Top := Round(ClientHeight*0.54);
end;
end;

end.
