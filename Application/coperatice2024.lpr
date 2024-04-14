program Coperatice2024;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, datetimectrls, zcomponent, uPrincipale, uDM, uAdherents, uResponsable,
  uCotisation1, uTarif
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TFrmPrincipale, FrmPrincipale);
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TFrmAdherent, FrmAdherent);
  Application.CreateForm(TFrmResponsable, FrmResponsable);
  Application.CreateForm(TFrmCotisation, FrmCotisation);
  Application.CreateForm(TFrmTarifs, FrmTarifs);
  Application.Run;
end.

