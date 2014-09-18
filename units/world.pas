unit world;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ExtCtrls, Controls, Graphics;

type

  TTileType = (ttGrass, ttTree, ttRock, ttRomanHouse, ttGermanHouse, ttSlavonicHouse);
  TTiles = array of array of TTileType;

  TMap = class
  private
    FWidth, FHeight: integer;
    FTiles: TTiles;
    FTileSize: integer;
    FTreeCount: integer;

    procedure GenerateForest(x, y: integer);
    procedure GenerateHills(x, y: integer);
    //private Generate

  public
    constructor Create;
    constructor Create(Width, Height: integer); overload;

    procedure Generate(Width, Height: integer);
    procedure ToImage(AImage: TImage; AImageList: TImageList);
    function ToText: TStringList;

    property TileSize: integer read FTileSize write FTileSize;
    property Tiles: TTiles read FTiles write FTiles;
    property TreeCount: integer read FTreeCount write FTreeCount;
  end;


implementation

constructor TMap.Create;
begin
  SetLength(FTiles, 0, 0);
end;

constructor TMap.Create(Width, Height: integer);
begin
  self.Generate(Width, Height);
  Randomize;
end;

procedure TMap.Generate(Width, Height: integer);
var
  x, y: integer;
begin
  FTreeCount := 0;
  SetLength(FTiles, Width, Height);
  FWidth := Width;
  FHeight := Height;
  for y := 0 to Height - 1 do
  begin
    for x := 0 to Width - 1 do
    begin
      FTiles[x, y] := TTileType.ttGrass;//TTileType(Random(6));
      if (Random(100) > 98) then
        GenerateForest(x, y);
    end;
  end;
end;

function TMap.ToText: TStringList;
var
  x, y: integer;
  line: string;
begin
  Result := TStringList.Create;
  for y := 0 to FHeight - 1 do
  begin
    line := '';
    for x := 0 to FWidth - 1 do
    begin
      line := line + IntToStr(integer(FTiles[x, y])) + ',  ';
    end;
    Result.Add(line);
  end;
end;

procedure TMap.ToImage(AImage: TImage; AImageList: TImageList);
var
  x, y: integer;
  img: TImage;
begin
  img := TImage.Create(nil);

  for y := 0 to FHeight - 1 do
  begin
    for x := 0 to FWidth - 1 do
    begin
      img.Picture.Bitmap.Clear;
      AImageList.GetBitmap(integer(FTiles[x, y]), img.Picture.Bitmap);
      AImage.Canvas.Draw(x * FTileSize, y * FTileSize, img.Picture.Bitmap);
    end;
  end;
end;

procedure TMap.GenerateForest(x, y: integer);
var
  extent: integer;    // extent of the forest
  Count: integer;     // number of trees
  I: integer;
  newx, newy: integer;
begin
  extent := random(10)+1;
  Count := Random(50) + 15;
  FTiles[x, y] := TTileType.ttTree;
  Inc(FTreeCount);

  for I := 0 to Count - 1 do
  begin
    newx := Random(extent) - 5;
    newy := Random(extent) - 5;
    if (x + newx < self.FWidth) and (y + newy < self.FHeight) then
    begin
      if (x + newx >= 0) and (y + newy >= 0) then
      begin
        if (FTiles[x + newx, y + newy] = TTileType.ttGrass) then
        begin
          FTiles[x + newx, y + newy] := TTileType.ttTree;
          Inc(FTreeCount);
        end;
      end;
    end;
  end;
end;

procedure TMap.GenerateHills(x, y: integer);
begin

end;

end.
