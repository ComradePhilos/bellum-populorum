unit world;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ExtCtrls, Controls, Graphics, Math;

type

  TTileType = (ttGrass, ttTree, ttRock, ttRomanHouse, ttGermanHouse, ttSlavonicHouse);
  TTiles = array of array of TTileType;

  TMap = class
  private
    FWidth, FHeight: integer;
    FTiles: TTiles;
    FTileSize: integer;

    procedure GenerateForest(x, y: integer);
    procedure GenerateRocks(x, y: integer);

  public
    constructor Create;
    constructor Create(Width, Height: integer); overload;

    procedure Generate(Width, Height: integer);
    procedure ToImage(AImage: TImage; AImageList: TImageList);
    function ToText: TStringList;

    property TileSize: integer read FTileSize write FTileSize;
    property Tiles: TTiles read FTiles write FTiles;
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
  SetLength(FTiles, Width, Height);
  FWidth := Width;
  FHeight := Height;
  for y := 0 to Height - 1 do
  begin
    for x := 0 to Width - 1 do
    begin
      FTiles[x, y] := TTileType.ttGrass;
      if (Random(100) > 98) then
        GenerateRocks(x, y);
      if (Random(100) > 95) then
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
  dist: integer;
begin
  extent := random(10) + 1;
  Count := Random(80) + 15;
  FTiles[x, y] := TTileType.ttTree;

  for I := 0 to Count - 1 do
  begin
    newx := x + Random(extent) - 5;
    newy := y + Random(extent) - 5;
    if (newx < self.FWidth) and (newy < self.FHeight) then
    begin
      if (newx >= 0) and (newy >= 0) then
      begin
        dist := round(power((x - newx), 2)) + round(power((y - newy), 2));
        if (dist <= extent) then
        begin
          if (FTiles[newx, newy] = TTileType.ttGrass) then
          begin
            FTiles[newx, newy] := TTileType.ttTree;
          end;
        end;
      end;
    end;
  end;
end;

procedure TMap.GenerateRocks(x, y: integer);
var
  extent: integer;    // extent of the rocks
  Count: integer;     // number of rocks
  I: integer;
  newx, newy: integer;
  dist: integer;
begin
  extent := random(5) + 1;
  Count := Random(15) + 3;
  FTiles[x, y] := TTileType.ttRock;

  for I := 0 to Count - 1 do
  begin
    newx := x + Random(extent) - 3;
    newy := y + Random(extent) - 3;
    if (newx < self.FWidth) and (newy < self.FHeight) then
    begin
      if (newx >= 0) and (newy >= 0) then
      begin
        dist := round(power((x - newx), 2)) + round(power((y - newy), 2));
        if (dist <= extent) then
        begin
          if (FTiles[newx, newy] = TTileType.ttGrass) then
          begin
            FTiles[newx, newy] := TTileType.ttRock;
          end;
        end;
      end;
    end;
  end;
end;

end.
