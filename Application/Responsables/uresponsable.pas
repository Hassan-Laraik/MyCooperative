unit uResponsable;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, ComCtrls,
  DBGrids, StdCtrls;

type

  { TFrmResponsable }

  TFrmResponsable = class(TForm)
    BtbRechercher: TButton;
     BtnAjouter: TButton;
    BtnAnnuler: TButton;
    BtnFremer: TButton;
    BtnImprimerResponsable: TButton;
    BtnImprimerAllResponsables: TButton;
    BtnModifier: TButton;
    BtnSupprimer: TButton;
    BtnValider: TButton;
    Button1: TButton;
    DBGrid1: TDBGrid;
    EdtAdresse: TMemo;
    EdtCin: TEdit;
    EdtGSM: TEdit;
    EdtNom: TEdit;
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
    Function ViderResponsable():Boolean;
    Procedure ChargerResponsable();
    Function ValiderResponsable():Boolean;
  public

  end;

var
  FrmResponsable: TFrmResponsable;

implementation
 uses UDM;
{$R *.lfm}

 { TFrmResponsable }

 procedure TFrmResponsable.BtbRechercherClick(Sender: TObject);
 begin
   if NOT DM.RechercheResponsable(trim(EdtRechercher.text)) then
   ShowMessage('Responsable Non Enregistré');
 end;

procedure TFrmResponsable.BtnAjouterClick(Sender: TObject);
begin
   Self.CDUD:='INSERT';
  self.ViderResponsable();
  PageControl1.ActivePage:=TabSheet2;
  EdtCin.SetFocus;
end;

procedure TFrmResponsable.BtnAnnulerClick(Sender: TObject);
begin
  PageControl1.ActivePage:=TabSheet1;
end;

procedure TFrmResponsable.BtnFremerClick(Sender: TObject);
begin
  //DM.DisactiverTable('Responsables');
  close;
end;

procedure TFrmResponsable.BtnModifierClick(Sender: TObject);
begin
  Self.CDUD:='UPDATE';
   PageControl1.ActivePage:=TabSheet2;
   self.ChargerResponsable();
end;

procedure TFrmResponsable.BtnValiderClick(Sender: TObject);
begin
  if  Not  self.Validerresponsable() then
       begin
         exit;
       end;
  case self.CDUD of
    'INSERT': if NOT DM.AjouterResponsable(EdtCin.Text,EdtNom.Text,EdtGSM.Text,EdtAdresse.text)
   then
    begin
      ShowMessage('Operration Non Effectuée  CIN Responsable Existe Deja!');
      exit;
    end;
    'UPDATE':if NOT DM.ModifierResponsable(EdtCin.Text,EdtNom.Text,EdtGSM.Text,EdtAdresse.text)
   then
    begin
      ShowMessage('Operration Non Effectuée  CIN responsable Existe Deja! !');
      exit;
    end;
  end;

  PageControl1.ActivePage:=TabSheet1;
end;

procedure TFrmResponsable.FormShow(Sender: TObject);
begin
  PageControl1.ActivePage := TabSheet1;
end;

function TFrmResponsable.ViderResponsable(): Boolean;
begin
  EdtCin.Clear;
  EdtNom.Clear;
  EdtGSM.Clear;
  EdtAdresse.Clear;
end;

procedure TFrmResponsable.ChargerResponsable();
begin
    //EdtCin.Text:=DM.ValeurDuChampReponsable('cin_responsable');
     //EdtNom.Text:=DM.ValeurDuChampReponsable('nom');
     //EdtGSM.Text:=DM.ValeurDuChampReponsable('gsm');
     //EdtAdresse.Text:=DM.ValeurDuChampReponsable('douar');
  EdtCin.Text:=DM.ValeurDuChamp('cin_responsable','ZtblResponsables');
  EdtNom.Text:=DM.ValeurDuChamp('nom','ZtblResponsables');
  EdtGSM.Text:=DM.ValeurDuChamp('gsm','ZtblResponsables');
  EdtAdresse.Text:=DM.ValeurDuChamp('douar','ZtblResponsables');
end;

function TFrmResponsable.ValiderResponsable(): Boolean;
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

end.

