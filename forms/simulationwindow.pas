unit SimulationWindow;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, RTTICtrls, Forms, Controls, Graphics,
	Dialogs, StdCtrls, ExtCtrls, Buttons, ComCtrls, Menus, Arrow, fgl, world, sim;

type

  { TForm2 }

  TForm2 = class(TForm)
				Arrow1: TArrow;
				Arrow2: TArrow;
				Arrow3: TArrow;
				Arrow4: TArrow;
				BitBtn1: TBitBtn;
				BitBtn2: TBitBtn;
				BitBtn3: TBitBtn;
				BitBtn4: TBitBtn;
    GenerateButton: TBitBtn;
		Edit1: TEdit;
		GroupBox1: TGroupBox;
	  Image1: TImage;
		Image2: TImage;
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
		StatusBar1: TStatusBar;
		Timer1: TTimer;
		Timer2: TTimer;
		ToolBar1: TToolBar;
		TrackBar1: TTrackBar;
	procedure BitBtn1Click(Sender: TObject);
	procedure BitBtn2Click(Sender: TObject);
	procedure BitBtn3Click(Sender: TObject);
	procedure BitBtn4Click(Sender: TObject);
  procedure FormResize(Sender: TObject);
    procedure GenerateButtonClick(Sender: TObject);
		procedure Edit1Change(Sender: TObject);
		//procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure Image1Paint(Sender: TObject);
		procedure Image1Resize(Sender: TObject);
		procedure Timer2Timer(Sender: TObject);
		procedure TrackBar1Change(Sender: TObject);
  private
    { private declarations }
    FDuration: Integer;
    FSim: TSimulation;
    FID: Integer;

    procedure DrawMap(Sender: TObject);

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
  self.DoubleBuffered := True;
  FSim := TSimulation.Create;
  FDuration := 3000;
  Trackbar1.Position := FDuration;
  Edit1.Text := IntToStr(FDuration);
  FSim.Map.OnChange := @DrawMap;
  Image1.Picture.Bitmap.Width := Image1.Width;
  Image1.Picture.Bitmap.Height := Image1.Height;
  self.Constraints.MinHeight := self.Height;
  self.Constraints.MinWidth := self.Width;
end;

procedure TForm2.Image1Paint(Sender: TObject);
begin
  FSim.Map.DrawToCanvas(Image1.Canvas);
end;

procedure TForm2.GenerateButtonClick(Sender: TObject);
var
  x,y: Integer;
  tmp: TMapSetup;
begin
  GenerateButton.Enabled := False;
  Application.ProcessMessages;

  tmp := FSim.Map.getParameters;

  x := StrToInt(LabeledEdit1.Text);
  y := StrToInt(LabeledEdit2.Text);
  tmp.Width := x;
  tmp.Height := y;
  FSim.Map.Generate(tmp);

  FSim.Map.DrawToCanvas(Image1.Picture.Bitmap.Canvas);
  GenerateButton.Enabled := True;

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
  FSim.Map.DrawToCanvas(Image1.Canvas);
end;

procedure TForm2.BitBtn2Click(Sender: TObject);
begin
  FSim.Map.ScrollDown;
  FSim.Map.DrawToCanvas(Image1.Canvas);
end;

procedure TForm2.BitBtn3Click(Sender: TObject);
begin
  FSim.Map.ScrollUp;
  FSim.Map.DrawToCanvas(Image1.Canvas);
end;

procedure TForm2.BitBtn4Click(Sender: TObject);
begin
   FSim.Map.ScrollLeft;
  FSim.Map.DrawToCanvas(Image1.Canvas);
end;

procedure TForm2.Edit1Change(Sender: TObject);
begin
  if TryStrToInt(Edit1.Text, FDuration) then
  begin
    Trackbar1.Position := FDuration;
    Timer1.Interval := FDuration;
	end;
end;

procedure TForm2.Image1Resize(Sender: TObject);
begin
  Image1.Picture.Bitmap.Width := Image1.Width;
  Image1.Picture.Bitmap.Height := Image1.Height;
end;

procedure TForm2.Timer2Timer(Sender: TObject);
begin
  Image1.Visible := True;
  //DrawMap(nil);
  Timer2.Enabled := False;
end;

procedure TForm2.TrackBar1Change(Sender: TObject);
begin
  Edit1.Text := IntToStr(TrackBar1.Position);
end;

procedure TForm2.DrawMap(Sender: TObject);
begin
  FSim.Map.DrawToCanvas(Image1.Canvas);
end;

end.

