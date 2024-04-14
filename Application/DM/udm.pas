unit uDM;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, ZConnection, ZDataset,variants;

type

  { TDM }

  TDM = class(TDataModule)
    DSTarifApplique: TDataSource;
    DsAdherents: TDataSource;
    DSResponsables: TDataSource;
    DSCollectes: TDataSource;
    ZCNX: TZConnection;
    ZqryAgreggats: TZQuery;
    ZqryTarifApplique: TZQuery;
    ZTblAdherents: TZQuery;
    ZTblAdherentscin_adherent: TStringField;
    ZTblAdherentsdouar: TStringField;
    ZTblAdherentsgsm: TStringField;
    ZTblAdherentsnom: TStringField;
    ZtblCollectes: TZQuery;
    ZtblCollectescin_adherent: TStringField;
    ZtblCollectescin_responsable: TStringField;
    ZtblCollectesdatecotisation: TDateField;
    ZtblCollectesidcotisations: TLongintField;
    ZtblCollectesperiode: TStringField;
    ZtblCollectesquantite: TFloatField;
    ZtblCollectestarif: TFloatField;
    ZtblResponsables: TZQuery;
    ZtblResponsablescin_responsable: TStringField;
    ZtblResponsablesdouar: TStringField;
    ZtblResponsablesgsm: TStringField;
    ZtblResponsablesnom: TStringField;
    Procedure ZTblAdherentsgsmGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    Procedure ZTblAdherentsPostError(DataSet: TDataSet; E: EDatabaseError;
      var DataAction: TDataAction);
    Procedure ZtblResponsablesgsmGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
  private

  public

//CRUD Adherents
      Function RechercheAdherent(cin : string): Boolean;
      Function AjouterAdherent(cin,nom,gsm,douar : string):Boolean;
      Function ModifierAdherent(cin,nom,gsm,douar : string):Boolean;
      Function SuprimerAdherent(cin : string) : Boolean;
     // function AnnulerAdherent():Boolean;
//CRUD Responsables
      Function RechercheResponsable(cin : string): Boolean;
      Function AjouterResponsable(cin,nom,gsm,adresse : string):Boolean;
      Function ModifierResponsable(cin,nom,gsm,adresse : string):Boolean;
      Function SuprimerResponsable(cin : string) : Boolean;
//CRUD Cotisations = Collectes
      //function AllCotisat
      function RechercheCotisation(cle: string; datecotisationDebut,
        datecotisationFin: string): Boolean;
      Procedure FiltrerCotisation(cle : string);
      function AjouterCotisation(dateCotisation: tdate; quantite, tarif: double;
        cinAdherent, cinResponsable: string; periode: string): Boolean;
      Function ModifierCotisation(dateCotisation : tdate;quantite : double;
                                  cinAdherent,cinResponsable : string;
                                  periode : string = 'MATAIN'): Boolean;
      Function SuprimerCotisation(idCotisation : string): Boolean;
//CRUD  Tarification
       Function AjouterTarif():Boolean;
       Function NouveauTarif():Boolean;
       Function TarifApplique(): Double;
// Fonction Utulitaires communs
      Function ActiverTable(_Table : String):Boolean;
      Function DisactiverTable(_Table : String):Boolean;
      Function ValeurDuChampAdherent(avalue : string) : string;
      Function ValeurDuChampReponsable(avalue : string) : string;
      Function ValeurDuChampCotisation(avalue : string) : string;
      Function ValeurDuChamp(avalue: string; ATable: string): string;
 //Greggats somme myenne max min nb
 function ToatalCotisationParPeriode(code: String; dateDebut, dateFin: string
   ): double; overload;
 function ToatalCotisationParPeriode(code: String ): Double;overload;
  end;


var
  DM: TDM;

implementation
    uses Dialogs;
{$R *.lfm}

{ TDM }

procedure TDM.ZTblAdherentsPostError(DataSet: TDataSet; E: EDatabaseError;
  var DataAction: TDataAction);
//var gsm : string;
begin
  if pos(e.Message,'adherents.gsm_UNIQUE') = 0 then
   begin
     if DataSet.State in[dsinsert,dsEdit] then
     begin
       DataSet.Cancel ;
     end;
     ShowMessage('Duplication:Donner Un Autre Numero de Téléphone');
     DataAction := daAbort;
   end;

end;

procedure TDM.ZtblResponsablesgsmGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
   if sender.AsString = '' then aText:='AUCUN'
  else aText := sender.AsString;
