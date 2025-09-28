unit UserFillInDetailsTeacher;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, jpeg, ExtCtrls, StdCtrls, DB, ADODB;

type
  TFillInDetailsT = class(TForm)
    imgBg: TImage;
    imgbgfromLook: TImage;
    dbgrdSelectClassT: TDBGrid;
    dbgrdClassesSelected: TDBGrid;
    imgQuit: TImage;
    imgTableReference: TImage;
    imgBiologyBtn: TImage;
    imgChemistryBtn: TImage;
    imgComputingBtn: TImage;
    imgEnglishBtn: TImage;
    imgGermanBtn: TImage;
    imgMathsBtn: TImage;
    imgPhysicsBtn: TImage;
    imgSpanishBtn: TImage;
    lblBiology: TLabel;
    lblEnglish: TLabel;
    lblComputing: TLabel;
    lblChemistry: TLabel;
    lblPhysics: TLabel;
    lblMaths: TLabel;
    lblGerman: TLabel;
    lblSpanish: TLabel;
    imgSubmit: TImage;
    lblSubmit: TLabel;
    qryFillTable: TADOQuery;
    dsFillTable: TDataSource;
    imgedt: TImage;
    edtClassAdd: TEdit;
    imgSubmitClass: TImage;
    lblSubmitClass: TLabel;
    qryFillTable2: TADOQuery;
    dsClassesSelected: TDataSource;
    qryUpdateDataEntry: TADOQuery;
    qryAddClassesFinal: TADOQuery;
    qrySubjectId: TADOQuery;
    conDelete: TADOConnection;
    qryTeacherID: TADOQuery;
    imgedtRemove: TImage;
    edtRemoveClass: TEdit;
    imgRemoveClass: TImage;
    lblRemoveClass: TLabel;
    imgFinalSubmit: TImage;
    lblFinalSubmit: TLabel;
    qrySelectClasses: TADOQuery;
    lblRemoveClasses: TLabel;
    lblAvailable: TLabel;
    lblSelectClass: TLabel;
    lblSelectedClasses: TLabel;
    lblAddClass: TLabel;
    lblSubjectSelect: TLabel;
    procedure FormCreate (Sender: TObject);
    procedure AddFontResourceAndBroadcast;
    procedure imgQuitClick(Sender: TObject);
    procedure imgMathsBtnClick(Sender: TObject);
    procedure imgEnglishBtnClick(Sender: TObject);
    procedure imgChemistryBtnClick(Sender: TObject);
    procedure imgComputingBtnClick(Sender: TObject);
    procedure imgBiologyBtnClick(Sender: TObject);
    procedure imgPhysicsBtnClick(Sender: TObject);
    procedure imgGermanBtnClick(Sender: TObject);
    procedure imgSpanishBtnClick(Sender: TObject);
    procedure imgSubmitClick(Sender: TObject);
    procedure FindTeacherID;
    procedure imgSubmitClassClick(Sender: TObject);
    procedure imgRemoveClassClick(Sender: TObject);
    function GetSubjectID(const ClassName: string): string;
    procedure imgFinalSubmitClick(Sender: TObject);

  private
    { Private declarations }
    FCurrentUserID: Integer;
  public
    { Public declarations }
    property CurrentUserID: Integer read FCurrentUserID write FCurrentUserID;
  end;

var
  FillInDetailsT: TFillInDetailsT;
  ScaleFactor: Double ;
  imgTableReferenceTop, imgTableReferenceLeft: Integer;
  TotalWidth, NumColumns, ColumnWidth, ExtraWidth: Integer;
  imgMathsBtnTop, imgMathsBtnLeft: Integer;
  imgEnglishBtnTop, imgEnglishBtnLeft: Integer;
  imgChemistryBtnTop,imgChemistryBtnLeft: Integer;
  imgComputingBtnTop,imgComputingBtnLeft: Integer;
  imgBiologyBtnTop, imgBiologyBtnLeft: Integer;
  imgPhysicsBtnTop, imgPhysicsBtnLeft: Integer;
  imgGermanBtnTop,imgGermanBtnLeft: Integer;
  imgSpanishBtnTop, imgSpanishBtnLeft: Integer;
  Maths, English, Chemistry, Computing, Biology, Physics, German, Spanish: Boolean;
  SubjectChosen: Boolean;
  imgSubmitTop, imgSubmitLeft: Integer;
  imgedtTop, imgedtLeft: Integer;
  edtClassAddTop, edtClassAddLeft: Integer;
  imgSubmitClassTop, imgSubmitClassLeft: Integer;
  CurrentTeacherID: string;
  ClassToAdd: string;
  imgedtRemoveTop, imgedtRemoveLeft: Integer;
  edtRemoveClassTop, edtRemoveClassLeft: Integer;
  imgRemoveClassTop, imgRemoveClassLeft: Integer;
  imgFinalSubmitTop, imgFinalSubmitLeft: Integer;
  ClassToRemove: string;
  lblSubjectSelectTop, lblSubjectSelectLeft: Integer;
  lblSelectClassTop, lblSelectClassLeft: Integer;
  lblAvailableTop,  lblAvailableLeft: Integer;
  lblAddClassTop, lblAddClassLeft: Integer;
  lblSelectedClassesTop, lblSelectedClassesLeft: Integer;
  lblRemoveClassesTop, lblRemoveClassesLeft: Integer;

implementation

uses CustomDialog, UserFillInDetails, NavigationPageStudent,
  NavigationPageTeacher;

{$R *.dfm}

procedure TFillInDetailsT.FormCreate (Sender: TObject);
var
  i: Integer;
