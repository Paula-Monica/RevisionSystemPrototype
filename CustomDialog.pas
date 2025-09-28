unit CustomDialog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, jpeg, ExtCtrls;

type
  TCustomDialogForm = class(TForm)
    imgBg: TImage;
    imgbtnYes: TImage;
    imgbtnNo: TImage;
    lblAreyousure: TLabel;
  procedure FormCreate(Sender: TObject);
  procedure imgbtnYesClick(Sender: TObject);
  procedure imgbtnNoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CustomDialogForm: TCustomDialogForm;
  imgbtnYesTop, imgbtnYesLeft: Integer;
  imgbtnNoTop, imgbtnNoLeft: Integer;
  lblAreyousureTop, lblAreyousureLeft: Integer;
  CustomDialogOpened: Boolean;

implementation

uses LoginPage;

{$R *.dfm}


procedure TCustomDialogForm.FormCreate(Sender: TObject);
  begin

    //Form size and position

    BorderStyle := bsSingle;
    FormStyle := fsStayOnTop;

    Width := Round(LoginForm.Width * 0.3);
    Height := Round(LoginForm.Height * 0.3);

    Position := poMainFormCenter;

    //imgbtnYes: appearance on page

    imgbtnYesTop := Round(ClientHeight * 0.5);
    imgbtnYesLeft := Round(ClientWidth * 0.46);
    imgbtnYes.Left := imgbtnYesLeft;
    imgbtnYes.Top := imgbtnYesTop;
    imgbtnYes.Constraints.MinWidth := Round(ClientWidth * 0.5);
    imgbtnYes.Constraints.MaxWidth := Round(ClientWidth * 0.5);
    imgbtnYes.Constraints.MinHeight := Round(ClientHeight * 0.4);
    imgbtnYes.Constraints.MaxHeight := Round(ClientHeight * 0.4);

    //imgbtnNo: appearance on page

    imgbtnNoTop := Round(ClientHeight * 0.5);
    imgbtnNoLeft := Round(ClientWidth * 0.015);
    imgbtnNo.Left := imgbtnNoLeft;
    imgbtnNo.Top := imgbtnNoTop;
    imgbtnNo.Constraints.MinWidth := Round(ClientWidth * 0.5);
    imgbtnNo.Constraints.MaxWidth := Round(ClientWidth * 0.5);
    imgbtnNo.Constraints.MinHeight := Round(ClientHeight * 0.4);
    imgbtnNo.Constraints.MaxHeight := Round(ClientHeight * 0.4);

    //lblAreyousure: appearance on page

    lblAreyousure.Font.Name := 'Arial Rounded MT Bold';
    lblAreyousure.Font.Size :=  Round(ClientWidth * 0.04);
    lblAreyousure.Transparent := True;
    lblAreyousure.Font.Color := RGB(232, 232, 232);
    lblAreyousure.Font.Style := lblAreyousure.Font.Style + [fsUnderline];
    lblAreyousureTop := Round(ClientHeight * 0.255);
    lblAreyousureLeft := Round(ClientWidth * 0.09);
    lblAreyousure.Left := lblAreyousureLeft;
    lblAreyousure.Top := lblAreyousureTop;
    lblAreyousure.Constraints.MinWidth := Round(ClientWidth * 0.85);
    lblAreyousure.Constraints.MaxWidth := Round(ClientWidth * 0.85);
    lblAreyousure.Constraints.MinHeight := Round(ClientHeight * 0.4);
    lblAreyousure.Constraints.MaxHeight := Round(ClientHeight * 0.4);



  end;



  procedure TCustomDialogForm.imgbtnYesClick(Sender: TObject);
begin
//RemoveFontResource();
Halt;
end;

  procedure TCustomDialogForm.imgbtnNoClick(Sender: TObject);
begin
  CustomDialogOpened := False;
  CustomDialogForm.Hide;
end;

end.
