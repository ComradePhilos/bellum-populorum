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
    ButtonApply: TBitBtn;
    ButtonAddPeople: TBitBtn;
    ButtonRemovePeople: TBitBtn;
		ButtonRandomize: TBitBtn;
		CheckBox1: TCheckBox;
		ButtonColor: TColorButton;
		PeopleBox: TComboBox;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Image1: TImage;
    Image2: TImage;
    LabeledEdit1: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    LabeledEdit3: TLabeledEdit;
    LabeledEdit4: TLabeledEdit;
		LabeledEdit5: TLabeledEdit;
		EditCitizens: TLabeledEdit;
		EditWood: TLabeledEdit;
		EditFood: TLabeledEdit;
		EditIron: TLabeledEdit;
		PeopleGrid: TStringGrid;
		procedure ButtonAddPeopleClick(Sender: TObject);
    procedure ButtonApplyClick(Sender: TObject);
		procedure FormCreate(Sender: TObject);
		procedure ButtonRandomizeClick(Sender: TObject);
  private
    { private declarations }
    FSimSetup: TSimSetup;
    FOnApply: TOnApplyEvent;
  public
    { public declarations }
    property SimSetup: TSimSetup read FSimSetup write FSimSetup;
    property OnApply: TOnApplyEvent read FOnApply write FOnApply;
  end;

  TSimSetupList = specialize TFPGObjectList<TForm3>;

var
  Form3: TForm3;

implementation

{$R *.lfm}

{ TForm3 }

procedure TForm3.ButtonApplyClick(Sender: TObject);
begin

  FSimSetup.MapSetup.Width := StrToInt(LabeledEdit1.Text);
  FSimSetup.MapSetup.Height := StrToInt(LabeledEdit2.Text);
  FSimSetup.MapSetup.ProbForest := StrToInt(LabeledEdit3.Text);
  FSimSetup.MapSetup.ProbRocks := StrToInt(LabeledEdit4.Text);
  FSimSetup.MapSetup.TileSize := 8;

  self.Visible := False;

  if Assigned(FOnApply) then
  begin
    FOnApply(self);
	end;
end;

procedure TForm3.ButtonAddPeopleClick(Sender: TObject);
begin
  PeopleGrid.RowCount := PeopleGrid.RowCount + 1;
  PeopleGrid.Cells[0,PeopleGrid.RowCount-1] := IntToStr(PeopleGrid.RowCount-1);
  PeopleGrid.Cells[1,PeopleGrid.RowCount-1] := PeopleBox.Items[PeopleBox.ItemIndex];
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
  self.Constraints.MinWidth := self.Width;
  self.Constraints.MinHeight := self.Height;
  Randomize;
end;

procedure TForm3.ButtonRandomizeClick(Sender: TObject);
begin
  PeopleBox.ItemIndex := Random(3);
  EditCitizens.Text := IntToStr(Random(9)+1);
  EditWood.Text := IntToStr(Random(400)+100);
  EditFood.Text := IntToStr(Random(400)+100);
  EditIron.Text := IntToStr(Random(400)+100);
  ButtonColor.ButtonColor := Random(clWhite);      // Good thing Colors are Integers
end;

end.

