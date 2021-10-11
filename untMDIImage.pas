unit untMDIImage;

interface

uses
  Classes, Forms, Controls, ExtCtrls, Menus, StdCtrls, Windows, Graphics, 
  untCalcImage;

type
  TfrmMDIImage = class(TForm)
    imgImage: TImage;
    PopupMenu: TPopupMenu;
    mnuEnregistrerImage: TMenuItem;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure imgImageMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    CalcImage : TCalcImage;

    procedure OuvrirImage(NomFichier : string);
    procedure EnregistrerImage(NomFichier : string);

    procedure AnalyseImage;
    procedure AfficheImage;
    procedure ChangerDimensionsImage(X, Y : Integer);
  end;

function LimiteCouleur(Couleur : Double) : Byte;
function CouleurToColor(Couleur : TCouleur) : TColor;

var
  frmMDIImage: TfrmMDIImage;

implementation

uses
  SysUtils, Math,
  untPrincipale;

{$R *.DFM}

{ TfrmMDIImage }

function CouleurToColor(Couleur : TCouleur) : TColor;
begin
  Result := LimiteCouleur(Couleur.Rouge) or (LimiteCouleur(Couleur.Vert) shl 8) or (LimiteCouleur(Couleur.Bleu) shl 16);  // Calcul la couleur du pixel
end;

procedure TfrmMDIImage.AnalyseImage;
var
  X, Y : Integer;
  Couleur : TColor;
begin
  frmPrincipale.ChangeStatus('Analyse de l''image');
  frmPrincipale.ProgressBar.Max := CalcImage.TailleX - 1;
  for X := 0 to CalcImage.TailleX - 1 do  // On parcourt tous
  begin
    frmPrincipale.ProgressBar.Position := X;
    for Y := 0 to CalcImage.TailleY - 1 do  // les pixels de l'image
      with CalcImage.Image[X, Y] do
      begin
        Couleur := imgImage.Canvas.Pixels[X, Y];
        Rouge := (Couleur and $000000FF);  // Calcul les différents
        Vert := (Couleur and $0000FF00) shr 8;  // composants de la couleur
        Bleu := (Couleur and $00FF0000) shr 16;  // à partir d'un pixel
      end;
  end;
end;

procedure TfrmMDIImage.EnregistrerImage(NomFichier: string);
begin
  imgImage.Picture.SaveToFile(NomFichier);  // Enregistre l'image
end;

procedure TfrmMDIImage.OuvrirImage(NomFichier: string);
begin
  imgImage.Picture.LoadFromFile(NomFichier);  // Ouvre et affiche l'image dans la fiche

  ChangerDimensionsImage(imgImage.Picture.Width, imgImage.Picture.Height);  // Redimension le tableau de données à la taille de l'image

  AnalyseImage;  // Procédure qui va analyser tous les pixels de l'images et va les mettres dans le tableau Image du CalcImage

  CalcImage.CalculerHistogramme;  // Calcul l'histogramme pour chaque couleur
  frmPrincipale.ChangeStatus('Prêt');
  frmPrincipale.ProgressBar.Position := 0;
end;

procedure TfrmMDIImage.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;  // Ferme la fiche et libère l'espace alloué par celle-ci
end;

procedure TfrmMDIImage.AfficheImage;
var
  X, Y : Integer;
begin
  imgImage.Picture.Bitmap.Width := CalcImage.TailleX;  // Met l'image
  imgImage.Picture.Bitmap.Height := CalcImage.TailleY;  // aux bonnes dimensions

  frmPrincipale.ChangeStatus('Affichage de l''image');
  frmPrincipale.ProgressBar.Max := CalcImage.TailleX - 1;
  for X := 0 to CalcImage.TailleX - 1 do  // Parcourt tous les
  begin
    frmPrincipale.ProgressBar.Position := X;
    for Y := 0 to CalcImage.TailleY - 1 do  // pixels de l'images
      imgImage.Canvas.Pixels[X, Y] := CouleurToColor(CalcImage.Image[X, Y]);
  end;

  CalcImage.CalculerHistogramme;

  frmPrincipale.FinCalcul;
end;

function LimiteCouleur(Couleur: Double): Byte;
begin
  Result := Round(Max(Min(255, Couleur), 0)); // Met la couleur de type Double sous forme d'un Byte;
end;

procedure TfrmMDIImage.FormDestroy(Sender: TObject);
begin
  CalcImage.Destroy;

  ListeImages.Extract(Self);  // Supprime la fiche de la liste des images (ici je n'utilise pas la procédure Delete car celle-ci appelle l'évènement OnDestroy et créerait donc une référence circulaire)
end;

procedure TfrmMDIImage.FormCreate(Sender: TObject);
begin
  DoubleBuffered := True;
  CalcImage := TCalcImage.Create;  // Crée le composant qui contient l'image sous forme de tableau
end;

procedure TfrmMDIImage.ChangerDimensionsImage(X, Y: Integer);
begin
  imgImage.Picture.Bitmap.Width := X;
  imgImage.Picture.Bitmap.Height := Y;
  CalcImage.ChangeDimensions(X, Y);

  { TODO : Barres de défilement }
end;

procedure TfrmMDIImage.imgImageMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  X := X - (imgImage.Width - imgImage.Picture.Width) div 2;  // Calcul la position du curseur sur l'image
  if (X < 0) or (X > imgImage.Picture.Width) then  // Verifie si le curseur est sur l'image
    X := -1;
  Y := Y - (imgImage.Height - imgImage.Picture.Height) div 2;  // Calcul la position du curseur sur l'image
  if (Y < 0) or (Y > imgImage.Picture.Height) then  // Verifie si le curseur est sur l'image
    Y := -1;

  frmPrincipale.ChangeCoordonneesCurseur(X, Y);
end;

end.
