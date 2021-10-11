unit untFiltreSeuil;

interface

uses
  StdCtrls, Controls, ExtCtrls, Classes, Dialogs,
  untHFiltreImage, untCalcImage;

type
  TfrmFiltreSeuil = class(TfrmHFiltreImage)
    grbCouleurInferieure: TGroupBox;
    ShapeCouleurCI: TShape;
    lblRougeCI: TLabel;
    lblVertCI: TLabel;
    lblBleuCI: TLabel;
    lblCouleurCI: TLabel;
    btnSelectionCouleurI: TButton;
    edtRougeCI: TEdit;
    edtVertCI: TEdit;
    edtBleuCI: TEdit;
    lblVertCS: TGroupBox;
    ShapeCouleurCS: TShape;
    lblRougeCS: TLabel;
    Label2: TLabel;
    lblBleuCS: TLabel;
    lblCouleurCS: TLabel;
    btnSelectionCouleurS: TButton;
    edtRougeCS: TEdit;
    edtVertCS: TEdit;
    edtBleuCS: TEdit;
    ColorDialogCS: TColorDialog;
    ColorDialogCI: TColorDialog;
    procedure btnSelectionCouleurIClick(Sender: TObject);
    procedure btnSelectionCouleurSClick(Sender: TObject);
    procedure edtRougeCIChange(Sender: TObject);
    procedure edtVertCIChange(Sender: TObject);
    procedure edtBleuCIChange(Sender: TObject);
    procedure edtRougeCSChange(Sender: TObject);
    procedure edtVertCSChange(Sender: TObject);
    procedure edtBleuCSChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    CouleurS, CouleurI : TCouleur;

    procedure PrevisualiseResultat; override;
    procedure RafraichirCouleur;
  end;

procedure CalculerOperation(Image : TCalcImage; CouleurI, CouleurS : TCouleur; var ImageResultat : TCalcImage);

var
  frmFiltreSeuil: TfrmFiltreSeuil;

implementation

uses
  SysUtils, Forms,
  untMDIImage, untPrincipale;

{$R *.DFM}

{ TfrmFiltreSeuil }

procedure TfrmFiltreSeuil.PrevisualiseResultat;
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
    CalculerOperation(CalcImagePrev, CouleurI, CouleurS, CalcImagePrevisualisation);  // Calcul l'image résultat de la prévisualisation

    AffichePrevisualisation;  // Affiche la prévisualisation
  end;
end;

procedure TfrmFiltreSeuil.RafraichirCouleur;
begin
  ShapeCouleurCI.Brush.Color := CouleurToColor(CouleurI);
  ColorDialogCI.Color := CouleurToColor(CouleurI);
  ShapeCouleurCS.Brush.Color := CouleurToColor(CouleurS);
  ColorDialogCS.Color := CouleurToColor(CouleurS);
  PrevisualiseResultat;
end;

procedure TfrmFiltreSeuil.btnSelectionCouleurIClick(Sender: TObject);
begin
  if ColorDialogCI.Execute then
  begin
    CouleurI.Rouge := ColorDialogCI.Color and $000000FF;  // Calcul les différents
    CouleurI.Vert := (ColorDialogCI.Color and $0000FF00) shr 8;  // composants de la
    CouleurI.Bleu := (ColorDialogCI.Color and $00FF0000) shr 16;  // couleur choisie
    edtRougeCI.Text := FloatToStr(CouleurI.Rouge);
    edtVertCI.Text := FloatToStr(CouleurI.Vert);
    edtBleuCI.Text := FloatToStr(CouleurI.Bleu);
    RafraichirCouleur;
  end;
end;

procedure TfrmFiltreSeuil.btnSelectionCouleurSClick(Sender: TObject);
begin
  if ColorDialogCS.Execute then
  begin
    CouleurS.Rouge := ColorDialogCS.Color and $000000FF;  // Calcul les différents
    CouleurS.Vert := (ColorDialogCS.Color and $0000FF00) shr 8;  // composants de la
    CouleurS.Bleu := (ColorDialogCS.Color and $00FF0000) shr 16;  // couleur choisie
    edtRougeCS.Text := FloatToStr(CouleurS.Rouge);
    edtVertCS.Text := FloatToStr(CouleurS.Vert);
    edtBleuCS.Text := FloatToStr(CouleurS.Bleu);
    RafraichirCouleur;
  end;
