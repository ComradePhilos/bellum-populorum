unit SimulationWindow;

{$mode objfpc}{$H+}

interface

uses
      Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
			ExtCtrls, Buttons,
      world, sim;

type

			{ TForm2 }

      TForm2 = class(TForm)
						BitBtn1: TBitBtn;
						Memo1: TMemo;
						PaintBox1: TPaintBox;
						procedure BitBtn1Click(Sender: TObject);
						procedure FormCreate(Sender: TObject);
						procedure FormDestroy(Sender: TObject);
      private
      { private declarations }

      public
        FSim: TSimulation;

      end;

var
      Form2: TForm2;

implementation

{$R *.lfm}

{ TForm2 }


procedure TForm2.BitBtn1Click(Sender: TObject);
begin
  FSim.Map.Generate(20,20);
  Memo1.Clear;
  Memo1.Lines.AddStrings(FSim.Map.ToText);
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  FSim := TSimulation.Create;
end;

procedure TForm2.FormDestroy(Sender: TObject);
begin
  FSim.Free;
end;

end.

