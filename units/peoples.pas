unit peoples;

{$mode objfpc}{$H+}

interface

uses
      Classes, SysUtils, fgl,
      {own units}
      citizens;

type

  //TPeopleType = (ptRoman, ptGerman, ptSlavonic);

  TPeople = Class
    private
      FName: String;
      FStrengthBonus: Integer;
      FPopulationBonus: Integer;
      FCitizens: TCitizenList;
    public
      constructor Create;
      destructor Destroy;
	end;

  TRoman = Class(TPeople)

	end;

  TGerman = Class(TPeople)

	end;

  TSlavonic = Class(TPeople)

	end;

  TPeoplesList = specialize TFPGObjectList<TPeople>;

implementation

constructor TPeople.Create;
begin
  FCitizens := TCitizenList.Create;
end;

destructor TPeople.Destroy;
begin
  FCitizens.Free;
end;

end.

