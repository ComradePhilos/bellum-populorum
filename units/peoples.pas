unit peoples;

{$mode objfpc}{$H+}

interface

uses
      Classes, SysUtils, fgl, Graphics,
      {own units}
      citizens, world, definitions;

type


  // ToDo: Setup stands for 1 people. implement a List of Setups later

  TPeople = Class
    private
      FInitCitizens: Integer;    // Start number of citizens
      FName: String;
      FPeopleType: TPeopleType;
      FColor: TColor;
      FStrengthBonus: Integer;
      FPopulationBonus: Integer;
      FHouses: THouseList;
      FCitizens: TCitizenList;
      FResources: TResources;
      FMap: TMap;                // reference to the map of the sim.

      FHouseTexture: TPicture;

    public
      constructor Create;
      destructor Destroy; override;

      procedure Dostep;
      procedure Settle;
      procedure TryExpansion;

      property PeopleType: TPeopleType read FPeopleType write FPeopleType;
      property Resources: TResources read FResources write FResources;
      property Citizens: TCitizenList read FCitizens write FCitizens;
      property HouseTexture: TPicture read FHouseTexture write FHouseTexture;
      property InitCitizens: Integer read FInitCitizens write FInitCitizens;
      property Map: TMap write FMap;
      property Color: TColor read FColor write FColor;
	end;
  TPeoplesList = specialize TFPGObjectList<TPeople>;

implementation

const
  emNoSpaceLeft = 'No space left on map!';
  StartWood = 0;
  StartFood = 0;
  StartIron = 0;
  cwood = 0;
  ciron = 1;
  cfood = 2;

constructor TPeople.Create;
begin
  FResources[cwood] := StartWood;
  FResources[ciron] := StartIron;
  FResources[cfood] := StartFood;
  FHouses := THouseList.Create(True);
end;

destructor TPeople.Destroy;
begin
  FHouses.Free;
end;

procedure TPeople.Settle;
var
  posx, posy: Integer;
begin
  if FMap.HasSpaceLeft then
  begin
    while true do
    begin
      posx := random(FMap.Width)-1;
      posy := random(FMap.Height)-1;
      if not FMap.IsOccupied(posx,posy) then
      begin
        FHouses.Add(FMap.AddHouse(posx,posy));
        FHouses[FHouses.Count-1].Picture :=  ImageRomanHouse.Picture;
        FHouses[FHouses.Count-1].Faction := self;
        break;
      end;
    end;
  end
  else
  begin
    raise Exception.Create(emNoSpaceLeft);
  end;
end;

procedure TPeople.Dostep;
begin
  if random(100) > 90 then
    TryExpansion;
end;

procedure TPeople.TryExpansion;
var
  house: Integer;
  a,b: Integer;
  xpos, ypos: Integer;
  rnd: Integer;
begin
  if (FHouses.Count > 0) then
  begin
    house := random(FHouses.Count);

    rnd := random(4);
    if rnd = 0 then        // left
    begin
      a := 0;
      b := -1;
    end;
    if rnd = 1 then       // right
    begin
      a := 0;
      b := 1;
    end;
    if rnd = 2 then       // top
    begin
      a := -1;
      b := 0;
    end;
    if rnd = 3 then      // bottom
    begin
      a := 1;
      b := 0;
    end;

    xpos := FHouses[house].x + b;
    ypos := FHouses[house].y + a;
    if FMap.IsInbounds(xpos,ypos) then
    begin
      if not FMap.IsOccupied(xpos,ypos) then
      begin
        FHouses.Add(FMap.AddHouse(xpos,ypos));
        FHouses[FHouses.Count-1].Picture :=  ImageRomanHouse.Picture;
        FHouses[FHouses.Count-1].Faction := self;
       end;
    end;
  end;
end;

end.

