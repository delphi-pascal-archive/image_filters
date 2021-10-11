unit untFiltreFondu;

interface

uses
  StdCtrls, Controls, ExtCtrls, Classes,
  untHFiltreImageImage, untCalcImage;

type
  TfrmFiltreFondu = class(TfrmHFiltreImageImage)
    grbParametres: TGroupBox;
    edtRouge: TEdit;
    lblRouge: TLabel;
    edtVert: TEdit;
    lblBleu: TLabel;
    edtBleu: TEdit;
    lblVert: TLabel;
    procedure edtRougeChange(Sender: TObject);
    procedure edtVertChange(Sender: TObject);
    procedure edtBleuChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    PourcentageImage1 : TCouleur;

    procedure PrevisualiseResultat; override;
  end;

var
  frmFiltreFondu: TfrmFiltreFondu;

procedure CalculerOperation(Image1, Image2 : TCalcImage; PourcentageImage1 : TCouleur; var ImageResultat : TCalcImage);

implementation

uses
  SysUtils, Forms,
  untMDIImage, untPrincipale;

{$R *.DFM}

{ TfrmFiltreFondu }

procedure TfrmFiltreFondu.PrevisualiseResultat;
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
    CalculerOperation(CalcImagePrev1, CalcImagePrev2, PourcentageImage1, CalcImagePrevisualisation);  // Calcul l'image résultat de la prévisualisation

    AffichePrevisualisation;  // Affiche la prévisualisation
  end;
end;

procedure CalculerOperation(Image1, Image2 : TCalcImage; PourcentageImage1 : TCouleur; var ImageResultat : TCalcImage);
var
  X, Y : Integer;
begin
  PourcentageImage1.Rouge := PourcentageImage1.Rouge / 100;  // Change les pourcentages (allant de 0 à 100)
  PourcentageImage1.Vert := PourcentageImage1.Vert / 100;  // en valeur décimale
  PourcentageImage1.Bleu := PourcentageImage1.Bleu / 100;  // (allant de 0 à 1)

  frmPrincipale.ChangeStatus('Calcul');
  frmPrincipale.ProgressBar.Max := Image1.TailleX - 1;
  for X := 0 to Image1.TailleX - 1 do  // Parcourt tous les pixels
  begin
    frmPrincipale.ProgressBar.Position := X;
    for Y := 0 to Image1.TailleY - 1 do  // de l'image
    begin
      ImageResultat.Image[X, Y].Rouge := Image1.Image[X, Y].Rouge * PourcentageImage1.Rouge + Image2.Image[X, Y].Rouge * (1 - PourcentageImage1.Rouge);  // Fait le fondu entre les pixels
      ImageResultat.Image[X, Y].Vert := Image1.Image[X, Y].Vert * PourcentageImage1.Vert + Image2.Image[X, Y].Vert * (1 - PourcentageImage1.Vert);  // de l'image 1 et les pixels de
      ImageResultat.Image[X, Y].Bleu := Image1.Image[X, Y].Bleu * PourcentageImage1.Bleu + Image2.Image[X, Y].Bleu * (1 - PourcentageImage1.Bleu);  // l'image 2 suivant le pourcentage donné
    end;
  end;
  frmPrincipale.FinCalcul;
end;

procedure TfrmFiltreFondu.edtRougeChange(Sender: TObject);
begin
  edtRouge.Text := FormateNombreDecimal(edtRouge.Text, True, PourcentageImage1.Rouge);
  Application.ProcessMessages;
  PrevisualiseResultat;
end;

procedure TfrmFiltreFondu.edtVertChange(Sender: TObject);
begin
  edtVert.Text := FormateNombreDecimal(edtVert.Text, True, PourcentageImage1.Vert);
  Application.ProcessMessages;
  PrevisualiseResultat;
end;

procedure TfrmFiltreFondu.edtBleuChange(Sender: TObject);
begin
  edtBleu.Text := FormateNombreDecimal(edtBleu.Text, True, PourcentageImage1.Bleu);
  Application.ProcessMessages;
  PrevisualiseResultat;
end;

procedure TfrmFiltreFondu.FormCreate(Sender: TObject);
begin
  inherited;
  PourcentageImage1.Rouge := 50;
  PourcentageImage1.Vert := 50;
  PourcentageImage1.Bleu := 50;
end;

procedure TfrmFiltreFondu.btnOKClick(Sender: TObject);
begin
  inherited;
  TfrmMDIImage(ListeImages.Last).Caption := Format('Fondu(%s, %s, RGB(%g, %g, %g))', [TfrmMDIImage(Image1).Caption, TfrmMDIImage(Image2).Caption, PourcentageImage1.Rouge, PourcentageImage1.Vert, PourcentageImage1.Bleu]);  // Affiche le titre de l'image

  CalculerOperation(TfrmMDIImage(Image1).CalcImage, TfrmMDIImage(Image2).CalcImage, PourcentageImage1, TfrmMDIImage(ListeImages.Last).CalcImage);  // Calcul le résultat

  TfrmMDIImage(ListeImages.Last).AfficheImage;  // Affiche le résultat
end;

end.
