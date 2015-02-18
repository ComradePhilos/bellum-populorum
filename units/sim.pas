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

  public
    constructor Create;
    destructor Destroy;
    procedure Clear;

    procedure GenerateRomans(AColor: TColor);  // Generating People
    procedure GenerateGermans(AColor: TColor);
    procedure GenerateSlavonics(AColor: TColor);
    procedure Initialize(ASimSetup: TSimSetup);  // Generates the start situation

    property Map: TMap read FMap write FMap;
    property Name: String read FName write FName;
    property TimePerRound: Integer read FTimePerRound write FTimePerRound;
  end;

  TSimulationList = specialize TFPGObjectList<TSimulation>;

implementation

constructor TSimulation.Create;
begin
  FPeoplesList := TPeoplesList.Create;
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

procedure TSimulation.Initialize(ASimSetup: TSimSetup);
var
  I: integer;
begin
  with ASimSetup do
  begin
    //FMap.MapSettings := MapSetup;
    for I := 0 to FPeoplesList.Count - 1 do
    begin
      //case FPeoplesList[I].PeopleType of
        //ptRoman: GenerateRomans(FPeoplesList[I].Colors[I]);
        //ptGerman: GenerateGermans(PeopleSetup.Colors[I]);
        //ptSlavonic: GenerateSlavonics(PeopleSetup.Colors[I]);
      //end;
    end;
  end;

end;

end.