end;

function TDM.ActiverTable(_Table: String): Boolean;
begin
   try
    //if  _Table = 'Adherents' then ZTblAdherents.Active:=true;
    //if  _Table = 'Responsables' then ZtblResponsables.Active:=true;
    //if  _Table = 'Cotisations' then ZtblCollectes.Active:=true;
    RESULT := True;
    TZQuery( FindComponent(_Table ) ). Active:= true;
   Except
      RESULT := False;
   end;


end;

function TDM.DisactiverTable(_Table: String): Boolean;
begin
  try
    //if  _Table = 'Adherents' then ZTblAdherents.Active:=False;
    //if  _Table = 'Responsables' then ZtblResponsables.Active:=False;
    //if  _Table = 'Cotisations' then ZtblCollectes.Active:=False;
    RESULT := True;
    TZQuery( FindComponent(_Table ) ). Active:= true;
   Except
      RESULT := False;
   end;
end;

procedure TDM.ZTblAdherentsgsmGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  if sender.AsString = '' then
   aText:='AUCUN'
  else
    aText := sender.AsString;
end;

function TDM.RechercheAdherent(cin: string): Boolean;
begin
   RESULT :=
   Self.ZTblAdherents.Locate('cin_adherent',trim(cin),[loCaseInsensitive]); //, loPartialKey]
end;

function TDM.AjouterAdherent(cin, nom, gsm, douar: string): Boolean;
begin
   RESULT := False;
   if Self.ZTblAdherents.State in [dsInsert,dsEdit] then exit;
   if Self.RechercheAdherent(trim(cin)) then exit;
   Self.ZTblAdherents.Insert;
   Self.ZTblAdherents.FieldByName('cin_adherent').AsString:= trim(cin);
   Self.ZTblAdherents.FieldByName('nom').AsString := trim(nom);
   if (trim(gsm) = '') then
        Self.ZTblAdherents.FieldByName('gsm').Clear else
        Self.ZTblAdherents.FieldByName('gsm').value := trim(gsm);
   Self.ZTblAdherents.FieldByName('douar').AsString := trim(douar);
   Self.ZTblAdherents.Post;
   RESULT := True;
end;

function TDM.ModifierAdherent(cin, nom, gsm, douar: string): Boolean;
begin
   RESULT := False;
   if Self.ZTblAdherents.State in [dsEdit,dsInsert] then exit;
   if NOT Self.RechercheAdherent(trim(cin)) then exit;
   Self.ZTblAdherents.Edit;
   Self.ZTblAdherents.FieldByName('cin_adherent').AsString := trim(cin);
   Self.ZTblAdherents.FieldByName('nom').AsString := trim(nom);
    if (trim(gsm)='') then
        Self.ZTblAdherents.FieldByName('gsm').Clear
        else Self.ZTblAdherents.FieldByName('gsm').Value := trim(gsm);
   Self.ZTblAdherents.FieldByName('douar').AsString := trim(douar);
   Self.ZTblAdherents.Post;
   RESULT := True;
end;

function TDM.SuprimerAdherent(cin: string): Boolean;
begin
  //Desactiver Adherent si possede des  cotisation
   //suprimer si ne possedant aucune cotisation
end;

{Function TDM.AnnulerAdherent: Boolean;
begin

   if Self.ZTblAdherents.State in [dsInsert,dsEdit] then
   begin
   Self.ZTblAdherents.Cancel;
   RESULT := False;
   exit;
   end;
    RESULT := False;
end;
     }
function TDM.RechercheResponsable(cin: string): Boolean;
begin
   RESULT := Self.ZtblResponsables.Locate('cin_responsable',trim(cin),[loCaseInsensitive, loPartialKey]);
end;

function TDM.AjouterResponsable(cin, nom, gsm, adresse: string): Boolean;
begin
  RESULT := False;
   if Self.ZtblResponsables.State in [dsInsert,dsEdit] then exit;
   if Self.RechercheResponsable(trim(cin)) then exit;
   Self.ZtblResponsables.Insert;
   Self.ZtblResponsables.FieldByName('cin_responsable').AsString:= trim(cin);
   Self.ZtblResponsables.FieldByName('nom').AsString:= trim(nom);
    if (trim(gsm) = '') then
        Self.ZtblResponsables.FieldByName('gsm').Clear
        else
          Self.ZtblResponsables.FieldByName('gsm').Value := trim(gsm);
   Self.ZtblResponsables.FieldByName('douar').AsString := trim(adresse);
   Self.ZtblResponsables.Post;
   RESULT := True;
