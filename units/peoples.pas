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
      FCitizens: TCitizenList;
      FResources: TResources;
      FMap: TMap;                                        // reference to the map of the sim.

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

implementation

const
  StartWood = 0;
  StartFood = 0;
  StartIron = 0;

constructor TPeople.Create;
begin
  FResources[0] := StartWood;
  FResources[1] := StartIron;
  FResources[2] := StartFood;
end;


end.

