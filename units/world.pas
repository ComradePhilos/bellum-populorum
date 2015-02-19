// this unit will contain all classes related to the world/map
unit world;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ExtCtrls, Controls, Graphics, Math, TypInfo, fgl, definitions;

type

  TOnChangeEvent = procedure(Sender: TObject) of object;

  TMapSetup = record
    Width: integer;
    Height: integer;
    TileSize: integer;
    ProbForest: integer;
    ProbRocks: integer;
  end;

  TMapObject = Class
    private
      FX, FY: Integer;
      FHealth: Integer;
      FPicture: TPicture;
      FAge: Integer;
    public
      constructor Create;
      procedure SetPos(x,y: Integer);

      property Picture: TPicture read FPicture write FPicture;
      property x: Integer read FX write FX;
      property y: Integer read FY write FY;
	end;

  TMapTree = class(TMapObject)
    private
      FFrameList: TImageList;
    public
      constructor Create;
  end;

  TMapObjectList = specialize TFPGObjectList<TMapObject>;

  TMap = class
  private
    FWidth, FHeight: integer;
    FTileSize: integer;
    FProbForest, FProbRocks: integer;
    FScrollX, FScrollY: Integer;

    FTiles: TTiles;
    FObjects: TMapObjectList;
    FOnChange: TOnChangeEvent;

    procedure GenerateForest(x, y: integer);
    procedure GenerateForest_ALT(x, y: integer);
    procedure GenerateRocks(x, y: integer);
    function Occupied(x,y: Integer):Boolean;
    procedure UpdateView;

  public
    constructor Create;
    constructor Create(AMapSettings: TMapSetup); overload;
    destructor Destroy;
    procedure Clear;

    procedure Generate; overload;
    procedure Generate(AMepSetup: TMapSetup);
    procedure SetParameters(AMapSetup: TMapSetup);
    function getParameters: TMapSetup;
    procedure SetTile(x,y,tile: Integer);
    function ToText: TStringList;

    procedure ScrollLeft;
    procedure ScrollRight;
    procedure ScrollUp;
    procedure ScrollDown;

    property OnChange: TOnChangeEvent read FOnChange write FOnChange;
    property Scrollx: Integer read FScrollx write FScrollx;
    property Scrolly: Integer read FScrolly write FScrolly;
    property Tiles: TTiles read FTiles write FTiles;
    property MapObjects: TMapObjectList read FObjects write FObjects;
    property Tilesize: Integer read FTileSize write FTileSize;
  end;

implementation

// #################################################### TMAP ###########################################################

constructor TMap.Create;
begin
  Randomize;
  SetLength(FTiles, 0, 0);
  FObjects := TMapObjectList.Create(True);
end;

constructor TMap.Create(AMapSettings: TMapSetup);
begin
  Randomize;
  FObjects := TMapObjectList.Create(True);
  Generate;
end;

destructor TMap.Destroy;
begin
  FObjects.Free;
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
  FObjects.Clear;
  for y := 0 to FHeight - 1 do
  begin
    for x := 0 to FWidth - 1 do
    begin
      FTiles[x, y] := TTileType.ttGrass;
      if (Random(1000) > (1000 - FProbRocks)) then
        GenerateRocks(x, y);
      if (Random(1000) > (1000 - FProbForest)) then
        GenerateForest_ALT(x, y);
    end;
  end;
  UpdateView;
end;

procedure TMap.Generate(AMepSetup: TMapSetup);
begin
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

procedure TMap.GenerateForest_ALT(x, y: integer);
var
  extent: integer;    // extent of the forest
  Count: integer;     // number of trees
  I: integer;
  newx, newy: integer;
  dist: integer;
begin
  extent := random(40) + 10;
  Count := Random(1300) + 300;

  for I := 0 to Count - 1 do
  begin
    newx := x + Random(extent) - 25;
    newy := y + Random(extent) - 25;
    if (newx < FWidth) and (newy < FHeight) then
    begin
      if (newx >= 0) and (newy >= 0) then
      begin
        dist := round(power((x - newx), 2)) + round(power((y - newy), 2));
        if (dist <= extent) then
        begin
          if not Occupied(newx,newy) then
          begin
            FObjects.Add(TMapTree.Create);
            FObjects[FObjects.Count-1].SetPos(newx,newy);
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
      line := line + GetEnumName(TypeInfo(TTileType),ord(FTiles[x, y]));
      //line := line + IntToStr(Integer(FTiles[x, y])) + ',  ';
    Result.Add(line);
  end;
end;

procedure TMap.SetTile(x,y,tile: Integer);
begin
  FTiles[round(x/FTileSize),round(y/FTileSize)] := TTileType(tile-1);
end;

procedure TMap.ScrollLeft;
begin
  FScrollx += 1;
  UpdateView;
end;

procedure TMap.ScrollRight;
begin
  FScrollx -= 1;
  UpdateView;
end;

procedure TMap.ScrollUp;
begin
  FScrolly += 1;
  UpdateView;
end;

procedure TMap.ScrollDown;
begin
  FScrolly -= 1;
  UpdateView;
end;

function TMap.Occupied(x,y: Integer):Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to FObjects.Count - 1 do
  begin
    if (x = FObjects[I].x) and (y = FObjects[I].y) then
    begin
      Result := True;
      break;
		end;
	end;
end;

procedure TMap.UpdateView;
begin
  if Assigned(FOnChange) then
  begin
    FOnChange(self);
  end;
end;

// ###################################### MAPOBJECTS ####################################################
constructor TMapObject.Create;
begin
  SetPos(0,0);
  FAge := 0;
  FPicture := TPicture.Create;
end;

procedure TMapObject.SetPos(x,y: Integer);
begin
  FX := x;
  FY := y;
end;

constructor TMapTree.Create;
begin
  inherited;
  FPicture.LoadFromFile('../gfx/objects/tree.png');
  FPicture.Bitmap.Transparent := True;
  FPicture.Bitmap.TransparentColor := clFuchsia;
end;

end.
