unit sim;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics, fgl,
  {own units}
  peoples, world, definitions;

type

  TSimSetup = record
    MapSetup: TMapSetup;
    PeopleSetup: TPeoplesList;
  end;

  TSimulation = class
  private
    FName: String;
    FID: integer;
    FRound: integer;                        // Round-Counter
    FRoundLimit: integer;                   // optional round limit
    FMap: TMap;
    FPeoplesList: TPeoplesList;
    FTimePerRound: Integer;
    FSetup: TSimSetup;

  public
    constructor Create;
    destructor Destroy;
    procedure Clear;

    procedure DoStep;
    procedure GenerateRomans(AColor: TColor);  // Generating People
    procedure GenerateGermans(AColor: TColor);
    procedure GenerateSlavonics(AColor: TColor);
    procedure Initialize;  // Generates the start situation

    property Map: TMap read FMap write FMap;
    property Name: String read FName write FName;
    property Round: Integer read FRound;
    property TimePerRound: Integer read FTimePerRound write FTimePerRound;
    property Setup: TSimSetup read FSetup write FSetup;
  end;

  TSimulationList = specialize TFPGObjectList<TSimulation>;

implementation

constructor TSimulation.Create;
begin
  FPeoplesList := TPeoplesList.Create(True);
  FMap := TMap.Create;
end;

destructor TSimulation.Destroy;
begin
  FPeoplesList.Free;
  FMap.Free;
end;

procedure TSimulation.Clear;
begin
  FMap.Clear;
  FName := '';
  FRound := 0;
  FRoundLimit := 0;
  FTimePerRound := 0;
  FPeoplesList.Clear;
end;

procedure TSimulation.DoStep;
var
  I: Integer;
begin
  FMap.DoStep;
  for I := 0 to FPeoplesList.Count - 1 do
  begin
    FPeoplesList[I].Dostep;
  end;
  Inc(FRound);
end;

procedure TSimulation.GenerateRomans(AColor: TColor);
begin
  FPeoplesList.Add(TPeople.Create);
  FPeoplesList[FPeoplesList.Count - 1].Color := AColor;
end;

procedure TSimulation.GenerateGermans(AColor: TColor);
begin
  FPeoplesList.Add(TPeople.Create);
  FPeoplesList[FPeoplesList.Count - 1].Color := AColor;
end;

procedure TSimulation.GenerateSlavonics(AColor: TColor);
begin
  FPeoplesList.Add(TPeople.Create);
  FPeoplesList[FPeoplesList.Count - 1].Color := AColor;
end;

procedure TSimulation.Initialize;
var
  I: Integer;
begin
  FPeoplesList := FSetup.PeopleSetup;
  for I := 0 to FPeoplesList.Count - 1 do
  begin
    FPeoplesList[I].Map := FMap;
    FPeoplesList[I].Settle;
  end;
end;


end.

