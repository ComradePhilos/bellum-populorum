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
      FCitizens: TCitizenList;
    public
      constructor Create;
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
  FCitizens := TCitizenList.Create(true);
end;

end.

