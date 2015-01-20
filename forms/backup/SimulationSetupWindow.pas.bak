unit SimulationSetupWindow;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, Forms, Controls, Graphics, Dialogs,
	ExtCtrls, StdCtrls, Buttons, Grids, EditBtn, fgl, world, peoples, sim, funcs,
	SimulationWindow;

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
		GroupBox3: TGroupBox;
		Image3: TImage;
		LabeledEdit6: TLabeledEdit;
		LabeledEdit7: TLabeledEdit;
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
		procedure ButtonRemovePeopleClick(Sender: TObject);
		procedure FormCreate(Sender: TObject);
		procedure ButtonRandomizeClick(Sender: TObject);
		procedure FormDestroy(Sender: TObject);
		procedure PeopleGridDrawCell(Sender: TObject; aCol, aRow: Integer;
					aRect: TRect; aState: TGridDrawState);
  private
    { private declarations }
    FSimSetup: TSimSetup;
    FOnApply: TOnApplyEvent;
    FPeoplesList: TPeoplesList;

    procedure EnableButtons;

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

procedure TForm3.ButtonRemovePeopleClick(Sender: TObject);
begin
  if (FPeoplesList.Count > 0) then
  begin
    FPeoplesList.Delete(PeopleGrid.Row-1);
    PeoplesToStringGrid(PeopleGrid, FPeoplesList);
	end;
  EnableButtons;
end;

procedure TForm3.ButtonAddPeopleClick(Sender: TObject);
var
  I: Integer;
  locWood, locFood, locIron: Integer;
  locRes: TResources;
begin
  I := FPeoplesList.Add(TPeople.Create);
  FPeoplesList[I].InitCitizens := StrToInt(EditCitizens.Text);
  FPeoplesList[I].PeopleType := TPeopleType(PeopleBox.ItemIndex);
  FPeoplesList[I].Color := ButtonColor.ButtonColor;
  locRes.Wood := StrToInt(EditWood.Text);
  locRes.Food := StrToInt(EditFood.Text);
  locRes.Iron := StrToInt(EditIron.Text);
  FPeoplesList[I].Resources := locRes;

  PeoplesToStringGrid(PeopleGrid, FPeoplesList);
  EnableButtons;
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
  self.Constraints.MinWidth := self.Width;
  self.Constraints.MinHeight := self.Height;
  FPeoplesList := TPeoplesList.Create;
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

procedure TForm3.FormDestroy(Sender: TObject);
begin
  FPeoplesList.Free;
end;

procedure TForm3.PeopleGridDrawCell(Sender: TObject; aCol, aRow: Integer;
			aRect: TRect; aState: TGridDrawState);
begin
  if (aRow > 0) and (aCol = 6) then
  begin
    with PeopleGrid do
    begin
    Canvas.Brush.Color:= StrToInt(PeopleGrid.Cells[ACol, ARow]);
    Canvas.FillRect(aRect);
    Canvas.TextOut(aRect.Left+2, aRect.Top+2, Cells[ACol, ARow]);
		end;
	end;
end;

procedure TForm3.EnableButtons;
begin
  ButtonRemovePeople.Enabled := (FPeoplesList.Count > 0);
  ButtonApply.Enabled := (FPeoplesList.Count > 0);
end;

end.

