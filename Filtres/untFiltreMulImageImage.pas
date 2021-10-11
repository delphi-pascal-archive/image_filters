unit untFiltreMulImageImage;

interface

uses
  StdCtrls, Controls, ExtCtrls, Classes,
  untHFiltreImageImage, untCalcImage;

type
  TfrmFiltreMulImageImage = class(TfrmHFiltreImageImage)
    procedure btnOKClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    procedure PrevisualiseResultat; override;
  end;

procedure CalculerOperation(Image1, Image2 : TCalcImage; var ImageResultat : TCalcImage);

var
  frmFiltreMulImageImage: TfrmFiltreMulImageImage;

implementation

uses
  SysUtils,
  untMDIImage, untPrincipale;

{$R *.DFM}

{ TfrmFiltreMulImageImage }

procedure TfrmFiltreMulImageImage.PrevisualiseResultat;
var
  X, Y : Integer;
  X2, Y2 : Integer;
begin
  if EnabledOK then  // Si les images sont "compatibles"
  begin
    for X := 0 to CalcImagePrevisualisation.TailleX - 1 do
    begin
      X2 := X * (TfrmMDIImage(Image1).CalcImage.TailleX - 1) div (CalcImagePrevisualisation.TailleX - 1);  // Calcul le pixel correspondant sur les images d'origines
      for Y := 0 to CalcImagePrevisualisation.TailleY - 1 do
      begin
        Y2 := Y * (TfrmMDIImage(Image1).CalcImage.TailleY - 1) div (CalcImagePrevisualisation.TailleY - 1);  // Calcul le pixel correspondant sur les images d'origines
        CalcImagePrev1.Image[X, Y] := TfrmMDIImage(Image1).CalcImage.Image[X2, Y2];  // Copie les pixels des images
        CalcImagePrev2.Image[X, Y] := TfrmMDIImage(Image2).CalcImage.Image[X2, Y2];  // d'origine sur les images de prévisualisation
      end;
    end;
    CalculerOperation(CalcImagePrev1, CalcImagePrev2, CalcImagePrevisualisation);  // Calcul l'image résultat de la prévisualisation

    AffichePrevisualisation;  // Affiche la prévisualisation
  end;end;

procedure CalculerOperation(Image1, Image2: TCalcImage; var ImageResultat: TCalcImage);
var
  X, Y : Integer;
begin
  frmPrincipale.ChangeStatus('Calcul');
  frmPrincipale.ProgressBar.Max := Image1.TailleX - 1;
  for X := 0 to Image1.TailleX - 1 do  // Parcourt tous les pixels
  begin
    frmPrincipale.ProgressBar.Position := X;
    for Y := 0 to Image1.TailleY - 1 do  // de l'image
    begin
      ImageResultat.Image[X, Y].Rouge := Image1.Image[X, Y].Rouge * Image2.Image[X, Y].Rouge;  // Multiplie
      ImageResultat.Image[X, Y].Vert := Image1.Image[X, Y].Vert * Image2.Image[X, Y].Vert;  // les pixels de l'image 1
      ImageResultat.Image[X, Y].Bleu := Image1.Image[X, Y].Bleu * Image2.Image[X, Y].Bleu;  // et les pixels de l'image 2
    end;
  end;
  frmPrincipale.FinCalcul;
end;

procedure TfrmFiltreMulImageImage.btnOKClick(Sender: TObject);
begin
  inherited;
  TfrmMDIImage(ListeImages.Last).Caption := Format('(%s) * (%s)', [TfrmMDIImage(Image1).Caption, TfrmMDIImage(Image2).Caption]);  // Affiche le titre de l'image

  CalculerOperation(TfrmMDIImage(Image1).CalcImage, TfrmMDIImage(Image2).CalcImage, TfrmMDIImage(ListeImages.Last).CalcImage);  // Calcul le résultat

  TfrmMDIImage(ListeImages.Last).AfficheImage;  // Affiche le résultat
end;

end.
