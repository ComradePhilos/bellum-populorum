unit world;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ExtCtrls, Controls, Graphics, Math;

type

  TOnChangeEvent = procedure(Sender: TObject) of object;

  TTileType = (ttGrass, ttTree, ttRock, ttRomanHouse, ttGermanHouse, ttSlavonicHouse);
  TTiles = array of array of TTileType;

  TMapSetup = record
    Width: integer;
    Height: integer;
    TileSize: Integer;
    ProbForest: integer;
    ProbRocks: integer;
  end;

  TMap = class
  private
    FMapSettings: TMapSetup;
    FTiles: TTiles;
    FOnChange: TOnChangeEvent;

    procedure GenerateForest(x, y: integer);
    procedure GenerateRocks(x, y: integer);

  public
    constructor Create;
    constructor Create(AMapSettings: TMapSetup); overload;

    procedure Generate; overload;
    procedure Generate(AMapSettings: TMapSetup);
    procedure DrawToCanvas(ACanvas: TCanvas; AImageList: TImageList);
    function ToText: TStringList;

    property MapSettings: TMapSetup read FMapSettings write FMapSettings;
    property OnChange: TOnChangeEvent read FOnChange write FOnChange;
    property Tiles: TTiles read FTiles write FTiles;
  end;


implementation

constructor TMap.Create;
begin
  Randomize;
  SetLength(FTiles, 0, 0);
end;

constructor TMap.Create(AMapSettings: TMapSetup);
begin
  Randomize;
  Generate;
end;

procedure TMap.Generate;
var
  x, y: integer;
begin
  with FMapSettings do
  begin
    SetLength(FTiles, Width, Height);
    for y := 0 to Height - 1 do
    begin
      for x := 0 to Width - 1 do
      begin
        FTiles[x, y] := TTileType.ttGrass;
        if (Random(1000) > 995) then
          GenerateRocks(x, y);
        if (Random(100) > 95) then
          GenerateForest(x, y);
      end;
    end;
  end;

  if Assigned(FOnChange) then
  begin
    FOnChange(self);
	end;
end;

procedure TMap.Generate(AMapSettings: TMapSetup);
begin
  FMapSettings := AMapSettings;
  Generate;
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

  with FMapSettings do
  begin
    for I := 0 to Count - 1 do
    begin
      newx := x + Random(extent) - 5;
      newy := y + Random(extent) - 5;
      if (newx < Width) and (newy < Height) then
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
  Count := Random(28) + 3;
  FTiles[x, y] := TTileType.ttRock;

  with FMapSettings do
  begin
    for I := 0 to Count - 1 do
    begin
      newx := x + Random(extent) - 3;
      newy := y + Random(extent) - 3;
      if (newx < Width) and (newy < Height) then
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
end;

function TMap.ToText: TStringList;
var
  x, y: integer;
  line: string;
begin
  Result := TStringList.Create;
  for y := 0 to FMapSettings.Height - 1 do
  begin
    line := '';
    for x := 0 to FMapSettings.Width - 1 do
    begin
      line := line + IntToStr(integer(FTiles[x, y])) + ',  ';
    end;
    Result.Add(line);
  end;
end;

procedure TMap.DrawToCanvas(ACanvas: TCanvas; AImageList: TImageList);
var
  x, y: integer;
  img: TImage;
begin
  img := TImage.Create(nil);

  with FMapSettings do
  begin
  for y := 0 to FMapSettings.Height - 1 do
  begin
    for x := 0 to FMapSettings.Width - 1 do
    begin
      img.Picture.Bitmap.Clear;
      AImageList.GetBitmap(integer(FTiles[x, y]), img.Picture.Bitmap);
      ACanvas.Draw(x * TileSize, y * TileSize, img.Picture.Bitmap);
    end;
  end;
	end;
	img.Free;
end;

end.
