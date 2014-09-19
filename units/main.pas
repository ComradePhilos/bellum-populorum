unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Menus, StdCtrls, ComCtrls,
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
  private
    { private declarations }
    FForm: TForm2;
    FSimFormList: TSimFormList;
    FSimCounter: integer;
    procedure EnableButtons;
    procedure RemoveSim(Sender: TObject);
    procedure SimFormListToTabs(ATabControl: TTabControl; ASimFormList: TSimFormList);

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
  Inc(FSimCounter);
  FSimFormList.Add(TForm2.Create(nil));
  FSimFormList[FSimFormList.Count - 1].ID := FSimCounter;
  FSimFormList[FSimFormList.Count - 1].Show;
  FSimFormList[FSimFormList.Count - 1].Caption := 'Simulation ' + IntToStr(FSimCounter);
  FSimFormList[FSimFormList.Count - 1].MyOnDestroy := @RemoveSim;
  TabControl1.Tabs.Add('Simulation ' + IntToStr(FSimCounter));
  EnableButtons;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  if (FSimFormList.Count > 0) then
  begin
    FSimFormList.Delete(TabControl1.TabIndex);
    //TabControl1.Tabs.Delete(TabControl1.TabIndex);
  end;
  EnableButtons;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FSimFormList := TSimFormList.Create(true);
  FSimCounter := 0;
  EnableButtons;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FSimFormList.Free;
  FForm.Free;
end;

procedure TForm1.EnableButtons;
begin
  Button2.Enabled := (TabControl1.Tabs.Count > 0);
  SimFormListToTabs(TabControl1, FSimFormList);
end;

procedure TForm1.RemoveSim(Sender: TObject);
var
  I: integer;
begin
  for I := 0 to FSimFormList.Count - 1 do
  begin
    if (FSimFormList[I].ID = TForm2(Sender).ID) then
    begin
      Application.MessageBox(PChar('ID: ' + IntToStr(TForm2(Sender).ID) + ' Index: ' + IntToStr(I)), 'test',0);
      FSimFormList.Delete(I);
      EnableButtons;
    end;
  end;


end;

procedure TForm1.SimFormListToTabs(ATabControl: TTabControl; ASimFormList: TSimFormList);
var
  I: Integer;
begin
  ATabControl.Tabs.Clear;
  for I := 0 to ASimFormList.Count - 1 do
  begin
    ATabControl.Tabs.Add('Simulation ' + IntToStr(ASimFormList[I].ID));
	end;
end;

end.

