unit QuizSelection;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, jpeg, ExtCtrls, DB, ADODB, StdCtrls;

type
  TQuizSelect = class(TForm)
    imgQuit: TImage;
    imgBg: TImage;
    scrlbxQuizSelect: TScrollBox;
    qryQuizID: TADOQuery;
    imgBackbtn: TImage;
    lblWelcome: TLabel;
    chkBiology: TCheckBox;
    chkPhysics: TCheckBox;
    chkChemistry: TCheckBox;
    chkMaths: TCheckBox;
    chkEnglish: TCheckBox;
    chkGerman: TCheckBox;
    chkSpanish: TCheckBox;
    chkComputing: TCheckBox;
    imgSelect: TImage;
    lblSelect: TLabel;
  procedure FormCreate(Sender: TObject);
  procedure imgQuitClick(Sender: TObject);
  procedure AddFontResourceAndBroadcast;
  procedure FetchQuizIDs;
  procedure CreateQuizImages;
  procedure ImageClick(Sender: TObject);
  procedure imgBackbtnClick(Sender: TObject);
  procedure UpdateFetchQuizIDs;
  procedure imgSelectClick(Sender: TObject);
  procedure ClearScrollBoxContents(ScrollBox: TScrollBox);

  private
    { Private declarations }
    QuizID: array of Integer;
  public
    { Public declarations }
  end;

var
  QuizSelect: TQuizSelect;
  ScaleFactor : Double;
  I: Integer;
  TakeQuizID: Integer;

implementation

uses CustomDialog, NavigationPageStudent, QuizCompletion, QuizResult;

{$R *.dfm}

