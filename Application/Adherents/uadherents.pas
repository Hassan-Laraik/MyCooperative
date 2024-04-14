unit uAdherents;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  DBGrids, ComCtrls;

type

  { TFrmAdherent }

  TFrmAdherent = class(TForm)
    BtbRechercher: TButton;
    BtnAjouter: TButton;
    BtnFremer: TButton;
    BtnImprimerAllAdherents: TButton;
    BtnImprimerAdherents1: TButton;
    BtnModifier: TButton;
    BtnSupprimer: TButton;
    BtnAnnuler: TButton;
    BtnValider: TButton;
    Button1: TButton;
    DBGrid1: TDBGrid;
    EdtAdresse: TMemo;
    EdtCin: TEdit;
    EdtNom: TEdit;
    EdtGSM: TEdit;
    EdtRechercher: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    PageControl1: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel5: TPanel;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    procedure BtbRechercherClick(Sender: TObject);
    procedure BtnAjouterClick(Sender: TObject);
    procedure BtnAnnulerClick(Sender: TObject);
    procedure BtnFremerClick(Sender: TObject);
    procedure BtnModifierClick(Sender: TObject);
    procedure BtnValiderClick(Sender: TObject);

    procedure FormShow(Sender: TObject);

  private
     CDUD : string;
     Function ValiderAdherent(): Boolean;
     procedure ViderAdherent();
     Procedure ChargerAdherent();
  public

  end;

var
  FrmAdherent: TFrmAdherent;
  const
  ADHERENTS    :String  = 'ZtblAdherents';
  RESPONSABLES : String = 'ZtblResponsables';
  COLLECTES    : String = 'ZtblCollectes' ;

implementation
uses UDM;

{$R *.lfm}

{ TFrmAdherent }

procedure TFrmAdherent.BtbRechercherClick(Sender: TObject);
begin
  if NOT DM.RechercheAdherent(trim(EdtRechercher.text)) then ShowMessage('Adherent Non Enregistré');
end;

procedure TFrmAdherent.BtnAjouterClick(Sender: TObject);
begin
  Self.CDUD := 'INSERT';
  self.ViderAdherent();
  PageControl1.ActivePage := TabSheet2;
  EdtCin.SetFocus;
end;

procedure TFrmAdherent.BtnAnnulerClick(Sender: TObject);
begin
  //if DM.AnnulerAdherent() then
  PageControl1.ActivePage := TabSheet1;
end;

procedure TFrmAdherent.BtnFremerClick(Sender: TObject);
begin
  //DM.DisactiverTable('Adherents');
  //DM.DisactiverTable(ADHERENTS);
  close;
end;

procedure TFrmAdherent.BtnModifierClick(Sender: TObject);
begin
   Self.CDUD := 'UPDATE';
   PageControl1.ActivePage := TabSheet2;
   self.ChargerAdherent();
end;

procedure TFrmAdherent.BtnValiderClick(Sender: TObject);
begin
  if  Not self.ValiderAdherent() then
  begin
    exit;
  end;
  case self.CDUD of
    'INSERT': if NOT DM.AjouterAdherent(EdtCin.Text,EdtNom.Text,EdtGSM.Text,EdtAdresse.text)
                then
                begin
                ShowMessage('Operration Non Effectuée  CIN Adherent Existe Deja!');
                exit;
                end;
    'UPDATE':if NOT DM.ModifierAdherent(EdtCin.Text,EdtNom.Text,EdtGSM.Text,EdtAdresse.text)
               then
                begin
                  ShowMessage('Operration Non Effectuée  CIN Adherent Existe Deja! !');
                  exit;
                end;
  end;
  PageControl1.ActivePage := TabSheet1;
end;

procedure TFrmAdherent.FormShow(Sender: TObject);
begin
  PageControl1.ActivePage := TabSheet1;
end;

function TFrmAdherent.ValiderAdherent(): Boolean;
begin
   Result := False;
    if Length(trim(EdtCin.text)) < 1 then
     begin
       ShowMessage('Code Adherent Non Conforme !');
       EdtCin.SetFocus;
       exit;
     end;
    if Length(trim(EdtNom.text)) < 3 then
     begin
       ShowMessage('Nom Adherent Non Conforme !');
       EdtNom.SetFocus;
       exit;
     end;
    if ((Length(trim(EdtGSM.text)) > 0)  AND  (Length(trim(EdtGSM.text)) <10 ))then
     begin
       ShowMessage('Numero GSM Non Conforme !');
       EdtGSM.SetFocus;
       exit;
     end;
    Result := True;
end;

procedure TFrmAdherent.ViderAdherent();
begin
     EdtCin.Clear;
     EdtNom.Clear;
     EdtGSM.Clear;
     EdtAdresse.Clear;
end;

procedure TFrmAdherent.ChargerAdherent();
begin
     //EdtCin.Text := DM.ValeurDuChampAdherent('cin_adherent');
     EdtCin.Text := DM.ValeurDuChamp('cin_adherent','ZTblAdherents');
     EdtNom.Text := DM.ValeurDuChamp('nom','ZTblAdherents');
     EdtGSM.Text := DM.ValeurDuChamp('gsm','ZTblAdherents');
     EdtAdresse.Text := DM.ValeurDuChamp('douar','ZTblAdherents');
end;

end.

