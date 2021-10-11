unit untPixelisation;

interface

uses
  StdCtrls, Controls, ExtCtrls, Classes,
  untHFiltreImage, untCalcImage;

type
  TModeCouleur = (mcCentre, mcMoyenne, mcMediane, mcMinMax);

type
  TfrmFiltrePixelisation = class(TfrmHFiltreImage)
    grbParametres: TGroupBox;
    lblTaillePixel: TLabel;
    edtTaillePixels: TEdit;
    rdgModeCouleur: TRadioGroup;
    procedure btnOKClick(Sender: TObject);
    procedure edtTaillePixelsChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure rdgModeCouleurClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    TaillePixel : Integer;
    ModeCouleur : TModeCouleur;

    procedure PrevisualiseResultat; override;
  end;

procedure CalculerOperation(Image : TCalcImage; TaillePixel : Integer; ModeCouleur : TModeCouleur; var ImageResultat : TCalcImage);

var
  frmFiltrePixelisation: TfrmFiltrePixelisation;

implementation

uses
  SysUtils,
  untMDIImage, untPrincipale;

{$R *.DFM}

procedure TfrmFiltrePixelisation.PrevisualiseResultat;
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
    CalculerOperation(CalcImagePrev, TaillePixel, ModeCouleur, CalcImagePrevisualisation);  // Calcul l'image résultat de la prévisualisation

    AffichePrevisualisation;  // Affiche la prévisualisation
  end;
end;

procedure CalculerOperation(Image : TCalcImage; TaillePixel : Integer; ModeCouleur : TModeCouleur; var ImageResultat : TCalcImage);
var
  X, Y : Integer;
begin
  frmPrincipale.ChangeStatus('Calcul');
  frmPrincipale.ProgressBar.Max := Image.TailleX - 1;
  for X := 0 to Image.TailleX - 1 do  // Parcourt tous les pixels
  begin
    frmPrincipale.ProgressBar.Position := X;
    for Y := 0 to Image.TailleY - 1 do  // de l'image
      ImageResultat.Image[X, Y] := Image.Image[(X div TaillePixel) * TaillePixel, (Y div TaillePixel) * TaillePixel];  // Calcule la valeur des pixels de l'image
  end;
  frmPrincipale.FinCalcul;
end;


procedure TfrmFiltrePixelisation.btnOKClick(Sender: TObject);
begin
  inherited;
  TfrmMDIImage(ListeImages.Last).Caption := Format('Pixelisation(%s, %d)', [TfrmMDIImage(Image).Caption, TaillePixel]);  // Affiche le titre de l'image

  CalculerOperation(TfrmMDIImage(Image).CalcImage, TaillePixel, ModeCouleur, TfrmMDIImage(ListeImages.Last).CalcImage);  // Calcul le résultat

  TfrmMDIImage(ListeImages.Last).AfficheImage;  // Affiche le résultat
end;

procedure TfrmFiltrePixelisation.edtTaillePixelsChange(Sender: TObject);
begin
  edtTaillePixels.Text := FormateNombreEntier(edtTaillePixels.Text, False, TaillePixel);

  PrevisualiseResultat;
end;

procedure TfrmFiltrePixelisation.FormCreate(Sender: TObject);
begin
  inherited;
  
  TaillePixel := 5;
  ModeCouleur := mcCentre;
end;

procedure TfrmFiltrePixelisation.rdgModeCouleurClick(Sender: TObject);
begin
{  case rdgModeCouleur.ItemIndex of  // Suivant le mode coché
  0 : ModeCouleur := mcCentre;
  1 : ModeCouleur := mcMoyenne;
  2 : ModeCouleur := mcMediane;
  3 : ModeCouleur := mcMinMax;
  end;}
end;

end.
