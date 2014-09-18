unit sim;

{$mode objfpc}{$H+}

interface

uses
      Classes, SysUtils,
      peoples, world;

type

  TPeopleType = (ptRoman, ptGerman, ptSlavonic);

  TSimSettings = record
    Peoples: array of TPeopleType;
    ProbabilityForest: Integer;
    ProbabilityRocks: Integer;
	end;

  TSimulation = Class
    private
      FID: Integer;
      FRound: Integer;                        // Round-Counter
      FRoundLimit: Integer;                   // optional round limit
      FMap: TMap;
      FPeoples: TPeoplesList;
      FTimeMod: Double;                       // Mutliplier for time
      FDuration: Integer;                     // Milliseconds since start
    public
      constructor Create;
      destructor Destroy;

      procedure GeneratePeople(APeopleType: TPeopleType);
      procedure GenerateRomans;
      procedure GenerateGermans;
      procedure GenerateSlavonics;
      procedure Initialize(ASimSettings: TSimSettings);

      property Map: TMap read FMap write FMap;
	end;

implementation

constructor TSimulation.Create;
begin
  FPeoples := TPeoplesList.Create;
  FMap := TMap.Create(1,1);
end;

destructor TSimulation.Destroy;
begin
  FPeoples.Free;
  FMap.Free;
end;

procedure TSimulation.GeneratePeople(APeopleType: TPeopleType);
begin
  case APeopleType of
    ptRoman: GenerateRomans;
	end;
end;

procedure TSimulation.GenerateRomans;
begin
  FPeoples.Add(TRomans.Create);
end;

procedure TSimulation.GenerateGermans;
begin
  FPeoples.Add(TGermans.Create);
end;

procedure TSimulation.GenerateSlavonics;
begin
  FPeoples.Add(TSlavonics.Create);
end;

procedure TSimulation.Initialize(ASimSettings: TSimSettings);
begin

end;

end.

