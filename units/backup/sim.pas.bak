unit sim;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics, fgl,
  {own units}
  peoples, world;

type

  TSimSetup = record
    MapSetup: TMapSetup;
    PeopleSetup: TPeopleSetup;
  end;

  TSimulation = class
  private
    FID: integer;
    FRound: integer;                        // Round-Counter
    FRoundLimit: integer;                   // optional round limit
    FMap: TMap;
    FPeoples: TPeoplesList;
    FTimeMod: double;                       // Mutliplier for time
    FDuration: integer;                     // Milliseconds since start
  public
    constructor Create;
    destructor Destroy;

    procedure GenerateRomans(AColor: TColor);                          // Generating People
    procedure GenerateGermans(AColor: TColor);
    procedure GenerateSlavonics(AColor: TColor);
    procedure Initialize(ASimSetup: TSimSetup);                         // Generates the start situation

    property Map: TMap read FMap write FMap;
  end;

  TSimulationList = specialize TFPGObjectList<TSimulation>;

implementation

const
  defWidth = 100;
  defHeight = 80;

constructor TSimulation.Create;
begin
  FPeoples := TPeoplesList.Create;
  FMap := TMap.Create;
end;

destructor TSimulation.Destroy;
begin
  FPeoples.Free;
  FMap.Free;
end;

procedure TSimulation.GenerateRomans(AColor: TColor);
begin
  FPeoples.Add(TPeople.Create);
  FPeoples[FPeoples.Count - 1].Color := AColor;
end;

procedure TSimulation.GenerateGermans(AColor: TColor);
begin
  FPeoples.Add(TPeople.Create);
  FPeoples[FPeoples.Count - 1].Color := AColor;
end;

procedure TSimulation.GenerateSlavonics(AColor: TColor);
begin
  FPeoples.Add(TPeople.Create);
  FPeoples[FPeoples.Count - 1].Color := AColor;
end;

procedure TSimulation.Initialize(ASimSetup: TSimSetup);
var
  I: integer;
begin
  with ASimSetup do
  begin
    FMap.MapSettings := MapSetup;
    for I := 0 to High(PeopleSetup.Peoples) - 1 do
    begin
      case PeopleSetup.Peoples[I] of
        ptRoman: GenerateRomans(PeopleSetup.Colors[I]);
        ptGerman: GenerateGermans(PeopleSetup.Colors[I]);
        ptSlavonic: GenerateSlavonics(PeopleSetup.Colors[I]);
      end;
    end;
  end;

end;

end.

