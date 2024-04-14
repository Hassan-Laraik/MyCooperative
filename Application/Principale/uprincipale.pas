unit uPrincipale;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, DBGrids, StdCtrls;

type

  { TFrmPrincipale }

  TFrmPrincipale = class(TForm)
    BtnGestionAdherents: TButton;
    BtnGestionResponsables: TButton;
    BtnGestionCotisations: TButton;
    BtnGestionDesTarifs: TButton;
    procedure BtnGestionAdherentsClick(Sender: TObject);
    procedure BtnGestionCotisationsClick(Sender: TObject);
    procedure BtnGestionDesTarifsClick(Sender: TObject);
    procedure BtnGestionResponsablesClick(Sender: TObject);

  private

  public

  end;

  const
  ADHERENTS    :String  = 'ZtblAdherents';
  RESPONSABLES : String = 'ZtblResponsables';
  COLLECTES    : String = 'ZtblCollectes' ;
var
  FrmPrincipale: TFrmPrincipale;

implementation
    uses UDM,uAdherents,uResponsable,uCotisation1,uTarif;
{$R *.lfm}

    { TFrmPrincipale }

procedure TFrmPrincipale.BtnGestionAdherentsClick(Sender: TObject);
begin
  DM.ActiverTable(ADHERENTS);
  FrmAdherent.ShowModal;
  DM.DisactiverTable(ADHERENTS);
end;

procedure TFrmPrincipale.BtnGestionCotisationsClick(Sender: TObject);
begin
  DM.ActiverTable(ADHERENTS);
  DM.ActiverTable(RESPONSABLES);
  DM.ActiverTable(COLLECTES);
  FrmCotisation.Show;
  FrmCotisation.FormStyle := fsStayOnTop;
  DM.DisactiverTable(COLLECTES);
  DM.DisactiverTable(ADHERENTS);
  DM.DisactiverTable(RESPONSABLES);
end;

procedure TFrmPrincipale.BtnGestionDesTarifsClick(Sender: TObject);
begin
  FrmTarifs.ShowModal;
end;

procedure TFrmPrincipale.BtnGestionResponsablesClick(Sender: TObject);
begin
  DM.ActiverTable(RESPONSABLES);
  FrmResponsable.ShowModal;
  DM.DisactiverTable(RESPONSABLES);
end;

{ TFrmPrincipale }



end.

