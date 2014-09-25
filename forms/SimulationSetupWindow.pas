unit SimulationSetupWindow;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Buttons, Grids, fgl,
  world, peoples, sim, SimulationWindow;

type

  { TForm3 }
  TOnApplyEvent = procedure(Sender: TObject) of Object;

  TForm3 = class(TForm)
    ApplyButton: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
		BitBtn4: TBitBtn;
		ColorButton1: TColorButton;
		ComboBox1: TComboBox;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Image1: TImage;
    Image2: TImage;
    LabeledEdit1: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    LabeledEdit3: TLabeledEdit;
    LabeledEdit4: TLabeledEdit;
		LabeledEdit5: TLabeledEdit;
		LabeledEdit6: TLabeledEdit;
		LabeledEdit7: TLabeledEdit;
		LabeledEdit8: TLabeledEdit;
		LabeledEdit9: TLabeledEdit;
		StringGrid1: TStringGrid;
		procedure ApplyButtonClick(Sender: TObject);
		procedure FormCreate(Sender: TObject);
		procedure FormDestroy(Sender: TObject);
  private
    { private declarations }
    FSimSetup: TSimSetup;
    FSim: TSimulation;
    FSimForm: TForm2;
    FOnApply: TOnApplyEvent;
  public
    { public declarations }
    property SimSetup: TSimSetup read FSimSetup write FSimSetup;
    property Sim: TSimulation read FSim write FSim;
    property SimForm: TForm2 read FSimForm write FSimForm;
    property OnApply: TOnApplyEvent read FOnApply write FOnApply;
  end;

  TSimSetupList = specialize TFPGObjectList<TForm3>;

var
  Form3: TForm3;

implementation

{$R *.lfm}

{ TForm3 }

procedure TForm3.ApplyButtonClick(Sender: TObject);
begin
  FSimSetup.MapSetup.Width := StrToInt(LabeledEdit1.Text);
  FSimSetup.MapSetup.Height := StrToInt(LabeledEdit2.Text);
  FSimSetup.MapSetup.ProbForest := StrToInt(LabeledEdit3.Text);
  FSimSetup.MapSetup.ProbRocks := StrToInt(LabeledEdit4.Text);
  FSimSetup.MapSetup.TileSize := 8;

  FSim.Name := LabeledEdit5.Text;
  FSim.Map.Generate(FSimSetup.MapSetup);
  FSimForm.Caption := FSim.Name;
  FSimForm.Show;
  self.Visible := False;

  if Assigned(FOnApply) then
  begin
    FOnApply(self);
	end;
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
  self.Constraints.MinWidth := self.Width;
  self.Constraints.MinHeight := self.Height;
end;

procedure TForm3.FormDestroy(Sender: TObject);
begin
  //FSim.Free;
end;

end.
