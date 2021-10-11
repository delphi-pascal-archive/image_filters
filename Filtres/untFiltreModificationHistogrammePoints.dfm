inherited frmFiltreModificationHistogrammePoints: TfrmFiltreModificationHistogrammePoints
  Left = 176
  Top = 131
  Width = 825
  Height = 588
  Caption = 'Modification de l'#39'Histogramme d'#39'une Image par série de Points'
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited bvbImages: TBevel
    Width = 665
  end
  inherited imgPrevisualisation: TImage
    Left = 680
  end
  inherited lblPrevisualisation: TLabel
    Left = 680
  end
  inherited btnOK: TButton
    Left = 732
  end
  inherited btnAnnuler: TButton
    Left = 732
  end
  inherited lstImage: TListBox
    Width = 649
  end
  object grbHistogrammes: TGroupBox
    Left = 8
    Top = 232
    Width = 801
    Height = 313
    Caption = 'Points Histogrammes'
    TabOrder = 3
    object imgRouge: TImage
      Left = 8
      Top = 25
      Width = 256
      Height = 256
      OnMouseDown = imgRougeMouseDown
      OnMouseMove = imgRougeMouseMove
      OnMouseUp = imgRougeMouseUp
    end
    object imgVert: TImage
      Left = 272
      Top = 25
      Width = 256
      Height = 256
      OnMouseDown = imgVertMouseDown
      OnMouseMove = imgVertMouseMove
      OnMouseUp = imgVertMouseUp
    end
    object imgBleu: TImage
      Left = 537
      Top = 25
      Width = 256
      Height = 256
      OnMouseDown = imgBleuMouseDown
      OnMouseMove = imgBleuMouseMove
      OnMouseUp = imgBleuMouseUp
    end
    object chkTravailleGris: TCheckBox
      Left = 8
      Top = 288
      Width = 97
      Height = 17
      Caption = 'Travailler en gris :'
      Checked = True
      State = cbChecked
      TabOrder = 0
      OnClick = chkTravailleGrisClick
    end
  end
end
