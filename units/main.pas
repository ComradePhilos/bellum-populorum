unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Menus, StdCtrls, ComCtrls, fgl,
  {own units}
  sim, simulationwindow;

// Todo:
// * all results and controls are in the main window
// * main form: tab with statistics for each simulation
// * call ToImage func. of TMap as few as possible

type

  { TForm1 }

  TSimList = specialize TFPGObjectList<TForm2>;

  TForm1 = class(TForm)
    Button1: TButton;
		Button2: TButton;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
		TabControl1: TTabControl;
    procedure Button1Click(Sender: TObject);
		procedure Button2Click(Sender: TObject);
		procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
		procedure MenuItem2Click(Sender: TObject);
  private
    { private declarations }
    FForm: TForm2;
    FSimList: TSimList;
    FSimCounter: Integer;
    procedure EnableButtons;
    procedure RemoveSim(Sender: TObject);

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
  inc(FSimCounter);
  FSimList.Add(TForm2.Create(self));
  FSimList[FSimList.Count-1].ID := FSimCounter;
  FSimList[FSimList.Count-1].Show;
  FSimList[FSimList.Count-1].Caption := 'Simulation ' + IntToStr(FSimCounter);
  FSimList[FSimList.Count-1].MyOnDestroy := @RemoveSim;
  TabControl1.Tabs.Add('Simulation' + IntToStr(FSimCounter));
  EnableButtons;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  if (FSimList.Count > 0) then
  begin
    FSimList.Delete(TabControl1.TabIndex);
    TabControl1.Tabs.Delete(TabControl1.TabIndex);
	end;
  EnableButtons;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FSimList := TSimList.Create;
  FSimCounter := 0;
  EnableButtons;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FSimlist.Free;
  FForm.Free;
end;

procedure TForm1.MenuItem2Click(Sender: TObject);
begin

end;

procedure TForm1.EnableButtons;
begin
  Button2.Enabled := (TabControl1.Tabs.Count > 0);
end;

procedure TForm1.RemoveSim(Sender: TObject);
var
  I: Integer;
begin

  for I := 0 to FSimList.Count-1 do
  begin
    if (FSimList[I].ID = TForm2(Sender).ID) then
    begin
      TabControl1.Tabs.Delete(I);
		end;
	end;

end;

end.