begin
//Ensuring the form appears as full screen
  BorderStyle := bsNone;
  Left := Screen.Monitors[0].Left;
  Top := Screen.Monitors[0].Top;
  Width := Screen.Monitors[0].Width;
  Height := Screen.Monitors[0].Height;

  ScaleFactor := 0.9;

  //Call procedure which loads a custom font
  AddFontResourceAndBroadcast;

  //imgQuit: appearance on page

  imgQuit.Top := 20;
  imgQuit.Constraints.MaxWidth := Round(ClientWidth * 0.07);
  imgQuit.Constraints.MaxHeight := Round(ClientWidth * 0.07);
  imgQuit.Left := ClientWidth - imgQuit.Width - 20;

  //imgbgfromLook: appearance on page

  imgbgfromLook.Constraints.MaxWidth := Round(ClientWidth * ScaleFactor);
  imgbgfromLook.Constraints.MaxHeight := Round(ClientHeight * ScaleFactor);
  imgbgfromLook.Constraints.MinWidth := Round(ClientWidth * ScaleFactor);
  imgbgfromLook.Constraints.MinHeight := Round(ClientHeight * ScaleFactor);
  imgbgfromLook.left := (ClientWidth - imgbgfromLook.Width) div 2;
  imgbgfromLook.Top := (ClientHeight - imgbgfromLook.Height) div 2;

  //imgMathsBtn: appearance on page

  imgMathsBtnTop := imgbgfromLook.Top + Round(imgbgfromLook.Height * 0.2);
  imgMathsBtnLeft := imgbgfromLook.Left + Round(imgbgfromLook.Width * 0.07);
  imgMathsBtn.Left := imgMathsBtnLeft;
  imgMathsBtn.Top := imgMathsBtnTop;
  imgMathsBtn.Constraints.MaxWidth := Round(ClientWidth * 0.18);
  imgMathsBtn.Constraints.MaxHeight := Round(ClientWidth * 0.075);
  imgMathsBtn.Constraints.MinWidth := Round(ClientWidth * 0.18);
  imgMathsBtn.Constraints.MinHeight := Round(ClientWidth * 0.075);

  //imgEnglishBtn: appearance on page

  imgEnglishBtnTop := imgbgfromLook.Top + Round(imgbgfromLook.Height * 0.2);
  imgEnglishBtnLeft := imgbgfromLook.Left + Round(imgbgfromLook.Width * 0.28);
  imgEnglishBtn.Left := imgEnglishBtnLeft;
  imgEnglishBtn.Top := imgEnglishBtnTop;
  imgEnglishBtn.Constraints.MaxWidth := Round(ClientWidth * 0.18);
  imgEnglishBtn.Constraints.MaxHeight := Round(ClientWidth * 0.075);
  imgEnglishBtn.Constraints.MinWidth := Round(ClientWidth * 0.18);
  imgEnglishBtn.Constraints.MinHeight := Round(ClientWidth * 0.075);

  //imgChemistryBtn: appearance on page

  imgChemistryBtnTop := imgbgfromLook.Top + Round(imgbgfromLook.Height * 0.35);
  imgChemistryBtnLeft := imgbgfromLook.Left + Round(imgbgfromLook.Width * 0.07);
  imgChemistryBtn.Left := imgChemistryBtnLeft;
  imgChemistryBtn.Top := imgChemistryBtnTop;
  imgChemistryBtn.Constraints.MaxWidth := Round(ClientWidth * 0.18);
  imgChemistryBtn.Constraints.MaxHeight := Round(ClientWidth * 0.075);
  imgChemistryBtn.Constraints.MinWidth := Round(ClientWidth * 0.18);
  imgChemistryBtn.Constraints.MinHeight := Round(ClientWidth * 0.075);

  //imgComputingBtn: appearance on page

  imgComputingBtnTop := imgbgfromLook.Top + Round(imgbgfromLook.Height * 0.35);
  imgComputingBtnLeft := imgbgfromLook.Left + Round(imgbgfromLook.Width * 0.28);
  imgComputingBtn.Left := imgComputingBtnLeft;
  imgComputingBtn.Top := imgComputingBtnTop;
  imgComputingBtn.Constraints.MaxWidth := Round(ClientWidth * 0.18);
  imgComputingBtn.Constraints.MaxHeight := Round(ClientWidth * 0.075);
  imgComputingBtn.Constraints.MinWidth := Round(ClientWidth * 0.18);
  imgComputingBtn.Constraints.MinHeight := Round(ClientWidth * 0.075);

  //imgBiologyBtn: appearance on page

  imgBiologyBtnTop := imgbgfromLook.Top + Round(imgbgfromLook.Height * 0.5);
  imgBiologyBtnLeft := imgbgfromLook.Left + Round(imgbgfromLook.Width * 0.07);
  imgBiologyBtn.Left := imgBiologyBtnLeft;
  imgBiologyBtn.Top := imgBiologyBtnTop;
  imgBiologyBtn.Constraints.MaxWidth := Round(ClientWidth * 0.18);
  imgBiologyBtn.Constraints.MaxHeight := Round(ClientWidth * 0.075);
  imgBiologyBtn.Constraints.MinWidth := Round(ClientWidth * 0.18);
  imgBiologyBtn.Constraints.MinHeight := Round(ClientWidth * 0.075);

  //imgPhysicsBtn: appearance on page

  imgPhysicsBtnTop := imgbgfromLook.Top + Round(imgbgfromLook.Height * 0.5);
  imgPhysicsBtnLeft := imgbgfromLook.Left + Round(imgbgfromLook.Width * 0.28);
  imgPhysicsBtn.Left := imgPhysicsBtnLeft;
  imgPhysicsBtn.Top := imgPhysicsBtnTop;
  imgPhysicsBtn.Constraints.MaxWidth := Round(ClientWidth * 0.18);
  imgPhysicsBtn.Constraints.MaxHeight := Round(ClientWidth * 0.075);
  imgPhysicsBtn.Constraints.MinWidth := Round(ClientWidth * 0.18);
  imgPhysicsBtn.Constraints.MinHeight := Round(ClientWidth * 0.075);

  //imgGermanBtn: appearance on page

  imgGermanBtnTop := imgbgfromLook.Top + Round(imgbgfromLook.Height * 0.65);
  imgGermanBtnLeft := imgbgfromLook.Left + Round(imgbgfromLook.Width * 0.07);
  imgGermanBtn.Left := imgGermanBtnLeft;
  imgGermanBtn.Top := imgGermanBtnTop;
  imgGermanBtn.Constraints.MaxWidth := Round(ClientWidth * 0.18);
  imgGermanBtn.Constraints.MaxHeight := Round(ClientWidth * 0.075);
  imgGermanBtn.Constraints.MinWidth := Round(ClientWidth * 0.18);
  imgGermanBtn.Constraints.MinHeight := Round(ClientWidth * 0.075);

  //imgSpanishBtn: appearance on page

  imgSpanishBtnTop := imgbgfromLook.Top + Round(imgbgfromLook.Height * 0.65);
  imgSpanishBtnLeft := imgbgfromLook.Left + Round(imgbgfromLook.Width * 0.28);
  imgSpanishBtn.Left := imgSpanishBtnLeft;
  imgSpanishBtn.Top := imgSpanishBtnTop;
  imgSpanishBtn.Constraints.MaxWidth := Round(ClientWidth * 0.18);
  imgSpanishBtn.Constraints.MaxHeight := Round(ClientWidth * 0.075);
  imgSpanishBtn.Constraints.MinWidth := Round(ClientWidth * 0.18);
  imgSpanishBtn.Constraints.MinHeight := Round(ClientWidth * 0.075);

  //lblMaths: appearance on page

  lblMaths.Font.Name := 'Arial Rounded MT Bold';
  lblMaths.Font.Size := Round(imgbgfromLook.Width * 0.023);;
  lblMaths.Transparent := True;
  lblMaths.Font.Color := RGB(155, 178, 127);
  lblMaths.Left := imgMathsBtn.Left + (imgMathsBtn.Width - lblMaths.Width) div 2;
  lblMaths.Top := imgMathsBtn.Top + (imgMathsBtn.Height - lblMaths.Height) div 2;

  //lblEnglish: appearance on page

  lblEnglish.Font.Name := 'Arial Rounded MT Bold';
  lblEnglish.Font.Size := Round(imgbgfromLook.Width * 0.023);;
  lblEnglish.Transparent := True;
  lblEnglish.Font.Color := RGB(155, 178, 127);
  lblEnglish.Left := imgEnglishBtn.Left + (imgEnglishBtn.Width - lblEnglish.Width) div 2;
  lblEnglish.Top := imgEnglishBtn.Top + (imgEnglishBtn.Height - lblEnglish.Height) div 2;

  //lblChemistry: appearance on page

  lblChemistry.Font.Name := 'Arial Rounded MT Bold';
  lblChemistry.Font.Size := Round(imgbgfromLook.Width * 0.023);;
  lblChemistry.Transparent := True;
  lblChemistry.Font.Color := RGB(155, 178, 127);
  lblChemistry.Left := imgChemistryBtn.Left + (imgChemistryBtn.Width - lblChemistry.Width) div 2;
  lblChemistry.Top := imgChemistryBtn.Top + (imgChemistryBtn.Height - lblChemistry.Height) div 2;

  //lblComputing: appearance on page

  lblComputing.Font.Name := 'Arial Rounded MT Bold';
  lblComputing.Font.Size := Round(imgbgfromLook.Width * 0.023);;
  lblComputing.Transparent := True;
  lblComputing.Font.Color := RGB(155, 178, 127);
  lblComputing.Left := imgComputingBtn.Left + (imgComputingBtn.Width - lblComputing.Width) div 2;
  lblComputing.Top := imgComputingBtn.Top + (imgComputingBtn.Height - lblComputing.Height) div 2;

  //lblBiology: appearance on page

  lblBiology.Font.Name := 'Arial Rounded MT Bold';
  lblBiology.Font.Size := Round(imgbgfromLook.Width * 0.023);;
  lblBiology.Transparent := True;
  lblBiology.Font.Color := RGB(155, 178, 127);
  lblBiology.Left := imgBiologyBtn.Left + (imgBiologyBtn.Width - lblBiology.Width) div 2;
  lblBiology.Top := imgBiologyBtn.Top + (imgBiologyBtn.Height - lblBiology.Height) div 2;

  //lblPhysics: appearance on page

  lblPhysics.Font.Name := 'Arial Rounded MT Bold';
  lblPhysics.Font.Size := Round(imgbgfromLook.Width * 0.023);;
  lblPhysics.Transparent := True;
  lblPhysics.Font.Color := RGB(155, 178, 127);
  lblPhysics.Left := imgPhysicsBtn.Left + (imgPhysicsBtn.Width - lblPhysics.Width) div 2;
  lblPhysics.Top := imgPhysicsBtn.Top + (imgPhysicsBtn.Height - lblPhysics.Height) div 2;

  //lblGerman: appearance on page

  lblGerman.Font.Name := 'Arial Rounded MT Bold';
  lblGerman.Font.Size := Round(imgbgfromLook.Width * 0.023);;
  lblGerman.Transparent := True;
  lblGerman.Font.Color := RGB(155, 178, 127);
  lblGerman.Left := imgGermanBtn.Left + (imgGermanBtn.Width - lblGerman.Width) div 2;
  lblGerman.Top := imgGermanBtn.Top + (imgGermanBtn.Height - lblGerman.Height) div 2;

  //lblSpanish: appearance on page

  lblSpanish.Font.Name := 'Arial Rounded MT Bold';
  lblSpanish.Font.Size := Round(imgbgfromLook.Width * 0.023);;
  lblSpanish.Transparent := True;
  lblSpanish.Font.Color := RGB(155, 178, 127);
  lblSpanish.Left := imgSpanishBtn.Left + (imgSpanishBtn.Width - lblSpanish.Width) div 2;
  lblSpanish.Top := imgSpanishBtn.Top + (imgSpanishBtn.Height - lblSpanish.Height) div 2;

   //imgTableReference: appearance on page

  imgTableReferenceTop := imgbgfromLook.Top + Round(imgbgfromLook.Height * 0.13);
  imgTableReferenceLeft := imgbgfromLook.Left + Round(imgbgfromLook.Width * 0.52);
  imgTableReference.Left := imgTableReferenceLeft;
  imgTableReference.Top := imgTableReferenceTop;
  imgTableReference.Constraints.MaxWidth := Round(ClientWidth * 0.37);
  imgTableReference.Constraints.MaxHeight := Round(ClientWidth * 0.35);
  imgTableReference.Constraints.MinWidth := Round(ClientWidth * 0.37);
  imgTableReference.Constraints.MinHeight := Round(ClientWidth * 0.35);

  //imgSubmit: appearance on page

  imgSubmitTop := imgbgfromLook.Top + Round(imgbgfromLook.Height * 0.8);
  imgSubmitLeft := imgbgfromLook.Left + Round(imgbgfromLook.Width * 0.17);
  imgSubmit.Left := imgSubmitLeft;
  imgSubmit.Top := imgSubmitTop;
  imgSubmit.Constraints.MaxWidth := Round(ClientWidth * 0.18);
  imgSubmit.Constraints.MaxHeight := Round(ClientWidth * 0.06);
  imgSubmit.Constraints.MinWidth := Round(ClientWidth * 0.18);
  imgSubmit.Constraints.MinHeight := Round(ClientWidth * 0.06);

  //lblSubmit: appearance on page

  lblSubmit.Font.Name := 'Arial Rounded MT Bold';
  lblSubmit.Font.Size := Round(imgbgfromLook.Width * 0.023);;
  lblSubmit.Transparent := True;
  lblSubmit.Font.Color := RGB(0, 0, 0);
  lblSubmit.Left := imgSubmit.Left + (imgSubmit.Width - lblSubmit.Width) div 2;
  lblSubmit.Top := imgSubmit.Top + (imgSubmit.Height - lblSubmit.Height) div 2;



  //Table apperance:

  dbgrdSelectClassT.Width :=  Round(imgTableReference.Width * 0.7);
  dbgrdSelectClassT.Left := imgTableReference.Left + (imgTableReference.Width - dbgrdSelectClassT.Width) div 2;
  dbgrdSelectClassT.Top :=  imgTableReference.Top +45;


    // Calculate the total width of all columns
  TotalWidth := 0;
  for i := 0 to dbgrdSelectClassT.Columns.Count - 1 do
    TotalWidth := TotalWidth + dbgrdSelectClassT.Columns[i].Width;

  // Calculate the width of each column to make them fit the grid's width
  ColumnWidth := dbgrdSelectClassT.Width div dbgrdSelectClassT.Columns.Count;

  // Adjust column widths
  for i := 0 to dbgrdSelectClassT.Columns.Count - 1 do
    dbgrdSelectClassT.Columns[i].Width := ColumnWidth;

  // Adjust the last column width to fit the remaining space
  dbgrdSelectClassT.Columns[dbgrdSelectClassT.Columns.Count - 1].Width :=
  dbgrdSelectClassT.Width - (ColumnWidth * (dbgrdSelectClassT.Columns.Count - 1));

  //Table apperance:

  dbgrdClassesSelected.Width :=  Round(imgTableReference.Width * 0.25);
  dbgrdClassesSelected.Left := imgTableReference.Left + 100;
  dbgrdClassesSelected.Top :=  imgTableReference.Top +410;


    // Calculate the total width of all columns
  TotalWidth := 0;
  for i := 0 to dbgrdClassesSelected.Columns.Count - 1 do
    TotalWidth := TotalWidth + dbgrdClassesSelected.Columns[i].Width;

  // Calculate the width of each column to make them fit the grid's width
  ColumnWidth := dbgrdClassesSelected.Width div dbgrdClassesSelected.Columns.Count;

  // Adjust column widths
  for i := 0 to dbgrdClassesSelected.Columns.Count - 1 do
    dbgrdClassesSelected.Columns[i].Width := ColumnWidth;

  // Adjust the last column width to fit the remaining space
  dbgrdClassesSelected.Columns[dbgrdClassesSelected.Columns.Count - 1].Width :=
  dbgrdClassesSelected.Width - (ColumnWidth * (dbgrdClassesSelected.Columns.Count - 1));

  //Declares SubjectChosen variable as false to allow teacher to select a subject and ensure only one subject at a time can be selected
  SubjectChosen:= False;

  //imgedt: apperance on page
  imgedtTop := imgbgfromLook.Top + Round(imgbgfromLook.Height * 0.43);
  imgedtLeft := imgbgfromLook.Left + Round(imgbgfromLook.Width * 0.58);
  imgedt.Left := imgedtLeft;
  imgedt.Top := imgedtTop;
  imgedt.Constraints.MaxWidth := Round(ClientWidth * 0.18);
  imgedt.Constraints.MaxHeight := Round(ClientWidth * 0.03);
  imgedt.Constraints.MinWidth := Round(ClientWidth * 0.18);
  imgedt.Constraints.MinHeight := Round(ClientWidth * 0.03);

  //edtClassAdd: Appereance on page
  edtClassAdd.Font.Name := 'Arial Rounded MT Bold';
  edtClassAdd.Width := Round(imgbgfromLook.Width * 0.175);
  edtClassAddTop := imgbgfromLook.Top + Round(imgbgfromLook.Height * 0.44);
  edtClassAddLeft := imgbgfromLook.Left + Round(imgbgfromLook.Width * 0.594);
  edtClassAdd.Left :=  edtClassAddLeft;
  edtClassAdd.Top := edtClassAddTop ;

  //imgSubmitClass: apperance on page
  imgSubmitClassTop := imgbgfromLook.Top + Round(imgbgfromLook.Height * 0.415);
  imgSubmitClassLeft := imgbgfromLook.Left + Round(imgbgfromLook.Width * 0.78);
  imgSubmitClass.Left := imgSubmitClassLeft;
  imgSubmitClass.Top := imgSubmitClassTop;
  imgSubmitClass.Constraints.MaxWidth := Round(ClientWidth * 0.1);
  imgSubmitClass.Constraints.MaxHeight := Round(ClientWidth * 0.05);
  imgSubmitClass.Constraints.MinWidth := Round(ClientWidth * 0.1);
  imgSubmitClass.Constraints.MinHeight := Round(ClientWidth * 0.05);


  // lblSubmitClass : apperance on page
  lblSubmitClass.Font.Name := 'Arial Rounded MT Bold';
  lblSubmitClass.Font.Size := Round(imgbgfromLook.Width * 0.008);;
  lblSubmitClass.Transparent := True;
  lblSubmitClass.Font.Color := RGB(232, 232, 232);
  lblSubmitClass.Left := imgSubmitClass.Left + (imgSubmitClass.Width - lblSubmitClass.Width) div 2;
  lblSubmitClass.Top := imgSubmitClass.Top + (imgSubmitClass.Height - lblSubmitClass.Height) div 2;

   //imgedtRemove: apperance on page
  imgedtRemoveTop := imgbgfromLook.Top + Round(imgbgfromLook.Height * 0.55);
  imgedtRemoveLeft := imgbgfromLook.Left + Round(imgbgfromLook.Width * 0.7);
  imgedtRemove.Left := imgedtRemoveLeft;
  imgedtRemove.Top := imgedtRemoveTop;
  imgedtRemove.Constraints.MaxWidth := Round(ClientWidth * 0.1);
  imgedtRemove.Constraints.MaxHeight := Round(ClientWidth * 0.03);
  imgedtRemove.Constraints.MinWidth := Round(ClientWidth * 0.1);
  imgedtRemove.Constraints.MinHeight := Round(ClientWidth * 0.03);

  //edtRemoveClass: Appereance on page
  edtRemoveClass.Font.Name := 'Arial Rounded MT Bold';
  edtRemoveClass.Width := Round(imgbgfromLook.Width * 0.0955);
  edtRemoveClassTop := imgbgfromLook.Top + Round(imgbgfromLook.Height * 0.56);
  edtRemoveClassLeft := imgbgfromLook.Left + Round(imgbgfromLook.Width * 0.707);
  edtRemoveClass.Left :=  edtRemoveClassLeft;
  edtRemoveClass.Top := edtRemoveClassTop ;

  //imgRemoveClass: apperance on page
  imgRemoveClassTop := imgbgfromLook.Top + Round(imgbgfromLook.Height * 0.53);
  imgRemoveClassLeft := imgbgfromLook.Left + Round(imgbgfromLook.Width * 0.81);
  imgRemoveClass.Left := imgRemoveClassLeft;
  imgRemoveClass.Top := imgRemoveClassTop;
  imgRemoveClass.Constraints.MaxWidth := Round(ClientWidth * 0.1);
  imgRemoveClass.Constraints.MaxHeight := Round(ClientWidth * 0.05);
  imgRemoveClass.Constraints.MinWidth := Round(ClientWidth * 0.1);
  imgRemoveClass.Constraints.MinHeight := Round(ClientWidth * 0.05);

 // lblRemoveClass : apperance on page
  lblRemoveClass.Font.Name := 'Arial Rounded MT Bold';
  lblRemoveClass.Font.Size := Round(imgbgfromLook.Width * 0.008);;
  lblRemoveClass.Transparent := True;
  lblRemoveClass.Font.Color := RGB(232, 232, 232);
  lblRemoveClass.Left := imgRemoveClass.Left + (imgRemoveClass.Width - lblRemoveClass.Width) div 2;
  lblRemoveClass.Top := imgRemoveClass.Top + (imgRemoveClass.Height - lblRemoveClass.Height) div 2;

  //imgFinalSubmit: apperance on page
  imgFinalSubmitTop := imgbgfromLook.Top + Round(imgbgfromLook.Height * 0.63);
  imgFinalSubmitLeft := imgbgfromLook.Left + Round(imgbgfromLook.Width * 0.68);
  imgFinalSubmit.Left := imgFinalSubmitLeft;
  imgFinalSubmit.Top := imgFinalSubmitTop;
  imgFinalSubmit.Constraints.MaxWidth := Round(ClientWidth * 0.215);
  imgFinalSubmit.Constraints.MaxHeight := Round(ClientWidth * 0.08);
  imgFinalSubmit.Constraints.MinWidth := Round(ClientWidth * 0.215);
  imgFinalSubmit.Constraints.MinHeight := Round(ClientWidth * 0.08);

  // lblFinalSubmit : apperance on page
  lblFinalSubmit.Font.Name := 'Arial Rounded MT Bold';
  lblFinalSubmit.Font.Size := Round(imgbgfromLook.Width * 0.025);;
  lblFinalSubmit.Transparent := True;
  lblFinalSubmit.Font.Color := RGB(232, 232, 232);
  lblFinalSubmit.Left := imgFinalSubmit.Left + (imgFinalSubmit.Width - lblFinalSubmit.Width) div 2;
  lblFinalSubmit.Top := imgFinalSubmit.Top + (imgFinalSubmit.Height - lblFinalSubmit.Height) div 2;

    //lblSubjectSelect: appearance on page

  lblSubjectSelect.Font.Name := 'Arial Rounded MT Bold';
  lblSubjectSelect.Font.Size := Round(imgbgfromLook.Width * 0.0185);
  lblSubjectSelect.Transparent := True;
  lblSubjectSelect.Font.Color := RGB(232, 232, 232);
  lblSubjectSelectTop := imgbgfromLook.Top + Round(imgbgfromLook.Height * 0.11);
  lblSubjectSelectLeft := imgbgfromLook.Left + Round(imgbgfromLook.Width * 0.115);
  lblSubjectSelect.Left := lblSubjectSelectLeft;
  lblSubjectSelect.Top := lblSubjectSelectTop;

   //lblSelectClass: appearance on page

  lblSelectClass.Font.Name := 'Arial Rounded MT Bold';
  lblSelectClass.Font.Size := Round(imgbgfromLook.Width * 0.0185);
  lblSelectClass.Transparent := True;
  lblSelectClass.Font.Color := RGB(155, 178, 127);
  lblSelectClassTop := imgbgfromLook.Top + Round(imgbgfromLook.Height * 0.08);
  lblSelectClassLeft := imgbgfromLook.Left + Round(imgbgfromLook.Width * 0.58);
  lblSelectClass.Left := lblSelectClassLeft;
  lblSelectClass.Top := lblSelectClassTop;

  //lblAvailable: appearance on page

  lblAvailable.Font.Name := 'Arial Rounded MT Bold';
  lblAvailable.Font.Size := Round(imgbgfromLook.Width * 0.011);
  lblAvailable.Transparent := True;
  lblAvailable.Font.Color := RGB(0, 0, 0);
  lblAvailableTop := imgbgfromLook.Top + Round(imgbgfromLook.Height * 0.145);
  lblAvailableLeft := imgbgfromLook.Left + Round(imgbgfromLook.Width * 0.665);
  lblAvailable.Left := lblAvailableLeft;
  lblAvailable.Top := lblAvailableTop;

  //lblAddClass: appearance on page

  lblAddClass.Font.Name := 'Arial Rounded MT Bold';
  lblAddClass.Font.Size := Round(imgbgfromLook.Width * 0.011);
  lblAddClass.Transparent := True;
  lblAddClass.Font.Color := RGB(0, 0, 0);
  lblAddClassTop := imgbgfromLook.Top + Round(imgbgfromLook.Height * 0.405);
  lblAddClassLeft := imgbgfromLook.Left + Round(imgbgfromLook.Width * 0.59);
  lblAddClass.Left := lblAddClassLeft;
  lblAddClass.Top := lblAddClassTop;

  //lblSelectedClasses: appearance on page

  lblSelectedClasses.Font.Name := 'Arial Rounded MT Bold';
  lblSelectedClasses.Font.Size := Round(imgbgfromLook.Width * 0.011);
  lblSelectedClasses.Transparent := True;
  lblSelectedClasses.Font.Color := RGB(0, 0, 0);
  lblSelectedClassesTop := imgbgfromLook.Top + Round(imgbgfromLook.Height * 0.51);
  lblSelectedClassesLeft := imgbgfromLook.Left + Round(imgbgfromLook.Width * 0.56);
  lblSelectedClasses.Left := lblSelectedClassesLeft;
  lblSelectedClasses.Top := lblSelectedClassesTop;

  //lblRemoveClasses: appearance on page

  lblRemoveClasses.Font.Name := 'Arial Rounded MT Bold';
  lblRemoveClasses.Font.Size := Round(imgbgfromLook.Width * 0.01);
  lblRemoveClasses.Transparent := True;
  lblRemoveClasses.Font.Color := RGB(0, 0, 0);
  lblRemoveClassesTop := imgbgfromLook.Top + Round(imgbgfromLook.Height * 0.528);
  lblRemoveClassesLeft := imgbgfromLook.Left + Round(imgbgfromLook.Width * 0.7);
  lblRemoveClasses.Left := lblRemoveClassesLeft;
  lblRemoveClasses.Top := lblRemoveClassesTop;


  end;


   //Adds custom font to Delphi program
