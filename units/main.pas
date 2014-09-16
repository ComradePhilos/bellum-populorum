unit main;

{$mode objfpc}{$H+}

interface

uses
      Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
			Menus, StdCtrls,
      {own units}
      sim;

// Todo:
// * each simulation has its own window?
// all results and controls are in the main window

type

			{ TForm1 }

      TForm1 = class(TForm)
			  Button1: TButton;
				MainMenu1: TMainMenu;
				procedure Button1Click(Sender: TObject);
				procedure FormDestroy(Sender: TObject);
      private
            { private declarations }
        FSim: TSimulation;
      public
            { public declarations }
      end;

var
      Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
begin
  FSim := TSimulation.Create;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FSim.Free;
end;

end.

