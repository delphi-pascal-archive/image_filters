unit untPrincipale;

interface

uses
  Forms, Dialogs, StdActns, ActnList, Menus, ExtDlgs, Classes, contnrs, ComCtrls, Controls,
  untCalcImage;

type
  TfrmPrincipale = class(TForm)
    OpenPictureDialog: TOpenPictureDialog;
    MainMenu: TMainMenu;
    mnuFichier: TMenuItem;
    mnuOuvrirImage: TMenuItem;
    mnuFermer: TMenuItem;
    mnuEnregistrer: TMenuItem;
    mnuBarre1: TMenuItem;
    mnuQuitter: TMenuItem;
    mnuiFiltres: TMenuItem;
    mnuArithmetique: TMenuItem;
    mnuAddition: TMenuItem;
    mnuAdditionII: TMenuItem;
    mnuAdditionIC: TMenuItem;
    mnuSoustraction: TMenuItem;
    mnuSoustractionII: TMenuItem;
    mnuSoustractionIC: TMenuItem;
    mnuMultiplication: TMenuItem;
    mnuMultiplicationII: TMenuItem;
    mnuMultiplicationIC: TMenuItem;
    mnuDivision: TMenuItem;
    mnuDivisionII: TMenuItem;
    mnuDivisionIC: TMenuItem;
    mnuFusion: TMenuItem;
    mnuAND: TMenuItem;
    mnuANDII: TMenuItem;
    mnuANDIC: TMenuItem;
    mnuOR: TMenuItem;
    mnuORII: TMenuItem;
    mnuORIC: TMenuItem;
    mnuXOR: TMenuItem;
    mnuXORII: TMenuItem;
    mnuXORIC: TMenuItem;
    mnuNOT: TMenuItem;
    mnuNiveauGris: TMenuItem;
    mnuOperationsPoint: TMenuItem;
    mnuSeuil: TMenuItem;
    mnuSeuilAdaptatif: TMenuItem;
    mnuChangementContraste: TMenuItem;
    mnuEgalisationHistogramme: TMenuItem;
    mnuEgalisationHistorammePoints: TMenuItem;
    mnuEgalisationHistogrammeFonction: TMenuItem;
    mnuAnalyseImage: TMenuItem;
    mnuHistogramme: TMenuItem;
    mnuFiltreDigital: TMenuItem;
    mnuMediane: TMenuItem;
    mnuMoyenne: TMenuItem;
    mnuMinimumMaximum: TMenuItem;
    mnuGaussien: TMenuItem;
    mnuFenetre: TMenuItem;
    mnuCascade: TMenuItem;
    mnuMosaiqueHorizontale: TMenuItem;
    mnuMosaiqueVerticale: TMenuItem;
    mnuToutReduire: TMenuItem;
    ActionList: TActionList;
    actOuvrirImage: TAction;
    actFermer: TWindowClose;
    actQuitter: TAction;
    actMosaiqueHorizontale: TWindowTileHorizontal;
    actMosaiqueVerticale: TWindowTileVertical;
    actCascade: TWindowCascade;
    actToutReduire: TWindowMinimizeAll;
    actEnregistrerImageSous: TAction;
    SaveDialog: TSaveDialog;
    mnuValeurAbsolue: TMenuItem;
    StatusBar: TStatusBar;
    ProgressBar: TProgressBar;
    mnuPixelisation: TMenuItem;
    procedure mnuQuitterClick(Sender: TObject);
    procedure actOuvrirImageExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure actEnregistrerImageSousExecute(Sender: TObject);
    procedure actEnregistrerImageSousUpdate(Sender: TObject);
    procedure mnuAdditionIIClick(Sender: TObject);
    procedure mnuSoustractionIIClick(Sender: TObject);
    procedure mnuMultiplicationIIClick(Sender: TObject);
    procedure mnuDivisionIIClick(Sender: TObject);
    procedure mnuANDIIClick(Sender: TObject);
    procedure mnuORIIClick(Sender: TObject);
    procedure mnuXORIIClick(Sender: TObject);
    procedure mnuAdditionICClick(Sender: TObject);
    procedure mnuSoustractionICClick(Sender: TObject);
    procedure mnuMultiplicationICClick(Sender: TObject);
    procedure mnuDivisionICClick(Sender: TObject);
    procedure mnuANDICClick(Sender: TObject);
    procedure mnuORICClick(Sender: TObject);
    procedure mnuXORICClick(Sender: TObject);
    procedure mnuFusionClick(Sender: TObject);
    procedure mnuNOTClick(Sender: TObject);
    procedure mnuValeurAbsolueClick(Sender: TObject);
    procedure mnuNiveauGrisClick(Sender: TObject);
    procedure mnuMoyenneClick(Sender: TObject);
    procedure mnuMinimumMaximumClick(Sender: TObject);
    procedure mnuGaussienClick(Sender: TObject);
    procedure mnuSeuilClick(Sender: TObject);
    procedure mnuSeuilAdaptatifClick(Sender: TObject);
    procedure mnuHistogrammeClick(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure mnuMedianeClick(Sender: TObject);
    procedure mnuEgalisationHistorammePointsClick(Sender: TObject);
    procedure mnuPixelisationClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    procedure ChangeCoordonneesCurseur(X, Y : Integer);
    procedure ChangeStatus(Status : string);
    procedure FinCalcul;
  end;

function FormateNombreDecimal(Texte : string; NegatifAutorise : Boolean; var Valeur : Double) : string;
function FormateNombreEntier(Texte : string; NegatifAutorise : Boolean; var Valeur : Integer) : string;

var
  frmPrincipale: TfrmPrincipale;
  ListeImages : TObjectList;
  Copie : TCalcImage;

implementation

uses
  SysUtils,
  untMDIImage,
  untFiltreAddImageImage, untFiltreSubImageImage, untFiltreMulImageImage, untFiltreDivImageImage, untFiltreANDImageImage, untFiltreORImageImage, untFiltreXORImageImage,
  untFiltreAddImageConstante, untFiltreSubImageConstante,
  untFiltreORImageConstante, untFiltreXORImageConstante,
  untFiltreMulImageConstante, untFiltreDivImageConstante,
  untFiltreANDImageConstante, untFiltreFondu, untFiltreNOT, untFiltreAbs,
  untFiltreNiveauxGris, untFiltreMoyenne, untFiltreMinMax, untFiltreGauss,
  untFiltreMediane, untFiltreSeuil, untFiltreSeuilAdaptatif, untHistogramme,
  untFiltreModificationHistogrammePoints, untPixelisation;

{$R *.DFM}


function FormateNombreDecimal(Texte : string; NegatifAutorise : Boolean; var Valeur : Double) : string;
var
  NumLettre : Integer;
  TexteFormate : string;
  PointPresent : Boolean;
begin
  PointPresent := False;  // Indique que aucun point n'a été vu

  TexteFormate := '';

  if (Texte[1] = '-') and NegatifAutorise then  // Si il y a un signe négatif en première position du Texte et que le signe négatif est autorisé
    TexteFormate := '-';

  for NumLettre := 1 to Length(Texte) do
  begin
    if (Texte[NumLettre] = '.') and not PointPresent then  // Si il y a un point et si il n'y a pas encore de point dans la chaîne
    begin
      if TexteFormate = '' then
        TexteFormate := '0.'
      else
        TexteFormate := TexteFormate + '.';
      PointPresent := True;  // Inique que un point à été trouvé dans le chaîne
    end;
    if (Texte[NumLettre] in ['0'..'9']) then  // Si il y a un chiffre
      TexteFormate := TexteFormate + Texte[NumLettre];  // On ajoute le chiffre
  end;

  if (TexteFormate = '') or (TexteFormate = '-') then
    Valeur := 0
  else
    Valeur := StrToFloat(TexteFormate);

  Result := TexteFormate;
end;

function FormateNombreEntier(Texte : string; NegatifAutorise : Boolean; var Valeur : Integer) : string;
var
  NumLettre : Integer;
  TexteFormate : string;
begin
  TexteFormate := '';

  if (Texte[1] = '-') and NegatifAutorise then  // Si il y a un signe négatif en première position du Texte et que le signe négatif est autorisé
    TexteFormate := '-';

  for NumLettre := 1 to Length(Texte) do
    if (Texte[NumLettre] in ['0'..'9']) then  // Si il y a un chiffre
      TexteFormate := TexteFormate + Texte[NumLettre];  // On ajoute le chiffre

  if (TexteFormate = '') or (TexteFormate = '-') then
    Valeur := 0
  else
    Valeur := StrToInt(TexteFormate);

  Result := TexteFormate;
end;

procedure TfrmPrincipale.mnuQuitterClick(Sender: TObject);
begin
  Close;  // Ferme l'Application
end;

procedure TfrmPrincipale.actOuvrirImageExecute(Sender: TObject);
var
  NumFichier : Integer;
begin
  if OpenPictureDialog.Execute then  // Si on Ouvre un fichier dans le OpenPictureDialog
    for NumFichier := 0 to OpenPictureDialog.Files.Count - 1 do  // Parcourt tous les fichiers selectionnés
    begin
      ListeImages.Add(TfrmMDIImage.Create(nil));  // Ajoute une nouvelle Form MDI dans la liste
      TfrmMDIImage(ListeImages.Last).OuvrirImage(OpenPictureDialog.Files[NumFichier]);  // Ouvre l'image dans le dernier Items de la liste
      TfrmMDIImage(ListeImages.Last).Caption := ExtractFileName(OpenPictureDialog.Files[NumFichier]);  // Change le titre de la fiche
    end;
end;

procedure TfrmPrincipale.FormCreate(Sender: TObject);
begin
  Copie := TCalcImage.Create;  // Crée le tableau de données de la copie
  ProgressBar.Parent := StatusBar;  // Insère la barre de progression dans le StatusBar
  ListeImages := TObjectList.Create;  // Crée de la Liste d'images
  ChangeStatus('Prêt');
end;

procedure TfrmPrincipale.actEnregistrerImageSousExecute(Sender: TObject);
begin
  if SaveDialog.Execute then
    TfrmMDIImage(MDIChildren[0]).EnregistrerImage(SaveDialog.FileName);  // Enregistre l'image de la première Form : la Form active
end;

procedure TfrmPrincipale.actEnregistrerImageSousUpdate(Sender: TObject);
begin
  if MDIChildCount = 0 then  // Si il n'y a pas d'image d'ouverte
    actEnregistrerImageSous.Enabled := False  // Désactive les menus d'enregistrement de l'image
  else
    actEnregistrerImageSous.Enabled := True;  // Active les menus d'enregistrement de l'image
end;

procedure TfrmPrincipale.mnuAdditionIIClick(Sender: TObject);
begin
  frmFiltreAddImageImage.ShowModal;
end;

procedure TfrmPrincipale.mnuSoustractionIIClick(Sender: TObject);
begin
  frmFiltreSubImageImage.ShowModal;
end;

procedure TfrmPrincipale.mnuMultiplicationIIClick(Sender: TObject);
begin
  frmFiltreMulImageImage.ShowModal;
end;

procedure TfrmPrincipale.mnuDivisionIIClick(Sender: TObject);
begin
  frmFiltreDivImageImage.ShowModal;
end;

procedure TfrmPrincipale.mnuANDIIClick(Sender: TObject);
begin
  frmFiltreANDImageImage.ShowModal;
end;

procedure TfrmPrincipale.mnuORIIClick(Sender: TObject);
begin
  frmFiltreORImageImage.ShowModal;
end;

procedure TfrmPrincipale.mnuXORIIClick(Sender: TObject);
begin
  frmFiltreXORImageImage.ShowModal;
end;

procedure TfrmPrincipale.mnuAdditionICClick(Sender: TObject);
begin
  frmFiltreAddImageConstante.ShowModal;
end;

procedure TfrmPrincipale.mnuSoustractionICClick(Sender: TObject);
begin
  frmFiltreSubImageConstante.ShowModal;
end;

procedure TfrmPrincipale.mnuMultiplicationICClick(Sender: TObject);
begin
  frmFiltreMulImageConstante.ShowModal;
end;

procedure TfrmPrincipale.mnuDivisionICClick(Sender: TObject);
begin
  frmFiltreDivImageConstante.ShowModal;
end;

procedure TfrmPrincipale.mnuANDICClick(Sender: TObject);
begin
  frmFiltreANDImageConstante.ShowModal;
end;

procedure TfrmPrincipale.mnuORICClick(Sender: TObject);
begin
  frmFiltreORImageConstante.ShowModal;
end;

procedure TfrmPrincipale.mnuXORICClick(Sender: TObject);
begin
  frmFiltreXORImageConstante.ShowModal;
end;

procedure TfrmPrincipale.mnuFusionClick(Sender: TObject);
begin
  frmFiltreFondu.ShowModal;
end;

procedure TfrmPrincipale.mnuNOTClick(Sender: TObject);
begin
  frmFiltreNOT.ShowModal;
end;

procedure TfrmPrincipale.mnuValeurAbsolueClick(Sender: TObject);
begin
  frmFiltreAbs.ShowModal;
end;

procedure TfrmPrincipale.mnuNiveauGrisClick(Sender: TObject);
begin
  frmFiltreNiveauxGris.ShowModal;
end;

procedure TfrmPrincipale.mnuMoyenneClick(Sender: TObject);
begin
  frmFiltreMoyenne.ShowModal;
end;

procedure TfrmPrincipale.mnuMinimumMaximumClick(Sender: TObject);
begin
  frmFiltreMinMax.ShowModal;
end;

procedure TfrmPrincipale.mnuGaussienClick(Sender: TObject);
begin
  frmFiltreGauss.ShowModal;
end;

procedure TfrmPrincipale.mnuSeuilClick(Sender: TObject);
begin
  frmFiltreSeuil.ShowModal;
end;

procedure TfrmPrincipale.mnuSeuilAdaptatifClick(Sender: TObject);
begin
  frmFiltreSeuilAdaptatif.ShowModal;
end;

procedure TfrmPrincipale.mnuHistogrammeClick(Sender: TObject);
begin
  frmHistogramme.ShowModal;
end;

procedure TfrmPrincipale.ChangeCoordonneesCurseur(X, Y: Integer);
begin
  if (X = -1) or (Y = -1) then
    StatusBar.Panels[1].Text := '(-, -)'
  else
    StatusBar.Panels[1].Text := Format('(%d, %d)', [X, Y]);
end;

procedure TfrmPrincipale.FormMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  ChangeCoordonneesCurseur(-1, -1);
end;

procedure TfrmPrincipale.ChangeStatus(Status: string);
begin
  StatusBar.Panels[2].Text := Status;
  StatusBar.Refresh;
end;

procedure TfrmPrincipale.FinCalcul;
begin
  ChangeStatus('Prêt');
  ProgressBar.Position := 0;
end;

procedure TfrmPrincipale.mnuMedianeClick(Sender: TObject);
begin
  frmFiltreMediane.ShowModal;
end;

procedure TfrmPrincipale.mnuEgalisationHistorammePointsClick(
  Sender: TObject);
begin
  frmFiltreModificationHistogrammePoints.ShowModal;
end;

procedure TfrmPrincipale.mnuPixelisationClick(Sender: TObject);
begin
  frmFiltrePixelisation.ShowModal;
end;

end.
