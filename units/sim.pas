unit sim;

{$mode objfpc}{$H+}

interface

uses
      Classes, SysUtils,
      SimulationWindow, peoples, funcs;

type

  TSimulation = Class
    private
      FRound: Integer;                        // Round-Counter
      FRoundLimit: Integer;                   // optional round limit
      FMap: TMap;
      FPeoples: TPeoplesList;
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

  FPeoples := TPeoplesList.Create(true);
  FMap := TMap.Create(20,20);
  FForm.Memo1.Clear;
  FForm.Memo1.Lines.AddStrings(FMap.ToText);
end;

destructor TSimulation.Destroy;
begin
  FPeoples.Free;
  FMap.Free;
  FForm.Free;
end;

procedure TSimulation.NextStep;
begin

end;

end.

