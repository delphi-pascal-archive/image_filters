unit untHistogramme;

interface

uses
  Windows, Forms, ExtCtrls, Controls, StdCtrls, Classes,
  untCalcImage, ComCtrls;

type
  TfrmHistogramme = class(TForm)
    bvbImages: TBevel;
    lblImage: TLabel;
    btnFermer: TButton;
    lstImage: TListBox;
    grbHistogrammes: TGroupBox;
    imgRouge: TImage;
    imgVert: TImage;
    imgBleu: TImage;
    lblRouge: TLabel;
    lblVert: TLabel;
    lblBleu: TLabel;
    TrackBar: TTrackBar;
    procedure FormShow(Sender: TObject);
    procedure lstImageDrawItem(Control: TWinControl; Index: Integer;
      Rectangle: TRect; State: TOwnerDrawState);
    procedure lstImageClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TrackBarChange(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    Image : Pointer;

    procedure RafraichirListeImages;
    procedure AfficherHistogrammes;
  end;

var
  frmHistogramme: TfrmHistogramme;

implementation

uses
  Graphics,
  untMDIImage, untPrincipale;

{$R *.DFM}

{ TfrmHistogramme }

procedure TfrmHistogramme.RafraichirListeImages;
var
  NumImage : Integer;
begin
  lstImage.Clear;  // Efface toute la liste

  for NumImage := 0 to ListeImages.Count - 1 do  // Parcourt toute la liste d'images
    lstImage.Items.Add(TfrmMDIImage(ListeImages.Items[NumImage]).Caption);  // Ajoute le titre des images à la liste
end;

procedure TfrmHistogramme.FormShow(Sender: TObject);
begin
  imgRouge.Canvas.Rectangle(0, 0, 256, 256);  // Efface les précédents
  imgVert.Canvas.Rectangle(0, 0, 256, 256);  // histogrammes dessinés
  imgBleu.Canvas.Rectangle(0, 0, 256, 256);  // de les images

  RafraichirListeImages;
end;

procedure TfrmHistogramme.lstImageDrawItem(Control: TWinControl;
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

procedure TfrmHistogramme.lstImageClick(Sender: TObject);
begin
  Image := ListeImages.Items[lstImage.ItemIndex];  // Pointe sur l'image sélectionnée
  AfficherHistogrammes;
end;

procedure TfrmHistogramme.AfficherHistogrammes;
var
  NumCouleur : Integer;
begin
  imgRouge.Canvas.Rectangle(0, 0, 256, 256);  // Efface les précédents
  imgVert.Canvas.Rectangle(0, 0, 256, 256);  // histogrammes dessinés
  imgBleu.Canvas.Rectangle(0, 0, 256, 256);  // de les images

  for NumCouleur := 0 to 255 do
  begin
    imgRouge.Canvas.MoveTo(NumCouleur, 255);
    imgVert.Canvas.MoveTo(NumCouleur, 255);
    imgBleu.Canvas.MoveTo(NumCouleur, 255);

    imgRouge.Canvas.LineTo(NumCouleur, 255 - Round(TfrmMDIImage(Image).CalcImage.Histogramme[NumCouleur].Rouge / Sqr(TrackBar.Position / 5)));  // Affiche une barre pour chaque couleur de
    imgVert.Canvas.LineTo(NumCouleur, 255 - Round(TfrmMDIImage(Image).CalcImage.Histogramme[NumCouleur].Vert / Sqr(TrackBar.Position / 5)));  // longueur proportionnel au nombre de fois
    imgBleu.Canvas.LineTo(NumCouleur, 255 - Round(TfrmMDIImage(Image).CalcImage.Histogramme[NumCouleur].Bleu / Sqr(TrackBar.Position / 5)));  // que la couleur est présente dans l'image
  end;
end;

procedure TfrmHistogramme.FormCreate(Sender: TObject);
begin
  imgRouge.Canvas.Brush.Color := clBlack;
  imgVert.Canvas.Brush.Color := clBlack;
  imgBleu.Canvas.Brush.Color := clBlack;

  imgRouge.Canvas.Pen.Color := clRed;
  imgVert.Canvas.Pen.Color := clGreen;
  imgBleu.Canvas.Pen.Color := clBlue;
end;

procedure TfrmHistogramme.TrackBarChange(Sender: TObject);
begin
  AfficherHistogrammes;
end;

end.
