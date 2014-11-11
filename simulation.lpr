program simulation;

{$mode objfpc}{$H+}

uses {$IFDEF UNIX} {$IFDEF UseCThreads}
  cthreads, {$ENDIF} {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, lazopenglcontext,
  main,
  sim,
  funcs,
  peoples,
  citizens,
  tasks,
  SimulationWindow,
  SimulationSetupWindow,
  world,
  houses,
  cities;

{$R *.res}

begin
  Application.Title := 'bellum populorum';
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
