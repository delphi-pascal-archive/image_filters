unit untFiltreMinMax;

interface

uses
  StdCtrls, Controls, ExtCtrls, Classes,
  untHFiltreFiltreDigital, untCalcImage;

type
  TfrmFiltreMinMax = class(TfrmHFiltreFiltreDigital)
    procedure btnOKClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    procedure PrevisualiseResultat; override;
  end;

procedure CalculerOperation(Image : TCalcImage; TailleFiltre : Integer; var ImageResultat : TCalcImage);
procedure CalculerPrevisualisation(Image : TCalcImage; TailleFiltre : Integer; var ImageResultat : TCalcImage);

var
  frmFiltreMinMax: TfrmFiltreMinMax;

implementation

uses
  Math, SysUtils, 
  untMDIImage, untPrincipale;

{$R *.DFM}

{ TfrmFiltreMinMax }

procedure TfrmFiltreMinMax.PrevisualiseResultat;
begin
  if EnabledOK then  // Si l'image est "compatible"
  begin
    CalculerPrevisualisation(TfrmMDIImage(Image).CalcImage, TailleFiltre, CalcImagePrevisualisation);

    AffichePrevisualisation;  // Affiche la prévisualisation
  end;
end;

procedure CalculerPrevisualisation(Image : TCalcImage; TailleFiltre : Integer; var ImageResultat : TCalcImage);
var
  X, Y : Integer;
  XTN, YTN : Integer;
  X2, Y2 : Integer;
  CouleurMin : TCouleur;
  CouleurMax : TCouleur;
  NombrePixels : Integer;
begin
  TailleFiltre := TailleFiltre div 2;

  for X := 0 to ImageResultat.TailleX - 1 do  // Parcourt tous les pixels
    for Y := 0 to ImageResultat.TailleY - 1 do  // de l'image
    begin
      NombrePixels := 0;

      XTN := X * (Image.TailleX - 1) div (ImageResultat.TailleX - 1);  // Calcul la position du pixel
      YTN := Y * (Image.TailleY - 1) div (ImageResultat.TailleY - 1);  // correspondant sur l'image d'origine
      for X2 := -TailleFiltre to TailleFiltre do
        if (XTN + X2 >= 0) and (XTN + X2 < Image.TailleX) then  // Teste si la colonne XTN + X2 est sur l'image d'origine
          for Y2 := -TailleFiltre to TailleFiltre do
            if (YTN + Y2 >= 0) and (YTN + Y2 < Image.TailleY) then  // Teste si la ligne YTN + Y2 est sur l'image d'origine
            begin
              if NombrePixels = 0 then  // Si c'est le premier pixel
              begin
                CouleurMin.Rouge := Image.Image[XTN + X2, YTN + Y2].Rouge;  // Initialise
                CouleurMin.Bleu := Image.Image[XTN + X2, YTN + Y2].Vert;  // les valeurs
                CouleurMin.Vert := Image.Image[XTN + X2, YTN + Y2].Bleu;  // Min et Max
                CouleurMax.Rouge := Image.Image[XTN + X2, YTN + Y2].Rouge;  // à la couleur
                CouleurMax.Bleu := Image.Image[XTN + X2, YTN + Y2].Vert;  // du premier pixel
                CouleurMax.Vert := Image.Image[XTN + X2, YTN + Y2].Bleu;  // de l'image
              end
              else
              begin
                CouleurMin.Rouge := Min(CouleurMin.Rouge, Image.Image[XTN + X2, YTN + Y2].Rouge);  // Cherche la plus
                CouleurMin.Vert := Min(CouleurMin.Vert, Image.Image[XTN + X2, YTN + Y2].Vert);  // faible valeur
                CouleurMin.Bleu := Min(CouleurMin.Bleu, Image.Image[XTN + X2, YTN + Y2].Bleu);  // de couleur
                CouleurMax.Rouge := Max(CouleurMax.Rouge, Image.Image[XTN + X2, YTN + Y2].Rouge);  // Cherche la plus
                CouleurMax.Vert := Max(CouleurMax.Vert, Image.Image[XTN + X2, YTN + Y2].Vert);  // forte valeur
                CouleurMax.Bleu := Max(CouleurMax.Bleu, Image.Image[XTN + X2, YTN + Y2].Bleu);  // de couleur
              end;
              Inc(NombrePixels);  // Augmente de 1 le nombre de pixels
            end;

      ImageResultat.Image[X, Y].Rouge := (CouleurMax.Rouge - CouleurMin.Rouge) / 2 + CouleurMin.Rouge;  // Calcule la
      ImageResultat.Image[X, Y].Vert := (CouleurMax.Vert - CouleurMin.Vert) / 2 + CouleurMin.Vert;  // valeur des pixels
      ImageResultat.Image[X, Y].Bleu := (CouleurMax.Bleu - CouleurMin.Bleu) / 2 + CouleurMin.Bleu;  // du resultat
    end;
