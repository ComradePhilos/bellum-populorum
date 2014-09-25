unit SimulationWindow;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Buttons, ComCtrls, Menus, fgl,
  world, sim;

type

  TMyOnDestroyEvent = procedure(Sender: TObject) of object;

  { TForm2 }

  TForm2 = class(TForm)
    GenerateButton: TBitBtn;
		Edit1: TEdit;
		Image1: TImage;
		Image2: TImage;
		ImageList1: TImageList;
		Label1: TLabel;
		LabeledEdit1: TLabeledEdit;
		LabeledEdit2: TLabeledEdit;
		MainMenu1: TMainMenu;
		MenuItem1: TMenuItem;
		MenuItem2: TMenuItem;
		MenuItem3: TMenuItem;
		MenuItem4: TMenuItem;
		MenuItem5: TMenuItem;
		MenuItem6: TMenuItem;
		MenuItem7: TMenuItem;
		Timer1: TTimer;
		TrackBar1: TTrackBar;
		procedure FormResize(Sender: TObject);
    procedure GenerateButtonClick(Sender: TObject);
		procedure Edit1Change(Sender: TObject);
		procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
		procedure Image1Resize(Sender: TObject);
		procedure TrackBar1Change(Sender: TObject);
  private
    { private declarations }
    FDuration: Integer;
    FSim: TSimulation;
    FID: Integer;

    FMyOnDestroy: TMyOnDestroyEvent;

    procedure DrawMap(Sender: TObject);

  public
    property Sim: TSimulation read FSim write FSim;
    property ID: Integer read FID write FID;
    property MyOnDestroy: TMyOnDestroyEvent read FMyOnDestroy write FMyOnDestroy;

  end;

  TSimFormList = specialize TFPGObjectList<TForm2>;

var
  Form2: TForm2;

implementation

{$R *.lfm}

{ TForm2 }

procedure TForm2.GenerateButtonClick(Sender: TObject);
var
  x,y: Integer;
  tmp: TMapSetup;
begin
  tmp := FSim.Map.MapSettings;

  x := StrToInt(LabeledEdit1.Text);
  y := StrToInt(LabeledEdit2.Text);
  tmp.Width := x;
  tmp.Height := y;
  FSim.Map.MapSettings := tmp;
  FSim.Map.Generate;

  FSim.Map.DrawToCanvas(Image1.Picture.Bitmap.Canvas, ImageList1);
end;

procedure TForm2.FormResize(Sender: TObject);
begin
  DrawMap(nil);
end;

procedure TForm2.Edit1Change(Sender: TObject);
begin
  if TryStrToInt(Edit1.Text, FDuration) then
  begin
    Trackbar1.Position := FDuration;
    Timer1.Interval := FDuration;
	end;
end;

procedure TForm2.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if Assigned(FMyOnDestroy) then
  begin
    //FMyOnDestroy(self);
	end;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  FSim := TSimulation.Create;
  FDuration := 3000;
  Trackbar1.Position := FDuration;
  Edit1.Text := IntToStr(FDuration);
  FSim.Map.OnChange := @DrawMap;
  Image1.Picture.Bitmap.Width := Image1.Width;
  Image1.Picture.Bitmap.Height := Image1.Height;
end;

procedure TForm2.Image1Resize(Sender: TObject);
begin
  Image1.Picture.Bitmap.Width := Image1.Width;
  Image1.Picture.Bitmap.Height := Image1.Height;
end;

procedure TForm2.TrackBar1Change(Sender: TObject);
begin
  Edit1.Text := IntToStr(TrackBar1.Position);
end;

procedure TForm2.DrawMap(Sender: TObject);
begin
  FSim.Map.DrawToCanvas(Image1.Canvas, ImageList1);
end;

end.

