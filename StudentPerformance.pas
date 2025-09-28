unit StudentPerformance;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, jpeg, ExtCtrls, StdCtrls, Grids, DBGrids, DB, ADODB;

type
  TPerformanceStudent = class(TForm)
    imgBg: TImage;
    imgQuit: TImage;
    imgBackbtn: TImage;
    lblQuizHistory: TLabel;
    dbgrdQuizHistory: TDBGrid;
    dsQuizHistory: TDataSource;
    qryQuizHistory: TADOQuery;
    qryStudentID: TADOQuery;
    qryPerformance: TADOQuery;
    qryQuiz: TADOQuery;
    qrySubject: TADOQuery;
    qryTotalTime: TADOQuery;
    lblTimeSpent: TLabel;
    lblPredictedGrades: TLabel;
    scrlbxPredictedGrades: TScrollBox;
    qryPredictedGrades: TADOQuery;
    procedure FormCreate(Sender: TObject);
    procedure AddFontResourceAndBroadcast;
    procedure imgQuitClick(Sender: TObject);
    procedure imgBackbtnClick(Sender: TObject);
    procedure OnShow(Sender: TObject);
    procedure GetStudentID;
    procedure UpdateTable;
    procedure CalculateTotalTime;
    procedure FormatTime(totalSeconds: Integer; var formattedTime: string);
    procedure CalculateTotalPredictedGradeBiology;
    procedure CalculateTotalPredictedGradeMaths;
    procedure FillScrollBoxWithImages;
    procedure CalculateTotalPredictedGradeEnglish;
    procedure CalculateTotalPredictedGradeChemistry;
    procedure CalculateTotalPredictedGradePhysics;
    procedure CalculateTotalPredictedGradeComputerScience;
    procedure CalculateTotalPredictedGradeSpanish;
    procedure CalculateTotalPredictedGradeGerman;
    procedure GenerateRevisionAdviceMaths;
    procedure GenerateRevisionAdviceEnglish;
    procedure GenerateRevisionAdviceBiology;
    procedure GenerateRevisionAdviceChemistry;
    procedure GenerateRevisionAdvicePhysics;
    procedure GenerateRevisionAdviceComputerScience;
    procedure GenerateRevisionAdviceSpanish;
    procedure GenerateRevisionAdviceGerman;



  private
    { Private declarations }
    FCurrentUserID: Integer;
  public
    { Public declarations }
    property CurrentUserID: Integer read FCurrentUserID write FCurrentUserID;
  end;

var
  PerformanceStudent: TPerformanceStudent;
  NumColumns: Integer;
  ColumnWidth: Integer;
  CurrentStudentID: Integer;
  TotalSeconds: Integer;
  formattedTime: string;
  SubjectLabels :array[1..8] of TLabel;
  RevisionAdvice:array[1..8] of TLabel;
  PredictedGradeLabels :array[1..8] of TLabel;
  BioPredictedGradeScore: string;
  MathsPredictedGradeScore: string;
  EnglishPredictedGradeScore: string;
  ChemistryPredictedGradeScore: string;
  PhysicsPredictedGradeScore: string;
  ComputerSciencePredictedGradeScore: string;
  SpanishPredictedGradeScore: string;
  GermanPredictedGradeScore: string;
  MathsPredictedGrade:string;
  EnglishPredictedGrade:string;
  BioPredictedGrade:string;
  ChemistryPredictedGrade:string;
  PhysicsPredictedGrade:string;
  ComputerSciencePredictedGrade:string;
  SpanishPredictedGrade:string;
  GermanPredictedGrade:string;

implementation

uses CustomDialog, NavigationPageStudent;

{$R *.dfm}

