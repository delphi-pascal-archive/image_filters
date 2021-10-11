unit untCalcImage;

interface

type
  TCouleur = record
    Rouge, Vert, Bleu : Double;  // Le type Double permet de ne pas perdre d'informations après une division ou d'autres opérations
  end;
  TCouleurHistogramme = record
    Rouge, Vert, Bleu : Integer;
  end;

type
  TCalcImage = class
  private
    FTailleX : Integer;
    FTailleY : Integer;

    procedure ChangeTailleX(const Value : Integer);
    procedure ChangeTailleY(const Value : Integer);

  public
    Image : array of array of TCouleur;

    Histogramme : array[0..255] of TCouleurHistogramme;

    property TailleX : Integer read FTailleX write ChangeTailleX;
    property TailleY : Integer read FTailleY write ChangeTailleY;

    procedure ChangeDimensions(X, Y : Integer);

    procedure CalculerHistogramme;

    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses
  untMDIImage, untPrincipale;

{ TCalcImage }

procedure TCalcImage.CalculerHistogramme;
var
  X, Y : Integer;
  NumCouleur : Integer;
begin
  frmPrincipale.ChangeStatus('Calcul de l''histogramme de l''image');
  for NumCouleur := 0 to 255 do
  begin
    Histogramme[NumCouleur].Rouge := 0;  // Remet à zero
    Histogramme[NumCouleur].Vert := 0;  // toutes les valeurs
    Histogramme[NumCouleur].Bleu := 0;  // des histogrammes
  end;

  frmPrincipale.ProgressBar.Max := TailleX - 1;
  for X := 0 to TailleX - 1 do
  begin
    frmPrincipale.ProgressBar.Position := X;
    for Y := 0 to TailleY - 1 do
    begin
      Inc(Histogramme[LimiteCouleur(Image[X, Y].Rouge)].Rouge);  // "Compte" le nombre
      Inc(Histogramme[LimiteCouleur(Image[X, Y].Vert)].Vert);  // de points de telle ou
      Inc(Histogramme[LimiteCouleur(Image[X, Y].Bleu)].Bleu);  // telle couleur
    end;
  end;
end;

procedure TCalcImage.ChangeDimensions(X, Y: Integer);
begin
  FTailleX := X;
  FTailleY := Y;

  SetLength(Image, FTailleX, FTailleY);  // Redimensionne la taille du tableau de données
end;

procedure TCalcImage.ChangeTailleX(const Value: Integer);
begin
  FTailleX := Value;

  SetLength(Image, FTailleX, FTailleY);  // Redimensionne la taille du tableau de données
end;

procedure TCalcImage.ChangeTailleY(const Value: Integer);
begin
  FTailleY := Value;

  SetLength(Image, FTailleX, FTailleY);  // Redimensionne la taille du tableau de données
end;

constructor TCalcImage.Create;
begin
  inherited;
end;

destructor TCalcImage.Destroy;
begin
  inherited;
end;

end.
