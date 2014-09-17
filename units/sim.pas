unit sim;

{$mode objfpc}{$H+}

interface

uses
      Classes, SysUtils,
      peoples, world;

type

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

      procedure NextStep;

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

procedure TSimulation.NextStep;
begin

end;

end.