procedure TPerformanceStudent.FormCreate(Sender: TObject);
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

  //lblQuizHistory: appearence on page
  lblQuizHistory.Font.Name := 'Arial Rounded MT Bold';
  lblQuizHistory.Font.Size := Round(ClientWidth * 0.03);
  lblQuizHistory.Font.Color := RGB(236,236,236);
  lblQuizHistory.Left := Round(ClientWidth * 0.16);
  lblQuizHistory.Top := Round(ClientHeight * 0.05);

  //dbgrdQuizHistory: appereance on page
  dbgrdQuizHistory.Top := Round(ClientHeight * 0.2);
  dbgrdQuizHistory.Left := Round(ClientWidth * 0.05);
  dbgrdQuizHistory.Width := Round(ClientWidth * 0.4);
  dbgrdQuizHistory.Height := Round(ClientHeight * 0.6);

  // Assuming dbgrdQuizHistory has 5 columns
  NumColumns := 5;

  // Calculate the width of each column
  ColumnWidth := Round((dbgrdQuizHistory.Width / NumColumns)-8);

  // Set the width of each column
  dbgrdQuizHistory.Columns[0].Width := ColumnWidth;
  dbgrdQuizHistory.Columns[1].Width := ColumnWidth;
  dbgrdQuizHistory.Columns[2].Width := ColumnWidth;
  dbgrdQuizHistory.Columns[3].Width := ColumnWidth;
  dbgrdQuizHistory.Columns[4].Width := ColumnWidth;

 //lblTimeSpent: appereance on page
  lblTimeSpent.Font.Name := 'Arial Rounded MT Bold';
  lblTimeSpent.Font.Size := Round(ClientWidth * 0.025);
  lblTimeSpent.Font.Color := RGB(156,179,128);
  lblTimeSpent.Left := Round(ClientWidth * 0.55);
  lblTimeSpent.Top := Round(ClientHeight * 0.05);

  //lblPredictedGrades: appereance on page
  lblPredictedGrades.Font.Name := 'Arial Rounded MT Bold';
  lblPredictedGrades.Font.Size := Round(ClientWidth * 0.02);
  lblPredictedGrades.Font.Color := RGB(156,179,128);
  lblPredictedGrades.Left := Round(ClientWidth * 0.625);
  lblPredictedGrades.Top := Round(ClientHeight * 0.4);

  //scrlbxPredictedGrades: appereance on page
  scrlbxPredictedGrades.Height := Round(ClientHeight * 0.4);
  scrlbxPredictedGrades.Width := Round(ClientWidth * 0.4);
  scrlbxPredictedGrades.Top := Round(ClientHeight * 0.5);
  scrlbxPredictedGrades.Left := Round(ClientWidth * 0.55);

  end;

  procedure TPerformanceStudent.AddFontResourceAndBroadcast;
  begin
    if AddFontResource('Revision System Project\FONTS\arial-rounded-mt-bold.ttf"') > 0 then
      SendMessage(HWND_BROADCAST, WM_FONTCHANGE, 0, 0);
  end;

  //Procedure for exiting the program upon pressing the exit button

  procedure TPerformanceStudent.imgQuitClick(Sender: TObject);
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

  procedure TPerformanceStudent.imgBackbtnClick(Sender: TObject);
  begin
    TotalSeconds := 0;
    StudentNavigation.Show;
    PerformanceStudent.Hide;

  end;

  procedure TPerformanceStudent.OnShow(Sender: TObject);
  begin
    GetStudentID;
    UpdateTable;
    CalculateTotalTime;
    lblTimeSpent.Caption := 'Total time spent doing quizzes:  ' + formattedTime;
    lblTimeSpent.Width := Round(ClientWidth  *0.4);
    lblTimeSpent.WordWrap:=  True;
    FillScrollBoxWithImages;
    SubjectLabels[1].Caption := 'Maths';
    SubjectLabels[2].Caption := 'English';
    SubjectLabels[3].Caption := 'Biology';
    SubjectLabels[4].Caption := 'Chemistry';
    SubjectLabels[5].Caption := 'Physics';
    SubjectLabels[6].Caption := 'Computer Science';
    SubjectLabels[7].Caption := 'Spanish';
    SubjectLabels[8].Caption := 'German';

    CalculateTotalPredictedGradeMaths;
    CalculateTotalPredictedGradeEnglish;
    CalculateTotalPredictedGradeBiology;
    CalculateTotalPredictedGradeChemistry;
    CalculateTotalPredictedGradePhysics;
    CalculateTotalPredictedGradeComputerScience;
    CalculateTotalPredictedGradeSpanish;
    CalculateTotalPredictedGradeGerman;


    PredictedGradeLabels[1].Caption := MathsPredictedGradeScore;
    PredictedGradeLabels[2].Caption := EnglishPredictedGradeScore;
    PredictedGradeLabels[3].Caption := BioPredictedGradeScore;
    PredictedGradeLabels[4].Caption := ChemistryPredictedGradeScore;
    PredictedGradeLabels[5].Caption := PhysicsPredictedGradeScore;
    PredictedGradeLabels[6].Caption := ComputerSciencePredictedGradeScore;
    PredictedGradeLabels[7].Caption := SpanishPredictedGradeScore;
    PredictedGradeLabels[8].Caption := GermanPredictedGradeScore;

    GenerateRevisionAdviceMaths;
    GenerateRevisionAdviceEnglish;
    GenerateRevisionAdviceBiology;
    GenerateRevisionAdviceChemistry;
    GenerateRevisionAdvicePhysics;
    GenerateRevisionAdviceComputerScience;
    GenerateRevisionAdviceSpanish;
    GenerateRevisionAdviceGerman;

  end;

  procedure TPerformanceStudent.GetStudentID;
  begin
   qryStudentID.SQL.Text := 'SELECT StudentID FROM Student WHERE MainUserID = :UserID';
  qryStudentID.Parameters.ParamByName('UserID').Value := CurrentUserID;
  qryStudentID.Open;
  CurrentStudentID := qryStudentID.FieldByName('StudentID').AsInteger;
  end;

  procedure TPerformanceStudent.UpdateTable;
