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
    BitBtn1: TBitBtn;
		Edit1: TEdit;
		Image2: TImage;
		ImageList1: TImageList;
		Label1: TLabel;
		LabeledEdit1: TLabeledEdit;
		LabeledEdit2: TLabeledEdit;
		MainMenu1: TMainMenu;
    Memo1: TMemo;
		MenuItem1: TMenuItem;
		MenuItem2: TMenuItem;
		MenuItem3: TMenuItem;
		MenuItem4: TMenuItem;
		MenuItem5: TMenuItem;
		MenuItem6: TMenuItem;
		MenuItem7: TMenuItem;
		Panel1: TPanel;
		Timer1: TTimer;
		TrackBar1: TTrackBar;
    procedure BitBtn1Click(Sender: TObject);
		procedure Edit1Change(Sender: TObject);
		procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
		procedure FormPaint(Sender: TObject);
		procedure TrackBar1Change(Sender: TObject);
  private
    { private declarations }
    FDuration: Integer;
    FSim: TSimulation;
    FID: Integer;

    FMyOnDestroy: TMyOnDestroyEvent;

    procedure DrawMap;

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

procedure TForm2.BitBtn1Click(Sender: TObject);
var
  x,y: Integer;
  mapsettings: TMapSetup;
begin
  x := StrToInt(LabeledEdit1.Text);
  y := StrToInt(LabeledEdit2.Text);
  mapsettings.Width := x;
  mapsettings.Height := y;
  mapsettings.TileSize := 8;
  FSim.Map.MapSettings := mapsettings;
  FSim.Map.Generate;

  Memo1.Clear;
  Memo1.Lines.AddStrings(FSim.Map.ToText);
  FSim.Map.DrawToCanvas(Panel1.Canvas, ImageList1);
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
  FSim.Map.DrawToCanvas(Panel1.Canvas, ImageList1);
  Panel1.OnPaint := @FormPaint;
end;

procedure TForm2.FormDestroy(Sender: TObject);
begin
  FSim.Free;
end;

procedure TForm2.FormPaint(Sender: TObject);
begin
  DrawMap;
end;

procedure TForm2.TrackBar1Change(Sender: TObject);
begin
  Edit1.Text := IntToStr(TrackBar1.Position);
end;

procedure TForm2.DrawMap;
begin
  FSim.Map.DrawToCanvas(Panel1.Canvas, ImageList1);
end;

end.

