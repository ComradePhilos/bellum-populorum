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
      FOwner: TObject;
      FAge: Integer;
      FFaction: Tobject;
      FIsObstacle: Boolean;
    public
      constructor Create(AMap: TObject);
      destructor Destroy;
      function GetPicture: TPicture; virtual;
      procedure GrowOlder; virtual;
      procedure SetPos(x,y: Integer);

      property Age: Integer read FAge write FAge;
      property Faction: Tobject read FFaction write FFaction;
      property IsObstacle: Boolean read FIsObstacle write FIsObstacle;
      property Owner: TObject read FOwner write FOwner;
      property Picture: TPicture read FPicture write FPicture;
      property x: Integer read FX write FX;
      property y: Integer read FY write FY;
	end;

  TMapTree = class(TMapObject)
    private
      FFrameList: TImageList;
    public
      constructor Create;
      procedure GrowOlder; override;
      procedure UpdatePicture;
  end;

  TMapHouse = class(TMapObject)
    public
      constructor Create;
      procedure HasSpace(var xpos,ypos: Integer);
      procedure TryExpansion;
  end;

  TMapRock = class(TMapObject)
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

    procedure DeleteOldTrees;
    procedure GenerateForest_ALT(x, y: integer);
    procedure GenerateRocks(x, y: integer);
    procedure UpdateView;

  public
    procedure AddTree(x,y: Integer; AAge: Integer = 0);
    function AddHouse(x,y: Integer): TMapHouse;
    procedure Clear;
    constructor Create;
    constructor Create(AMapSettings: TMapSetup); overload;
    destructor Destroy;
    procedure DoStep;
    procedure Generate; overload;
    procedure Generate(AMepSetup: TMapSetup);
    function getParameters: TMapSetup;
    function HasSpaceLeft: Boolean;
    function IsInbounds(x,y: Integer): Boolean;
    function IsOccupied(x,y: Integer):Boolean;
    procedure ScrollLeft;
    procedure ScrollRight;
    procedure ScrollUp;
    procedure ScrollDown;
    procedure SetParameters(AMapSetup: TMapSetup);
    procedure SetTile(x,y,tile: Integer);

    property Height: Integer read FHeight write FHeight;
    property MapObjects: TMapObjectList read FObjects write FObjects;
    property OnChange: TOnChangeEvent read FOnChange write FOnChange;
    property Scrollx: Integer read FScrollx write FScrollx;
    property Scrolly: Integer read FScrolly write FScrolly;
    property Tiles: TTiles read FTiles write FTiles;
    property Tilesize: Integer read FTileSize write FTileSize;
    property Width: Integer read FWidth write FWidth;
  end;

  THouseList = specialize TFPGObjectList<TMapHouse>;

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
  FObjects.Clear;
end;

function TMap.AddHouse(x,y: Integer): TMapHouse;
begin
  if not IsOccupied(x,y) and IsInbounds(x,y) then
  begin
    FObjects.Add(TMapHouse.Create);
    FObjects[FObjects.Count-1].SetPos(x,y);
    Result := TMapHouse(FObjects[FObjects.Count-1]);
	end;
end;

procedure TMap.AddTree(x,y: Integer; AAge: Integer = 0);
begin
  if not IsOccupied(x,y) and IsInbounds(x,y) then
  begin
    FObjects.Add(TMapTree.Create);
    FObjects[FObjects.Count-1].SetPos(x,y);
    FObjects[FObjects.Count-1].Owner := self;
    FObjects[FObjects.Count-1].Age := AAge;
    TMapTree(FObjects[FObjects.Count-1]).UpdatePicture;
	end;
end;

procedure TMap.DeleteOldTrees;
var
  I: Integer;
  index: Integer;
begin
  index := -1;
  for I := 0 to FObjects.Count - 1 do
  begin
    if FObjects[I].ClassNameIs('TMapTree') then
    begin
      if (FObjects[I].Age > cTreeLifeTime) then
      begin
        index := I;
        break;
			end;
		end;
  end;

  if (index <> -1) then
  begin
    FObjects.Delete(index);
    DeleteOldTrees;
	end;