procedure TFillInDetailsT.AddFontResourceAndBroadcast;
begin
  if AddFontResource('Revision System Project\FONTS\arial-rounded-mt-bold.ttf"') > 0 then
    SendMessage(HWND_BROADCAST, WM_FONTCHANGE, 0, 0);
end;

procedure TFillInDetailsT.imgQuitClick(Sender: TObject);
begin
  //check quitting form isn't already opened
if CustomDialogOpened = False then
  begin

    begin

    //Marks quitting form as opened so multiple can not be opened at once
    CustomDialogOpened := True;
    CustomDialogForm := TCustomDialogForm.Create(nil);
    //Position of quitting form
    SetWindowPos(CustomDialogForm.Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE);
    CustomDialogForm.Show;
  end;
  end
else
end;


procedure TFillInDetailsT.imgMathsBtnClick(Sender: TObject);
begin
 if Maths = True then
 begin
    Maths:= False;
  //Change image of button to darker
  imgMathsBtn.Picture.LoadFromFile('D:\School stuff\Revision System Project\IMG\SignUpPage\unselectedbtn.jpg');
   SubjectChosen:= False;
  end
  else
  begin
    if SubjectChosen = False then
    begin
  Maths:= True;
  imgMathsBtn.Picture.LoadFromFile('D:\School stuff\Revision System Project\IMG\SignUpPage\SelectedButton.jpg');
  SubjectChosen:= True;
  end
  else
  begin
  ShowMessage('You can only select one subject as a teacher, make sure you deselect chosen subject if you would like to change it');
  end;
  end
