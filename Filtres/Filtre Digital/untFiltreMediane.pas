unit untFiltreMediane;

interface

uses
  StdCtrls, Controls, ExtCtrls, Classes,
  untHFiltreFiltreDigital, untCalcImage;

type
  TfrmFiltreMediane = class(TfrmHFiltreFiltreDigital)
    procedure btnOKClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    procedure PrevisualiseResultat; override;
  end;

procedure CalculerOperation(Image : TCalcImage; TailleFiltre : Integer; var ImageResultat : TCalcImage);

var
  frmFiltreMediane: TfrmFiltreMediane;

implementation

uses
  Math, SysUtils,
  untMDIImage, untPrincipale;

{$R *.DFM}

{ TfrmHFiltreFiltreDigital3 }

procedure TfrmFiltreMediane.PrevisualiseResultat;
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
    CalculerOperation(CalcImagePrev, TailleFiltre, CalcImagePrevisualisation);  // Calcul l'image résultat de la prévisualisation

    AffichePrevisualisation;  // Affiche la prévisualisation
  end;
end;

procedure CalculerOperation(Image : TCalcImage; TailleFiltre : Integer; var ImageResultat : TCalcImage);

  procedure Swap(var X, Y : Double);
  var
    Index : Double;
  begin
    Index := X;
    X := Y;
    Y := Index;
  end;


var
  X, Y : Integer;
  X2, Y2 : Integer;
  Couleur : array of TCouleur;
  Couleur2 : array of TCouleur;
  NombrePixels : Integer;
  NumPixel : Integer;
  NumPixel2 : Integer;
begin
  TailleFiltre := TailleFiltre div 2;

  SetLength(Couleur, (TailleFiltre * 2 + 1) * (TailleFiltre * 2 + 1));
  SetLength(Couleur2, (TailleFiltre * 2 + 1) * (TailleFiltre * 2 + 1));

  frmPrincipale.ChangeStatus('Calcul');
  frmPrincipale.ProgressBar.Max := Image.TailleX - 1;
  for X := 0 to Image.TailleX - 1 do  // Parcourt tous les pixels
  begin
    frmPrincipale.ProgressBar.Position := X;
    for Y := 0 to Image.TailleY - 1 do  // de l'image
    begin
      NombrePixels := 0;

      for X2 := -TailleFiltre to TailleFiltre do
        if (X + X2 >= 0) and (X + X2 < Image.TailleX) then  // Teste si la colonne X + X2 est sur l'image
          for Y2 := -TailleFiltre to TailleFiltre do
            if (Y + Y2 >= 0) and (Y + Y2 < Image.TailleY) then  // Teste si la ligne Y + Y2 est sur l'image
            begin
              Couleur[NombrePixels].Rouge := Image.Image[X + X2, Y + Y2].Rouge;  // Inscription de valeur
              Couleur[NombrePixels].Vert := Image.Image[X + X2, Y + Y2].Vert;  // de pixels
              Couleur[NombrePixels].Bleu := Image.Image[X + X2, Y + Y2].Bleu;  // dans le tableau
              Inc(NombrePixels);  // Augmente de 1 le nombre de pixels additionnés
            end;

      for NumPixel := 0 to NombrePixels - 2 do  // Tri les couleurs par ordre croissant
        for NumPixel2 := NumPixel + 1 to NombrePixels - 1 do
        begin
          if Couleur[NumPixel2].Rouge < Couleur[NumPixel].Rouge then
            Swap(Couleur[NumPixel].Rouge, Couleur[NumPixel2].Rouge);
          if Couleur[NumPixel2].Vert < Couleur[NumPixel].Vert then
            Swap(Couleur[NumPixel].Vert, Couleur[NumPixel2].Vert);
          if Couleur[NumPixel2].Bleu < Couleur[NumPixel].Bleu then
            Swap(Couleur[NumPixel].Bleu, Couleur[NumPixel2].Bleu);
        end;

      if Odd(NombrePixels) then
      begin
        ImageResultat.Image[X, Y].Rouge := Couleur[NombrePixels div 2].Rouge;  // Calcul la
        ImageResultat.Image[X, Y].Vert := Couleur[NombrePixels div 2].Vert;  // couleur
        ImageResultat.Image[X, Y].Bleu := Couleur[NombrePixels div 2].Bleu;  // du pixel
      end
      else
      begin
        ImageResultat.Image[X, Y].Rouge := (Couleur[NombrePixels div 2].Rouge + Couleur[NombrePixels div 2 + 1].Rouge) / 2;  // Calcul la
        ImageResultat.Image[X, Y].Vert := (Couleur[NombrePixels div 2].Vert + Couleur[NombrePixels div 2 + 1].Vert) / 2;  // couleur
        ImageResultat.Image[X, Y].Bleu := (Couleur[NombrePixels div 2].Bleu + Couleur[NombrePixels div 2 + 1].Bleu) / 2;  // du pixel
      end;
    end;
  end;
  frmPrincipale.FinCalcul;
end;

procedure TfrmFiltreMediane.btnOKClick(Sender: TObject);
begin
  inherited;
  TfrmMDIImage(ListeImages.Last).Caption := Format('Médiane(%s, %d)', [TfrmMDIImage(Image).Caption, TailleFiltre]);  // Affiche le titre de l'image

  CalculerOperation(TfrmMDIImage(Image).CalcImage, TailleFiltre, TfrmMDIImage(ListeImages.Last).CalcImage);  // Calcul le résultat

  TfrmMDIImage(ListeImages.Last).AfficheImage;  // Affiche le résultat
end;

end.
