unit untHFiltreImageConstante;

interface

uses
  Windows, Forms, ExtCtrls, Controls, StdCtrls, Classes, Dialogs,
  untCalcImage;

type
  TfrmHFiltreImageConstante = class(TForm)
    bvbImages: TBevel;
    imgPrevisualisation: TImage;
    lblPrevisualisation: TLabel;
    lblImage: TLabel;
    btnOK: TButton;
    btnAnnuler: TButton;
    lstImage: TListBox;
    grbCouleur: TGroupBox;
    ShapeCouleur: TShape;
    ColorDialog: TColorDialog;
    btnSelectionCouleur: TButton;
    edtRouge: TEdit;
    edtVert: TEdit;
    edtBleu: TEdit;
    lblRouge: TLabel;
    lblVert: TLabel;
    lblBleu: TLabel;
    lblCouleur: TLabel;
    procedure btnSelectionCouleurClick(Sender: TObject);
    procedure edtRougeChange(Sender: TObject);
    procedure edtVertChange(Sender: TObject);
    procedure edtBleuChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lstImageDrawItem(Control: TWinControl; Index: Integer;
      Rectangle: TRect; State: TOwnerDrawState);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lstImageClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    CalcImagePrevisualisation : TCalcImage;
    CalcImagePrev : TCalcImage;

    Image : Pointer;
    Couleur : TCouleur;

    procedure RafraichirListeImages;
    procedure AffichePrevisualisation;
    function EnabledOK : Boolean;
    procedure RafraichirCouleur;

    procedure PrevisualiseResultat; virtual; abstract;
  end;

var
  frmHFiltreImageConstante: TfrmHFiltreImageConstante;

implementation

uses
  SysUtils, Graphics,
  untMDIImage, untPrincipale;

{$R *.DFM}

procedure TfrmHFiltreImageConstante.AffichePrevisualisation;
var
  X, Y : Integer;
begin
  for X := 0 to CalcImagePrevisualisation.TailleX - 1 do  // Parcourt tous les
    for Y := 0 to CalcImagePrevisualisation.TailleY - 1 do  // pixels de l'images
      imgPrevisualisation.Canvas.Pixels[X, Y] := CouleurToColor(CalcImagePrevisualisation.Image[X, Y]);
end;

procedure TfrmHFiltreImageConstante.btnSelectionCouleurClick(
  Sender: TObject);
begin
  if ColorDialog.Execute then
  begin
    Couleur.Rouge := ColorDialog.Color and $000000FF;  // Calcul les différents
    Couleur.Vert := (ColorDialog.Color and $0000FF00) shr 8;  // composants de la
    Couleur.Bleu := (ColorDialog.Color and $00FF0000) shr 16;  // couleur choisie
    edtRouge.Text := FloatToStr(Couleur.Rouge);
    edtVert.Text := FloatToStr(Couleur.Vert);
    edtBleu.Text := FloatToStr(Couleur.Bleu);
    RafraichirCouleur;
  end;
end;

function TfrmHFiltreImageConstante.EnabledOK: Boolean;
begin
  if (lstImage.ItemIndex > -1)  then  // Si une image est sélectionnée
    Result := True
  else
    Result := False;
end;

procedure TfrmHFiltreImageConstante.RafraichirCouleur;
begin
  ShapeCouleur.Brush.Color := CouleurToColor(Couleur);
  ColorDialog.Color := CouleurToColor(Couleur);
  PrevisualiseResultat;
end;

procedure TfrmHFiltreImageConstante.RafraichirListeImages;
var
  NumImage : Integer;
begin
  lstImage.Clear;  // Efface toute la liste

  for NumImage := 0 to ListeImages.Count - 1 do  // Parcourt toute la liste d'images
    lstImage.Items.Add(TfrmMDIImage(ListeImages.Items[NumImage]).Caption);  // Ajoute le titre des images à la liste
end;

procedure TfrmHFiltreImageConstante.edtRougeChange(Sender: TObject);
begin
  edtRouge.Text := FormateNombreDecimal(edtRouge.Text, True, Couleur.Rouge);
  Application.ProcessMessages;
  RafraichirCouleur;
end;

procedure TfrmHFiltreImageConstante.edtVertChange(Sender: TObject);
begin
  edtVert.Text := FormateNombreDecimal(edtVert.Text, True, Couleur.Vert);
  Application.ProcessMessages;
  RafraichirCouleur;
end;

procedure TfrmHFiltreImageConstante.edtBleuChange(Sender: TObject);
begin
  edtBleu.Text := FormateNombreDecimal(edtBleu.Text, True, Couleur.Bleu);
  Application.ProcessMessages;
  RafraichirCouleur;
end;

procedure TfrmHFiltreImageConstante.FormShow(Sender: TObject);
begin
  btnOK.Enabled := False;  // Au début, aucune image n'est sélectionnée donc on ne peut pas cliquer sur OK
  imgPrevisualisation.Canvas.Rectangle(0, 0, imgPrevisualisation.Width, imgPrevisualisation.Height);  // Efface l'image de la prévisualisation
  RafraichirListeImages;