end;



procedure TFillInDetailsT.imgEnglishBtnClick(Sender: TObject);
begin
 if English = True then
 begin
    English:= False;
  //Change image of button to darker
  imgEnglishBtn.Picture.LoadFromFile('D:\School stuff\Revision System Project\IMG\SignUpPage\unselectedbtn.jpg');
  SubjectChosen:= False;
  end
  else
  begin
    if SubjectChosen = False then
    begin
  English:= True;
  imgEnglishBtn.Picture.LoadFromFile('D:\School stuff\Revision System Project\IMG\SignUpPage\SelectedButton.jpg');
  SubjectChosen:= True;
  end
  else
  begin
    ShowMessage('You can only select one subject as a teacher, make sure you deselect chosen subject if you would like to change it');
    end;
  end;
  end;

procedure TFillInDetailsT.imgChemistryBtnClick(Sender: TObject);
begin
 if Chemistry = True then
 begin
    Chemistry:= False;
  //Change image of button to darker
  imgChemistryBtn.Picture.LoadFromFile('D:\School stuff\Revision System Project\IMG\SignUpPage\unselectedbtn.jpg');
  SubjectChosen:= False;
  end
  else
  begin
    if SubjectChosen = False then
    begin
  Chemistry:= True;
  imgChemistryBtn.Picture.LoadFromFile('D:\School stuff\Revision System Project\IMG\SignUpPage\SelectedButton.jpg');
  SubjectChosen:= True;
  end
  else
  begin
    ShowMessage('You can only select one subject as a teacher, make sure you deselect chosen subject if you would like to change it');
    end;
  end;
  end;

