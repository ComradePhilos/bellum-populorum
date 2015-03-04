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

const cTilePath = 'tiles/';
const cObjectPath = 'objects/';
const cTileSize = 8;
const cTreeReproductionTime = 300;  // higher means less reproduction
const cTreeAdolescenceTime = 350; // Time until tree is considered fully grown
const cTreeLifeTime = 4000;    // tree will die after x rounds

implementation

procedure InitImages;
begin
  ImageGrass := TImage.Create(nil);
  ImageTree := TImage.Create(nil);
  ImageTreeMedium := TImage.Create(nil);
  ImageTreeSmall := TImage.Create(nil);
  ImageRock := TImage.Create(nil);
end;

procedure LoadImages;
var
  sizepath: String;
begin
  sizePath := '../gfx/' + IntToStr(cTileSize) + 'x' + IntToStr(cTileSize) +'/';
  ImageGrass.Picture.LoadFromFile(SizePath + cTilePath + 'grass.png');

  ImageTree.Picture.LoadFromFile(SizePath + cObjectPath + 'tree2.png');
  ImageTreeMedium.Picture.LoadFromFile(SizePath + cObjectPath + 'tree_medium2.png');
  ImageRock.Picture.LoadFromFile(SizePath + cObjectPath + 'rock.png');
end;

end.

