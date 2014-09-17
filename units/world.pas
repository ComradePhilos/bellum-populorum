unit world;

{$mode objfpc}{$H+}

interface

uses
      Classes, SysUtils;
type

TTileType = (ttGrass, ttTree, ttRock, ttRomanHouse, ttGermanHouse, ttSlavonicHouse);

TMap = Class
  private
    FWidth, FHeight: Integer;
    FTiles : array of array of TTileType;
    FTileSize: Integer;

  public
    constructor Create;
    constructor Create(width, height: Integer); overload;

    procedure Generate(width, height: Integer);
    function ToText: TStringList;
end;


implementation

constructor TMap.Create;
begin
  SetLength(FTiles, 0,0);
end;

constructor TMap.Create(width, height: Integer);
begin
  self.Generate(width,height);
end;

procedure TMap.Generate(width, height: Integer);
var
  x, y: Integer;
begin
  SetLength(FTiles, width, height);
  FWidth := width;
  FHeight := height;
  Randomize;
  for y := 0 to height - 1 do
  begin
    for x := 0 to width - 1 do
    begin
      FTiles[x,y] := TTileType(Random(5));
    end;
  end;
end;

function TMap.ToText: TStringList;
var
  x, y: Integer;
  line: String;
begin
  Result := TStringList.Create;
  for y := 0 to FHeight - 1 do
  begin
    line := '';
    for x := 0 to FWidth - 1 do
    begin
      line := line + IntToStr(Integer(FTiles[x,y])) + ',  ';
		end;
    Result.Add(line);
	end;
end;

end.