procedure TFillInDetailsT.imgComputingBtnClick(Sender: TObject);
begin
 if Computing = True then
 begin
    Computing:= False;
  //Change image of button to darker
  imgComputingBtn.Picture.LoadFromFile('D:\School stuff\Revision System Project\IMG\SignUpPage\unselectedbtn.jpg');
  SubjectChosen:= False;
  end
  else
  begin
    if SubjectChosen = False then
    begin
  Computing:= True;
  imgComputingBtn.Picture.LoadFromFile('D:\School stuff\Revision System Project\IMG\SignUpPage\SelectedButton.jpg');
  SubjectChosen:= True;
  end
  else
  begin
    ShowMessage('You can only select one subject as a teacher, make sure you deselect chosen subject if you would like to change it');
    end;
  end;
  end;

procedure TFillInDetailsT.imgBiologyBtnClick(Sender: TObject);
begin
 if Biology = True then
 begin
    Biology:= False;
  //Change image of button to darker
  imgBiologyBtn.Picture.LoadFromFile('D:\School stuff\Revision System Project\IMG\SignUpPage\unselectedbtn.jpg');
  SubjectChosen:= False;
  end
  else
  begin
    if SubjectChosen = False then
    begin
  Biology:= True;
  imgBiologyBtn.Picture.LoadFromFile('D:\School stuff\Revision System Project\IMG\SignUpPage\SelectedButton.jpg');
  SubjectChosen:= True;
  end
  else
  begin
    ShowMessage('You can only select one subject as a teacher, make sure you deselect chosen subject if you would like to change it');
    end;
  end;
  end;

