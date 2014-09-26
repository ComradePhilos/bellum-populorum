unit houses;

{$mode objfpc}{$H+}

interface

uses
      Classes, SysUtils, fgl;

type
  THouse = class
    private
      FX, FY: Integer;
      FInhabitants: Integer;
      FMaxInhabitants: Integer;
      FFood: Integer;
      FMaxFood: Integer;

    public
      constructor Create;

      function CreateCitizen: Boolean;
      function FoodNeeded: Integer;
	end;

  THouseList = specialize TFPGObjectList<THouse>;

implementation

constructor THouse.Create;
begin
  FX := 0;
  FY := 0;
  FInhabitants := 0;
  FMaxInhabitants := 4;
  FFood := 0;
  FMaxFood := 500;
end;

function THouse.FoodNeeded: Integer;
begin
  Result := FMaxFood - FFood;
end;

function THouse.CreateCitizen: Boolean;
begin
  if (FInhabitants < FMaxInhabitants) and (FFood >= 100) then
  begin
    // create man
    Inc(FInhabitants);
    FFood -= 100;
    Result := True;
	end
  else
  begin
    Result := False;
	end;
end;

end.

