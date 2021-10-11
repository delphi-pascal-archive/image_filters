unit untFiltreGauss;

interface

uses
  StdCtrls, Controls, ExtCtrls, Classes,
  untHFiltreFiltreDigital, untCalcImage;

type
  TfrmFiltreGauss = class(TfrmHFiltreFiltreDigital)
    lblDeviation: TLabel;
    edtDeviation: TEdit;
    procedure btnOKClick(Sender: TObject);
    procedure edtDeviationChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    Deviation : Double;

    procedure PrevisualiseResultat; override;
  end;

procedure CalculerOperation(Image : TCalcImage; TailleFiltre : Integer; Deviation : Double; var ImageResultat : TCalcImage);
procedure CalculerPrevisualisation(Image : TCalcImage; TailleFiltre : Integer; Deviation : Double; var ImageResultat : TCalcImage);

var
  frmFiltreGauss: TfrmFiltreGauss;

implementation

uses
  Math, SysUtils, Forms,
  untMDIImage, untPrincipale;

{$R *.DFM}

{ TfrmFiltreGauss }

procedure TfrmFiltreGauss.PrevisualiseResultat;
begin
  if EnabledOK then  // Si l'image est "compatible"
  begin
    CalculerPrevisualisation(TfrmMDIImage(Image).CalcImage, TailleFiltre, Deviation, CalcImagePrevisualisation);

    AffichePrevisualisation;  // Affiche la prévisualisation
  end;
end;

procedure CalculerPrevisualisation(Image : TCalcImage; TailleFiltre : Integer; Deviation : Double; var ImageResultat : TCalcImage);
var
  Gaussienne : array of array of Double;
  X, Y : Integer;
  XTN, YTN : Integer;
  X2, Y2 : Integer;
  Couleur : TCouleur;
  TotalGauss : Double;
begin
  TailleFiltre := TailleFiltre div 2;

  SetLength(Gaussienne, TailleFiltre * 2 + 1, TailleFiltre * 2 + 1);

  if Deviation = 0 then
    Deviation := 0.01;

  for X := -TailleFiltre to TailleFiltre do
    for Y := -TailleFiltre to TailleFiltre do
      Gaussienne[X + TailleFiltre, Y + TailleFiltre] := Exp(-(Sqr(X) + Sqr(Y)) / (2 * Sqr(Deviation))) / (2 * Pi * Sqr(Deviation));

  for X := 0 to ImageResultat.TailleX - 1 do  // Parcourt tous les pixels
    for Y := 0 to ImageResultat.TailleY - 1 do  // de l'image
    begin
      Couleur.Rouge := 0;
      Couleur.Bleu := 0;
      Couleur.Vert := 0;
      TotalGauss := 0;

      XTN := X * (Image.TailleX - 1) div (ImageResultat.TailleX - 1);  // Calcul la position du pixel
      YTN := Y * (Image.TailleY - 1) div (ImageResultat.TailleY - 1);  // correspondant sur l'image d'origine
      for X2 := -TailleFiltre to TailleFiltre do
        if (XTN + X2 >= 0) and (XTN + X2 < Image.TailleX) then  // Teste si la colonne XTN + X2 est sur l'image d'origine
          for Y2 := -TailleFiltre to TailleFiltre do
            if (YTN + Y2 >= 0) and (YTN + Y2 < Image.TailleY) then  // Teste si la ligne YTN + Y2 est sur l'image d'origine
            begin
              Couleur.Rouge := Couleur.Rouge + Image.Image[XTN + X2, YTN + Y2].Rouge * Gaussienne[X2 + TailleFiltre, Y2 + TailleFiltre];  // Addition tous les
              Couleur.Vert := Couleur.Vert + Image.Image[XTN + X2, YTN + Y2].Vert * Gaussienne[X2 + TailleFiltre, Y2 + TailleFiltre];  // pixels entourant
              Couleur.Bleu := Couleur.Bleu + Image.Image[XTN + X2, YTN + Y2].Bleu * Gaussienne[X2 + TailleFiltre, Y2 + TailleFiltre];  // le pixel [XTN, YTN]
              TotalGauss := TotalGauss + Gaussienne[X2 + TailleFiltre, Y2 + TailleFiltre];  // Augmente de 1 le nombre de pixels additionnés
            end;

      ImageResultat.Image[X, Y].Rouge := Couleur.Rouge / TotalGauss;  // Calcul la
      ImageResultat.Image[X, Y].Vert := Couleur.Vert / TotalGauss;  // moyenne des
      ImageResultat.Image[X, Y].Bleu := Couleur.Bleu / TotalGauss;  // pixels
    end;
