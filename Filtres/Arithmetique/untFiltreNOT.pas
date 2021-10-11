unit untFiltreNOT;

interface

uses
  StdCtrls, Controls, ExtCtrls, Classes,
  untHFiltreImage, untCalcImage;

type
  TfrmFiltreNOT = class(TfrmHFiltreImage)
    procedure btnOKClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    procedure PrevisualiseResultat; override;
  end;

procedure CalculerOperation(Image : TCalcImage; var ImageResultat : TCalcImage);

var
  frmFiltreNOT: TfrmFiltreNOT;

implementation

uses
  SysUtils,
  untMDIImage, untPrincipale;

{$R *.DFM}

{ TfrmFiltreNOT }

procedure TfrmFiltreNOT.PrevisualiseResultat;
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
    CalculerOperation(CalcImagePrev, CalcImagePrevisualisation);  // Calcul l'image résultat de la prévisualisation

    AffichePrevisualisation;  // Affiche la prévisualisation
  end;
end;

procedure CalculerOperation(Image : TCalcImage; var ImageResultat : TCalcImage);
var
  X, Y : Integer;
begin
  frmPrincipale.ChangeStatus('Calcul');
  frmPrincipale.ProgressBar.Max := Image.TailleX - 1;
  for X := 0 to Image.TailleX - 1 do  // Parcourt tous les pixels
  begin
    frmPrincipale.ProgressBar.Position := X;
    for Y := 0 to Image.TailleY - 1 do  // de l'image
    begin
      ImageResultat.Image[X, Y].Rouge := not LimiteCouleur(Image.Image[X, Y].Rouge);  // Applique l'opérateur NOT
      ImageResultat.Image[X, Y].Vert := not LimiteCouleur(Image.Image[X, Y].Vert);  // à tous les pixels
      ImageResultat.Image[X, Y].Bleu := not LimiteCouleur(Image.Image[X, Y].Bleu);  // de l'image
    end;
  end;
  frmPrincipale.FinCalcul;
end;

procedure TfrmFiltreNOT.btnOKClick(Sender: TObject);
begin
  inherited;
  TfrmMDIImage(ListeImages.Last).Caption := Format('NOT %s', [TfrmMDIImage(Image).Caption]);  // Affiche le titre de l'image

  CalculerOperation(TfrmMDIImage(Image).CalcImage, TfrmMDIImage(ListeImages.Last).CalcImage);  // Calcul le résultat

  TfrmMDIImage(ListeImages.Last).AfficheImage;  // Affiche le résultat
end;

end.
