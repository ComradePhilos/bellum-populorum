unit funcs;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Grids, peoples, definitions;

procedure PeoplesToStringGrid(AGrid: TStringGrid; APeoplesList: TPeoplesList);

implementation

procedure PeoplesToStringGrid(AGrid: TStringGrid; APeoplesList: TPeoplesList);
var
  I: integer;
begin
  AGrid.RowCount := 1;

    AGrid.RowCount := APeoplesList.Count+1;
    for I := 0 to APeoplesList.Count - 1 do
    begin
      AGrid.Cells[0, I+1] := IntToStr(I + 1);
      AGrid.Cells[1, I+1] := txtPeoples[APeoplesList[I].PeopleType];
      AGrid.Cells[2, I+1] := IntToStr(APeoplesList[I].InitCitizens);
      AGrid.Cells[3, I+1] := IntToStr(APeoplesList[I].Resources[0]);
      AGrid.Cells[4, I+1] := IntToStr(APeoplesList[I].Resources[1]);
      AGrid.Cells[5, I+1] := IntToStr(APeoplesList[I].Resources[2]);
      AGrid.Cells[6, I+1] := IntToStr(APeoplesList[I].Color);
    end;

end;

end.