procedure TFillInDetailsT.imgPhysicsBtnClick(Sender: TObject);
begin
 if Physics = True then
 begin
    Physics:= False;
  //Change image of button to darker
  imgPhysicsBtn.Picture.LoadFromFile('D:\School stuff\Revision System Project\IMG\SignUpPage\unselectedbtn.jpg');
  SubjectChosen:= False;
  end
  else
  begin
    if SubjectChosen = False then
    begin
  Physics:= True;
  imgPhysicsBtn.Picture.LoadFromFile('D:\School stuff\Revision System Project\IMG\SignUpPage\SelectedButton.jpg');
  SubjectChosen:= True;
  end
  else
  begin
    ShowMessage('You can only select one subject as a teacher, make sure you deselect chosen subject if you would like to change it');
    end;
  end;
  end;

procedure TFillInDetailsT.imgGermanBtnClick(Sender: TObject);
begin
 if German = True then
 begin
    German:= False;
  //Change image of button to darker
  imgGermanBtn.Picture.LoadFromFile('D:\School stuff\Revision System Project\IMG\SignUpPage\unselectedbtn.jpg');
  SubjectChosen:= False;
  end
  else
  begin
    if SubjectChosen = False then
    begin
  German:= True;
  imgGermanBtn.Picture.LoadFromFile('D:\School stuff\Revision System Project\IMG\SignUpPage\SelectedButton.jpg');
  SubjectChosen:= True;
  end
  else
  begin
    ShowMessage('You can only select one subject as a teacher, make sure you deselect chosen subject if you would like to change it');
    end;
  end;
  end;