procedure TQuizSelect.FormCreate(Sender: TObject);
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
  imgBackbtn.Constraints.MaxWidth := Round(ClientWidth * 0.085);
  imgBackbtn.Constraints.MaxHeight := Round(ClientWidth * 0.06);
  imgBackbtn.Constraints.MinWidth := Round(ClientWidth * 0.085);
  imgBackbtn.Constraints.MinHeight := Round(ClientWidth * 0.06);
  imgBackbtn.Left := Round(ClientWidth * 0.02);

  //scrlbxQuizSelect: apperance on page
  scrlbxQuizSelect.Color := RGB(213, 213, 213);
  scrlbxQuizSelect.Top := Round(ClientHeight * 0.15);
  scrlbxQuizSelect.Left := Round(ClientWidth * 0.1);
  scrlbxQuizSelect.Width := Round(ClientWidth * 0.75);
  scrlbxQuizSelect.Height := Round(ClientHeight * 0.75);

  //lblWelcome: appereance on page
  lblWelcome.Font.Name := 'Arial Rounded MT Bold';
  lblWelcome.Font.Size := Round(ClientWidth * 0.035);
  lblWelcome.Transparent := True;
  lblWelcome.Font.Color := RGB(0, 0 , 0);
  lblWelcome.Left := Round(ClientWidth * 0.38);
  lblWelcome.Top := Round(ClientHeight * 0.025);

  //chkBiology: appereance on page
  chkBiology.Color :=  RGB(214,214,214);
  chkBiology.Font.Size := Round(ClientWidth * 0.01);
  chkBiology.Height := Round(ClientWidth * 0.015);
  chkBiology.Width := Round(ClientWidth * 0.2);
  chkBiology.Top := Round(ClientWidth * 0.15);
  chkBiology.Left := Round(ClientWidth * 0.88);

  //chkChemistry: appereance on page
  chkChemistry.Color :=  RGB(214,214,214);
  chkChemistry.Font.Size := Round(ClientWidth * 0.01);
  chkChemistry.Height := Round(ClientWidth * 0.015);
  chkChemistry.Width := Round(ClientWidth * 0.2);
  chkChemistry.Top := Round(ClientWidth * 0.18);
  chkChemistry.Left := Round(ClientWidth * 0.88);

  //chkPhysics: appereance on page
  chkPhysics.Color :=  RGB(214,214,214);
  chkPhysics.Font.Size := Round(ClientWidth * 0.01);
  chkPhysics.Height := Round(ClientWidth * 0.015);
  chkPhysics.Width := Round(ClientWidth * 0.2);
  chkPhysics.Top := Round(ClientWidth * 0.21);
  chkPhysics.Left := Round(ClientWidth * 0.88);

  //chkMaths: appereance on page
  chkMaths.Color :=  RGB(214,214,214);
  chkMaths.Font.Size := Round(ClientWidth * 0.01);
  chkMaths.Height := Round(ClientWidth * 0.015);
  chkMaths.Width := Round(ClientWidth * 0.2);
  chkMaths.Top := Round(ClientWidth * 0.24);
  chkMaths.Left := Round(ClientWidth * 0.88);

  //chkEnglish: appereance on page
  chkEnglish.Color :=  RGB(214,214,214);
  chkEnglish.Font.Size := Round(ClientWidth * 0.01);
  chkEnglish.Height := Round(ClientWidth * 0.015);
  chkEnglish.Width := Round(ClientWidth * 0.2);
  chkEnglish.Top := Round(ClientWidth * 0.27);
  chkEnglish.Left := Round(ClientWidth * 0.88);

  //chkComputing: appereance on page
  chkComputing.Color :=  RGB(214,214,214);
  chkComputing.Font.Size := Round(ClientWidth * 0.01);
  chkComputing.Height := Round(ClientWidth * 0.015);
  chkComputing.Width := Round(ClientWidth * 0.2);
  chkComputing.Top := Round(ClientWidth * 0.30);
  chkComputing.Left := Round(ClientWidth * 0.88);

  //chkGerman: appereance on page
  chkGerman.Color :=  RGB(214,214,214);
  chkGerman.Font.Size := Round(ClientWidth * 0.01);
  chkGerman.Height := Round(ClientWidth * 0.015);
  chkGerman.Width := Round(ClientWidth * 0.2);
  chkGerman.Top := Round(ClientWidth * 0.33);
  chkGerman.Left := Round(ClientWidth * 0.88);

  //chkSpanish: appereance on page
  chkSpanish.Color :=  RGB(214,214,214);
  chkSpanish.Font.Size := Round(ClientWidth * 0.01);
  chkSpanish.Height := Round(ClientWidth * 0.015);
  chkSpanish.Width := Round(ClientWidth * 0.2);
  chkSpanish.Top := Round(ClientWidth * 0.36);
  chkSpanish.Left := Round(ClientWidth * 0.88);

  //imgSelect: appereance on page
  imgSelect.Width := Round(ClientWidth * 0.135);
  imgSelect.Height:= Round(ClientHeight * 0.1);
  imgSelect.Top := Round(ClientWidth * 0.4);
  imgSelect.Left := Round(ClientWidth * 0.86);

  //lblSelect: appearance on page

  lblSelect.Font.Name := 'Arial Rounded MT Bold';
  lblSelect.Font.Size := Round(ClientWidth * 0.018);;
  lblSelect.Transparent := True;
  lblSelect.Font.Color := RGB(227, 227 , 227);
  lblSelect.Left := imgSelect.Left + (imgSelect.Width - lblSelect.Width) div 2;
  lblSelect.Top := imgSelect.Top + (imgSelect.Height - lblSelect.Height) div 2;



  FetchQuizIDs;
  CreateQuizImages;

end;

procedure TQuizSelect.AddFontResourceAndBroadcast;
begin
  if AddFontResource('Revision System Project\FONTS\arial-rounded-mt-bold.ttf"') > 0 then
    SendMessage(HWND_BROADCAST, WM_FONTCHANGE, 0, 0);
end;

//Procedure for exiting the program upon pressing the exit button

procedure TQuizSelect.imgQuitClick(Sender: TObject);
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

procedure TQuizSelect.FetchQuizIDs;
begin
  try
    // Open the query to execute the SQL statement
    qryQuizID.SQL.Text := 'SELECT QuizID FROM Quiz';
    qryQuizID.Open;

    // Initialize the QuizID array with the number of rows in the result set
    SetLength(QuizID, qryQuizID.RecordCount);

    // Iterate through the result set and populate the QuizID array
    I := 0;
    while not qryQuizID.Eof do
    begin
      QuizID[I] := qryQuizID.FieldByName('QuizID').AsInteger;
      qryQuizID.Next;
      Inc(I);
    end;
  finally
    // Close the query
    qryQuizID.Close;
  end;
end;

procedure TQuizSelect.CreateQuizImages;
const
  NumImagesPerRow = 3;
  ImageGap = 20;
var
  I, Row, Col: Integer;
  QuizImage: TImage;
  QuizLabel: TLabel;
  QuizSubjectLabel: TLabel;
  ImageSize : Integer;
  QuizName: string;
  SubjectID: string;
  QuizSubject: string;