begin
  qryQuizHistory.SQL.Text := 'SELECT Result.QuizID, Score, Result.SubjectID, Grade, TimeSpent, QName, SubName, StudentID ' +
   ' FROM Subject INNER JOIN (Result INNER JOIN Quiz ON Result.QuizID = Quiz.QuizID) ON (Quiz.SubjectID = Subject.SubjectID) AND (Subject.SubjectID = Result.SubjectID)'+
   ' WHERE Result.StudentID = :UserStudentID';


  {
  'SELECT Result.QuizID, Result.SubjectID, Result.Score, Result.Grade, Quiz.QName, Quiz.SubjectID, Subject.SubName ' +
  'FROM Result ' +
  'INNER JOIN Quiz ON Result.QuizID = Quiz.QuizID ' +
  'INNER JOIN Subject ON Result.SubjectID = Subject.SubjectID ' +
  'WHERE Result.StudentID = :UserStudentID';
   }

  qryQuizHistory.Parameters.ParamByName('UserStudentID').Value := CurrentStudentID;
  qryQuizHistory.Open;
  dbgrdQuizHistory.Refresh;
  dbgrdQuizHistory.Update;
end;

procedure TPerformanceStudent.CalculateTotalTime;
begin
qryTotalTime.SQL.Text := 'SELECT TimeSpent FROM Result WHERE StudentID = :UserStudentID';
qryTotalTime.Parameters.ParamByName('UserStudentID').Value := CurrentStudentID;
qryTotalTime.Open;
  while not qryTotalTime.Eof do
  begin
    totalSeconds := totalSeconds + qryTotalTime.FieldByName('TimeSpent').AsInteger;
    qryTotalTime.Next;
  end;

  qryTotalTime.Close;
  FormatTime(totalSeconds, formattedTime);
end;

procedure TPerformanceStudent.FormatTime(totalSeconds: Integer; var formattedTime: string);
var
  hours, minutes, seconds: Integer;
begin
  // Calculate hours, minutes, and remaining seconds
  hours := totalSeconds div 3600;
  totalSeconds := totalSeconds mod 3600;
  minutes := totalSeconds div 60;
  seconds := totalSeconds mod 60;

  // Format the time as "hh:mm:ss"
  formattedTime := Format('%2.2d:%2.2d:%2.2d', [hours, minutes, seconds]);
end;

procedure TPerformanceStudent.CalculateTotalPredictedGradeMaths;
var
 NumOfResults: Integer;
 totalScore: Integer;
 AverageMathsScore:Integer;
  begin
    qryPredictedGrades.SQL.Text := 'SELECT Score, SubjectID FROM Result WHERE StudentID = :UserStudentID and SubjectID = :SubjectID';
    qryPredictedGrades.Parameters.ParamByName('UserStudentID').Value := CurrentStudentID;
    qryPredictedGrades.Parameters.ParamByName('SubjectID').Value := 'M01';
    qryPredictedGrades.open;
    NumOfResults:=0;

    if not qryPredictedGrades.Eof then
  begin
    totalScore := 0; // Initialize totalScore and NumOfResults before calculating
    NumOfResults := 0;

    while not qryPredictedGrades.Eof do
    begin
      totalScore := totalScore + qryPredictedGrades.FieldByName('Score').AsInteger;
      NumOfResults := NumOfResults + 1;
      qryPredictedGrades.Next; // Move to the next record in the dataset
    end;

    AverageMathsScore := Round(totalScore / NumOfResults);

    qryPredictedGrades.SQL.Text := 'SELECT PredictedGrade FROM Grades WHERE AverageMark = :MathsScoreUser';
    qryPredictedGrades.Parameters.ParamByName('MathsScoreUser').Value := AverageMathsScore;
    qryPredictedGrades.Open;
    MathsPredictedGrade := qryPredictedGrades.FieldByName('PredictedGrade').AsString;



    MathsPredictedGradeScore := 'Your average grade is: ' + MathsPredictedGrade;
  end
  else
  begin
    MathsPredictedGradeScore := 'Not enough data';
  end;
  end;

  procedure TPerformanceStudent.CalculateTotalPredictedGradeEnglish;
