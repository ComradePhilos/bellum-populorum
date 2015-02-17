unit definitions;

{$mode objfpc}{$H+}

interface

uses
      Classes, SysUtils, fgl;

type
  TFaction = (fRoman, fGerman, FSlavonic);

  TTileType = (ttGrass, ttTree, ttRock, ttRomanHouse, ttGermanHouse, ttSlavonicHouse, ttBerries);
  TTiles = array of array of TTileType;

  TResources = array[0..2] of Integer;
  TPeopleType = (ptRoman, ptGerman, ptSlavonic);

var
  txtPeoples: array[TPeopleType] of String = ('Roman', 'German', 'Slavonic');

implementation



end.