end;

procedure TfrmFiltreSeuil.edtRougeCIChange(Sender: TObject);
begin
  edtRougeCI.Text := FormateNombreDecimal(edtRougeCI.Text, True, CouleurI.Rouge);
  Application.ProcessMessages;
  RafraichirCouleur;
end;

procedure TfrmFiltreSeuil.edtVertCIChange(Sender: TObject);
begin
  edtVertCI.Text := FormateNombreDecimal(edtVertCI.Text, True, CouleurI.Vert);
  Application.ProcessMessages;
  RafraichirCouleur;
end;

procedure TfrmFiltreSeuil.edtBleuCIChange(Sender: TObject);
begin
  edtBleuCI.Text := FormateNombreDecimal(edtBleuCI.Text, True, CouleurI.Bleu);
  Application.ProcessMessages;
  RafraichirCouleur;
end;

procedure TfrmFiltreSeuil.edtRougeCSChange(Sender: TObject);
begin
  edtRougeCS.Text := FormateNombreDecimal(edtRougeCS.Text, True, CouleurS.Rouge);
  Application.ProcessMessages;
  RafraichirCouleur;
end;

procedure TfrmFiltreSeuil.edtVertCSChange(Sender: TObject);
begin
  edtVertCS.Text := FormateNombreDecimal(edtVertCS.Text, True, CouleurS.Vert);
  Application.ProcessMessages;
  RafraichirCouleur;
end;

procedure TfrmFiltreSeuil.edtBleuCSChange(Sender: TObject);
begin
  edtBleuCS.Text := FormateNombreDecimal(edtBleuCS.Text, True, CouleurS.Bleu);
  Application.ProcessMessages;
  RafraichirCouleur;
end;

procedure TfrmFiltreSeuil.FormCreate(Sender: TObject);
begin
  inherited;

  CouleurI.Rouge := 128;
  CouleurI.Vert := 128;
  CouleurI.Bleu := 128;

  CouleurS.Rouge := 255;
  CouleurS.Vert := 255;
  CouleurS.Bleu := 255;
end;

procedure CalculerOperation(Image : TCalcImage; CouleurI, CouleurS : TCouleur; var ImageResultat : TCalcImage);
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
      if (Image.Image[X, Y].Rouge >= CouleurI.Rouge) and (Image.Image[X, Y].Rouge <= CouleurS.Rouge) then
        ImageResultat.Image[X, Y].Rouge := 255
      else
        ImageResultat.Image[X, Y].Rouge := 0;

      if (Image.Image[X, Y].Vert >= CouleurI.Vert) and (Image.Image[X, Y].Vert <= CouleurS.Vert) then
        ImageResultat.Image[X, Y].Vert := 255
      else
        ImageResultat.Image[X, Y].Vert := 0;

      if (Image.Image[X, Y].Bleu >= CouleurI.Bleu) and (Image.Image[X, Y].Bleu <= CouleurS.Bleu) then
        ImageResultat.Image[X, Y].Bleu := 255
      else
        ImageResultat.Image[X, Y].Bleu := 0;
    end;
  end;
  frmPrincipale.FinCalcul;
end;

procedure TfrmFiltreSeuil.btnOKClick(Sender: TObject);
begin
  inherited;
  TfrmMDIImage(ListeImages.Last).Caption := Format('Seuil(%s, RGB(%g, %g, %g), RGB(%g, %g, %g))',  [TfrmMDIImage(Image).Caption, CouleurI.Rouge, CouleurI.Vert, CouleurI.Bleu, CouleurS.Rouge, CouleurS.Vert, CouleurS.Bleu]);  // Affiche le titre de l'image

  CalculerOperation(TfrmMDIImage(Image).CalcImage, CouleurI, CouleurS, TfrmMDIImage(ListeImages.Last).CalcImage);  // Calcul le résultat

  TfrmMDIImage(ListeImages.Last).AfficheImage;  // Affiche le résultat
end;

end.
