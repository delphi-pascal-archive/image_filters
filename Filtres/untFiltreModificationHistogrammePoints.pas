unit untFiltreModificationHistogrammePoints;

interface

uses
  StdCtrls, Controls, ExtCtrls, Classes, contnrs, Windows,
  untHFiltreImage, untCalcImage;

type
  THistogramme = (hRouge, hVert, hBleu);
  TPointHistogramme = class
  public
    X, Y : Integer;
    Visible : Boolean;
    constructor Create;
    destructor Destroy; override;
    procedure ChangerPosition(PX, PY : Integer);
  end;
  TParametreCub = record
    A, B, C, D : Double;
    X1, X2 : Integer;
  end;

type
  TfrmFiltreModificationHistogrammePoints = class(TfrmHFiltreImage)
    grbHistogrammes: TGroupBox;
    imgRouge: TImage;
    imgVert: TImage;
    imgBleu: TImage;
    chkTravailleGris: TCheckBox;
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure imgRougeMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgRougeMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure imgRougeMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgVertMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgBleuMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgVertMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure imgBleuMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure imgVertMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgBleuMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure chkTravailleGrisClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    PointsHistogrammes : array[THistogramme] of TObjectList;
    NombrePoints : array[THistogramme] of Integer;
    Parametres : array[THistogramme] of array of TParametreCub;

    ListePoints : array[THistogramme] of array of TPoint;

    Selection : Integer;


    procedure AfficherPoints(Histogramme : THistogramme);
    procedure TriePoints(Histogramme : THistogramme);
    procedure PrevisualiseResultat; override;
    procedure CalculParametres(Histogramme : THistogramme);
    procedure AjouterPoint(X, Y: Integer; Histogramme : THistogramme);
    procedure VisiblePoints(Histogramme : THistogramme);
    procedure SupprimeNonVisible(Histogramme : THistogramme);

    procedure ActMouseDown(Histogramme : THistogramme; X, Y : Integer; Shift : TShiftState);
    procedure ActMouseMove(Histogramme : THistogramme; X, Y : Integer; Shift : TShiftState);
  end;

procedure CalculerOperation(Image : TCalcImage; ParametresRouge, ParametresVert, ParametresBleu : array of TParametreCub; var ImageResultat : TCalcImage);

var
  frmFiltreModificationHistogrammePoints: TfrmFiltreModificationHistogrammePoints;

implementation

uses
  SysUtils, Graphics, Math,
  untMDIImage, untPrincipale;

{$R *.DFM}

{ TfrmFiltreModificationHistogrammePoints }

procedure TfrmFiltreModificationHistogrammePoints.PrevisualiseResultat;
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
    CalculerOperation(CalcImagePrev, Parametres[hRouge], Parametres[hBleu], Parametres[HVert], CalcImagePrevisualisation);  // Calcul l'image résultat de la prévisualisation

    AffichePrevisualisation;  // Affiche la prévisualisation
  end;
end;

procedure CalculerOperation(Image : TCalcImage; ParametresRouge, ParametresVert, ParametresBleu : array of TParametreCub; var ImageResultat : TCalcImage);
var
  X, Y : Integer;
  NumParametre : Integer;
  NumeroParametre : array[THistogramme] of array[0..255] of Integer;
  CouleurRouge : Integer;
  CouleurVert : Integer;
  CouleurBleu : Integer;
