unit SimulationWindow;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, RTTICtrls, Forms, Controls, Graphics, Math,
	Dialogs, StdCtrls, ExtCtrls, Buttons, ComCtrls, Menus, Arrow, fgl, world, sim, definitions;

type

  { TForm2 }

  TForm2 = class(TForm)
		BitBtn1: TBitBtn;
		BitBtn2: TBitBtn;
		BitBtn3: TBitBtn;
		BitBtn4: TBitBtn;
		BitBtn5: TBitBtn;
		BitBtn6: TBitBtn;
		Edit1: TEdit;
		GroupBox1: TGroupBox;
	  Image1: TImage;
		Image2: TImage;
		Label1: TLabel;
		Label2: TLabel;
		MainMenu1: TMainMenu;
		MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
		MenuItem2: TMenuItem;
		MenuItem3: TMenuItem;
		MenuItem4: TMenuItem;
		MenuItem5: TMenuItem;
		MenuItem6: TMenuItem;
		MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
		StatusBar1: TStatusBar;
		RoundTimer: TTimer;
		Timer2: TTimer;
		ToolBar1: TToolBar;
		TrackBar1: TTrackBar;
	  procedure BitBtn1Click(Sender: TObject);
	  procedure BitBtn2Click(Sender: TObject);
	  procedure BitBtn3Click(Sender: TObject);
	  procedure BitBtn4Click(Sender: TObject);
		procedure BitBtn5Click(Sender: TObject);
		procedure BitBtn6Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
		procedure Edit1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1Paint(Sender: TObject);
		procedure Image1Resize(Sender: TObject);
    procedure MenuItem10Click(Sender: TObject);
		procedure RoundTimerTimer(Sender: TObject);
		procedure Timer2Timer(Sender: TObject);
		procedure TrackBar1Change(Sender: TObject);
  private
    { private declarations }
    FDuration: Integer;
    FSim: TSimulation;
    FID: Integer;

    procedure DrawMap(Sender: TObject);
    function IsInbounds(ACanvas: TCanvas; x, y: Integer): Boolean;

  public
    property Sim: TSimulation read FSim write FSim;
    property ID: Integer read FID write FID;

  end;

  TSimFormList = specialize TFPGObjectList<TForm2>;

var
  Form2: TForm2;

implementation

{$R *.lfm}

procedure TForm2.FormCreate(Sender: TObject);
begin
  FSim := TSimulation.Create;
  FDuration := 100;
  Trackbar1.Position := FDuration;
  Edit1.Text := IntToStr(FDuration);
  FSim.Map.OnChange := @DrawMap;
  Image1.Picture.Bitmap.Width := Image1.Width;
  Image1.Picture.Bitmap.Height := Image1.Height;
  self.Constraints.MinHeight := self.Height;
  self.Constraints.MinWidth := self.Width;
end;

procedure TForm2.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  posx, posy: Integer;
begin
  posx := round(x/FSim.Map.Tilesize);
  posy := round(y/FSim.Map.Tilesize);
  FSim.Map.AddTree(posx,posy);
end;

procedure TForm2.Image1Paint(Sender: TObject);
begin
  DrawMap(nil);
end;

procedure TForm2.FormResize(Sender: TObject);
begin
  Image1.Visible := False;
  Timer2.Enabled := False;
  Timer2.Enabled := True;
end;

procedure TForm2.BitBtn1Click(Sender: TObject);
begin
  FSim.Map.ScrollRight;
end;

procedure TForm2.BitBtn2Click(Sender: TObject);
begin
  FSim.Map.ScrollDown;
end;

procedure TForm2.BitBtn3Click(Sender: TObject);
begin
  FSim.Map.ScrollUp;
end;

procedure TForm2.BitBtn4Click(Sender: TObject);
begin
   FSim.Map.ScrollLeft;
end;

procedure TForm2.BitBtn5Click(Sender: TObject);
begin
   RoundTimer.Interval := StrToInt(Edit1.Text);
   RoundTimer.Enabled := True;
end;

procedure TForm2.BitBtn6Click(Sender: TObject);
begin
   RoundTimer.Enabled := False;
end;

procedure TForm2.Edit1Change(Sender: TObject);
begin
  if TryStrToInt(Edit1.Text, FDuration) then
  begin
    Trackbar1.Position := FDuration;
    RoundTimer.Interval := FDuration;
	end;
end;

procedure TForm2.Image1Resize(Sender: TObject);
begin
  Image1.Picture.Bitmap.Width := Image1.Width;
  Image1.Picture.Bitmap.Height := Image1.Height;
end;

procedure TForm2.MenuItem10Click(Sender: TObject);
begin
  FSim.Initialize;
end;

procedure TForm2.RoundTimerTimer(Sender: TObject);
begin
  FSim.DoStep;
  Label2.Caption := 'Round: ' + IntToStr(FSim.Round);
end;

procedure TForm2.Timer2Timer(Sender: TObject);
begin
  Image1.Visible := True;
  Timer2.Enabled := False;
end;

procedure TForm2.TrackBar1Change(Sender: TObject);
begin
  Edit1.Text := IntToStr(TrackBar1.Position);
end;

procedure TForm2.DrawMap(Sender: TObject);
var
  I: Integer;
  x, y: integer;
  tmpbmp: TBitMap;
  posx, posy: Integer;
begin
  tmpbmp := TBitMap.Create;
  try
  tmpbmp.PixelFormat := pf32Bit;
  tmpbmp.Width := Image1.Width;
  tmpbmp.Height := Image1.Height;
  tmpbmp.Canvas.Brush.Color := clBlack;
  tmpbmp.Canvas.FillRect(0, 0, tmpbmp.Width, tmpbmp.Height);
  Image1.Canvas.Clear;
  Image1.Canvas.Brush.Color := clBlack;
  Image1.Canvas.FillRect(0, 0, Image1.Canvas.Width, Image1.Canvas.Height);

  with FSim do
  begin

    for y := 0 to Map.Height - 1 do
    begin
      for x := 0 to Map.Width - 1 do
      begin
        posx := (x - Map.Scrollx)*Map.TileSize;
        posy := (y - Map.Scrolly)*Map.TileSize;
        if IsInbounds(tmpbmp.Canvas, posx, posy) then
        begin
          tmpbmp.Canvas.Draw(posx, posy, ImageGrass.Picture.Bitmap);
        end;
      end;
    end;

    for I := 0 to Map.MapObjects.Count - 1 do
    begin
      posx := (Map.MapObjects[I].x - Map.Scrollx)*Map.TileSize;
      posy := (Map.MapObjects[I].y - Map.Scrolly)*Map.TileSize;
      if IsInbounds(tmpbmp.Canvas, posx, posy) and assigned(Map.MapObjects[I].Picture) then
        tmpbmp.Canvas.Draw(posx, posy, Map.MapObjects[I].Picture.Bitmap);
		end;
	end;

  Image1.Canvas.Draw(0,0, tmpbmp);
  finally
    tmpbmp.Free;
  end;
end;

function TForm2.IsInbounds(ACanvas: TCanvas; x, y: Integer): Boolean;
begin
  Result := False;
  if (x >= 0) and (x < ACanvas.Width) then
  begin
    if (y >= 0) and (y < ACanvas.Height) then
    begin
      Result := True;
    end;
  end;
end;

end.

