unit uCotisation1;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  ComCtrls, DBGrids, Calendar, EditBtn, Spin, ExtDlgs, DateTimePicker;

type

  { TFrmCotisation }

  TFrmCotisation = class(TForm)
    BtbRechercher: TButton;
    BtnAjouter: TButton;
    BtnAnnuler: TButton;
    BtnImprimerCotisationAdherent: TButton;
    BtnModifier: TButton;
    BtnSupprimer: TButton;
    BtnValider: TButton;
    Button1: TButton;
    BtnRechercherAdherent: TButton;
    BtnCotisation: TButton;
    BtnRetout: TButton;
    BtnFremer: TButton;
    Btnilterer: TButton;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    EdtAdresse: TMemo;
    EdtCin: TEdit;
    EdtDAteCotisation: TDateTimePicker;
    EdtGSM: TEdit;
    EdtNom: TEdit;
    EdtQuantite: TFloatSpinEdit;
    EdtRechercher: TDateEdit;
    EdtRechercher1: TDateEdit;
    EdtRechercherAdherent: TLabeledEdit;
    EdtRechercherAdherent1: TLabeledEdit;
    EdtRechercherAdherent2: TLabeledEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label10: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    PageControl1: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    RadioPeriode: TRadioGroup;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    procedure BtbRechercherClick(Sender: TObject);
    procedure BtnAjouterClick(Sender: TObject);
    procedure BtnAnnulerClick(Sender: TObject);
    procedure BtnCotisationClick(Sender: TObject);
    procedure BtnFremerClick(Sender: TObject);
    procedure BtniltererClick(Sender: TObject);
    procedure BtnModifierClick(Sender: TObject);
    procedure BtnRechercherAdherentClick(Sender: TObject);
    procedure BtnRetoutClick(Sender: TObject);
    procedure BtnValiderClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    tarif : Double;
    CDUD : string;
    Cin_Responsable : string;
    procedure ViderCotidation();
    procedure ChargerCotisation();
  public

  end;

var
  FrmCotisation: TFrmCotisation;
  const
  ADHERENTS    :String  = 'ZtblAdherents';
  RESPONSABLES : String = 'ZtblResponsables';
  COLLECTES    : String = 'ZtblCollectes' ;
implementation
 uses UDM;
{$R *.lfm}

 { TFrmCotisation }

 procedure TFrmCotisation.BtnAjouterClick(Sender: TObject);
 begin
   Self.CDUD := 'INSERT';
   PageControl1.ActivePage := TabSheet3;
   self.ViderCotidation();

  EdtQuantite.SetFocus;
 end;

procedure TFrmCotisation.BtbRechercherClick(Sender: TObject);
var
 cin_adherent  :  String;
begin
 if IsNullDate(EdtRechercher.Date ) then
  begin
   ShowMessage('Remplissez La Date Debut');
   EdtRechercher.SetFocus;
  exit;
  end;
 if IsNullDate(EdtRechercher1.Date ) then
  begin
   ShowMessage('Remplissez La Date Fin');
   EdtRechercher1.SetFocus;
  exit;
  end;
 cin_adherent := DBGrid1.Columns.Items[4].Field.AsString;
  if  DM.RechercheCotisation(cin_adherent,
                             EdtRechercher.text,
                             EdtRechercher1.text) then
   begin
   showmessage(
       FloatToStr(DM.ToatalCotisationParPeriode(cin_adherent,EdtRechercher.text,
                             EdtRechercher1.text))
    );
   end else
   begin
      ShowMessage('Cotistaion / Collecte Non Existante');
   end;
end;

procedure TFrmCotisation.BtnAnnulerClick(Sender: TObject);
begin
  PageControl1.ActivePage := TabSheet1;
end;

procedure TFrmCotisation.BtnCotisationClick(Sender: TObject);
var
   cin_adherent :  string ;
begin
  cin_adherent := DBGrid2.Columns.Items[0].Field.AsString;
  ShowMessage(cin_adherent);
  DM.FiltrerCotisation(cin_adherent);
  PageControl1.ActivePage := TabSheet2;
end;

procedure TFrmCotisation.BtnFremerClick(Sender: TObject);
begin
  DM.DisactiverTable('Cotisation');
  close;
end;