begin
  for NumParametre := 1 to Length(ParametresRouge) - 1 do  // Permet de
    for X := ParametresRouge[NumParametre].X1 to ParametresRouge[NumParametre].X2 do  // gagner
      NumeroParametre[hRouge][X] := NumParametre;  // du temps

  for NumParametre := 1 to Length(ParametresVert) - 1 do  // Permet de
    for X := ParametresVert[NumParametre].X1 to ParametresVert[NumParametre].X2 do  // gagner
      NumeroParametre[hVert][X] := NumParametre;  // du temps

  for NumParametre := 1 to Length(ParametresBleu) - 1 do  // Permet de
    for X := ParametresBleu[NumParametre].X1 to ParametresBleu[NumParametre].X2 do  // gagner
      NumeroParametre[hBleu][X] := NumParametre;  // du temps

  frmPrincipale.ChangeStatus('Calcul');
  frmPrincipale.ProgressBar.Max := Image.TailleX - 1;
  for X := 0 to Image.TailleX - 1 do  // Parcourt tous les pixels
  begin
    frmPrincipale.ProgressBar.Position := X;
    for Y := 0 to Image.TailleY - 1 do  // de l'image
    begin
      CouleurRouge := LimiteCouleur(Image.Image[X, Y].Rouge);
      ImageResultat.Image[X, Y].Rouge := Power(CouleurRouge, 3) * ParametresRouge[NumeroParametre[hRouge][CouleurRouge]].A + Sqr(CouleurRouge) * ParametresRouge[NumeroParametre[hRouge][CouleurRouge]].B + CouleurRouge * ParametresRouge[NumeroParametre[hRouge][CouleurRouge]].C + ParametresRouge[NumeroParametre[hRouge][CouleurRouge]].D;

      CouleurVert := LimiteCouleur(Image.Image[X, Y].Vert);
      ImageResultat.Image[X, Y].Vert := Power(CouleurVert, 3) * ParametresVert[NumeroParametre[hVert][CouleurVert]].A + Sqr(CouleurVert) * ParametresVert[NumeroParametre[hVert][CouleurVert]].B + CouleurVert * ParametresVert[NumeroParametre[hVert][CouleurVert]].C + ParametresVert[NumeroParametre[hVert][CouleurVert]].D;

      CouleurBleu := LimiteCouleur(Image.Image[X, Y].Bleu);
      ImageResultat.Image[X, Y].Bleu := Power(CouleurBleu, 3) * ParametresBleu[NumeroParametre[hBleu][CouleurBleu]].A + Sqr(CouleurBleu) * ParametresBleu[NumeroParametre[hBleu][CouleurBleu]].B + CouleurBleu * ParametresBleu[NumeroParametre[hBleu][CouleurBleu]].C + ParametresBleu[NumeroParametre[hBleu][CouleurBleu]].D;
    end;
  end;
  frmPrincipale.FinCalcul;
end;

procedure TfrmFiltreModificationHistogrammePoints.btnOKClick(Sender: TObject);
begin
  inherited;
  TfrmMDIImage(ListeImages.Last).Caption := Format('ModifieHistogrammes(%s)', [TfrmMDIImage(Image).Caption]);  // Affiche le titre de l'image

  CalculerOperation(TfrmMDIImage(Image).CalcImage, Parametres[hRouge], Parametres[hBleu], Parametres[HVert], TfrmMDIImage(ListeImages.Last).CalcImage);  // Calcul le résultat

  TfrmMDIImage(ListeImages.Last).AfficheImage;  // Affiche le résultat
end;

procedure TfrmFiltreModificationHistogrammePoints.FormCreate(
  Sender: TObject);
begin
  inherited;

  PointsHistogrammes[hRouge] := TObjectList.Create;  // Crée les listes
  PointsHistogrammes[hVert] := TObjectList.Create;  // contenants les points
  PointsHistogrammes[hBleu] := TObjectList.Create;  // des équations

  AjouterPoint(0, 0, hRouge);  // Ajoute 2 fois
  AjouterPoint(0, 0, hRouge);  // chaque point
  AjouterPoint(0, 0, hVert);  // car ils seront
  AjouterPoint(0, 0, hVert);  // utilisés dans la
  AjouterPoint(0, 0, hBleu);  // fonction cubique
  AjouterPoint(0, 0, hBleu);  // du troisième degré

  AjouterPoint(255, 255, hRouge);  // Ajoute 2 fois
  AjouterPoint(255, 255, hRouge);  // chaque point
  AjouterPoint(255, 255, hVert);  // car ils seront
  AjouterPoint(255, 255, hVert);  // utilisés dans la
  AjouterPoint(255, 255, hBleu);  // fonction cubique
  AjouterPoint(255, 255, hBleu);  // du troisième degré

  imgRouge.Canvas.Brush.Color := clBlack;
  imgVert.Canvas.Brush.Color := clBlack;
  imgBleu.Canvas.Brush.Color := clBlack;

  imgRouge.Canvas.Pen.Color := clRed;
  imgVert.Canvas.Pen.Color := clGreen;
  imgBleu.Canvas.Pen.Color := clBlue;

  TriePoints(hRouge);
  TriePoints(hVert);
  TriePoints(hBleu);

  CalculParametres(hRouge);
  CalculParametres(hVert);
  CalculParametres(hBleu);

  AfficherPoints(hRouge);
  AfficherPoints(hVert);
  AfficherPoints(hBleu);