procedure TFillInDetailsT.imgSpanishBtnClick(Sender: TObject);
begin
 if Spanish = True then
 begin
    Spanish:= False;
  //Change image of button to darker
  imgSpanishBtn.Picture.LoadFromFile('D:\School stuff\Revision System Project\IMG\SignUpPage\unselectedbtn.jpg');
  SubjectChosen:= False;
  end
  else
  begin
    if SubjectChosen = False then
    begin
  Spanish:= True;
  imgSpanishBtn.Picture.LoadFromFile('D:\School stuff\Revision System Project\IMG\SignUpPage\SelectedButton.jpg');
  SubjectChosen:= True;
  end
  else
  begin
    ShowMessage('You can only select one subject as a teacher, make sure you deselect chosen subject if you would like to change it');
    end;
  end;
  end;

procedure TFillInDetailsT.imgSubmitClick(Sender: TObject);
var
  WhereClause: string;
begin

//ensures a user selected a subject
  if (Maths = False) and (English = false) and (Physics = false) and  (Chemistry = False) and (Biology = False) and (Computing = False) and (German  = False) and (Spanish = False) then
  begin
    ShowMessage('Please select a subject to start');
  end
  else
  begin

  SubjectChosen := True;
  qryFillTable.SQL.Text := 'SELECT TeacherClass.ClassName, TeacherClass.SubjectID, Subject.SubName ' +
                           'FROM TeacherClass ' +
                           'INNER JOIN Subject ON TeacherClass.SubjectID = Subject.SubjectID';

  //Initzialising where clause
  WhereClause := '';

  // Check if each subject is selected and add it to the WHERE clause
  if Biology then
    WhereClause := 'TeacherClass.SubjectID = ''B01''';

  if Physics then
  begin
    if WhereClause <> '' then
      WhereClause := WhereClause + ' OR ';
    WhereClause := WhereClause + 'TeacherClass.SubjectID = ''P01''';
  end;

  if German then
  begin
    if WhereClause <> '' then
      WhereClause := WhereClause + ' OR ';
    WhereClause := WhereClause + 'TeacherClass.SubjectID = ''G01''';
  end;

  if Spanish then
  begin
    if WhereClause <> '' then
      WhereClause := WhereClause + ' OR ';
    WhereClause := WhereClause + 'TeacherClass.SubjectID = ''S01''';
  end;

  if Maths then
  begin
    if WhereClause <> '' then
      WhereClause := WhereClause + ' OR ';
    WhereClause := WhereClause + 'TeacherClass.SubjectID = ''M01''';
  end;

  if English then
  begin
    if WhereClause <> '' then
      WhereClause := WhereClause + ' OR ';
    WhereClause := WhereClause + 'TeacherClass.SubjectID = ''E01''';
  end;

  if Chemistry then
  begin
    if WhereClause <> '' then
      WhereClause := WhereClause + ' OR ';
    WhereClause := WhereClause + 'TeacherClass.SubjectID = ''C01''';
  end;

  if Computing then
  begin
    if WhereClause <> '' then
      WhereClause := WhereClause + ' OR ';
    WhereClause := WhereClause + 'TeacherClass.SubjectID = ''CS01''';
  end;

  // If there's a WHERE clause, append it to the SQL query
  if WhereClause <> '' then
    qryFillTable.SQL.Text := qryFillTable.SQL.Text + ' WHERE ' + WhereClause + ' AND TeacherClass.TeacherID IS NULL';

  // Set the dataset and open the query
  dsFillTable.DataSet := qryFillTable;
  dbgrdSelectClassT.DataSource := dsFillTable;
  qryFillTable.Open;
  edtClassAdd.Clear;
  // Check if any records are returned after applying the WHERE clause
  if qryFillTable.RecordCount = 0 then
  begin
  ShowMessage('All classes in this subject have a teacher.');
  qryFillTable.Close; // Close the dataset
  end
end;
end;

procedure TFillInDetailsT.FindTeacherID;
begin
 qryTeacherID.SQL.Text := 'SELECT TeacherID FROM Teacher WHERE MainUserID = :UserID';
 qryTeacherID.Parameters.ParamByName('UserID').Value := CurrentUserID;
 qryTeacherID.Open;
 CurrentTeacherID := qryTeacherID.FieldByName('TeacherID').AsString;

end;

procedure TFillInDetailsT.imgSubmitClassClick(Sender: TObject);
var
  ClassFound: Boolean ;