var
 NumOfResults: Integer;
 totalScore: Integer;
 AverageEnglishScore:Integer;
  begin
    qryPredictedGrades.SQL.Text := 'SELECT Score, SubjectID FROM Result WHERE StudentID = :UserStudentID and SubjectID = :SubjectID';
    qryPredictedGrades.Parameters.ParamByName('UserStudentID').Value := CurrentStudentID;
    qryPredictedGrades.Parameters.ParamByName('SubjectID').Value := 'E01';
    qryPredictedGrades.open;
    NumOfResults:=0;

    if not qryPredictedGrades.Eof then
  begin
    totalScore := 0; // Initialize totalScore and NumOfResults before calculating
    NumOfResults := 0;

    while not qryPredictedGrades.Eof do
    begin
      totalScore := totalScore + qryPredictedGrades.FieldByName('Score').AsInteger;
      NumOfResults := NumOfResults + 1;
      qryPredictedGrades.Next; // Move to the next record in the dataset
    end;

    AverageEnglishScore := Round(totalScore / NumOfResults);

    qryPredictedGrades.SQL.Text := 'SELECT PredictedGrade FROM Grades WHERE AverageMark = :EnglishScoreUser';
    qryPredictedGrades.Parameters.ParamByName('EnglishScoreUser').Value := AverageEnglishScore;
    qryPredictedGrades.Open;
    EnglishPredictedGrade := qryPredictedGrades.FieldByName('PredictedGrade').AsString;



    EnglishPredictedGradeScore := 'Your average grade is: ' + EnglishPredictedGrade;
  end
  else
  begin
    EnglishPredictedGradeScore := 'Not enough data';
  end;
  end;

procedure TPerformanceStudent.CalculateTotalPredictedGradeBiology;
var
 NumOfResults: Integer;
 totalScore: Integer;
 AverageBioScore:Integer;
  begin
    qryPredictedGrades.SQL.Text := 'SELECT Score, SubjectID FROM Result WHERE StudentID = :UserStudentID and SubjectID = :SubjectID';
    qryPredictedGrades.Parameters.ParamByName('UserStudentID').Value := CurrentStudentID;
    qryPredictedGrades.Parameters.ParamByName('SubjectID').Value := 'B01';
    qryPredictedGrades.open;
    NumOfResults:=0;

    if not qryPredictedGrades.Eof then
  begin
    totalScore := 0; // Initialize totalScore and NumOfResults before calculating
    NumOfResults := 0;

    while not qryPredictedGrades.Eof do
    begin
      totalScore := totalScore + qryPredictedGrades.FieldByName('Score').AsInteger;
      NumOfResults := NumOfResults + 1;
      qryPredictedGrades.Next; // Move to the next record in the dataset
    end;

    AverageBioScore := Round(totalScore / NumOfResults);

    qryPredictedGrades.SQL.Text := 'SELECT PredictedGrade FROM Grades WHERE AverageMark = :BioScoreUser';
    qryPredictedGrades.Parameters.ParamByName('BioScoreUser').Value := AverageBioScore;
    qryPredictedGrades.Open;
    BioPredictedGrade := qryPredictedGrades.FieldByName('PredictedGrade').AsString;



    BioPredictedGradeScore := 'Your average grade is: ' + BioPredictedGrade;
  end
  else
  begin
    BioPredictedGradeScore := 'Not enough data';
  end;
  end;

  procedure TPerformanceStudent.CalculateTotalPredictedGradeChemistry;
var
 NumOfResults: Integer;
 totalScore: Integer;
 AverageChemistryScore:Integer;
  begin
    qryPredictedGrades.SQL.Text := 'SELECT Score, SubjectID FROM Result WHERE StudentID = :UserStudentID and SubjectID = :SubjectID';
    qryPredictedGrades.Parameters.ParamByName('UserStudentID').Value := CurrentStudentID;
    qryPredictedGrades.Parameters.ParamByName('SubjectID').Value := 'C01';
    qryPredictedGrades.open;
    NumOfResults:=0;

    if not qryPredictedGrades.Eof then
  begin
    totalScore := 0; // Initialize totalScore and NumOfResults before calculating
    NumOfResults := 0;

    while not qryPredictedGrades.Eof do
    begin
      totalScore := totalScore + qryPredictedGrades.FieldByName('Score').AsInteger;
      NumOfResults := NumOfResults + 1;
      qryPredictedGrades.Next; // Move to the next record in the dataset
    end;

    AverageChemistryScore := Round(totalScore / NumOfResults);

    qryPredictedGrades.SQL.Text := 'SELECT PredictedGrade FROM Grades WHERE AverageMark = :ChemistryScoreUser';
    qryPredictedGrades.Parameters.ParamByName('ChemistryScoreUser').Value := AverageChemistryScore;
    qryPredictedGrades.Open;
    ChemistryPredictedGrade := qryPredictedGrades.FieldByName('PredictedGrade').AsString;



    ChemistryPredictedGradeScore := 'Your average grade is: ' + ChemistryPredictedGrade;
  end
  else
  begin
    ChemistryPredictedGradeScore := 'Not enough data';
  end;
  end;

  procedure TPerformanceStudent.CalculateTotalPredictedGradePhysics;
