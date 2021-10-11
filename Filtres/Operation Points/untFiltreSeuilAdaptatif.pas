unit untFiltreSeuilAdaptatif;

interface

uses
  StdCtrls, Controls, ExtCtrls, Classes,
  untHFiltreImage, untCalcImage, Dialogs, untHFiltreFiltreDigital;

type
  TTypeFiltreSeuilAdaptatif = (tfMoyenne, tfMinMax, tfGaussien);

type
  TfrmFiltreSeuilAdaptatif = class(TfrmHFiltreFiltreDigital)
    rdgTypeFiltre: TRadioGroup;
    edtDeviation: TEdit;
    lblDeviation: TLabel;
    grbCouleurMinimale: TGroupBox;
    ShapeCouleur: TShape;
    lblRouge: TLabel;
    lblVert: TLabel;
    lblBleu: TLabel;
    lblCouleur: TLabel;
    btnSelectionCouleur: TButton;
    edtRouge: TEdit;
    edtVert: TEdit;
    edtBleu: TEdit;
    ColorDialog: TColorDialog;
    procedure rdgTypeFiltreClick(Sender: TObject);
    procedure btnSelectionCouleurClick(Sender: TObject);
    procedure edtRougeChange(Sender: TObject);
    procedure edtVertChange(Sender: TObject);
    procedure edtBleuChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure edtDeviationChange(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    Couleur : TCouleur;
    Deviation : Double;
    TypeFiltre : TTypeFiltreSeuilAdaptatif;

    procedure PrevisualiseResultat; override;
    procedure RafraichirCouleur;
  end;

procedure CalculerOperation(Image : TCalcImage; CouleurMin : TCouleur; TailleFiltre : Integer; Deviation : Double; TypeFiltre : TTypeFiltreSeuilAdaptatif; var ImageResultat : TCalcImage);

var
  frmFiltreSeuilAdaptatif: TfrmFiltreSeuilAdaptatif;

implementation

uses
  SysUtils, Forms, Math,
  untMDIImage, untPrincipale,
  untFiltreMoyenne, untFiltreMinMax, untFiltreGauss, untFiltreSubImageImage, untFiltreAbs, untFiltreSeuil;

{$R *.DFM}

{ TfrmFiltreSeuilAdaptatif }

procedure TfrmFiltreSeuilAdaptatif.PrevisualiseResultat;
var
  X, Y : Integer;
  X2, Y2 : Integer;
begin
  if EnabledOK then  // Si l'image est "compatible"
  begin
    for X := 0 to CalcImagePrevisualisation.TailleX - 1 do
    begin
      X2 := X * (TfrmMDIImage(Image).CalcImage.TailleX - 1) div (CalcImagePrevisualisation.TailleX - 1);  // Calcul le pixel correspondant sur les images d'origines
      for Y := 0 to CalcImagePrevisualisation.TailleY - 1 do
      begin
        Y2 := Y * (TfrmMDIImage(Image).CalcImage.TailleY - 1) div (CalcImagePrevisualisation.TailleY - 1);  // Calcul le pixel correspondant sur les images d'origines
        CalcImagePrev.Image[X, Y] := TfrmMDIImage(Image).CalcImage.Image[X2, Y2];  // Copie les pixels des images d'origine sur les images de prévisualisation
      end;
    end;
    CalculerOperation(CalcImagePrev, Couleur, TailleFiltre, Deviation, TypeFiltre, CalcImagePrevisualisation);  // Calcul l'image résultat de la prévisualisation

    AffichePrevisualisation;  // Affiche la prévisualisation
  end;
end;

procedure TfrmFiltreSeuilAdaptatif.RafraichirCouleur;
begin
  ShapeCouleur.Brush.Color := CouleurToColor(Couleur);
  ColorDialog.Color := CouleurToColor(Couleur);
  PrevisualiseResultat;
end;

procedure TfrmFiltreSeuilAdaptatif.rdgTypeFiltreClick(Sender: TObject);
begin
  case rdgTypeFiltre.ItemIndex of  // Selon le type de filtre selectionné
  0 : TypeFiltre := tfMoyenne;
  1 : TypeFiltre := tfMinMax;
  2 : TypeFiltre := tfGaussien;
  end;

  lblDeviation.Visible := rdgTypeFiltre.ItemIndex = 2;  // Affiche le paramètre déviation
  edtDeviation.Visible := rdgTypeFiltre.ItemIndex = 2;  // si le filtre Gaussien est sélectionné

  PrevisualiseResultat;
end;

procedure TfrmFiltreSeuilAdaptatif.btnSelectionCouleurClick(
  Sender: TObject);
begin
  if ColorDialog.Execute then
  begin
    Couleur.Rouge := ColorDialog.Color and $000000FF;  // Calcul les différents
    Couleur.Vert := (ColorDialog.Color and $0000FF00) shr 8;  // composants de la
    Couleur.Bleu := (ColorDialog.Color and $00FF0000) shr 16;  // couleur choisie
    edtRouge.Text := FloatToStr(Couleur.Rouge);
    edtVert.Text := FloatToStr(Couleur.Vert);
    edtBleu.Text := FloatToStr(Couleur.Bleu);
    RafraichirCouleur;
  end;
end;

procedure TfrmFiltreSeuilAdaptatif.edtRougeChange(Sender: TObject);
begin
  edtRouge.Text := FormateNombreDecimal(edtRouge.Text, False, Couleur.Rouge);
  Application.ProcessMessages;
  RafraichirCouleur;
end;

procedure TfrmFiltreSeuilAdaptatif.edtVertChange(Sender: TObject);
begin
  edtVert.Text := FormateNombreDecimal(edtVert.Text, False, Couleur.Vert);
  Application.ProcessMessages;
  RafraichirCouleur;
end;

procedure TfrmFiltreSeuilAdaptatif.edtBleuChange(Sender: TObject);
begin
  edtBleu.Text := FormateNombreDecimal(edtBleu.Text, False, Couleur.Bleu);
  Application.ProcessMessages;
  RafraichirCouleur;
end;

procedure TfrmFiltreSeuilAdaptatif.FormCreate(Sender: TObject);
begin
  inherited;

  Couleur.Rouge := 50;
  Couleur.Vert := 50;
  Couleur.Bleu := 50;

  TypeFiltre := tfMoyenne;
  Deviation := 2;
end;


procedure CalculerOperation(Image : TCalcImage; CouleurMin : TCouleur; TailleFiltre : Integer; Deviation : Double; TypeFiltre : TTypeFiltreSeuilAdaptatif; var ImageResultat : TCalcImage);
var
  CouleurS : TCouleur;
begin
  case TypeFiltre of  // Selon le type de filtre voulu
  tfMoyenne : untFiltreMoyenne.CalculerPrevisualisation(Image, TailleFiltre, ImageResultat);  // Applique le flou Moyenne à l'image
  tfMinMax : untFiltreMinMax.CalculerPrevisualisation(Image, TailleFiltre, ImageResultat);  // Applique le flou Min/Max à l'image
  tfGaussien : untFiltreGauss.CalculerPrevisualisation(Image, TailleFiltre, Deviation, ImageResultat);  // Applique le flou Gaussien à l'image
  end;
  untFiltreSubImageImage.CalculerOperation(Image, ImageResultat, ImageResultat);  // Soustrait les deux images

  untFiltreAbs.CalculerOperation(ImageResultat, ImageResultat);  // Calcul la valeur absolue du résultat

  CouleurS.Rouge := MaxDouble;
  CouleurS.Vert := MaxDouble;
  CouleurS.Bleu := MaxDouble;
  untFiltreSeuil.CalculerOperation(ImageResultat, CouleurMin, CouleurS, ImageResultat);  // Affiche les contours
end;

procedure TfrmFiltreSeuilAdaptatif.btnOKClick(Sender: TObject);
begin
  inherited;
  case TypeFiltre of  // Selon le type de filtre voulu
  tfMoyenne : TfrmMDIImage(ListeImages.Last).Caption := Format('SeuilAdaptatifMoyenne(%s, %d, RGB(%g, %g, %g))', [TfrmMDIImage(Image).Caption, TailleFiltre, Couleur.Rouge, Couleur.Vert, Couleur.Bleu]);  // Affiche le titre de l'image
  tfMinMax : TfrmMDIImage(ListeImages.Last).Caption := Format('SeuilAdaptatifMinMax(%s, %d, RGB(%g, %g, %g))', [TfrmMDIImage(Image).Caption, TailleFiltre, Couleur.Rouge, Couleur.Vert, Couleur.Bleu]);  // Affiche le titre de l'image
  tfGaussien : TfrmMDIImage(ListeImages.Last).Caption := Format('SeuilAdaptatifGauss(%s, %d, %g, RGB(%g, %g, %g))', [TfrmMDIImage(Image).Caption, TailleFiltre, Deviation, Couleur.Rouge, Couleur.Vert, Couleur.Bleu]);  // Affiche le titre de l'image
  end;

  CalculerOperation(TfrmMDIImage(Image).CalcImage, Couleur, TailleFiltre, Deviation, TypeFiltre, TfrmMDIImage(ListeImages.Last).CalcImage);  // Calcul le résultat

  TfrmMDIImage(ListeImages.Last).AfficheImage;  // Affiche le résultat
end;

procedure TfrmFiltreSeuilAdaptatif.edtDeviationChange(Sender: TObject);
begin
  edtDeviation.Text := FormateNombreDecimal(edtDeviation.Text, False, Deviation);
  Application.ProcessMessages;
  PrevisualiseResultat;
end;

end.