begin
ClassToAdd := edtClassAdd.Text;

  if SubjectChosen = True then
  begin
   // Initialize ClassFound flag to false
  ClassFound := False;

  // Check if the dataset associated with the grid is active
  if not qryFillTable.Active then
    qryFillTable.Open;

  // Move to the first record in the dataset
  qryFillTable.First;

  // Loop through each record in the dataset
  while not qryFillTable.EOF do
  begin
    // Check if the value in the ClassName field matches ClassToAdd
    if qryFillTable.FieldByName('ClassName').AsString = ClassToAdd then
    begin
      // Set ClassFound flag to true
      ClassFound := True;
      // Exit the loop since the class is found
      Break;
    end;

    // Move to the next record in the dataset
    qryFillTable.Next;
  end;

  // If the class is not found, display a message
  if not ClassFound then
    ShowMessage('The class ' + ClassToAdd + ' is not available, select a valid class from the table.');
    end;


    if ClassFound = True then
    begin
     // Check if a row with the same MainUserID and ClassName already exists
      qryFillTable2.SQL.Text := 'SELECT COUNT(*) FROM ClassSelectionProcessTeacher WHERE ClassName = :ClassName AND MainUserID = :UserID';
      qryFillTable2.Parameters.ParamByName('ClassName').Value := ClassToAdd;
      qryFillTable2.Parameters.ParamByName('UserID').Value := CurrentUserID;
      qryFillTable2.Open;

    if qryFillTable2.Fields[0].AsInteger = 0 then
    begin
      // No existing row found, proceed with insertion
      qryFillTable2.Close;
      qryFillTable2.SQL.Text := 'INSERT INTO ClassSelectionProcessTeacher (ClassName, MainUserID) VALUES (:ClassName, :MainUserID)';
      qryFillTable2.Parameters.ParamByName('ClassName').Value := ClassToAdd;
      qryFillTable2.Parameters.ParamByName('MainUserID').Value := CurrentUserID;
      qryFillTable2.ExecSQL;
      edtClassAdd.Clear;

      // Refresh the dataset associated with the grid to reflect the changes
      qryFillTable2.SQL.Text := 'SELECT ClassName FROM ClassSelectionProcessTeacher WHERE MainUserID = :UserID';
      qryFillTable2.Parameters.ParamByName('UserID').Value := CurrentUserID;
      qryFillTable2.Open;

       // Optionally, show a message confirming the insertion
      ShowMessage('The class "' + ClassToAdd + '" has been successfully selected');
    end
    else
      begin
      // Existing row found, display a message or take appropriate action
      ShowMessage('The selected class "' + ClassToAdd + '" has already been selected');
      qryFillTable2.SQL.Text := 'SELECT ClassName FROM ClassSelectionProcessTeacher WHERE MainUserID = :UserID';
      qryFillTable2.Parameters.ParamByName('UserID').Value := CurrentUserID;
      qryFillTable2.Open;
      end;


    end;
    end;

    procedure TFillInDetailsT.imgRemoveClassClick(Sender: TObject);
begin
  ClassToRemove := edtRemoveClass.Text;
   conDelete.Open;
   conDelete.BeginTrans;
  // Remove the row from the database
  qryFillTable2.SQL.Text := 'DELETE FROM ClassSelectionProcessTeacher WHERE ClassName = :ClassName AND MainUserID = :UserID';
  qryFillTable2.Parameters.ParamByName('ClassName').Value := ClassToRemove;
  qryFillTable2.Parameters.ParamByName('UserID').Value := CurrentUserID;
  qryFillTable2.ExecSQL;
  conDelete.CommitTrans;
  conDelete.Close;

  // Refresh the dataset associated with the grid to reflect the changes
  qryFillTable2.SQL.Text := 'SELECT SelectionID, ClassName, MainUserID FROM ClassSelectionProcessTeacher WHERE MainUserID = :UserID';
  qryFillTable2.Parameters.ParamByName('UserID').Value := CurrentUserID;
  qryFillTable2.Open;
  qryFillTable2.Refresh;


  // Refresh the grid with the updated dataset
  dsClassesSelected.DataSet := qryFillTable2;
  dbgrdClassesSelected.DataSource := dsClassesSelected;
  dbgrdClassesSelected.Refresh;
  dbgrdClassesSelected.Update; // Force immediate update of the grid
  // Optionally, show a message confirming the deletion
  if qryFillTable2.RowsAffected > 0 then
  begin
    ShowMessage('The class "' + ClassToRemove + '" has been successfully removed');
    edtRemoveClass.Clear;
  end
  else
  begin
    ShowMessage('The class "' + ClassToRemove + '" does not exist for the current user');
    edtRemoveClass.Clear;
  end;
end;

function TFillInDetailsT.GetSubjectID(const ClassName: string): string;
begin
  qrySubjectID.SQL.Text := 'SELECT SubjectID FROM Subject WHERE SubjectID = (SELECT SubjectID FROM TeacherClass WHERE ClassName = :ClassName)';
  qrySubjectID.Parameters.ParamByName('ClassName').Value := ClassName;
  qrySubjectID.Open;
  try
    if not qrySubjectID.IsEmpty then
      Result := qrySubjectID.FieldByName('SubjectID').AsString
    else
      Result := '';
  finally
    qrySubjectID.Close;
  end;
end;

procedure TFillInDetailsT.imgFinalSubmitClick(Sender: TObject);
var
  TeacherID, SubjectID: string;
  DetailFillIn: Boolean;
begin
  // Get the TeacherID associated with the current user
  qryTeacherID.SQL.Text := 'SELECT TeacherID FROM Teacher WHERE MainUserID = :UserID';
  qryTeacherID.Parameters.ParamByName('UserID').Value := CurrentUserID;
  qryTeacherID.Open;
  if not qryTeacherID.IsEmpty then
    TeacherID := qryTeacherID.FieldByName('TeacherID').AsString
  else
  begin
    ShowMessage('Teacher ID not found for the current user.');
    Exit; // Exit the procedure if TeacherID is not found
  end;

  // Select ClassName from ClassSelectionProcessStudent for the current user
  qrySelectClasses.SQL.Text := 'SELECT ClassName FROM ClassSelectionProcessTeacher WHERE MainUserID = :UserID';
  qrySelectClasses.Parameters.ParamByName('UserID').Value := CurrentUserID;
  qrySelectClasses.Open;
  while not qrySelectClasses.Eof do
  begin
    // Get SubjectID for the current ClassName
    SubjectID := GetSubjectID(qrySelectClasses.FieldByName('ClassName').AsString);
      // Insert ClassName, TeacherID, and SubjectID into qryAddClassesFinal
      qryAddClassesFinal.SQL.Text := 'UPDATE TeacherClass SET TeacherID = :TeacherID WHERE ClassName =:ClassName';
      qryAddClassesFinal.Parameters.ParamByName('ClassName').Value := qrySelectClasses.FieldByName('ClassName').AsString;
      qryAddClassesFinal.Parameters.ParamByName('TeacherID').Value := TeacherID;
      qryAddClassesFinal.ExecSQL;
      DetailFillIn:=True;
    qrySelectClasses.Next;
  end;

  if DetailFillIn = true then
  begin
  qryUpdateDataEntry.SQL.Text := 'UPDATE account SET DataEntryDone = :DataEntryDone WHERE MainUserID = :UserID';
  qryUpdateDataEntry.Parameters.ParamByName('DataEntryDone').Value := True;
  qryUpdateDataEntry.Parameters.ParamByName('UserID').Value := CurrentUserID;
  qryUpdateDataEntry.ExecSQL;

  FillInDetailsT.Hide;
  TeacherNavigation.Show;
  end;

end;



end.