end;

procedure TfrmHFiltreImageConstante.lstImageDrawItem(Control: TWinControl;
  Index: Integer; Rectangle: TRect; State: TOwnerDrawState);

  procedure CopieImage(CanvasDest : TCanvas; Rect : TRect; BitmapSource : TBitmap);
  var
    X, Y : Integer;
  begin
    for X := Rect.Left to Rect.Right do  // Parcourt tous les
      for Y := Rect.Top to Rect.Bottom do  // pixels du rectangle
        CanvasDest.Pixels[X, Y] := BitmapSource.Canvas.Pixels[(X - Rect.Left) * (BitmapSource.Width - 1) div (Rect.Right - Rect.Left), (Y - Rect.Top) * (BitmapSource.Height - 1) div (Rect.Bottom - Rect.Top)];  //Copie l'image pixel par pixel dans le rectangle
  end;
var
  Bitmap : TBitmap;
begin
  Bitmap := TBitmap.Create;  // Création du Bitmap temporaire
  Bitmap.Width := Rectangle.Right - Rectangle.Left;  // Changement des dimensions
  Bitmap.Height := Rectangle.Bottom - Rectangle.Top;  // du bitmap temporaire

  Bitmap.Canvas.Font := lstImage.Canvas.Font;  // Affectation des
  Bitmap.Canvas.Brush := lstImage.Canvas.Brush;  // mêmes propriétés
  Bitmap.Canvas.Pen := lstImage.Canvas.Pen;  // au bitmap temporaire

  Bitmap.Canvas.FillRect(Rect(0, 0, Rectangle.Right - Rectangle.Left, Rectangle.Bottom - Rectangle.Top));  // Effacement du bitmap

  if Index < lstImage.Items.Count then
  begin
    Bitmap.Canvas.TextOut(70, (Rectangle.Bottom - Rectangle.Top - Bitmap.Canvas.TextHeight(lstImage.Items[Index])) div 2, lstImage.Items[Index]);  // Ecrit le titre de l'image dans le bitmap temporaire
    CopieImage(Bitmap.Canvas, Rect(4, 2, 64, Rectangle.Bottom - Rectangle.Top - 4), TfrmMDIImage(ListeImages.Items[Index]).imgImage.Picture.Bitmap);  // Affiche la petite image à coté du titre
  end;

  lstImage.Canvas.CopyRect(Rectangle, Bitmap.Canvas, Rect(0, 0, Rectangle.Right - Rectangle.Left, Rectangle.Bottom - Rectangle.Top));  // Copie du bitmap temporaire dans le canvas de la liste

  Bitmap.Free;
end;

procedure TfrmHFiltreImageConstante.FormCreate(Sender: TObject);
begin
  imgPrevisualisation.Canvas.Pen.Color := clBlack;
  imgPrevisualisation.Canvas.Brush.Color := Color;

  CalcImagePrevisualisation := TCalcImage.Create;  // Crée le tableau de données de l'image d prévisualisation
  CalcImagePrevisualisation.ChangeDimensions(imgPrevisualisation.Width, imgPrevisualisation.Height);  // Dimensionne le tableau de données

  CalcImagePrev := TCalcImage.Create;
  CalcImagePrev.ChangeDimensions(imgPrevisualisation.Width, imgPrevisualisation.Height);

  Couleur.Rouge := 255;
  Couleur.Vert := 255;
  Couleur.Bleu := 255;
end;

procedure TfrmHFiltreImageConstante.FormDestroy(Sender: TObject);
begin
  CalcImagePrevisualisation.Destroy;
  CalcImagePrev.Destroy;
end;

procedure TfrmHFiltreImageConstante.lstImageClick(Sender: TObject);
begin
  Image := ListeImages.Items[lstImage.ItemIndex];  // Pointe sur l'image sélectionnée

  imgPrevisualisation.Canvas.Rectangle(0, 0, imgPrevisualisation.Width, imgPrevisualisation.Height);  // Efface l'image de la prévisualisation
  btnOK.Enabled := EnabledOK;  // Vérifie si l'image est "compatible"
  PrevisualiseResultat;
end;

procedure TfrmHFiltreImageConstante.btnOKClick(Sender: TObject);
begin
  ListeImages.Add(TfrmMDIImage.Create(nil));  // Crée une nouvelle Form image
  TfrmMDIImage(ListeImages.Last).ChangerDimensionsImage(TfrmMDIImage(Image).CalcImage.TailleX, TfrmMDIImage(Image).CalcImage.TailleY);  // Redimensionne l'image
  TfrmMDIImage(ListeImages.Last).Caption := 'Image : ' + IntToStr(ListeImages.Count);  // Affiche le titre de l'image
end;

end.
