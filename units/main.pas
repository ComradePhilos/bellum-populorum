unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Menus, StdCtrls,
  {own units}
  sim, simulationwindow;

// Todo:
// * all results and controls are in the main window
// * main form: tab with statistics for each simulation
// * call ToImage func. of TMap as few as possible

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    procedure Button1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
		procedure MenuItem2Click(Sender: TObject);
  private
    { private declarations }
    FForm: TForm2;

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
  FForm := TForm2.Create(self);
  FForm.Show;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FForm.Free;
end;

procedure TForm1.MenuItem2Click(Sender: TObject);
begin

end;

end.