var
 NumOfResults: Integer;
 totalScore: Integer;
 AveragePhysicsScore:Integer;
  begin
    qryPredictedGrades.SQL.Text := 'SELECT Score, SubjectID FROM Result WHERE StudentID = :UserStudentID and SubjectID = :SubjectID';
    qryPredictedGrades.Parameters.ParamByName('UserStudentID').Value := CurrentStudentID;
    qryPredictedGrades.Parameters.ParamByName('SubjectID').Value := 'P01';
    qryPredictedGrades.open;
    NumOfResults:=0;

    if not qryPredictedGrades.Eof then
  begin
    totalScore := 0; // Initialize totalScore and NumOfResults before calculating
    NumOfResults := 0;

    while not qryPredictedGrades.Eof do
    begin
      totalScore := totalScore + qryPredictedGrades.FieldByName('Score').AsInteger;
      NumOfResults := NumOfResults + 1;
      qryPredictedGrades.Next; // Move to the next record in the dataset
    end;

    AveragePhysicsScore := Round(totalScore / NumOfResults);

    qryPredictedGrades.SQL.Text := 'SELECT PredictedGrade FROM Grades WHERE AverageMark = :PhysicsScoreUser';
    qryPredictedGrades.Parameters.ParamByName('PhysicsScoreUser').Value := AveragePhysicsScore;
    qryPredictedGrades.Open;
    PhysicsPredictedGrade := qryPredictedGrades.FieldByName('PredictedGrade').AsString;



    PhysicsPredictedGradeScore := 'Your average grade is: ' + PhysicsPredictedGrade;
  end
  else
  begin
    PhysicsPredictedGradeScore := 'Not enough data';
  end;
  end;

  procedure TPerformanceStudent.CalculateTotalPredictedGradeComputerScience;
var
 NumOfResults: Integer;
 totalScore: Integer;
 AverageComputerScienceScore:Integer;
  begin
    qryPredictedGrades.SQL.Text := 'SELECT Score, SubjectID FROM Result WHERE StudentID = :UserStudentID and SubjectID = :SubjectID';
    qryPredictedGrades.Parameters.ParamByName('UserStudentID').Value := CurrentStudentID;
    qryPredictedGrades.Parameters.ParamByName('SubjectID').Value := 'CS01';
    qryPredictedGrades.open;
    NumOfResults:=0;

    if not qryPredictedGrades.Eof then
  begin
    totalScore := 0; // Initialize totalScore and NumOfResults before calculating
    NumOfResults := 0;

    while not qryPredictedGrades.Eof do
    begin
      totalScore := totalScore + qryPredictedGrades.FieldByName('Score').AsInteger;
      NumOfResults := NumOfResults + 1;
      qryPredictedGrades.Next; // Move to the next record in the dataset
    end;

    AverageComputerScienceScore := Round(totalScore / NumOfResults);

    qryPredictedGrades.SQL.Text := 'SELECT PredictedGrade FROM Grades WHERE AverageMark = :ComputerScienceScoreUser';
    qryPredictedGrades.Parameters.ParamByName('ComputerScienceScoreUser').Value := AverageComputerScienceScore;
    qryPredictedGrades.Open;
    ComputerSciencePredictedGrade := qryPredictedGrades.FieldByName('PredictedGrade').AsString;



    ComputerSciencePredictedGradeScore := 'Your average grade is: ' + ComputerSciencePredictedGrade;
  end
  else
  begin
    ComputerSciencePredictedGradeScore := 'Not enough data';
  end;
  end;

  procedure TPerformanceStudent.CalculateTotalPredictedGradeSpanish;
var
 NumOfResults: Integer;
 totalScore: Integer;
 AverageSpanishScore:Integer;
  begin
    qryPredictedGrades.SQL.Text := 'SELECT Score, SubjectID FROM Result WHERE StudentID = :UserStudentID and SubjectID = :SubjectID';
    qryPredictedGrades.Parameters.ParamByName('UserStudentID').Value := CurrentStudentID;
    qryPredictedGrades.Parameters.ParamByName('SubjectID').Value := 'S01';
    qryPredictedGrades.open;
    NumOfResults:=0;

    if not qryPredictedGrades.Eof then
  begin
    totalScore := 0; // Initialize totalScore and NumOfResults before calculating
    NumOfResults := 0;

    while not qryPredictedGrades.Eof do
    begin
      totalScore := totalScore + qryPredictedGrades.FieldByName('Score').AsInteger;
      NumOfResults := NumOfResults + 1;
      qryPredictedGrades.Next; // Move to the next record in the dataset
    end;

    AverageSpanishScore := Round(totalScore / NumOfResults);

    qryPredictedGrades.SQL.Text := 'SELECT PredictedGrade FROM Grades WHERE AverageMark = :SpanishScoreUser';
    qryPredictedGrades.Parameters.ParamByName('SpanishScoreUser').Value := AverageSpanishScore;
    qryPredictedGrades.Open;
    SpanishPredictedGrade := qryPredictedGrades.FieldByName('PredictedGrade').AsString;



    SpanishPredictedGradeScore := 'Your average grade is: ' + SpanishPredictedGrade;
  end
  else
  begin
    SpanishPredictedGradeScore := 'Not enough data';
  end;
  end;

  procedure TPerformanceStudent.CalculateTotalPredictedGradeGerman;