end;

procedure TfrmFiltreModificationHistogrammePoints.FormShow(
  Sender: TObject);
begin
  inherited;

  imgRouge.Canvas.Rectangle(0, 0, 256, 256);  // Efface les précédents
  imgVert.Canvas.Rectangle(0, 0, 256, 256);  // points dessinés
  imgBleu.Canvas.Rectangle(0, 0, 256, 256);  // de les images

  AfficherPoints(hRouge);
  AfficherPoints(hVert);
  AfficherPoints(hBleu);
end;

procedure TfrmFiltreModificationHistogrammePoints.imgRougeMouseDown(
  Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
var
  NumSelection : Integer;
begin
  NumSelection := Selection;  // Sauvegarde la valeur de Selection
  ActMouseDown(hRouge, X, Y, Shift);
  if chkTravailleGris.Checked then
  begin
    Selection := NumSelection;  // Remet la valeur de selection pour eviter des bugs
    ActMouseDown(hVert, X, Y, Shift);
    Selection := NumSelection;  // Remet la valeur de selection pour eviter des bugs
    ActMouseDown(hBleu, X, Y, Shift);
  end;
end;

procedure TfrmFiltreModificationHistogrammePoints.AfficherPoints(Histogramme: THistogramme);
var
  NumPoint : Integer;
  X : Integer;
begin
  if Histogramme = hRouge then
  begin
    imgRouge.Canvas.Rectangle(0, 0, 256, 256);  // Efface les précédents points dessinés dans l'image
    imgRouge.Canvas.MoveTo(0, 255);
    for NumPoint := 2 to NombrePoints[Histogramme] - 2 do  // Parcourt tous les points
    begin
      imgRouge.Canvas.Rectangle(TPointHistogramme(PointsHistogrammes[Histogramme].Items[NumPoint]).X - 2, 255 - TPointHistogramme(PointsHistogrammes[Histogramme].Items[NumPoint]).Y - 2, TPointHistogramme(PointsHistogrammes[Histogramme].Items[NumPoint]).X + 2, 255 - TPointHistogramme(PointsHistogrammes[Histogramme].Items[NumPoint]).Y + 2);  // Affiche le point
      for X := TPointHistogramme(PointsHistogrammes[Histogramme].Items[NumPoint - 1]).X to TPointHistogramme(PointsHistogrammes[Histogramme].Items[NumPoint]).X do
      begin
        imgRouge.Canvas.LineTo(X, 255 - Round(Power(X, 3) * Parametres[Histogramme][NumPoint - 1].A + Sqr(X) * Parametres[Histogramme][NumPoint - 1].B + X * Parametres[Histogramme][NumPoint - 1].C + Parametres[Histogramme][NumPoint - 1].D));  // Affiche la courbe
      end;
    end;
  end;

  if Histogramme = hVert then
  begin
    imgVert.Canvas.Rectangle(0, 0, 256, 256);  // Efface les précédents points dessinés dans l'image
    imgVert.Canvas.MoveTo(0, 255);
    for NumPoint := 2 to NombrePoints[Histogramme] - 2 do  // Parcourt tous les points
    begin
      imgVert.Canvas.Rectangle(TPointHistogramme(PointsHistogrammes[Histogramme].Items[NumPoint]).X - 2, 255 - TPointHistogramme(PointsHistogrammes[Histogramme].Items[NumPoint]).Y - 2, TPointHistogramme(PointsHistogrammes[Histogramme].Items[NumPoint]).X + 2, 255 - TPointHistogramme(PointsHistogrammes[Histogramme].Items[NumPoint]).Y + 2);  // Affiche le point
      for X := TPointHistogramme(PointsHistogrammes[Histogramme].Items[NumPoint - 1]).X to TPointHistogramme(PointsHistogrammes[Histogramme].Items[NumPoint]).X do
      begin
        imgVert.Canvas.LineTo(X, 255 - Round(Power(X, 3) * Parametres[Histogramme][NumPoint - 1].A + Sqr(X) * Parametres[Histogramme][NumPoint - 1].B + X * Parametres[Histogramme][NumPoint - 1].C + Parametres[Histogramme][NumPoint - 1].D));  // Affiche la courbe
      end;
    end;
  end;

  if Histogramme = hBleu then
  begin
    imgBleu.Canvas.Rectangle(0, 0, 256, 256);  // Efface les précédents points dessinés dans l'image
    imgBleu.Canvas.MoveTo(0, 255);
    for NumPoint := 2 to NombrePoints[Histogramme] - 2 do  // Parcourt tous les points
    begin
      imgBleu.Canvas.Rectangle(TPointHistogramme(PointsHistogrammes[Histogramme].Items[NumPoint]).X - 2, 255 - TPointHistogramme(PointsHistogrammes[Histogramme].Items[NumPoint]).Y - 2, TPointHistogramme(PointsHistogrammes[Histogramme].Items[NumPoint]).X + 2, 255 - TPointHistogramme(PointsHistogrammes[Histogramme].Items[NumPoint]).Y + 2);  // Affiche le point
      for X := TPointHistogramme(PointsHistogrammes[Histogramme].Items[NumPoint - 1]).X to TPointHistogramme(PointsHistogrammes[Histogramme].Items[NumPoint]).X do
      begin
        imgBleu.Canvas.LineTo(X, 255 - Round(Power(X, 3) * Parametres[Histogramme][NumPoint - 1].A + Sqr(X) * Parametres[Histogramme][NumPoint - 1].B + X * Parametres[Histogramme][NumPoint - 1].C + Parametres[Histogramme][NumPoint - 1].D));  // Affiche la courbe
      end;
    end;
  end;
end;

procedure TfrmFiltreModificationHistogrammePoints.TriePoints(Histogramme: THistogramme);

  procedure Swap(var Point1, Point2 : Integer);
  var
    Point : Integer;
  begin
    Point := Point1;  // Inverse
    Point1 := Point2;  // les deux
    Point2 := Point;  // points
  end;

var
  NumPoint : Integer;
  NumPoint2 : Integer;
begin
  NombrePoints[Histogramme] := 0;

  for NumPoint := 0 to PointsHistogrammes[Histogramme].Count - 1 do
    if TPointHistogramme(PointsHistogrammes[Histogramme].Items[NumPoint]).Visible then  // Compte le nombre
      Inc(NombrePoints[Histogramme]);  // de points visibles

  for NumPoint := 0 to NombrePoints[Histogramme] - 2 do
    if not TPointHistogramme(PointsHistogrammes[Histogramme].Items[NumPoint]).Visible then
    begin
      Swap(TPointHistogramme(PointsHistogrammes[Histogramme].Items[NumPoint]).X, TPointHistogramme(PointsHistogrammes[Histogramme].Items[PointsHistogrammes[Histogramme].Count - 1]).X);  // Met les points
      Swap(TPointHistogramme(PointsHistogrammes[Histogramme].Items[NumPoint]).Y, TPointHistogramme(PointsHistogrammes[Histogramme].Items[PointsHistogrammes[Histogramme].Count - 1]).Y);  // visibles "devants"
      TPointHistogramme(PointsHistogrammes[Histogramme].Items[NumPoint]).Visible := True;  // les points
      TPointHistogramme(PointsHistogrammes[Histogramme].Items[PointsHistogrammes[Histogramme].Count - 1]).Visible := False;  // non visibles
    end;

  for NumPoint := 0 to NombrePoints[Histogramme] - 2 do
    for NumPoint2 := NumPoint + 1 to NombrePoints[Histogramme] - 1 do
      if TPointHistogramme(PointsHistogrammes[Histogramme].Items[NumPoint]).X > TPointHistogramme(PointsHistogrammes[Histogramme].Items[NumPoint2]).X then
      begin
        if Selection = NumPoint then
          Selection := NumPoint2
        else
          if Selection = NumPoint2 then
            Selection := NumPoint;
        Swap(TPointHistogramme(PointsHistogrammes[Histogramme].Items[NumPoint]).X, TPointHistogramme(PointsHistogrammes[Histogramme].Items[NumPoint2]).X);  // Trie par ordre croissant
        Swap(TPointHistogramme(PointsHistogrammes[Histogramme].Items[NumPoint]).Y, TPointHistogramme(PointsHistogrammes[Histogramme].Items[NumPoint2]).Y);  // les points visibles
      end;
end;

procedure TfrmFiltreModificationHistogrammePoints.CalculParametres(Histogramme: THistogramme);
var
  NumPoint : Integer;
  X1, Y1, X2, Y2, X3, Y3 : Integer;

  X12, X13, X22, X23 : Single;
  Den : Single;
  YY1, YY2 : Single;
begin
  SetLength(Parametres[Histogramme], NombrePoints[Histogramme] - 2);

  YY2 := 0;
  for NumPoint := 0 to NombrePoints[Histogramme] - 3 do
  begin
    X1 := TPointHistogramme(PointsHistogrammes[Histogramme].Items[NumPoint]).X;  // Permet
    Y1 := TPointHistogramme(PointsHistogrammes[Histogramme].Items[NumPoint]).Y;  // de
    X2 := TPointHistogramme(PointsHistogrammes[Histogramme].Items[NumPoint + 1]).X;  // prendre
    Y2 := TPointHistogramme(PointsHistogrammes[Histogramme].Items[NumPoint + 1]).Y;  // moins
    X3 := TPointHistogramme(PointsHistogrammes[Histogramme].Items[NumPoint + 2]).X;  // de
    Y3 := TPointHistogramme(PointsHistogrammes[Histogramme].Items[NumPoint + 2]).Y;  // place

    YY1 := YY2;
    if X3 = X1 then
      YY2 := (Y3 - Y1) / 0.01
    else
      YY2 := (Y3 - Y1) / (X3 - X1);

    if X1 - X2 = 0 then
      Den := 0.01
    else
      Den := X1 - X2;
    Den := Den * Den * Den;

    X12 := Sqr(X1);
    X13 := X12 * X1;
    X22 := Sqr(X2);
    X23 := X22 * X2;

    Parametres[Histogramme][NumPoint].A := (x1 * yy1 + x1 * yy2 + 2 * y2 - 2 * y1 - yy1 * x2 - yy2 * x2) / Den;  // Calcul des paramètres de la fonction cubique
    Parametres[Histogramme][NumPoint].B := -(x12 * yy1 + 2 * x12 * yy2 - 3 * x1 * y1 - x1 * yy2 * x2 + 3 * x1 * y2 + x1 * yy1 * x2 - 2 * yy1 * x22 - 3 * x2 * y1 - x22 * yy2 +3 * x2 * y2) / Den;  // Cette partie du code
    Parametres[Histogramme][NumPoint].C := (yy2 * x13  + 2 * x12 * yy1 * x2 + x12 * yy2 * x2 - 6 * x1 * y1 * x2 - 2 * x22 * X1 * yy2 + 6 * x1 * y2 * x2 -yy1 * x22 * x1 - yy1 * x23) / Den;  // viens de la source : http://www.delphifr.com/code.aspx?id=17067
    Parametres[Histogramme][NumPoint].D := -(-x13 * y2 + yy2 * x13 * x2 - x12 * x22 * yy2 + 3 * x12 * x2 * y2 + yy1  *x22 * x12 - 3 * y1 * x22 * x1 - x1 * yy1 * x23 + y1 * x23) / Den;  // de daniel.maho

    Parametres[Histogramme][NumPoint].X1 := X1;
    Parametres[Histogramme][NumPoint].X2 := X2;
  end;
end;

procedure TfrmFiltreModificationHistogrammePoints.AjouterPoint(X, Y: Integer; Histogramme : THistogramme);
var
  Point : TPointHistogramme;
begin
  Point := TPointHistogramme.Create;
  Point.ChangerPosition(X, Y);

  PointsHistogrammes[Histogramme].Add(Point);
end;

procedure TfrmFiltreModificationHistogrammePoints.VisiblePoints(Histogramme : THistogramme);
var
  NumPoint : Integer;
begin
  for NumPoint := 0 to PointsHistogrammes[Histogramme].Count - 1 do
    TPointHistogramme(PointsHistogrammes[Histogramme].Items[NumPoint]).Visible := True;

  for NumPoint := 0 to PointsHistogrammes[Histogramme].Count - 1 do
    if (NumPoint <> Selection) and (TPointHistogramme(PointsHistogrammes[Histogramme].Items[NumPoint]).X = TPointHistogramme(PointsHistogrammes[Histogramme].Items[Selection]).X) then
      TPointHistogramme(PointsHistogrammes[Histogramme].Items[NumPoint]).Visible := False
    else
      TPointHistogramme(PointsHistogrammes[Histogramme].Items[NumPoint]).Visible := True;
end;

procedure TfrmFiltreModificationHistogrammePoints.SupprimeNonVisible(Histogramme : THistogramme);
var
  NumPoint : Integer;
begin
  for NumPoint := PointsHistogrammes[Histogramme].Count - 1 downto 0 do
    if not TPointHistogramme(PointsHistogrammes[Histogramme].Items[NumPoint]).Visible then
      PointsHistogrammes[Histogramme].Delete(NumPoint)  // Supprime les points non visibles
    else
      Break;
end;

{ TPointHistogramme }

procedure TPointHistogramme.ChangerPosition(PX, PY : Integer);
begin
  X := PX;
  Y := PY;
end;

constructor TPointHistogramme.Create;
begin
  X := 0;  // Initialise les positions du
  Y := 0;  // points au valeur (0, 0)
  Visible := True;
end;

destructor TPointHistogramme.Destroy;
begin
  inherited;

end;

procedure TfrmFiltreModificationHistogrammePoints.imgRougeMouseMove(
  Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  NumSelection : Integer;
begin
  NumSelection := Selection;  // Sauvegarde la valeur de Selection
  ActMouseMove(hRouge, X, Y, Shift);
  if chkTravailleGris.Checked then
  begin
    Selection := NumSelection;  // Remet la valeur de selection pour eviter des bugs
    ActMouseMove(hVert, X, Y, Shift);
    Selection := NumSelection;  // Remet la valeur de selection pour eviter des bugs
    ActMouseMove(hBleu, X, Y, Shift);
  end;
end;

procedure TfrmFiltreModificationHistogrammePoints.imgRougeMouseUp(
  Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  SupprimeNonVisible(hRouge);
  if chkTravailleGris.Checked then
  begin
    SupprimeNonVisible(hVert);
    SupprimeNonVisible(hBleu);
  end;
  PrevisualiseResultat;
end;

procedure TfrmFiltreModificationHistogrammePoints.imgVertMouseDown(
  Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
var
  NumSelection : Integer;
begin
  NumSelection := Selection;  // Sauvegarde la valeur de Selection
  ActMouseDown(hVert, X, Y, Shift);
  if chkTravailleGris.Checked then
  begin
    Selection := NumSelection;  // Remet la valeur de selection pour eviter des bugs
    ActMouseDown(hRouge, X, Y, Shift);
    Selection := NumSelection;  // Remet la valeur de selection pour eviter des bugs
    ActMouseDown(hBleu, X, Y, Shift);
  end;
end;

procedure TfrmFiltreModificationHistogrammePoints.imgBleuMouseDown(
  Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
var
  NumSelection : Integer;
begin
  NumSelection := Selection;  // Sauvegarde la valeur de Selection
  ActMouseDown(hBleu, X, Y, Shift);
  if chkTravailleGris.Checked then
  begin
    Selection := NumSelection;  // Remet la valeur de selection pour eviter des bugs
    ActMouseDown(hRouge, X, Y, Shift);
    Selection := NumSelection;  // Remet la valeur de selection pour eviter des bugs
    ActMouseDown(hVert, X, Y, Shift);
  end;
end;

procedure TfrmFiltreModificationHistogrammePoints.imgVertMouseMove(
  Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  NumSelection : Integer;
begin
  NumSelection := Selection;  // Sauvegarde la valeur de Selection
  ActMouseMove(hVert, X, Y, Shift);
  if chkTravailleGris.Checked then
  begin
    Selection := NumSelection;  // Remet la valeur de selection pour eviter des bugs
    ActMouseMove(hRouge, X, Y, Shift);
    Selection := NumSelection;  // Remet la valeur de selection pour eviter des bugs
    ActMouseMove(hBleu, X, Y, Shift);
  end;
end;

procedure TfrmFiltreModificationHistogrammePoints.imgBleuMouseMove(
  Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  NumSelection : Integer;
begin
  NumSelection := Selection;  // Sauvegarde la valeur de Selection
  ActMouseMove(hBleu, X, Y, Shift);
  if chkTravailleGris.Checked then
  begin
    Selection := NumSelection;  // Remet la valeur de selection pour eviter des bugs
    ActMouseMove(hRouge, X, Y, Shift);
    Selection := NumSelection;  // Remet la valeur de selection pour eviter des bugs
    ActMouseMove(hVert, X, Y, Shift);
  end;
end;

procedure TfrmFiltreModificationHistogrammePoints.imgVertMouseUp(
  Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  SupprimeNonVisible(hVert);
  if chkTravailleGris.Checked then
  begin
    SupprimeNonVisible(hRouge);
    SupprimeNonVisible(hBleu);
  end;
  PrevisualiseResultat;
end;

procedure TfrmFiltreModificationHistogrammePoints.imgBleuMouseUp(
  Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  SupprimeNonVisible(hBleu);
  if chkTravailleGris.Checked then
  begin
    SupprimeNonVisible(hRouge);
    SupprimeNonVisible(hVert);
  end;
  PrevisualiseResultat;
end;

procedure TfrmFiltreModificationHistogrammePoints.ActMouseDown(
  Histogramme: THistogramme; X, Y: Integer; Shift: TShiftState);
var
  NumPoint : Integer;
  MinDistance : Double;
  Distance : Double;
  NumeroPoint : Integer;
begin
  if ssLeft in Shift then
  begin
    NumeroPoint := -1;  // Aucun point n'est sélectionné
    MinDistance := 5;  // Aucun point n'est sélectionné si il n'est pas à moins de 5 pixels de la souris
    for NumPoint := 2 to PointsHistogrammes[Histogramme].Count - 3 do  // Parcourt tous les points "utilisateur"
    begin
      Distance := Sqrt(Sqr(TPointHistogramme(PointsHistogrammes[Histogramme].Items[NumPoint]).X - X) + Sqr(TPointHistogramme(PointsHistogrammes[Histogramme].Items[NumPoint]).Y - (255 - Y)));  // Calcul la distance entre la souris et le Point
      if Distance < MinDistance then  // Si il est plus proche de la souris que le dernier
      begin
        MinDistance := Distance;  // La distance minimale est mise à jour
        NumeroPoint := NumPoint;  // Le point sélectionné est le point le plus proche
      end;
    end;
    if NumeroPoint <> -1 then  // Si un point est selectionné
    begin
      Selection := NumeroPoint;  // On le sélectionne
      TPointHistogramme(PointsHistogrammes[Histogramme].Items[Selection]).X := X;  // On met à jour
      TPointHistogramme(PointsHistogrammes[Histogramme].Items[Selection]).Y := 255 - Y;  // sa position
    end
    else
    begin
      AjouterPoint(X, 255 - Y, Histogramme);  // On l'ajoute

      Selection := PointsHistogrammes[Histogramme].Count - 1;
    end;
    Histogramme := Histogramme;

    VisiblePoints(Histogramme);
    TriePoints(Histogramme);
    CalculParametres(Histogramme);
    AfficherPoints(Histogramme);
  end;
  if ssRight in Shift then
  begin
    NumeroPoint := -1;  // Aucun point ne peut-être effacé
    MinDistance := 5;  // Aucun point n'est supprimé si il n'est pas à moins de 5 pixels de la souris
    for NumPoint := 2 to PointsHistogrammes[Histogramme].Count - 3 do  // Parcourt tous les points "utilisateur"
    begin
      Distance := Sqrt(Sqr(TPointHistogramme(PointsHistogrammes[Histogramme].Items[NumPoint]).X - X) + Sqr(TPointHistogramme(PointsHistogrammes[Histogramme].Items[NumPoint]).Y - (255 - Y)));  // Calcul la distance entre la souris et le Point
      if Distance < MinDistance then  // Si il est plus proche de la souris que le dernier
      begin
        MinDistance := Distance;  // La distance minimale est mise à jour
        NumeroPoint := NumPoint;  // Le point sélectionné est le point le plus proche
      end;
    end;
    if NumeroPoint <> -1 then  // Si un point est selectionné
      PointsHistogrammes[Histogramme].Delete(NumeroPoint);  // On le supprime

    TriePoints(Histogramme);
    CalculParametres(Histogramme);
    AfficherPoints(Histogramme);
  end;
end;

procedure TfrmFiltreModificationHistogrammePoints.ActMouseMove(
  Histogramme: THistogramme; X, Y: Integer; Shift: TShiftState);
begin
  if (ssLeft in Shift) and (X > 0) and (X < 255) and (Y > 0) and (Y < 255) then
  begin
    TPointHistogramme(PointsHistogrammes[Histogramme].Items[Selection]).ChangerPosition(X, 255 - Y);

    VisiblePoints(Histogramme);
    TriePoints(Histogramme);
    CalculParametres(Histogramme);
    AfficherPoints(Histogramme);
  end;
end;

procedure TfrmFiltreModificationHistogrammePoints.chkTravailleGrisClick(
  Sender: TObject);
var
  NumPoint : Integer;
begin
  if chkTravailleGris.Checked then
  begin
    NombrePoints[hVert] := NombrePoints[hRouge];
    NombrePoints[hBleu] := NombrePoints[hRouge];

    PointsHistogrammes[hVert].Clear;
    PointsHistogrammes[hBleu].Clear;

    for NumPoint := 0 to PointsHistogrammes[hRouge].Count - 1 do
    begin
      AjouterPoint(TPointHistogramme(PointsHistogrammes[hRouge].Items[NumPoint]).X, TPointHistogramme(PointsHistogrammes[hRouge].Items[NumPoint]).Y, hVert);
      AjouterPoint(TPointHistogramme(PointsHistogrammes[hRouge].Items[NumPoint]).X, TPointHistogramme(PointsHistogrammes[hRouge].Items[NumPoint]).Y, hBleu);
      TPointHistogramme(PointsHistogrammes[hVert].Items[NumPoint]).Visible := TPointHistogramme(PointsHistogrammes[hRouge].Items[NumPoint]).Visible;
      TPointHistogramme(PointsHistogrammes[hBleu].Items[NumPoint]).Visible := TPointHistogramme(PointsHistogrammes[hRouge].Items[NumPoint]).Visible;
    end;

    CalculParametres(hVert);
    CalculParametres(hBleu);
    AfficherPoints(hVert);
    AfficherPoints(hBleu);
  end;
end;

end.