end;

procedure TMap.DoStep;
var
  I: Integer;
begin
  for I := 0 to FObjects.Count - 1 do
  begin
    FObjects[I].GrowOlder;
	end;
  DeleteOldTrees;
  UpdateView;
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
          AddTree(newx, newy, Random(1500));
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
         if not IsOccupied(newx,newy) then
          begin
            FObjects.Add(TMapRock.Create);
            FObjects[FObjects.Count-1].SetPos(newx,newy);
          end;
        end;
      end;
    end;
  end;
end;

function TMap.IsInbounds(x,y: Integer):Boolean;
begin
  Result := False;
  if (x >= 0) and (x < self.Width) then
		if (y >= 0) and (y < self.Height) then
      Result := True;
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

function TMap.IsOccupied(x,y: Integer):Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to FObjects.Count - 1 do
  begin
    if FObjects[I].IsObstacle and (x = FObjects[I].x) and (y = FObjects[I].y) then
    begin
      Result := True;
      break;
		end;
  end;
end;

function TMap.HasSpaceLeft: Boolean;
var
  posx, posy: Integer;
begin
  Result := False;
  for posy := 0 to FHeight - 1 do
  begin
    for posx := 0 to FWidth - 1 do
    begin
      if not IsOccupied(posx,posy) then
      begin
        exit(True);
      end;
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
constructor TMapObject.Create(AMap: TObject);
begin
  SetPos(0,0);
  FAge := 0;
  FOwner := AMap;
  FPicture := TPicture.Create;
end;

destructor TMapObject.Destroy;
begin
  FPicture.Free;
end;

procedure TMapObject.GrowOlder;
begin
  FAge += 1;
end;

function TMapObject.GetPicture: TPicture;
begin
  Result := FPicture;
end;

procedure TMapObject.SetPos(x,y: Integer);
begin
  FX := x;
  FY := y;
end;

constructor TMapTree.Create;
begin
  inherited;
  FIsObstacle := True;
  UpdatePicture;
end;

procedure TMapTree.GrowOlder;
var
  posx,posy: Integer;
begin
  inherited;
  UpdatePicture;
  // plant new tree
  if (self.Age > cTreeAdolescenceTime) and (Random(cTreeReproductionTime) = 1) then
  begin
    posx := self.x + random(3)-1;
    posy := self.y + random(3)-1;
    TMap(Owner).AddTree(posx,posy);
	end;
end;

procedure TMapTree.UpdatePicture;
begin
  if (FAge < cTreeAdolescenceTime) then
    FPicture := ImageTreeMedium.Picture;
  if (FAge >= cTreeAdolescenceTime) then
    FPicture := ImageTree.Picture;
end;

constructor TMapRock.Create;
begin
  inherited;
  FIsObstacle := True;
  FPicture := ImageRock.Picture;
end;

constructor TMapHouse.Create;
begin
  inherited;
  FIsObstacle := True;
end;

procedure TMapHouse.HasSpace(var xpos,ypos: Integer);
var
  a,b: Integer;
begin
  xpos := -1;
  ypos := -1;
  for a := -1 to 1 do
  begin
    for b := -1 to 1 do
    begin
      if TMap(FOwner).IsInbounds(self.x + b, self.y + a) then
      begin
        if not TMap(FOwner).IsOccupied(self.x + b, self.y + a) then
        begin
          xpos := self.x + b;
          ypos := self.y + a;
          break;
        end;
      end;
    end;
  end;
end;

procedure TMapHouse.TryExpansion;
var
  a,b: Integer;
  xpos, ypos: Integer;
begin
  for a := -1 to 1 do
  begin
    for b := -1 to 1 do
    begin
      xpos := self.x + b;
      ypos := self.y + a;
      if TMap(FOwner).IsInbounds(xpos,ypos) then
      begin
        if not TMap(FOwner).IsOccupied(xpos,ypos) then
        begin
          TMap(FOwner).AddHouse(xpos,ypos);
        end;
      end;
    end;
  end;
end;

end.
