unit peoples;

{$mode objfpc}{$H+}

interface

uses
      Classes, SysUtils;

type

  //TPeopleType = (ptRoman, ptGerman, ptSlavonic);

  TPeople = Class
    FName: String;
    //FMembers: TMemberList;
    //FType: TPeopleType;

	end;

  TRoman = Class(TPeople)

	end;

  TGerman = Class(TPeople)

	end;

  TSlavonic = Class(TPeople)

	end;

implementation

end.

