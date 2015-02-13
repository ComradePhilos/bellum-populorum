// this unit will contain all classes related to the world/map
unit world;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ExtCtrls, Controls, Graphics, Math;

type

  TOnChangeEvent = procedure(Sender: TObject) of object;

  TTileType = (ttGrass, ttTree, ttRock, ttRomanHouse, ttGermanHouse, ttSlavonicHouse, ttBerries);
  TTiles = array of array of TTileType;

  TMapSetup = record
    Width: integer;
    Height: integer;
    TileSize: integer;
    ProbForest: integer;
    ProbRocks: integer;
  end;


  TMap = class
  private
    ImageGrass: TImage;
    ImageTree: TImage;
    ImageRock: TImage;
    ImageBerries: TImage;
    ImageRomanHouse: TImage;
    ImageGermanHouse: TImage;
    ImageSlavonicHouse: TImage;

    // World
    FWidth, FHeight: integer;
    FTileSize: integer;
    FProbForest, FProbRocks: integer;

    FTiles: TTiles;
    FOnChange: TOnChangeEvent;

    procedure LoadImages;
    procedure GenerateForest(x, y: integer);
    procedure GenerateRocks(x, y: integer);
    procedure GenerateBerries(x, y: Integer);

  public
    constructor Create;
    constructor Create(AMapSettings: TMapSetup); overload;
    destructor Destroy;
    procedure Clear;

    procedure Generate; overload;
    procedure Generate(AMepSetup: TMapSetup);
    procedure SetParameters(AMapSetup: TMapSetup);
    function getParameters: TMapSetup;
    procedure DrawToCanvas(ACanvas: TCanvas);
    procedure SetTile(x,y,tile: Integer);
    function ToText: TStringList;

    property OnChange: TOnChangeEvent read FOnChange write FOnChange;
    property Tiles: TTiles read FTiles write FTiles;
  end;

  TMapObject = Class
    private
      FX, FY: Integer;
      FHealth: Integer;
	end;


implementation


// #################################################### TMAP ###########################################################

constructor TMap.Create;
begin
  LoadImages;
  Randomize;
  SetLength(FTiles, 0, 0);
end;

constructor TMap.Create(AMapSettings: TMapSetup);
begin
  LoadImages;
  Randomize;
  Generate;
end;

destructor TMap.Destroy;
begin
  ImageGrass.Free;
  ImageTree.Free;
  ImageRock.Free;
end;

procedure TMap.LoadImages;
begin
  ImageGrass := TImage.Create(nil);
  ImageGrass.Picture.LoadFromFile('../gfx/tiles/8x8/grass.png');
  ImageTree := TImage.Create(nil);
  ImageTree.Picture.LoadFromFile('../gfx/tiles/8x8/tree.png');
  ImageRock := TImage.Create(nil);
  ImageRock.Picture.LoadFromFile('../gfx/tiles/8x8/rock.png');
  ImageBerries := TImage.Create(nil);
  ImageBerries.Picture.LoadFromFile('../gfx/tiles/8x8/berries2.png');
  ImageRomanHouse := TImage.Create(nil);
  ImageRomanHouse.Picture.LoadFromFile('../gfx/tiles/8x8/roman house.png');
  ImageGermanHouse := TImage.Create(nil);
  ImageGermanHouse.Picture.LoadFromFile('../gfx/tiles/8x8/german house.png');
  ImageSlavonicHouse := TImage.Create(nil);
  ImageSlavonicHouse.Picture.LoadFromFile('../gfx/tiles/8x8/slavonic house.png');
end;

procedure TMap.Clear;
begin
  SetLength(FTiles, 0, 0);
  FWidth := 0;
  FHeight := 0;
  FTileSize := 0;
  FProbForest := 0;
  FProbRocks := 0;
end;

procedure TMap.Generate;
var
  x, y: integer;
begin
  SetLength(FTiles, FWidth, FHeight);
  for y := 0 to FHeight - 1 do
  begin
    for x := 0 to FWidth - 1 do
    begin
      FTiles[x, y] := TTileType.ttGrass;
      if (Random(1000) > (1000 - FProbRocks)) then
        GenerateRocks(x, y);
      if (Random(1000) > (1000 - FProbForest)) then
        GenerateForest(x, y);
    end;
  end;

  if Assigned(FOnChange) then
  begin
    FOnChange(self);
  end;
end;

procedure TMap.Generate(AMepSetup: TMapSetup);
begin
  //FMapSettings := AMapSettings;
  SetParameters(AMepSetup);
  Generate;
end;

procedure TMap.SetParameters(AMapSetup: TMapSetup);
begin
  self.FWidth := AMapSetup.Width;
  self.FHeight := AMapSetup.Height;
  self.FTileSize := AMapSetup.TileSize;
  self.FProbForest := AMapSetup.ProbForest;
  self.FProbRocks := AMapSetup.ProbRocks;
end;

function TMap.getParameters: TMapSetup;
begin
  Result.Width := self.FWidth;
  Result.Height := self.FHeight;
  Result.TileSize := self.FTileSize;
  Result.ProbForest := self.FProbForest;
  Result.ProbRocks := self.FProbRocks;
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
    if (newx < FWidth) and (newy < FHeight) then
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
  extent := random(5) + 2;
  Count := Random(28) + 6;
  FTiles[x, y] := TTileType.ttRock;


  for I := 0 to Count - 1 do
  begin
    newx := x + Random(extent) - 3;
    newy := y + Random(extent) - 3;
    if (newx < FWidth) and (newy < FHeight) then
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

procedure TMap.GenerateBerries(x, y: Integer);
begin
  FTiles[x,y] := TTileType.ttBerries
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
      line := line + IntToStr(integer(FTiles[x, y])) + ',  ';
    Result.Add(line);
  end;
end;

procedure TMap.DrawToCanvas(ACanvas: TCanvas);
var
  x, y: integer;
  tmpbmp: TBitMap;
begin
  tmpbmp := TBitMap.Create;
  try
  tmpbmp.PixelFormat := pf32Bit;
  tmpbmp.Width := ACanvas.Width;
  tmpbmp.Height := ACanvas.Height;
  tmpbmp.Canvas.Brush.Color := clBlack;
  tmpbmp.Canvas.FillRect(0, 0, tmpbmp.Width, tmpbmp.Height);

  for y := 0 to FHeight - 1 do
  begin
    for x := 0 to FWidth - 1 do
    begin
      case (FTiles[x, y]) of
        ttGrass: tmpbmp.Canvas.Draw(x * FTileSize, y * FTileSize, ImageGrass.Picture.Bitmap);
        ttTree: tmpbmp.Canvas.Draw(x * FTileSize, y * FTileSize, ImageTree.Picture.Bitmap);
        ttRock: tmpbmp.Canvas.Draw(x * FTileSize, y * FTileSize, ImageRock.Picture.Bitmap);
        ttRomanHouse: tmpbmp.Canvas.Draw(x * FTileSize, y * FTileSize, ImageRomanHouse.Picture.Bitmap);
      end;
    end;
  end;
  ACanvas.Draw(0,0, tmpbmp);
  finally
    tmpbmp.Free;
  end;
end;

procedure TMap.SetTile(x,y,tile: Integer);
begin
  FTiles[round(x/FTileSize),round(y/FTileSize)] := TTileType(tile-1);
end;

end.