end;

procedure CalculerOperation(Image : TCalcImage; TailleFiltre : Integer; var ImageResultat : TCalcImage);
var
  X, Y : Integer;
  X2, Y2 : Integer;
  CouleurMin : TCouleur;
  CouleurMax : TCouleur;
  NombrePixels : Integer;
begin
  TailleFiltre := TailleFiltre div 2;

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
              if NombrePixels = 0 then  // Si c'est le premier pixel
              begin
                CouleurMin.Rouge := Image.Image[X + X2, Y + Y2].Rouge;  // Initialise
                CouleurMin.Bleu := Image.Image[X + X2, Y + Y2].Vert;  // les valeurs
                CouleurMin.Vert := Image.Image[X + X2, Y + Y2].Bleu;  // Min et Max
                CouleurMax.Rouge := Image.Image[X + X2, Y + Y2].Rouge;  // à la couleur
                CouleurMax.Bleu := Image.Image[X + X2, Y + Y2].Vert;  // du premier pixel
                CouleurMax.Vert := Image.Image[X + X2, Y + Y2].Bleu;  // de l'image
              end
              else
              begin
                CouleurMin.Rouge := Min(CouleurMin.Rouge, Image.Image[X + X2, Y + Y2].Rouge);  // Cherche la plus
                CouleurMin.Vert := Min(CouleurMin.Vert, Image.Image[X + X2, Y + Y2].Vert);  // faible valeur
                CouleurMin.Bleu := Min(CouleurMin.Bleu, Image.Image[X + X2, Y + Y2].Bleu);  // de couleur
                CouleurMax.Rouge := Max(CouleurMax.Rouge, Image.Image[X + X2, Y + Y2].Rouge);  // Cherche la plus
                CouleurMax.Vert := Max(CouleurMax.Vert, Image.Image[X + X2, Y + Y2].Vert);  // forte valeur
                CouleurMax.Bleu := Max(CouleurMax.Bleu, Image.Image[X + X2, Y + Y2].Bleu);  // de couleur
              end;
              Inc(NombrePixels);  // Augmente de 1 le nombre de pixels
            end;

      ImageResultat.Image[X, Y].Rouge := (CouleurMax.Rouge - CouleurMin.Rouge) / 2 + CouleurMin.Rouge;  // Calcule la
      ImageResultat.Image[X, Y].Vert := (CouleurMax.Vert - CouleurMin.Vert) / 2 + CouleurMin.Vert;  // valeur des pixels
      ImageResultat.Image[X, Y].Bleu := (CouleurMax.Bleu - CouleurMin.Bleu) / 2 + CouleurMin.Bleu;  // du resultat
    end;
  end;
  frmPrincipale.FinCalcul;
end;

procedure TfrmFiltreMinMax.btnOKClick(Sender: TObject);
begin
  inherited;
  TfrmMDIImage(ListeImages.Last).Caption := Format('MinMax(%s, %d)', [TfrmMDIImage(Image).Caption, TailleFiltre]);  // Affiche le titre de l'image

  CalculerOperation(TfrmMDIImage(Image).CalcImage, TailleFiltre, TfrmMDIImage(ListeImages.Last).CalcImage);  // Calcul le résultat

  TfrmMDIImage(ListeImages.Last).AfficheImage;  // Affiche le résultat
end;

end.
