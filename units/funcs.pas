unit funcs;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Grids, peoples;

procedure PeoplesToStringGrid(AGrid: TStringGrid; APeopleSetup: TPeopleSetup);

implementation

procedure PeoplesToStringGrid(AGrid: TStringGrid; APeopleSetup: TPeopleSetup);
var
  I: integer;
begin
  with APeopleSetup do
  begin
    for I := 0 to High(Peoples) - 1 do
    begin
      AGrid.Cells[0, I] := IntToStr(I + 1);
      AGrid.Cells[1, I] := txtPeoples[Peoples[I]];
      AGrid.Cells[2, I] := IntToStr(CitizenCounts[I]);
      //AGrid.Cells[];
    end;
  end;
end;

end.