var
 NumOfResults: Integer;
 totalScore: Integer;
 AverageGermanScore:Integer;
  begin
    qryPredictedGrades.SQL.Text := 'SELECT Score, SubjectID FROM Result WHERE StudentID = :UserStudentID and SubjectID = :SubjectID';
    qryPredictedGrades.Parameters.ParamByName('UserStudentID').Value := CurrentStudentID;
    qryPredictedGrades.Parameters.ParamByName('SubjectID').Value := 'G01';
    qryPredictedGrades.open;
    NumOfResults:=0;

    if not qryPredictedGrades.Eof then
  begin
    totalScore := 0; // Initialize totalScore and NumOfResults before calculating
    NumOfResults := 0;

    while not qryPredictedGrades.Eof do
    begin
      totalScore := totalScore + qryPredictedGrades.FieldByName('Score').AsInteger;
      NumOfResults := NumOfResults + 1;
      qryPredictedGrades.Next; // Move to the next record in the dataset
    end;

    AverageGermanScore := Round(totalScore / NumOfResults);

    qryPredictedGrades.SQL.Text := 'SELECT PredictedGrade FROM Grades WHERE AverageMark = :GermanScoreUser';
    qryPredictedGrades.Parameters.ParamByName('GermanScoreUser').Value := AverageGermanScore;
    qryPredictedGrades.Open;
    GermanPredictedGrade := qryPredictedGrades.FieldByName('PredictedGrade').AsString;



    GermanPredictedGradeScore := 'Your average grade is: ' + GermanPredictedGrade;
  end
  else
  begin
    GermanPredictedGradeScore := 'Not enough data';
  end;
  end;

procedure TPerformanceStudent.FillScrollBoxWithImages;
var
  ImageWidth, ImageHeight, Padding, Gap, LabelHeight: Integer;
  i: Integer;
  ImagePanel: array[1..8] of TPanel;
  Image: array[1..8] of TImage;
begin
  // Calculate image dimensions, padding, gap between images, and label height
  ImageWidth := Round(scrlbxPredictedGrades.Width * 0.95); // Adjusted width to be shorter
  ImageHeight := Round(ClientHeight * 0.2); // 0.2 times the client height
  Padding := 10; // Padding between image and scroll box borders
  Gap := 10; // Gap between images
  LabelHeight := 20; // Height of each label

  // Clear any existing images and labels
  for i := scrlbxPredictedGrades.ControlCount - 1 downto 0 do
  begin
    if scrlbxPredictedGrades.Controls[i] is TPanel then
      scrlbxPredictedGrades.Controls[i].Free;
  end;

  // Generate 8 images and labels
  for i := 1 to 8 do
  begin
    // Create and position the image panel
    ImagePanel[i] := TPanel.Create(scrlbxPredictedGrades);
    ImagePanel[i].Name := 'ImagePanel' + IntToStr(i); // Unique panel name
    ImagePanel[i].Parent := scrlbxPredictedGrades;
    ImagePanel[i].Width := ImageWidth;
    ImagePanel[i].Height := ImageHeight;
    ImagePanel[i].Left := Padding;
    ImagePanel[i].Top := Padding + ((ImageHeight + Gap) * (i - 1)); // Position the panel with gap

    // Create and position the image inside the panel
    Image[i] := TImage.Create(ImagePanel[i]);
    Image[i].Name := 'Image' + IntToStr(i); // Unique image name
    Image[i].Parent := ImagePanel[i];
    Image[i].Align := alClient;
    Image[i].Stretch := True;
    Image[i].Picture.LoadFromFile('D:\School stuff\Revision System Project\IMG\DarkGrey Quiz Box.jpg');

    // Create and position the subject label inside the panel
    SubjectLabels[i] := TLabel.Create(ImagePanel[i]);
    SubjectLabels[i].Parent := ImagePanel[i];
    SubjectLabels[i].Left := Padding;
    SubjectLabels[i].Top := Padding + Round(2.5* LabelHeight); // Position the label above the image
    SubjectLabels[i].Width := ImageWidth;
    SubjectLabels[i].Height := LabelHeight;
    SubjectLabels[i].Font.Size := Round(ClientWidth * 0.012);
    SubjectLabels[i].Font.Name := 'Arial Rounded MT Bold';
    SubjectLabels[i].Transparent := True;
    SubjectLabels[i].Caption := 'lblSub' + IntToStr(i); // Adjusted label caption
    SubjectLabels[i].Alignment := taCenter;

    // Create and position the predicted grade label inside the panel
    PredictedGradeLabels[i] := TLabel.Create(ImagePanel[i]);
    PredictedGradeLabels[i].Parent := ImagePanel[i];
    PredictedGradeLabels[i].Left := Padding;
    PredictedGradeLabels[i].Top := Padding + Round(5.5* LabelHeight);
    PredictedGradeLabels[i].Transparent := True; // Position the label above the image
    PredictedGradeLabels[i].Width := ImageWidth;
    PredictedGradeLabels[i].Height := LabelHeight;
    PredictedGradeLabels[i].Font.Size := Round(ClientWidth * 0.012);
    PredictedGradeLabels[i].Font.Name := 'Arial Rounded MT Bold';
    PredictedGradeLabels[i].Caption := 'lblPredictedGrade' + IntToStr(i); // Adjusted label caption
    PredictedGradeLabels[i].Alignment := taCenter;

    RevisionAdvice[i] := TLabel.Create(ImagePanel[i]);
    RevisionAdvice[i].Parent := ImagePanel[i];
    RevisionAdvice[i].Left := Padding;
    RevisionAdvice[i].Top := Padding + (8* LabelHeight);
    RevisionAdvice[i].Transparent := True; // Position the label above the image
    RevisionAdvice[i].Width := ImageWidth;
    RevisionAdvice[i].Height := LabelHeight;
    RevisionAdvice[i].Font.Size := Round(ClientWidth * 0.01);
    RevisionAdvice[i].Font.Name := 'Arial Rounded MT Bold';
    RevisionAdvice[i].Caption := 'lblRevisionAdvice' + IntToStr(i); // Adjusted label caption
    RevisionAdvice[i].Alignment := taCenter;
  end;