end;

procedure CalculerOperation(Image : TCalcImage; TailleFiltre : Integer; Deviation : Double; var ImageResultat : TCalcImage);
var
  Gaussienne : array of array of Double;
  X, Y : Integer;
  X2, Y2 : Integer;
  Couleur : TCouleur;
  TotalGauss : Double;
begin
  TailleFiltre := TailleFiltre div 2;

  SetLength(Gaussienne, TailleFiltre * 2 + 1, TailleFiltre * 2 + 1);

  if Deviation = 0 then
    Deviation := 0.01;

  for X := -TailleFiltre to TailleFiltre do
    for Y := -TailleFiltre to TailleFiltre do
      Gaussienne[X + TailleFiltre, Y + TailleFiltre] := Exp(-(Sqr(X) + Sqr(Y)) / (2 * Sqr(Deviation))) / (2 * Pi * Sqr(Deviation));

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
      TotalGauss := 0;

      for X2 := -TailleFiltre to TailleFiltre do
        if (X + X2 >= 0) and (X + X2 < Image.TailleX) then  // Teste si la colonne X + X2 est sur l'image
          for Y2 := -TailleFiltre to TailleFiltre do
            if (Y + Y2 >= 0) and (Y + Y2 < Image.TailleY) then  // Teste si la ligne Y + Y2 est sur l'image
            begin
              Couleur.Rouge := Couleur.Rouge + Image.Image[X + X2, Y + Y2].Rouge * Gaussienne[X2 + TailleFiltre, Y2 + TailleFiltre];  // Addition tous les
              Couleur.Vert := Couleur.Vert + Image.Image[X + X2, Y + Y2].Vert * Gaussienne[X2 + TailleFiltre, Y2 + TailleFiltre];  // pixels entourant
              Couleur.Bleu := Couleur.Bleu + Image.Image[X + X2, Y + Y2].Bleu * Gaussienne[X2 + TailleFiltre, Y2 + TailleFiltre];  // le pixel [X, Y]
              TotalGauss := TotalGauss + Gaussienne[X2 + TailleFiltre, Y2 + TailleFiltre];  // Augmente de 1 le nombre de pixels additionnés
            end;

      ImageResultat.Image[X, Y].Rouge := Couleur.Rouge / TotalGauss;  // Calcul la
      ImageResultat.Image[X, Y].Vert := Couleur.Vert / TotalGauss;  // moyenne des
      ImageResultat.Image[X, Y].Bleu := Couleur.Bleu / TotalGauss;  // pixels
    end;
  end;
  frmPrincipale.FinCalcul;
end;

procedure TfrmFiltreGauss.btnOKClick(Sender: TObject);
begin
  inherited;
  TfrmMDIImage(ListeImages.Last).Caption := Format('Gauss(%s, %d, %g)', [TfrmMDIImage(Image).Caption, TailleFiltre, Deviation]);  // Affiche le titre de l'image

  CalculerOperation(TfrmMDIImage(Image).CalcImage, TailleFiltre, Deviation, TfrmMDIImage(ListeImages.Last).CalcImage);  // Calcul le résultat

  TfrmMDIImage(ListeImages.Last).AfficheImage;  // Affiche le résultat
end;

procedure TfrmFiltreGauss.edtDeviationChange(Sender: TObject);
begin
  edtDeviation.Text := FormateNombreDecimal(edtDeviation.Text, False, Deviation);
  Application.ProcessMessages;
  PrevisualiseResultat;
end;

procedure TfrmFiltreGauss.FormCreate(Sender: TObject);
begin
  inherited;

  Deviation := 2;
end;

end.
