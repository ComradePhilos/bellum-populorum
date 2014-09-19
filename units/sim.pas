unit sim;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics, fgl,
  {own units}
  peoples, world;

type

  TPeopleType = (ptRoman, ptGerman, ptSlavonic);

  TSimSettings = record
    Peoples: array of TPeopleType;
    Colors: array of TColor;
    ProbForest: integer;
    ProbRocks: integer;
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

    procedure GenerateRomans(AColor: TColor);
    procedure GenerateGermans(AColor: TColor);
    procedure GenerateSlavonics(AColor: TColor);
    procedure Initialize(ASimSettings: TSimSettings);

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
  FPeoples.Add(TRomans.Create);
  FPeoples[FPeoples.Count - 1].Color := AColor;
end;

procedure TSimulation.GenerateGermans(AColor: TColor);
begin
  FPeoples.Add(TGermans.Create);
  FPeoples[FPeoples.Count - 1].Color := AColor;
end;

procedure TSimulation.GenerateSlavonics(AColor: TColor);
begin
  FPeoples.Add(TSlavonics.Create);
  FPeoples[FPeoples.Count - 1].Color := AColor;
end;

procedure TSimulation.Initialize(ASimSettings: TSimSettings);
var
  I: integer;
begin
  with ASimSettings do
  begin
    for I := 0 to High(Peoples) - 1 do
    begin
      case Peoples[I] of
        ptRoman: GenerateRomans(Colors[I]);
        ptGerman: GenerateGermans(Colors[I]);
        ptSlavonic: GenerateSlavonics(Colors[I]);
      end;
    end;
  end;

end;

end.