end;

function TDM.ModifierResponsable(cin, nom, gsm, adresse: string): Boolean;
begin
  RESULT := False;
   if Self.ZtblResponsables.State in [dsEdit,dsInsert] then exit;
   if NOT Self.RechercheResponsable(trim(cin)) then exit;
   Self.ZtblResponsables.Edit;
   Self.ZtblResponsables.FieldByName('cin_responsable').AsString:= trim(cin);
   Self.ZtblResponsables.FieldByName('nom').AsString:= trim(nom);
    if (trim(gsm)= '') then
        Self.ZtblResponsables.FieldByName('gsm').Clear
        else
          Self.ZtblResponsables.FieldByName('gsm').Value := trim(gsm);
   Self.ZtblResponsables.FieldByName('douar').AsString := trim(adresse);
   Self.ZtblResponsables.Post;
   RESULT := True;
end;

function TDM.SuprimerResponsable(cin: string): Boolean;
begin

end;

function TDM.RechercheCotisation(cle: string; datecotisationDebut,
  datecotisationFin: string): Boolean;
//var
  //datecotisationToString : String;
  var
    requete : string;
    datedebut ,dateFin :TDate;
begin
    //FormatSettings.DateSeparator:='-';
   //datecotisationToString := DateToStr(datecotisation);
   RESULT :=  False;
   {Self.ZtblCollectes.Locate('cin_adherent;datecotisation',
                            VarArrayOf([trim(cle),datecotisation]),
                            [loCaseInsensitive]); }

    try
      self.ZtblCollectes.Close;
      self.ZtblCollectes.SQL.Clear;
      self.ZtblCollectes.SQL.add('select * from collectes where ');
      self.ZtblCollectes.sql.add('cin_adherent=:cin AND (');
      self.ZtblCollectes.SQL.Add(' datecotisation between :datedebut  and :datefin )');
      self.ZtblCollectes.ParamByName('cin').AsString:=cle;
      self.ZtblCollectes.ParamByName('datedebut').AsString:=datecotisationDebut;
      self.ZtblCollectes.ParamByName('datefin').AsString:=datecotisationFin;
      self.ZtblCollectes.Open;
      Result := True;
    except
       on e : exception do begin
         showmessage(e.Message) ;
         Result := False;
       end;
    end;



end;

procedure TDM.FiltrerCotisation(cle: string);
begin

if trim(cle) = '' then
 begin
 ZtblCollectes.close;
  ZtblCollectes.SQL.clear;
  ZtblCollectes.SQL.add('select * from  collectes ');
  ZtblCollectes.Open;
     exit;
  end;
   ZtblCollectes.close;
  ZtblCollectes.SQL.clear;
   ZtblCollectes.SQL.add('select * from  collectes where cin_adherent =:cin');
    ZtblCollectes.ParamByName('cin').AsString:= cle;
   ZtblCollectes.Open;

end;

function TDM.AjouterCotisation(dateCotisation: tdate; quantite,tarif: double;
  cinAdherent, cinResponsable: string; periode: string): Boolean;
//var
 // tarif : Double;
begin
   RESULT := False;
   if Self.ZtblCollectes.State in [dsInsert,dsEdit] then exit;
     //self.ZqryTarifApplique.Active:=true;
    //tarif := self.ZqryTarifApplique.FieldByName('prix').AsFloat;
   //if Self.RechercheCotisation(trim(cin)) then exit;
   Self.ZtblCollectes.Insert;
   Self.ZtblCollectes.FieldByName('cin_responsable').AsString:= trim(cinResponsable);
   Self.ZtblCollectes.FieldByName('cin_adherent').AsString:= trim(cinAdherent);
   Self.ZtblCollectes.FieldByName('datecotisation').AsDateTime:= dateCotisation;
   Self.ZtblCollectes.FieldByName('quantite').AsFloat := quantite;
   Self.ZtblCollectes.FieldByName('tarif').AsFloat := tarif;
   Self.ZtblCollectes.FieldByName('periode').AsString := periode;
   Self.ZtblCollectes.Post;
   RESULT := True;
end;

function TDM.ModifierCotisation(dateCotisation: tdate; quantite: double;
  cinAdherent, cinResponsable: string; periode: string): Boolean;
