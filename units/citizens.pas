unit citizens;

{$mode objfpc}{$H+}

interface

uses
      Classes, SysUtils;

type

  TCitizen = Class
    private
      FHP: Integer;
      //FColor: TColor;
      FPosX, FPosY: Integer;
      FAge: Integer;
      FMaxAge: Integer;
      FStrength: Integer;
      FHunger: Integer;

    public
      constructor Create;
      procedure Move(x, y: Integer);


	end;

implementation

constructor TCitizen.Create;
begin

end;

procedure TCitizen.Move(x, y: Integer);
begin

end;

end.