end;

procedure TPerformanceStudent.GenerateRevisionAdviceMaths;
begin
  if (MathsPredictedGrade = 'U') or (MathsPredictedGrade = 'E') or (MathsPredictedGrade = 'D') then
  begin
   RevisionAdvice[1].Caption:= 'Do at least 5 hours of revision per week to improve grade'
  end;

  if (MathsPredictedGrade = 'C') or (MathsPredictedGrade = 'B') then
  begin
   RevisionAdvice[1].Caption:= 'Do at least 3 hours of revision per week to improve grade'
  end;

  if (MathsPredictedGrade = 'A') or (MathsPredictedGrade = 'A*') then
  begin
   RevisionAdvice[1].Caption:= 'Minimal Revision needed: 1-2 hours per week'
  end;

  if (MathsPredictedGradeScore = 'Not enough data') then
  begin
   RevisionAdvice[1].Caption:= 'Complete more quizzes for a prediciton'
  end;
end;

procedure TPerformanceStudent.GenerateRevisionAdviceEnglish;
begin
  if (EnglishPredictedGrade = 'U') or (EnglishPredictedGrade = 'E') or (EnglishPredictedGrade = 'D') then
  begin
   RevisionAdvice[2].Caption:= 'Do at least 5 hours of revision per week to improve grade'
  end;

  if (EnglishPredictedGrade = 'C') or (EnglishPredictedGrade = 'B') then
  begin
   RevisionAdvice[2].Caption:= 'Do at least 3 hours of revision per week to improve grade'
  end;

  if (EnglishPredictedGrade = 'A') or (EnglishPredictedGrade = 'A*') then
  begin
   RevisionAdvice[2].Caption:= 'Minimal Revision needed: 1-2 hours per week'
  end;

  if (EnglishPredictedGradeScore = 'Not enough data') then
  begin
   RevisionAdvice[2].Caption:= 'Complete more quizzes for a prediciton'
  end;
end;

procedure TPerformanceStudent.GenerateRevisionAdviceBiology;
begin
  if (BioPredictedGrade = 'U') or (BioPredictedGrade = 'E') or (BioPredictedGrade = 'D') then
  begin
   RevisionAdvice[3].Caption:= 'Do at least 5 hours of revision per week to improve grade'
  end;

  if (BioPredictedGrade = 'C') or (BioPredictedGrade = 'B') then
  begin
   RevisionAdvice[3].Caption:= 'Do at least 3 hours of revision per week to improve grade'
  end;

  if (BioPredictedGrade = 'A') or (BioPredictedGrade = 'A*') then
  begin
   RevisionAdvice[3].Caption:= 'Minimal Revision needed: 1-2 hours per week'
  end;

  if (BioPredictedGradeScore = 'Not enough data') then
  begin
   RevisionAdvice[3].Caption:= 'Complete more quizzes for a prediciton'
  end;
end;

