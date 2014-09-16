unit citizens;

{$mode objfpc}{$H+}

interface

uses
      Classes, SysUtils, fgl;

type

  TCitizen = Class
    private
      FHP: Integer;                                         // Health Points
      //FColor: TColor;                                     // Color shown on map
      FPosX, FPosY: Integer;                                // Coordinates of the map
      FAge: Integer;                                        // After several years/rounds a person dies
      FMaxAge: Integer;                                     // random individual max life time
      FStrength: Integer;                                   // For fights
      FHunger: Integer;

    public
      constructor Create;
      procedure Move(x, y: Integer);
	end;

  TCitizenList = specialize TFPGObjectList<TCitizen>;


implementation

constructor TCitizen.Create;
begin

end;

procedure TCitizen.Move(x, y: Integer);
begin

end;

end.

