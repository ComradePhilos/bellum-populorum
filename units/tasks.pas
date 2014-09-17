unit tasks;

{$mode objfpc}{$H+}

interface

uses
      Classes, SysUtils;

type

  TTaskType = (ttMove, ttGather, ttAttack);

  TTask = Class
    private
      FType: TTaskType;
      FTargetX, FTargetY: Integer;
      FPriority: Integer;
	end;

implementation

end.