begin
  // Iterate through the QuizID array
  for I := 0 to Length(QuizID) - 1 do
  begin
    // Calculate the row and column for the current image
    Row := I div NumImagesPerRow;
    Col := I mod NumImagesPerRow;
    ImageSize := Round((scrlbxQuizSelect.Width) / 3.23);
    // Create a new image component
    QuizImage := TImage.Create(Self);

    // Set properties for the image
    QuizImage.Parent := scrlbxQuizSelect; // Set the scroll box as the parent
    QuizImage.Left := Col * (ImageSize + ImageGap) + ImageGap; // Set left position with a gap of 20 pixels between images
    QuizImage.Top := Row * (ImageSize + ImageGap) + ImageGap; // Adjust the top position based on the row
    QuizImage.Width := ImageSize; // Set width
    QuizImage.Height := ImageSize; // Set height
    QuizImage.Stretch := True; // Stretch the image within the TImage component
    QuizImage.Picture.LoadFromFile('D:\School stuff\Revision System Project\IMG\DarkGrey Quiz Box.jpg');
    QuizImage.Tag := QuizID[I]; // Set QuizID as the tag for the image
    QuizImage.OnClick := ImageClick;

    qryQuizID.SQL.Text := 'SELECT QName FROM Quiz WHERE QuizID =:CurrentQuizID';
    qryQuizID.Parameters.ParamByName('CurrentQuizID').Value := QuizID[I];
    qryQuizID.Open;
    QuizName := qryQuizID.FieldByName('QName').AsString;

    // Inside the loop where you fetch Quiz IDs
    qryQuizID.SQL.Text := 'SELECT SubjectID FROM Quiz WHERE QuizID = :CurrentQuizID';
    qryQuizID.Parameters.ParamByName('CurrentQuizID').Value := QuizID[I];
    qryQuizID.Open;
    SubjectID := qryQuizID.FieldByName('SubjectID').AsString;
    qryQuizID.Close;

    // Now fetch the SubName using the SubjectID
    qryQuizID.SQL.Text := 'SELECT SubName FROM Subject WHERE SubjectID = :SubjectID';
    qryQuizID.Parameters.ParamByName('SubjectID').Value := SubjectID;
    qryQuizID.Open;
    QuizSubject := qryQuizID.FieldByName('SubName').AsString;
    qryQuizID.Close;

    //Set properties for label with quiz names.
    QuizLabel := TLabel.Create(Self);
    QuizLabel.Parent := scrlbxQuizSelect;
    QuizLabel.AutoSize := True;
    QuizLabel.Transparent := True;
    QuizLabel.Caption := QuizName;
    QuizLabel.Font.Name := 'Arial Rounded MT Bold';
    QuizLabel.Font.Size := Round(QuizImage.Width * 0.08);
    QuizLabel.Tag := QuizID[I];
    QuizLabel.OnClick := ImageClick;

    // Calculate the label width required for the caption
    QuizLabel.Width := QuizLabel.Canvas.TextWidth(QuizLabel.Caption);

    // Ensure the label width does not exceed ImageSize
    if QuizLabel.Width > ImageSize then
      QuizLabel.Width := ImageSize;

    // Center the label horizontally within the image
    QuizLabel.Left := QuizImage.Left + (ImageSize - QuizLabel.Width) div 2;

    // Center the label vertically within the image
    QuizLabel.Top := QuizImage.Top + (ImageSize - QuizLabel.Height) div 2;

    //Set properties for SubjectLabel with quiz names.
    QuizSubjectLabel := TLabel.Create(Self);
    QuizSubjectLabel.Parent := scrlbxQuizSelect;
    QuizSubjectLabel.AutoSize := True;
    QuizSubjectLabel.Transparent := True;
    QuizSubjectLabel.Caption := QuizSubject;
    QuizSubjectLabel.Font.Name := 'Arial Rounded MT Bold';
    QuizSubjectLabel.Font.Size := Round(QuizImage.Width * 0.05);
    QuizSubjectLabel.Font.Color := RGB(157, 179 , 128);
    QuizSubjectLabel.Tag := QuizID[I];
    QuizSubjectLabel.OnClick := ImageClick;

    // Calculate the SubjectLabel width required for the caption
    QuizSubjectLabel.Width := QuizSubjectLabel.Canvas.TextWidth(QuizSubjectLabel.Caption);

    // Ensure the SubjectLabel width does not exceed ImageSize
    if QuizSubjectLabel.Width > ImageSize then
      QuizSubjectLabel.Width := ImageSize;

    // Center the SubjectLabel horizontally within the image
    QuizSubjectLabel.Left := QuizImage.Left + (ImageSize - QuizSubjectLabel.Width) div 2;

    // Center the SubjectLabel vertically within the image
    QuizSubjectLabel.Top := (QuizImage.Top + (ImageSize - QuizSubjectLabel.Height) div 2) + 50;


  end;
