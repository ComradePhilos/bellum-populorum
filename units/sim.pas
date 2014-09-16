unit sim;

{$mode objfpc}{$H+}

interface

uses
      Classes, SysUtils;

type
  TSimulation = Class
    private
      FRound: Integer;                        // Round-Counter
      FRoundLimit: Integer;                   // optional round limit
      //FMap: TMap;
      //FPeoples:                             // Peoples
      FTimeMod: Double;                       // Mutliplier for time
      FDuration: Integer;                     // Milliseconds since start
    public
      constructor Create;

      procedure NextStep;
	end;

implementation

constructor TSimulation.Create;
begin

end;

procedure TSimulation.NextStep;
begin

end;

end.