procedure TFrmCotisation.BtniltererClick(Sender: TObject);
   var cin_adherent  :  String;
   begin
    cin_adherent := DBGrid1.Columns.Items[4].Field.AsString;
   ShowMessage(FloatToStr(DM.ToatalCotisationParPeriode(cin_adherent)));
    //showmessage(
     //  FloatToStr(DM.ToatalCotisationParPeriode(cin_adherent,EdtRechercher.text,
            //                 EdtRechercher1.text))
   // );

end;

procedure TFrmCotisation.BtnModifierClick(Sender: TObject);
begin
  Self.CDUD:='UPDATE';
  PageControl1.ActivePage := TabSheet3;
  self.ChargerCotisation();
end;

procedure TFrmCotisation.BtnRechercherAdherentClick(Sender: TObject);
begin
  DM.FiltrerCotisation('') ;
  if Not DM.RechercheAdherent(trim(EdtRechercherAdherent.Text)) then
         ShowMessage('Adherent Non Trouvé !!') ;
end;

procedure TFrmCotisation.BtnRetoutClick(Sender: TObject);
begin
  //initialise collectes
  PageControl1.ActivePage := TabSheet1;
end;

procedure TFrmCotisation.BtnValiderClick(Sender: TObject);
var periode : String;
begin
  {if  Not  self.ValiderAdherent() then
       begin
         exit;
       end; }
   if RadioPeriode.ItemIndex = 0 then periode := 'MATAIN';
   if RadioPeriode.ItemIndex = 1 then periode := 'SOIR'; ;
  case self.CDUD of
    'INSERT': if NOT DM.AjouterCotisation(
                                          EdtDAteCotisation.Date,
                                          EdtQuantite.Value,
                                          self.tarif,
                                          EdtCin.Text,
                                          Cin_Responsable,
                                          periode
                                          )
                  then
                   begin
                    ShowMessage('Operration Non Effectuée ');
                    exit;
                  end;
    'UPDATE': if NOT DM.ModifierCotisation(
                                          EdtDAteCotisation.Date,
                                          EdtQuantite.Value,
                                          EdtCin.Text,
                                          Cin_Responsable,
                                          periode
                                          )
                    then
                     begin
                      ShowMessage('Operration Non Effectuée ');
                      exit;
                    end;
  end;
  PageControl1.ActivePage := TabSheet2;
end;

procedure TFrmCotisation.FormCreate(Sender: TObject);
begin
    self.tarif:=DM.TarifApplique();
end;

procedure TFrmCotisation.FormShow(Sender: TObject);
begin
  self.Cin_Responsable := 'RES1';
  PageControl1.ActivePage := TabSheet1;
end;

 procedure TFrmCotisation.ViderCotidation();
 begin
     EdtCin.Text:= DM.ValeurDuChampAdherent('cin_adherent');
     EdtNom.Text:= DM.ValeurDuChampAdherent('nom');
     EdtGSM.Text:= DM.ValeurDuChampAdherent('gsm');
     //EdtAdresse.Clear;
     EdtDAteCotisation.Date := date();
     EdtQuantite.Text := '5';
     RadioPeriode.ItemIndex := 0;
 end;

 procedure TFrmCotisation.ChargerCotisation();
 begin
    // EdtCin.Text := DM.ValeurDuChampAdherent('cin_adherent');
    //EdtNom.Text := DM.ValeurDuChampAdherent('nom');
    //EdtGSM.Text := DM.ValeurDuChampAdherent('gsm');
     //EdtDAteCotisation.Date := StrToDate(DM.ValeurDuChampCotisation('datecotisation'));
     //EdtQuantite.Text := DM.ValeurDuChampCotisation('quantite');
    {if DM.ValeurDuChampCotisation('periode') = 'MATAIN' then
       RadioPeriode.ItemIndex := 0
     else
       RadioPeriode.ItemIndex := 1;}

     EdtCin.Text := DM.ValeurDuChamp('cin_adherent','ZtblAdherents');
     EdtNom.Text := DM.ValeurDuChamp('nom','ZtblAdherents');
     EdtGSM.Text := DM.ValeurDuChamp('gsm','ZtblAdherents');


     EdtDAteCotisation.Date := StrToDate(DM.ValeurDuChamp('datecotisation','ZtblCollectes'));
     EdtQuantite.Text := DM.ValeurDuChamp('quantite','ZtblCollectes');

     if DM.ValeurDuChamp('periode','ZtblCollectes') = 'MATAIN' then
       RadioPeriode.ItemIndex := 0
     else
       RadioPeriode.ItemIndex := 1;
 end;

end.

