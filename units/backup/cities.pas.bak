unit cities;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
  peoples, houses, world;

type
  TCity = class
  private
    FX, FY: integer;                                                // city centre
    FPeople: TPeopleType;
    // what nationality?
    FHouseList: THouseList;

  public
    constructor Create;
    destructor Destroy;


    procedure Expand(AMap: TMap);               // Tries to Build a house
  end;

implementation

constructor TCity.Create;
begin
  FHouseList := THouseList.Create;
end;

destructor TCity.Destroy;
begin
  FHouseList.Free;
end;

procedure TCity.Expand(AMap: TMap);
begin

end;

end.