begin
  RESULT := False;
   if Self.ZtblCollectes.State in [dsInsert,dsEdit] then exit;
   //if Self.RechercheCotisation(trim(cin)) then exit;
   Self.ZtblCollectes.Edit;
   Self.ZtblCollectes.FieldByName('cin_responsable').AsString:= trim(cinResponsable);
   Self.ZtblCollectes.FieldByName('cin_adherent').AsString := trim(cinAdherent);
   Self.ZtblCollectes.FieldByName('datecotisation').AsDateTime := dateCotisation;
   Self.ZtblCollectes.FieldByName('quantite').AsFloat := quantite;
   Self.ZtblCollectes.FieldByName('periode').AsString := periode;
   Self.ZtblCollectes.Post;
   RESULT := True;
end;

function TDM.SuprimerCotisation(idCotisation: string): Boolean;
begin

end;

function TDM.AjouterTarif(): Boolean;
begin
   Result := False;
  if DM.ZqryTarifApplique.State in [dsInsert,dsEdit] then
   begin
      DM.ZqryTarifApplique.Post;
     Result := True;
   end;
end;

function TDM.NouveauTarif(): Boolean;
begin
   Result := False;
  if DM.ZqryTarifApplique.State in [dsBrowse] then
   begin
      DM.ZqryTarifApplique.Append;
     Result := True;
   end;
end;

function TDM.TarifApplique(): Double;
var
  tarif : Double;
begin
   DM.ZqryTarifApplique.close;
   DM.ZqryTarifApplique.SQL.Clear;
   DM.ZqryTarifApplique. SQL.Add('select prix from tarifs where active = 1 ');
   DM.ZqryTarifApplique.open;
   tarif:= DM.ZqryTarifApplique.FieldByName('prix').AsFloat;
   DM.ZqryTarifApplique.Close;
   DM.ZqryTarifApplique.SQL.Clear;
   DM.ZqryTarifApplique.SQL.add('select * from tarifs');
   DM.ZqryTarifApplique.open;
   Result := tarif;
end;

function TDM.ValeurDuChampAdherent(avalue: string): string;
begin
  RESULT := ZTblAdherents.FieldByName(avalue).AsString;
end;

function TDM.ValeurDuChampReponsable(avalue: string): string;
begin
   RESULT := ZtblResponsables.FieldByName(avalue).AsString;
end;

function TDM.ValeurDuChampCotisation(avalue: string): string;
begin
   RESULT := ZtblCollectes.FieldByName(avalue).AsString;
end;
function TDM.ValeurDuChamp(avalue: string; ATable: string): string;
begin
   RESULT :=  TZTable( FindComponent(ATable ) ). FieldByName(avalue).AsString;;
end;

function TDM.ToatalCotisationParPeriode(code: String; dateDebut, dateFin: string): double;
begin
  Self.ZqryAgreggats.Close;
  Self.ZqryAgreggats.SQL.Clear;
  Self.ZqryAgreggats.SQL.Add('select sum(quantite * tarif) as Total from collectes');
  Self.ZqryAgreggats.SQL.Add(' where cin_adherent =:cin');
  Self.ZqryAgreggats.SQL.Add(' AND ( ');
  Self.ZqryAgreggats.SQL.Add(' datecotisation between  ');
  Self.ZqryAgreggats.SQL.Add(' :datedebut  ');
  Self.ZqryAgreggats.SQL.Add(' AND  ');
  Self.ZqryAgreggats.SQL.Add(' :datefin  ');
  Self.ZqryAgreggats.SQL.Add(' )  ');
  Self.ZqryAgreggats.ParamByName('cin').AsString:= code;
  Self.ZqryAgreggats.ParamByName('datedebut').AsString:= dateDebut;
  Self.ZqryAgreggats.ParamByName('datefin').AsString:= dateFin;
  Self.ZqryAgreggats.Open;
  Result := Self.ZqryAgreggats.FieldByName('Total').AsFloat;
end;

function TDM.ToatalCotisationParPeriode(code: String): Double;
begin
  Self.ZqryAgreggats.Close;
  Self.ZqryAgreggats.SQL.Clear;
  Self.ZqryAgreggats.SQL.Add('select sum(quantite * tarif) as Total from collectes');
  Self.ZqryAgreggats.SQL.Add(' where cin_adherent =:cin');
  Self.ZqryAgreggats.ParamByName('cin').AsString:= code;
  Self.ZqryAgreggats.Open;
  Result := Self.ZqryAgreggats.FieldByName('Total').AsFloat;
end;

end.

