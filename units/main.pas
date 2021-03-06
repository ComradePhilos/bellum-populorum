unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Menus, StdCtrls, ComCtrls, Buttons, ActnList,
  {own units}
  sim, SimulationWindow, SimulationSetupWindow, definitions;


// Todo and to think about:
// * try a class based version of the map and its objects? -> objects will be no tiles anymore
// * maybe add manipulable growing-rate for each people
// * summer and winter -> scalable, see how dem People gonna survive =P
// * implement the thoughts shown by the class diagramme
// * make extra classes inheriting from TPeople? -> each people has its own implementation

type

  { TForm1 }

  TForm1 = class(TForm)
    ActionList1: TActionList;
	  Label1: TLabel;
    ShowButton: TBitBtn;
    CloseButton: TBitBtn;
    StartButton: TBitBtn;
    BitBtn4: TBitBtn;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    TabControl1: TTabControl;
		procedure MenuItem2Click(Sender: TObject);
    procedure ShowButtonClick(Sender: TObject);
    procedure SetupButtonClick(Sender: TObject);
    procedure NewClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

  private
    { private declarations }
    FForm: TForm2;
    FSetupForm: TForm3;
    FSimFormList: TSimFormList;
    FSimSetupList: TSimSetupList;
    FSimCounter: integer;
    FOSName: String;
    procedure UpdateWindow;
    procedure SetupDone(Sender: TObject);
    procedure RemoveSim(Sender: TObject);
    procedure SimFormListToTabs(ATabControl: TTabControl; ASimFormList: TSimFormList);

  public
    { public declarations }
  end;

var
  Form1: TForm1;
  BuildDate: TDateTime;

implementation

const
  ProgrammeName = 'bellum populorum';
  ProgrammeVersion = '0.1.2';

{$R *.lfm}

procedure TForm1.FormCreate(Sender: TObject);
var
  fs: TFormatSettings;
begin
  fs.DateSeparator := '/';
  fs.ShortDateFormat:='yyyy/mm/dd';
  BuildDate := StrToDate({$I %DATE%},fs);
  FOSName := 'unknown';
  // OS detection and special OS-based operations
  {$IFDEF macos}
  FOSName := 'MacOS';
  {$ENDIF}
  {$IFDEF mswindows}
  FOSName := 'Windows';
  {$ENDIF}
  {$IFDEF linux}
  FOSName := 'Linux';
  {$ENDIF}

  Caption := ProgrammeName + '  ' + ProgrammeVersion + '  (' + DateToStr(BuildDate) +')';
  FSimFormList := TSimFormList.Create(True);
  FSimSetupList := TSimSetupList.Create(True);
  FSimCounter := 0;
  InitImages;
  LoadImages;
  UpdateWindow;
end;

procedure TForm1.NewClick(Sender: TObject);
begin
  FSimSetupList.Add(TForm3.Create(nil));
  FSimSetupList[FSimSetupList.Count - 1].LabeledEdit5.Text :=
    'Simulation ' + IntToStr(FSimCounter+1);
  FSimSetupList[FSimSetupList.Count - 1].OnApply := @SetupDone;
  FSimSetupList[FSimSetupList.Count - 1].Show;
end;

procedure TForm1.ShowButtonClick(Sender: TObject);
begin
  if (FSimFormList.Count > 0) then
  begin
    FSimFormList[TabControl1.TabIndex].Show;
  end;
end;

procedure TForm1.MenuItem2Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TForm1.SetupButtonClick(Sender: TObject);
begin
  FSimSetupList[TabControl1.TabIndex].Show;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  if (FSimFormList.Count > 0) then
  begin
    FSimFormList.Delete(TabControl1.TabIndex);
  end;
  UpdateWindow;
end;

procedure TForm1.FormDestroy(Sender: TObject);
var
  I: integer;
begin
  FSimFormList.Free;
  FSimSetupList.Free;
  FForm.Free;
  FSetupForm.Free;
  ImageGrass.Free;
  ImageTree.Free;
  ImageTreeMedium.Free;
  ImageTreeSmall.Free;
  ImageRock.Free;
  ImageRomanHouse.Free;
end;

procedure TForm1.UpdateWindow;
begin
  ShowButton.Enabled := (FSimFormList.Count > 0);
  CloseButton.Enabled := (FSimFormList.Count > 0);
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
      FSimFormList.Delete(I);
    end;
  end;
  UpdateWindow;
end;

procedure TForm1.SimFormListToTabs(ATabControl: TTabControl; ASimFormList: TSimFormList);
var
  I: integer;
begin
  ATabControl.Tabs.Clear;
  for I := 0 to ASimFormList.Count - 1 do
  begin
    ATabControl.Tabs.Add(FSimFormList[I].Sim.Name);
  end;
end;

procedure TForm1.SetupDone(Sender: TObject);
begin
  // Create simulation window | load values from setup
  Inc(FSimCounter);

  FSimFormList.Add(TForm2.Create(nil));
  FSimFormList[FSimFormList.Count - 1].ID := FSimCounter;
  FSimFormList[FSimFormList.Count - 1].Caption := TForm3(Sender).LabeledEdit5.Text;
  FSimFormList[FSimFormList.Count - 1].Sim.Name := TForm3(Sender).LabeledEdit5.Text;
  FSimFormList[FSimFormList.Count - 1].Sim.Map.SetParameters(TForm3(Sender).SimSetup.MapSetup);
  FSimFormList[FSimFormList.Count - 1].Sim.Map.Generate;
  UpdateWindow;
  TabControl1.TabIndex := TabControl1.Tabs.Count - 1;

  if TForm3(Sender).CheckBox1.Checked then
  begin
    FSimFormList[FSimFormList.Count - 1].Show;
    //FSimFormList[FSimFormList.Count - 1].Sim.Initialize(TForm3(Sender).SimSetup);
    FSimFormList[FSimFormList.Count - 1].Sim.Setup := TForm3(Sender).SimSetup;
	end;
end;


end.
