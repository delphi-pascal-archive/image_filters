unit untFiltreAddImageConstante;

interface

uses
  StdCtrls, Controls, ExtCtrls, Classes,
  untHFiltreImageConstante, untCalcImage, Dialogs;

type
  TfrmFiltreAddImageConstante = class(TfrmHFiltreImageConstante)
    procedure btnOKClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    procedure PrevisualiseResultat; override;
  end;

procedure CalculerOperation(Image : TCalcImage; Couleur : TCouleur; var ImageResultat : TCalcImage);

var
  frmFiltreAddImageConstante: TfrmFiltreAddImageConstante;

implementation

uses
  SysUtils,
  untMDIImage, untPrincipale;

{$R *.DFM}

{ TfrmFiltreAddImageConstante }

procedure TfrmFiltreAddImageConstante.PrevisualiseResultat;
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
    CalculerOperation(CalcImagePrev, Couleur, CalcImagePrevisualisation);  // Calcul l'image résultat de la prévisualisation

    AffichePrevisualisation;  // Affiche la prévisualisation
  end;
end;

procedure CalculerOperation(Image : TCalcImage; Couleur : TCouleur; var ImageResultat : TCalcImage);
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
      ImageResultat.Image[X, Y].Rouge := Image.Image[X, Y].Rouge + Couleur.Rouge;  // Additionne
      ImageResultat.Image[X, Y].Vert := Image.Image[X, Y].Vert + Couleur.Vert;  // les pixels de l'image
      ImageResultat.Image[X, Y].Bleu := Image.Image[X, Y].Bleu + Couleur.Bleu;  // et la couleur
    end;
  end;
  frmPrincipale.FinCalcul;
end;

procedure TfrmFiltreAddImageConstante.btnOKClick(Sender: TObject);
begin
  inherited;
  TfrmMDIImage(ListeImages.Last).Caption := Format('(%s) + RGB(%g, %g, %g)', [TfrmMDIImage(Image).Caption, Couleur.Rouge, Couleur.Vert, Couleur.Bleu]);  // Affiche le titre de l'image

  CalculerOperation(TfrmMDIImage(Image).CalcImage, Couleur, TfrmMDIImage(ListeImages.Last).CalcImage);  // Calcul le résultat

  TfrmMDIImage(ListeImages.Last).AfficheImage;  // Affiche le résultat
end;

end.
