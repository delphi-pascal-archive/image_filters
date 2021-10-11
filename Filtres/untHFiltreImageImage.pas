unit untHFiltreImageImage;

interface

uses
  Windows, Forms, ExtCtrls, Controls, StdCtrls, Classes,
  untCalcImage;

type
  TfrmHFiltreImageImage = class(TForm)
    btnOK: TButton;
    btnAnnuler: TButton;
    bvbImages: TBevel;
    imgPrevisualisation: TImage;
    lblPrevisualisation: TLabel;
    lstImage1: TListBox;
    lblImage1: TLabel;
    lstImage2: TListBox;
    lblImage2: TLabel;
    procedure FormShow(Sender: TObject);
    procedure lstImage1DrawItem(Control: TWinControl; Index: Integer;
      Rectangle: TRect; State: TOwnerDrawState);
    procedure lstImage2DrawItem(Control: TWinControl; Index: Integer;
      Rectangle: TRect; State: TOwnerDrawState);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lstImage1Click(Sender: TObject);
    procedure lstImage2Click(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    CalcImagePrevisualisation : TCalcImage;
    CalcImagePrev1 : TCalcImage;
    CalcImagePrev2 : TCalcImage;

    Image1 : Pointer;
    Image2 : Pointer;

    procedure RafraichirListeImages;
    procedure AffichePrevisualisation;
    function EnabledOK : Boolean;
    procedure PrevisualiseResultat; virtual; abstract;
  end;

var
  frmHFiltreImageImage: TfrmHFiltreImageImage;

implementation

uses
  Graphics, SysUtils,
  untPrincipale, untMDIImage;

{$R *.DFM}

procedure TfrmHFiltreImageImage.RafraichirListeImages;
var
  NumImage : Integer;
begin
  lstImage1.Clear;  // Efface toute
  lstImage2.Clear;  // la liste

  for NumImage := 0 to ListeImages.Count - 1 do  // Parcourt toute la liste d'images
  begin
    lstImage1.Items.Add(TfrmMDIImage(ListeImages.Items[NumImage]).Caption);  // Ajoute le titre des
    lstImage2.Items.Add(TfrmMDIImage(ListeImages.Items[NumImage]).Caption);  // images � la liste
  end;
end;

procedure TfrmHFiltreImageImage.FormShow(Sender: TObject);
begin
  btnOK.Enabled := False;  // Au d�but, aucune image n'est s�lectionn�e donc on ne peut pas cliquer sur OK
  imgPrevisualisation.Canvas.Rectangle(0, 0, imgPrevisualisation.Width, imgPrevisualisation.Height);  // Efface l'image de la pr�visualisation
  RafraichirListeImages;
end;

procedure TfrmHFiltreImageImage.lstImage1DrawItem(Control: TWinControl;
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
  Bitmap := TBitmap.Create;  // Cr�ation du Bitmap temporaire
  Bitmap.Width := Rectangle.Right - Rectangle.Left;  // Changement des dimensions
  Bitmap.Height := Rectangle.Bottom - Rectangle.Top;  // du bitmap temporaire

  Bitmap.Canvas.Font := lstImage1.Canvas.Font;  // Affectation des
  Bitmap.Canvas.Brush := lstImage1.Canvas.Brush;  // m�mes propri�t�s
  Bitmap.Canvas.Pen := lstImage1.Canvas.Pen;  // au bitmap temporaire

  Bitmap.Canvas.FillRect(Rect(0, 0, Rectangle.Right - Rectangle.Left, Rectangle.Bottom - Rectangle.Top));  // Effacement du bitmap

  if Index < lstImage1.Items.Count then
  begin
    Bitmap.Canvas.TextOut(70, (Rectangle.Bottom - Rectangle.Top - Bitmap.Canvas.TextHeight(lstImage1.Items[Index])) div 2, lstImage1.Items[Index]);  // Ecrit le titre de l'image dans le bitmap temporaire
    CopieImage(Bitmap.Canvas, Rect(4, 2, 64, Rectangle.Bottom - Rectangle.Top - 4), TfrmMDIImage(ListeImages.Items[Index]).imgImage.Picture.Bitmap);  // Affiche la petite image � cot� du titre
  end;

  lstImage1.Canvas.CopyRect(Rectangle, Bitmap.Canvas, Rect(0, 0, Rectangle.Right - Rectangle.Left, Rectangle.Bottom - Rectangle.Top));  // Copie du bitmap temporaire dans le canvas de la liste

  Bitmap.Free;
end;

procedure TfrmHFiltreImageImage.lstImage2DrawItem(Control: TWinControl;
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
  Bitmap := TBitmap.Create;  // Cr�ation du Bitmap temporaire
  Bitmap.Width := Rectangle.Right - Rectangle.Left;  // Changement des dimensions
  Bitmap.Height := Rectangle.Bottom - Rectangle.Top;  // du bitmap temporaire

  Bitmap.Canvas.Font := lstImage2.Canvas.Font;  // Affectation des
  Bitmap.Canvas.Brush := lstImage2.Canvas.Brush;  // m�mes propri�t�s
  Bitmap.Canvas.Pen := lstImage2.Canvas.Pen;  // au bitmap temporaire

  Bitmap.Canvas.FillRect(Rect(0, 0, Rectangle.Right - Rectangle.Left, Rectangle.Bottom - Rectangle.Top));  // Effacement du bitmap

  if Index < lstImage2.Items.Count then
  begin
    Bitmap.Canvas.TextOut(70, (Rectangle.Bottom - Rectangle.Top - Bitmap.Canvas.TextHeight(lstImage2.Items[Index])) div 2, lstImage2.Items[Index]);  // Ecrit le titre de l'image dans le bitmap temporaire
    CopieImage(Bitmap.Canvas, Rect(4, 2, 64, Rectangle.Bottom - Rectangle.Top - 4), TfrmMDIImage(ListeImages.Items[Index]).imgImage.Picture.Bitmap);  // Affiche la petite image � cot� du titre
  end;

  lstImage2.Canvas.CopyRect(Rectangle, Bitmap.Canvas, Rect(0, 0, Rectangle.Right - Rectangle.Left, Rectangle.Bottom - Rectangle.Top));  // Copie du bitmap temporaire dans le canvas de la liste

  Bitmap.Free;
end;

procedure TfrmHFiltreImageImage.FormCreate(Sender: TObject);
begin
  imgPrevisualisation.Canvas.Pen.Color := clBlack;
  imgPrevisualisation.Canvas.Brush.Color := Color;

  CalcImagePrevisualisation := TCalcImage.Create;  // Cr�e le tableau de donn�es de l'image d pr�visualisation
  CalcImagePrevisualisation.ChangeDimensions(imgPrevisualisation.Width, imgPrevisualisation.Height);  // Dimensionne le tableau de donn�es

  CalcImagePrev1 := TCalcImage.Create;
  CalcImagePrev1.ChangeDimensions(imgPrevisualisation.Width, imgPrevisualisation.Height);

  CalcImagePrev2 := TCalcImage.Create;
  CalcImagePrev2.ChangeDimensions(imgPrevisualisation.Width, imgPrevisualisation.Height);
end;

procedure TfrmHFiltreImageImage.FormDestroy(Sender: TObject);
begin
  CalcImagePrevisualisation.Destroy;
  CalcImagePrev1.Destroy;
  CalcImagePrev2.Destroy;
end;

function TfrmHFiltreImageImage.EnabledOK: Boolean;
begin
  if (lstImage1.ItemIndex > -1) and (lstImage2.ItemIndex > -1) then  // Si 2 images sont s�lectionn�e
    Result := (TfrmMDIImage(Image1).CalcImage.TailleX = TfrmMDIImage(Image2).CalcImage.TailleX) and (TfrmMDIImage(Image1).CalcImage.TailleY = TfrmMDIImage(Image2).CalcImage.TailleY)  // V�rifie si les 2 images s�lectionn�es sont de la m�me taille
  else
    Result := False;
end;

procedure TfrmHFiltreImageImage.lstImage1Click(Sender: TObject);
begin
  Image1 := ListeImages.Items[lstImage1.ItemIndex];  // Pointe sur l'image s�lectionn�e

  imgPrevisualisation.Canvas.Rectangle(0, 0, imgPrevisualisation.Width, imgPrevisualisation.Height);  // Efface l'image de la pr�visualisation
  btnOK.Enabled := EnabledOK;  // V�rifie si les images sont "compatibles"
  PrevisualiseResultat;
end;

procedure TfrmHFiltreImageImage.lstImage2Click(Sender: TObject);
begin
  Image2 := ListeImages.Items[lstImage2.ItemIndex];  // Pointe sur l'image s�lectionn�e

  imgPrevisualisation.Canvas.Rectangle(0, 0, imgPrevisualisation.Width, imgPrevisualisation.Height);  // Efface l'image de la pr�visualisation
  btnOK.Enabled := EnabledOK;  // V�rifie si les images sont "compatibles"
  PrevisualiseResultat;
end;

procedure TfrmHFiltreImageImage.AffichePrevisualisation;
var
  X, Y : Integer;
begin
  for X := 0 to CalcImagePrevisualisation.TailleX - 1 do  // Parcourt tous les
    for Y := 0 to CalcImagePrevisualisation.TailleY - 1 do  // pixels de l'images
      imgPrevisualisation.Canvas.Pixels[X, Y] := CouleurToColor(CalcImagePrevisualisation.Image[X, Y]);
end;

procedure TfrmHFiltreImageImage.btnOKClick(Sender: TObject);
begin
  ListeImages.Add(TfrmMDIImage.Create(nil));  // Cr�e une nouvelle Form image
  TfrmMDIImage(ListeImages.Last).ChangerDimensionsImage(TfrmMDIImage(Image1).CalcImage.TailleX, TfrmMDIImage(Image1).CalcImage.TailleY);  // Redimensionne l'image
  TfrmMDIImage(ListeImages.Last).Caption := 'Image : ' + IntToStr(ListeImages.Count);  // Affiche le titre de l'image
end;

end.
