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
    FName: String;
    FID: integer;
    FRound: integer;                        // Round-Counter
    FRoundLimit: integer;                   // optional round limit
    FMap: TMap;
    FPeoples: TPeoplesList;
    FTimePerRound: Integer;

  public
    constructor Create;
    destructor Destroy;
    procedure Clear;

    procedure GenerateRomans(AColor: TColor);                          // Generating People
    procedure GenerateGermans(AColor: TColor);
    procedure GenerateSlavonics(AColor: TColor);
    procedure Initialize(ASimSetup: TSimSetup);                         // Generates the start situation

    property Map: TMap read FMap write FMap;
    property Name: String read FName write FName;
    property TimePerRound: Integer read FTimePerRound write FTimePerRound;
  end;

  TSimulationList = specialize TFPGObjectList<TSimulation>;

implementation

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

procedure TSimulation.Clear;
begin
  FMap.Clear;
  FName := '';
  FRound := 0;
  FRoundLimit := 0;
  FTimePerRound := 0;
  FPeoples.Clear;
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
    //FMap.MapSettings := MapSetup;
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

