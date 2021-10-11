unit untFiltreMoyenne;

interface

uses
  StdCtrls, Controls, ExtCtrls, Classes,
  untHFiltreFiltreDigital, untCalcImage;

type
  TfrmFiltreMoyenne = class(TfrmHFiltreFiltreDigital)
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
  frmFiltreMoyenne: TfrmFiltreMoyenne;

implementation

uses
  Math, SysUtils, 
  untMDIImage, untPrincipale;

{$R *.DFM}

{ TfrmFiltreMoyenne }

procedure TfrmFiltreMoyenne.PrevisualiseResultat;
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
  Couleur : TCouleur;
  NombrePixels : Integer;
begin
  TailleFiltre := TailleFiltre div 2;

  for X := 0 to ImageResultat.TailleX - 1 do  // Parcourt tous les pixels
    for Y := 0 to ImageResultat.TailleY - 1 do  // de l'image
    begin
      Couleur.Rouge := 0;
      Couleur.Bleu := 0;
      Couleur.Vert := 0;
      NombrePixels := 0;

      XTN := X * (Image.TailleX - 1) div (ImageResultat.TailleX - 1);  // Calcul la position du pixel
      YTN := Y * (Image.TailleY - 1) div (ImageResultat.TailleY - 1);  // correspondant sur l'image d'origine
      for X2 := -TailleFiltre to TailleFiltre do
        if (XTN + X2 >= 0) and (XTN + X2 < Image.TailleX) then  // Teste si la colonne XTN + X2 est sur l'image d'origine
          for Y2 := -TailleFiltre to TailleFiltre do
            if (YTN + Y2 >= 0) and (YTN + Y2 < Image.TailleY) then  // Teste si la ligne YTN + Y2 est sur l'image d'origine
            begin
              Couleur.Rouge := Couleur.Rouge + Image.Image[XTN + X2, YTN + Y2].Rouge;  // Addition tous les
              Couleur.Vert := Couleur.Vert + Image.Image[XTN + X2, YTN + Y2].Vert;  // pixels entourant
              Couleur.Bleu := Couleur.Bleu + Image.Image[XTN + X2, YTN + Y2].Bleu;  // le pixel [XTN, YTN]
              Inc(NombrePixels);  // Augmente de 1 le nombre de pixels
            end;

      ImageResultat.Image[X, Y].Rouge := Couleur.Rouge / NombrePixels;  // Calcule la
      ImageResultat.Image[X, Y].Vert := Couleur.Vert / NombrePixels;  // moyenne des
      ImageResultat.Image[X, Y].Bleu := Couleur.Bleu / NombrePixels;  // pixels
    end;
end;

procedure CalculerOperation(Image : TCalcImage; TailleFiltre : Integer; var ImageResultat : TCalcImage);
var
  X, Y : Integer;
  X2, Y2 : Integer;
  Couleur : TCouleur;
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
      Couleur.Rouge := 0;
      Couleur.Bleu := 0;
      Couleur.Vert := 0;
      NombrePixels := 0;

      for X2 := -TailleFiltre to TailleFiltre do
        if (X + X2 >= 0) and (X + X2 < Image.TailleX) then  // Teste si la colonne X + X2 est sur l'image
          for Y2 := -TailleFiltre to TailleFiltre do
            if (Y + Y2 >= 0) and (Y + Y2 < Image.TailleY) then  // Teste si la ligne Y + Y2 est sur l'image
            begin
              Couleur.Rouge := Couleur.Rouge + Image.Image[X + X2, Y + Y2].Rouge;  // Addition tous les
              Couleur.Vert := Couleur.Vert + Image.Image[X + X2, Y + Y2].Vert;  // pixels entourant
              Couleur.Bleu := Couleur.Bleu + Image.Image[X + X2, Y + Y2].Bleu;  // le pixel [X, Y]
              Inc(NombrePixels);  // Augmente de 1 le nombre de pixels
            end;

      ImageResultat.Image[X, Y].Rouge := Couleur.Rouge / NombrePixels;  // Calcule la
      ImageResultat.Image[X, Y].Vert := Couleur.Vert / NombrePixels;  // moyenne des
      ImageResultat.Image[X, Y].Bleu := Couleur.Bleu / NombrePixels;  // pixels
    end;
  end;
  frmPrincipale.FinCalcul;
end;

procedure TfrmFiltreMoyenne.btnOKClick(Sender: TObject);
begin
  inherited;
  TfrmMDIImage(ListeImages.Last).Caption := Format('Moyenne(%s, %d)', [TfrmMDIImage(Image).Caption, TailleFiltre]);  // Affiche le titre de l'image

  CalculerOperation(TfrmMDIImage(Image).CalcImage, TailleFiltre, TfrmMDIImage(ListeImages.Last).CalcImage);  // Calcul le résultat

  TfrmMDIImage(ListeImages.Last).AfficheImage;  // Affiche le résultat
end;

end.
