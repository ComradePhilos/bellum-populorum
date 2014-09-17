unit world;

{$mode objfpc}{$H+}

interface

uses
      Classes, SysUtils, ExtCtrls, Controls, Graphics;
type

TTileType = (ttGrass, ttTree, ttRock, ttRomanHouse, ttGermanHouse, ttSlavonicHouse);
TTiles = array of array of TTileType;

TMap = Class
  private
    FWidth, FHeight: Integer;
    FTiles : TTiles;
    FTileSize: Integer;

  public
    constructor Create;
    constructor Create(width, height: Integer); overload;

    procedure Generate(width, height: Integer);
    procedure ToImage(AImage: TImage; AImageList: TImageList);
    function ToText: TStringList;
    property TileSize: Integer read FTileSize write FTileSize;
    property Tiles: TTiles read FTiles write FTiles;
end;


implementation

constructor TMap.Create;
begin
  SetLength(FTiles, 0,0);
end;

constructor TMap.Create(width, height: Integer);
begin
  self.Generate(width,height);
end;

procedure TMap.Generate(width, height: Integer);
var
  x, y: Integer;
begin
  SetLength(FTiles, width, height);
  FWidth := width;
  FHeight := height;
  Randomize;
  for y := 0 to height - 1 do
  begin
    for x := 0 to width - 1 do
    begin
      FTiles[x,y] := TTileType(Random(6));
    end;
  end;
end;

function TMap.ToText: TStringList;
var
  x, y: Integer;
  line: String;
begin
  Result := TStringList.Create;
  for y := 0 to FHeight - 1 do
  begin
    line := '';
    for x := 0 to FWidth - 1 do
    begin
      line := line + IntToStr(Integer(FTiles[x,y])) + ',  ';
		end;
    Result.Add(line);
	end;
end;

procedure TMap.ToImage(AImage: TImage; AImageList: TImageList);
var
  x,y: Integer;
  img: TImage;
begin
  img := TImage.Create(nil);

  for y := 0 to FHeight - 1 do
  begin
    for x := 0 to FWidth - 1 do
    begin
      img.Picture.Bitmap.Clear;
      AImageList.GetBitmap(Integer(FTiles[x,y]), img.Picture.Bitmap);
      AImage.Canvas.Draw(x*8, y*8, img.Picture.Bitmap );
		end;
	end;
end;

end.