end;

procedure TQuizSelect.ImageClick(Sender: TObject);
  begin
    TakeQuizID := TImage(Sender).Tag;
    CompleteQuiz.TakeQuizID := TakeQuizID;
    QuizOutcome.QuizID := TakeQuizID;
    CompleteQuiz.Show;
    QuizSelect.Hide;
  end;

procedure TQuizSelect.imgBackbtnClick(Sender: TObject);
begin
  QuizSelect.Hide;
  StudentNavigation.Show;
end;

procedure TQuizSelect.UpdateFetchQuizIDs;
var
  WhereClause: string;
begin

  // Check if at least one subject is selected
  if not (chkBiology.Checked or chkChemistry.Checked or chkComputing.Checked or
          chkEnglish.Checked or chkGerman.Checked or chkMaths.Checked or
          chkPhysics.Checked or chkSpanish.Checked) then
  begin
    ShowMessage('Please select at least one subject');
    Exit; // Exit the procedure if no subject is selected
  end;

    // Clear the QuizID array before populating it with new IDs
  SetLength(QuizID, 0);

  // Construct the SQL query based on the selected subjects
  WhereClause := '';
  if chkBiology.Checked then
    WhereClause := 'SubjectID = ''B01''';

  if chkPhysics.Checked then
  begin
    if WhereClause <> '' then
      WhereClause := WhereClause + ' OR ';
    WhereClause := WhereClause + 'SubjectID = ''P01''';
  end;

  if chkChemistry.Checked then
  begin
    if WhereClause <> '' then
      WhereClause := WhereClause + ' OR ';
    WhereClause := WhereClause + 'SubjectID = ''C01''';
  end;

   if chkComputing.Checked then
  begin
    if WhereClause <> '' then
      WhereClause := WhereClause + ' OR ';
    WhereClause := WhereClause + 'SubjectID = ''CS01''';
  end;

   if chkEnglish.Checked then
  begin
    if WhereClause <> '' then
      WhereClause := WhereClause + ' OR ';
    WhereClause := WhereClause + 'SubjectID = ''E01''';
  end;

    if chkGerman.Checked then
  begin
    if WhereClause <> '' then
      WhereClause := WhereClause + ' OR ';
    WhereClause := WhereClause + 'SubjectID = ''G01''';
  end;

    if chkMaths.Checked then
  begin
    if WhereClause <> '' then
      WhereClause := WhereClause + ' OR ';
    WhereClause := WhereClause + 'SubjectID = ''M01''';
  end;

    if chkSpanish.Checked then
  begin
    if WhereClause <> '' then
      WhereClause := WhereClause + ' OR ';
    WhereClause := WhereClause + 'SubjectID = ''S01''';
  end;


  if WhereClause <> '' then
    qryQuizID.SQL.Text := 'SELECT QuizID FROM Quiz WHERE ' + WhereClause
  else
    qryQuizID.SQL.Text := 'SELECT QuizID FROM Quiz';

  // Execute the query
  qryQuizID.Open;
  try
    // Populate the QuizID array with the retrieved QuizIDs
    qryQuizID.First; // Move to the first record
    while not qryQuizID.Eof do
    begin
      SetLength(QuizID, Length(QuizID) + 1); // Increase array length
      QuizID[High(QuizID)] := qryQuizID.FieldByName('QuizID').AsInteger;
      qryQuizID.Next; // Move to the next record
    end;
  finally
    qryQuizID.Close; // Close the query
  end;
end;

procedure TQuizSelect.ClearScrollBoxContents(ScrollBox: TScrollBox);
var
  I: Integer;
begin
  // Iterate through the controls in the scroll box and free them
  for I := ScrollBox.ControlCount - 1 downto 0 do
    ScrollBox.Controls[I].Free;
end;


procedure TQuizSelect.imgSelectClick(Sender: TObject);
begin
  ClearScrollBoxContents(scrlbxQuizSelect);
  UpdateFetchQuizIDs;
  CreateQuizImages;
end;

end.
