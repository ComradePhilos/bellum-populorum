unit sim;

{$mode objfpc}{$H+}

interface

uses
      Classes, SysUtils, SimulationWindow;

type
  TSimulation = Class
    private
      FRound: Integer;                        // Round-Counter
      FRoundLimit: Integer;                   // optional round limit
      //FMap: TMap;
      //FPeoples:
      FForm: TForm2;
      FTimeMod: Double;                       // Mutliplier for time
      FDuration: Integer;                     // Milliseconds since start
    public
      constructor Create;
      destructor Destroy;

      procedure NextStep;
	end;

implementation

constructor TSimulation.Create;
begin
  FForm := TForm2.Create(nil);
  FForm.Show;
end;

destructor TSimulation.Destroy;
begin
  FForm.Free;
end;

procedure TSimulation.NextStep;
begin

end;

end.

