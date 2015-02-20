unit definitions;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fgl, ExtCtrls;

type
  TFaction = (fRoman, fGerman, FSlavonic);

  TTileType = (ttGrass, ttTree, ttRock, ttRomanHouse, ttGermanHouse, ttSlavonicHouse, ttBerries);
  TTiles = array of array of TTileType;

  TResources = array[0..2] of Integer;
  TPeopleType = (ptRoman, ptGerman, ptSlavonic);

  procedure LoadImages;
  procedure InitImages;
var
  txtPeoples: array[TPeopleType] of String = ('Roman', 'German', 'Slavonic');
  ImageGrass: TImage;
  ImageTree: TImage;
  ImageTreeMedium: TImage;
  ImageTreeSmall: TImage;
  ImageRock: TImage;
  ImageBerries: TImage;
  ImageRomanHouse: TImage;
  ImageGermanHouse: TImage;
  ImageSlavonicHouse: TImage;

implementation

const cTilePath = '../gfx/tiles/8x8/';
const cObjectPath = '../gfx/objects/';

procedure InitImages;
begin
  ImageGrass := TImage.Create(nil);
  ImageTree := TImage.Create(nil);
  ImageTreeMedium := TImage.Create(nil);
  ImageTreeSmall := TImage.Create(nil);
  ImageRock := TImage.Create(nil);
end;

procedure LoadImages;
begin
  ImageGrass.Picture.LoadFromFile(cTilePath + 'grass.png');
  ImageRock.Picture.LoadFromFile(cTilePath + 'rock.png');

  ImageTree.Picture.LoadFromFile(cObjectPath + 'tree2.png');
  ImageTreeMedium.Picture.LoadFromFile(cObjectPath + 'tree_medium2.png');
  ImageTreeSmall.Picture.LoadFromFile(cObjectPath + 'tree_small2.png');
end;

end.

