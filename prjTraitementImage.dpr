program prjTraitementImage;

uses
  Forms,
  untPrincipale in 'untPrincipale.pas' {frmPrincipale},
  untMDIImage in 'untMDIImage.pas' {frmMDIImage},
  untCalcImage in 'untCalcImage.pas',
  untHFiltreImageImage in 'Filtres\untHFiltreImageImage.pas' {frmHFiltreImageImage},
  untFiltreAddImageImage in 'Filtres\Arithmetique\untFiltreAddImageImage.pas' {frmFiltreAddImageImage},
  untFiltreSubImageImage in 'Filtres\Arithmetique\untFiltreSubImageImage.pas' {frmFiltreSubImageImage},
  untFiltreMulImageImage in 'Filtres\Arithmetique\untFiltreMulImageImage.pas' {frmFiltreMulImageImage},
  untFiltreDivImageImage in 'Filtres\Arithmetique\untFiltreDivImageImage.pas' {frmFiltreDivImageImage},
  untFiltreXORImageImage in 'Filtres\Arithmetique\untFiltreXORImageImage.pas' {frmFiltreXORImageImage},
  untFiltreORImageImage in 'Filtres\Arithmetique\untFiltreORImageImage.pas' {frmFiltreORImageImage},
  untFiltreANDImageImage in 'Filtres\Arithmetique\untFiltreANDImageImage.pas' {frmFiltreANDImageImage},
  untHFiltreImageConstante in 'Filtres\untHFiltreImageConstante.pas' {frmHFiltreImageConstante},
  untFiltreAddImageConstante in 'Filtres\Arithmetique\untFiltreAddImageConstante.pas' {frmFiltreAddImageConstante},
  untFiltreXORImageConstante in 'Filtres\Arithmetique\untFiltreXORImageConstante.pas' {frmFiltreXORImageConstante},
  untFiltreORImageConstante in 'Filtres\Arithmetique\untFiltreORImageConstante.pas' {frmFiltreORImageConstante},
  untFiltreANDImageConstante in 'Filtres\Arithmetique\untFiltreANDImageConstante.pas' {frmFiltreANDImageConstante},
  untFiltreDivImageConstante in 'Filtres\Arithmetique\untFiltreDivImageConstante.pas' {frmFiltreDivImageConstante},
  untFiltreMulImageConstante in 'Filtres\Arithmetique\untFiltreMulImageConstante.pas' {frmFiltreMulImageConstante},
  untFiltreSubImageConstante in 'Filtres\Arithmetique\untFiltreSubImageConstante.pas' {frmFiltreSubImageConstante},
  untFiltreFondu in 'Filtres\Arithmetique\untFiltreFondu.pas' {frmFiltreFondu},
  untHFiltreImage in 'Filtres\untHFiltreImage.pas' {frmHFiltreImage},
  untFiltreNiveauxGris in 'Filtres\Arithmetique\untFiltreNiveauxGris.pas' {frmFiltreNiveauxGris},
  untFiltreAbs in 'Filtres\Arithmetique\untFiltreAbs.pas' {frmFiltreAbs},
  untFiltreNOT in 'Filtres\Arithmetique\untFiltreNOT.pas' {frmFiltreNOT},
  untHFiltreFiltreDigital in 'Filtres\untHFiltreFiltreDigital.pas' {frmHFiltreFiltreDigital},
  untFiltreMoyenne in 'Filtres\Filtre Digital\untFiltreMoyenne.pas' {frmFiltreMoyenne},
  untFiltreMinMax in 'Filtres\Filtre Digital\untFiltreMinMax.pas' {frmFiltreMinMax},
  untFiltreMediane in 'Filtres\Filtre Digital\untFiltreMediane.pas' {frmFiltreMediane},
  untFiltreGauss in 'Filtres\Filtre Digital\untFiltreGauss.pas' {frmFiltreGauss},
  untFiltreSeuil in 'Filtres\Operation Points\untFiltreSeuil.pas' {frmFiltreSeuil},
  untFiltreSeuilAdaptatif in 'Filtres\Operation Points\untFiltreSeuilAdaptatif.pas' {frmFiltreSeuilAdaptatif},
  untHistogramme in 'Filtres\Analyse Image\untHistogramme.pas' {frmHistogramme},
  untFiltreModificationHistogrammePoints in 'Filtres\Operation Points\untFiltreModificationHistogrammePoints.pas' {frmFiltreModificationHistogrammePoints},
  untPixelisation in 'Filtres\Operation Points\untPixelisation.pas' {frmFiltrePixelisation};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Traitement d''Image';
  Application.CreateForm(TfrmPrincipale, frmPrincipale);
  Application.CreateForm(TfrmHFiltreImageImage, frmHFiltreImageImage);
  Application.CreateForm(TfrmFiltreAddImageImage, frmFiltreAddImageImage);
  Application.CreateForm(TfrmFiltreSubImageImage, frmFiltreSubImageImage);
  Application.CreateForm(TfrmFiltreMulImageImage, frmFiltreMulImageImage);
  Application.CreateForm(TfrmFiltreDivImageImage, frmFiltreDivImageImage);
  Application.CreateForm(TfrmFiltreXORImageImage, frmFiltreXORImageImage);
  Application.CreateForm(TfrmFiltreORImageImage, frmFiltreORImageImage);
  Application.CreateForm(TfrmFiltreANDImageImage, frmFiltreANDImageImage);
  Application.CreateForm(TfrmHFiltreImageConstante, frmHFiltreImageConstante);
  Application.CreateForm(TfrmFiltreAddImageConstante, frmFiltreAddImageConstante);
  Application.CreateForm(TfrmFiltreXORImageConstante, frmFiltreXORImageConstante);
  Application.CreateForm(TfrmFiltreORImageConstante, frmFiltreORImageConstante);
  Application.CreateForm(TfrmFiltreANDImageConstante, frmFiltreANDImageConstante);
  Application.CreateForm(TfrmFiltreDivImageConstante, frmFiltreDivImageConstante);
  Application.CreateForm(TfrmFiltreMulImageConstante, frmFiltreMulImageConstante);
  Application.CreateForm(TfrmFiltreSubImageConstante, frmFiltreSubImageConstante);
  Application.CreateForm(TfrmFiltreFondu, frmFiltreFondu);
  Application.CreateForm(TfrmHFiltreImage, frmHFiltreImage);
  Application.CreateForm(TfrmFiltreNiveauxGris, frmFiltreNiveauxGris);
  Application.CreateForm(TfrmFiltreAbs, frmFiltreAbs);
  Application.CreateForm(TfrmFiltreNOT, frmFiltreNOT);
  Application.CreateForm(TfrmHFiltreFiltreDigital, frmHFiltreFiltreDigital);
  Application.CreateForm(TfrmFiltreMoyenne, frmFiltreMoyenne);
  Application.CreateForm(TfrmFiltreMinMax, frmFiltreMinMax);
  Application.CreateForm(TfrmFiltreMediane, frmFiltreMediane);
  Application.CreateForm(TfrmFiltreGauss, frmFiltreGauss);
  Application.CreateForm(TfrmFiltreSeuil, frmFiltreSeuil);
  Application.CreateForm(TfrmFiltreSeuilAdaptatif, frmFiltreSeuilAdaptatif);
  Application.CreateForm(TfrmHistogramme, frmHistogramme);
  Application.CreateForm(TfrmFiltreModificationHistogrammePoints, frmFiltreModificationHistogrammePoints);
  Application.CreateForm(TfrmFiltrePixelisation, frmFiltrePixelisation);
  Application.Run;
end.
