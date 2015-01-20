unit peoples;

{$mode objfpc}{$H+}

interface

uses
      Classes, SysUtils, fgl, Graphics,
      {own units}
      citizens, world;

type

  TResources = record
    Wood: Integer;
    Iron: Integer;
    Food: Integer;
	end;

  TPeopleType = (ptRoman, ptGerman, ptSlavonic);

  TPeopleSetup = record
    Peoples: array of TPeopleType;
    Names: TStringList;
    CitizenCounts: array of Integer;
    Colors: array of TColor;
    Ressources: array of TResources;
	end;

  // ToDo: Setup stands for 1 people. implement a List of Setups later

  TPeople = Class
    private
      FInitCitizens: Integer;    // Start number of citizens
      FName: String;
      FPeopleType: TPeopleType;
      FColor: TColor;
      FStrengthBonus: Integer;
      FPopulationBonus: Integer;
      FCitizens: TCitizenList;
      FResources: TResources;
      FMap: TMap;                                                               // reference to the map of the sim.

      procedure BuildHouse(x,y: Integer);        // This is only the method to set a house on the map
                                                                    // actually a house must be created by 2 citizens
    public
      constructor Create;

      property PeopleType: TPeopleType read FPeopleType write FPeopleType;
      property Resources: TResources read FResources write FResources;
      property Citizens: TCitizenList read FCitizens write FCitizens;
      property InitCitizens: Integer read FInitCitizens write FInitCitizens;
      property Map: TMap write FMap;
      property Color: TColor read FColor write FColor;
	end;

  TPeoplesList = specialize TFPGObjectList<TPeople>;

var
  txtPeoples: array[TPeopleType] of String = ('Roman', 'German', 'Slavonic');

implementation

const
  StartWood = 0;
  StartFood = 0;
  StartIron = 0;

constructor TPeople.Create;
begin
  FResources.Wood := StartWood;
  FResources.Iron := StartIron;
  FResources.Food := StartFood;
end;

procedure TPeople.BuildHouse(x,y: Integer);
begin
  if (FResources.Wood >= 100) then
  begin
    if (FMap.Tiles[x,y] = TTileType.ttGrass) then
    begin
      case FPeopleType of
        ptRoman: FMap.Tiles[x,y] := TTileType.ttRomanHouse;
        ptGerman: FMap.Tiles[x,y] := TTileType.ttGermanHouse;
        ptSlavonic: FMap.Tiles[x,y] := TTileType.ttSlavonicHouse;
      end;
      FResources.Wood -= 100;
		end;
	end;
end;

end.

