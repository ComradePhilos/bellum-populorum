unit SimulationWindow;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Buttons,
  world, sim;

type

  { TForm2 }

  TForm2 = class(TForm)
    BitBtn1: TBitBtn;
		Image1: TImage;
		Image2: TImage;
		ImageList1: TImageList;
    Memo1: TMemo;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
		procedure Image2Click(Sender: TObject);
  private
    { private declarations }

  public
    FSim: TSimulation;

  end;

var
  Form2: TForm2;

implementation

{$R *.lfm}

{ TForm2 }

procedure TForm2.BitBtn1Click(Sender: TObject);
var
  x,y: Integer;
begin
  FSim.Map.Generate(20, 20);
  Memo1.Clear;
  Memo1.Lines.AddStrings(FSim.Map.ToText);
  //FSim.Map.ToImage(Image1, ImageList1);
  for y := 0 to 20 - 1 do
  begin
    for x := 0 to 20 - 1 do
    begin
      Image2.Canvas.Clear;
      ImageList1.GetBitmap(Integer(FSim.Map.Tiles[x,y])-1, Image2.Picture.Bitmap);
      Image1.Canvas.Draw(x*8, y*8, Image2.Picture.Bitmap );//Image2.Picture.Bitmap);
		end;
	end;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  FSim := TSimulation.Create;
  //Image1.Canvas.Brush.Color := clBlack;
  //Image1.Canvas.FillRect(0,0,Image1.Width, Image1.Height);
  FSim.Map.TileSize := 8;
end;

procedure TForm2.FormDestroy(Sender: TObject);
begin
  FSim.Free;
end;

procedure TForm2.Image2Click(Sender: TObject);
begin

end;


end.