procedure TPerformanceStudent.GenerateRevisionAdviceChemistry;
begin
  if (ChemistryPredictedGrade = 'U') or (ChemistryPredictedGrade = 'E') or (ChemistryPredictedGrade = 'D') then
  begin
   RevisionAdvice[4].Caption:= 'Do at least 5 hours of revision per week to improve grade'
  end;

  if (ChemistryPredictedGrade = 'C') or (ChemistryPredictedGrade = 'B') then
  begin
   RevisionAdvice[4].Caption:= 'Do at least 3 hours of revision per week to improve grade'
  end;

  if (ChemistryPredictedGrade = 'A') or (ChemistryPredictedGrade = 'A*') then
  begin
   RevisionAdvice[4].Caption:= 'Minimal Revision needed: 1-2 hours per week'
  end;

  if (ChemistryPredictedGradeScore = 'Not enough data') then
  begin
   RevisionAdvice[4].Caption:= 'Complete more quizzes for a prediciton'
  end;
end;

procedure TPerformanceStudent.GenerateRevisionAdvicePhysics;
begin
  if (PhysicsPredictedGrade = 'U') or (PhysicsPredictedGrade = 'E') or (PhysicsPredictedGrade = 'D') then
  begin
   RevisionAdvice[5].Caption:= 'Do at least 5 hours of revision per week to improve grade'
  end;

  if (PhysicsPredictedGrade = 'C') or (PhysicsPredictedGrade = 'B') then
  begin
   RevisionAdvice[5].Caption:= 'Do at least 3 hours of revision per week to improve grade'
  end;

  if (PhysicsPredictedGrade = 'A') or (PhysicsPredictedGrade = 'A*') then
  begin
   RevisionAdvice[5].Caption:= 'Minimal Revision needed: 1-2 hours per week'
  end;

  if (PhysicsPredictedGradeScore = 'Not enough data') then
  begin
   RevisionAdvice[5].Caption:= 'Complete more quizzes for a prediciton'
  end;
end;

procedure TPerformanceStudent.GenerateRevisionAdviceComputerScience;
begin
  if (ComputerSciencePredictedGrade = 'U') or (ComputerSciencePredictedGrade = 'E') or (ComputerSciencePredictedGrade = 'D') then
  begin
   RevisionAdvice[6].Caption:= 'Do at least 5 hours of revision per week to improve grade'
  end;

  if (ComputerSciencePredictedGrade = 'C') or (ComputerSciencePredictedGrade = 'B') then
  begin
   RevisionAdvice[6].Caption:= 'Do at least 3 hours of revision per week to improve grade'
  end;

  if (ComputerSciencePredictedGrade = 'A') or (ComputerSciencePredictedGrade = 'A*') then
  begin
   RevisionAdvice[6].Caption:= 'Minimal Revision needed: 1-2 hours per week'
  end;

  if (ComputerSciencePredictedGradeScore = 'Not enough data') then
  begin
   RevisionAdvice[6].Caption:= 'Complete more quizzes for a prediciton'
  end;
end;

procedure TPerformanceStudent.GenerateRevisionAdviceSpanish;
begin
  if (SpanishPredictedGrade = 'U') or (SpanishPredictedGrade = 'E') or (SpanishPredictedGrade = 'D') then
  begin
   RevisionAdvice[7].Caption:= 'Do at least 5 hours of revision per week to improve grade'
  end;

  if (SpanishPredictedGrade = 'C') or (SpanishPredictedGrade = 'B') then
  begin
   RevisionAdvice[7].Caption:= 'Do at least 3 hours of revision per week to improve grade'
  end;

  if (SpanishPredictedGrade = 'A') or (SpanishPredictedGrade = 'A*') then
  begin
   RevisionAdvice[7].Caption:= 'Minimal Revision needed: 1-2 hours per week'
  end;

  if (SpanishPredictedGradeScore = 'Not enough data') then
  begin
   RevisionAdvice[7].Caption:= 'Complete more quizzes for a prediciton'
  end;
end;

procedure TPerformanceStudent.GenerateRevisionAdviceGerman;
begin
  if (GermanPredictedGrade = 'U') or (GermanPredictedGrade = 'E') or (GermanPredictedGrade = 'D') then
  begin
   RevisionAdvice[8].Caption:= 'Do at least 5 hours of revision per week to improve grade'
  end;

  if (GermanPredictedGrade = 'C') or (GermanPredictedGrade = 'B') then
  begin
   RevisionAdvice[8].Caption:= 'Do at least 3 hours of revision per week to improve grade'
  end;

  if (GermanPredictedGrade = 'A') or (GermanPredictedGrade = 'A*') then
  begin
   RevisionAdvice[8].Caption:= 'Minimal Revision needed: 1-2 hours per week'
  end;

  if (GermanPredictedGradeScore = 'Not enough data') then
  begin
   RevisionAdvice[8].Caption:= 'Complete more quizzes for a prediciton'
  end;
end;

end.
