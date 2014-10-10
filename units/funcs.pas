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
  AGrid.Clear;

  with APeopleSetup do
  begin
    AGrid.RowCount := High(Peoples);
    for I := 0 to High(Peoples) - 1 do
    begin
      AGrid.Cells[0, I+1] := IntToStr(I + 1);
      AGrid.Cells[1, I+1] := txtPeoples[Peoples[I]];
      AGrid.Cells[2, I+1] := IntToStr(CitizenCounts[I]);
      AGrid.Cells[3, I+1] := IntToStr(Ressources[I].Wood);
      AGrid.Cells[4, I+1] := IntToStr(Ressources[I].Food);
      AGrid.Cells[5, I+1] := IntToStr(Ressources[I].Iron);
    end;
  end;
end;

end.
