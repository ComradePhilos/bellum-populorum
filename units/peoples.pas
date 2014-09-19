unit peoples;

{$mode objfpc}{$H+}

interface

uses
      Classes, SysUtils, fgl, Graphics,
      {own units}
      citizens, world;

type

  TRessources = record
    Wood: Integer;
    Iron: Integer;
    Food: Integer;
	end;

  TPeople = Class
    private
      FName: String;
      FColor: TColor;
      FStrengthBonus: Integer;
      FPopulationBonus: Integer;
      FCitizens: TCitizenList;
      FRessources: TRessources;
      FMap: TMap;                                                               // reference to the map of the sim.

      procedure BuildHouse(x,y: Integer); virtual; abstract;        // This is only the method to set a house on the map
                                                                    // actually a house must be created by 2 citizens

    public
      constructor Create;
      destructor Destroy;

      property Map: TMap write FMap;
      property Color: TColor read FColor write FColor;
	end;

  TRomans = Class(TPeople)
    private
      procedure BuildHouse(x,y: Integer);
    public
	end;

  TGermans = Class(TPeople)
    private
      procedure BuildHouse(x,y: Integer);
    public
	end;

  TSlavonics = Class(TPeople)
    private
      procedure BuildHouse(x,y: Integer);
    public
	end;

  TPeoplesList = specialize TFPGObjectList<TPeople>;

implementation

const
  StartWood = 100;
  StartFood = 100;
  StartIron = 0;

constructor TPeople.Create;
begin
  FCitizens := TCitizenList.Create;
  FRessources.Wood := StartWood;
  FRessources.Iron := StartIron;
  FRessources.Food := StartFood;
end;

destructor TPeople.Destroy;
begin
  FCitizens.Free;
end;

procedure TRomans.BuildHouse(x,y: Integer);
begin
  if (FRessources.Wood >= 100) then
  begin
    if (FMap.Tiles[x,y] = TTileType.ttGrass) then
    begin
      FMap.Tiles[x,y] := TTileType.ttRomanHouse;
      FRessources.Wood -= 100;
		end;
	end;
end;

procedure TGermans.BuildHouse(x,y: Integer);
begin
  if (FRessources.Wood >= 100) then
  begin
    if (FMap.Tiles[x,y] = TTileType.ttGrass) then
    begin
      FMap.Tiles[x,y] := TTileType.ttGermanHouse;
      FRessources.Wood -= 100;
		end;
	end;
end;

procedure TSlavonics.BuildHouse(x,y: Integer);
begin
  if (FRessources.Wood >= 100) then
  begin
    if (FMap.Tiles[x,y] = TTileType.ttGrass) then
    begin
      FMap.Tiles[x,y] := TTileType.ttSlavonicHouse;
      FRessources.Wood -= 100;
		end;
	end;
end;

end.

