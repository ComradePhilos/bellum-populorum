unit tasks;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type

  TTaskType = (ttMove, ttGather, ttAttack);

  TTask = class
  private
    FType: TTaskType;
    FTargetX, FTargetY: integer;
    FPriority: integer;
  end;

implementation

end.
