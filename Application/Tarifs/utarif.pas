unit uTarif;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, DBGrids,
  DBCtrls, StdCtrls, DBDateTimePicker;

type

  { TFrmTarifs }

  TFrmTarifs = class(TForm)
    BtnValider: TButton;
    BtnSupprimer: TButton;
    BtnModifier: TButton;
    BtnAjouter: TButton;
    DBEdit2: TDBDateTimePicker;
    DBEdit3: TDBDateTimePicker;
    DBEdit4: TDBEdit;
    DBEdit5: TDBCheckBox;
    DBGrid1: TDBGrid;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel4: TPanel;
    procedure BtnAjouterClick(Sender: TObject);
    procedure BtnValiderClick(Sender: TObject);
    procedure DBEdit2Change(Sender: TObject);
  private

  public

  end;

var
  FrmTarifs: TFrmTarifs;

implementation
    uses UDM;
{$R *.lfm}

    { TFrmTarifs }

    procedure TFrmTarifs.DBEdit2Change(Sender: TObject);
    begin

    end;

procedure TFrmTarifs.BtnValiderClick(Sender: TObject);
begin
  if not DM.AjouterTarif() then
  ShowMessage('OPération Non Effectuée !')
  else
    ShowMessage('OPération Effectuée !')  ;
end;

procedure TFrmTarifs.BtnAjouterClick(Sender: TObject);
begin
   DM.NouveauTarif()
end;

end.

