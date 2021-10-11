inherited frmFiltreSeuilAdaptatif: TfrmFiltreSeuilAdaptatif
  Left = 257
  Top = 84
  Height = 548
  Caption = 'Seuil Adaptatif d'#39'une Image'
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited grbParametres: TGroupBox
    Height = 121
    object lblDeviation: TLabel [1]
      Left = 16
      Top = 72
      Width = 51
      Height = 13
      Caption = 'Déviation :'
      Visible = False
    end
    object rdgTypeFiltre: TRadioGroup
      Left = 224
      Top = 16
      Width = 137
      Height = 89
      Caption = 'Type de Filtre'
      ItemIndex = 0
      Items.Strings = (
        'Moyenne'
        'Min / Max'
        'Gaussien')
      TabOrder = 1
      OnClick = rdgTypeFiltreClick
    end
    object edtDeviation: TEdit
      Left = 16
      Top = 88
      Width = 121
      Height = 21
      TabOrder = 2
      Text = '2'
      Visible = False
      OnChange = edtDeviationChange
    end
  end
  object grbCouleurMinimale: TGroupBox
    Left = 8
    Top = 328
    Width = 569
    Height = 177
    Caption = 'Couleur Minimale'
    TabOrder = 4
    object ShapeCouleur: TShape
      Left = 448
      Top = 48
      Width = 105
      Height = 105
      Brush.Color = 3289650
    end
    object lblRouge: TLabel
      Left = 16
      Top = 24
      Width = 38
      Height = 13
      Caption = 'Rouge :'
    end
    object lblVert: TLabel
      Left = 16
      Top = 72
      Width = 25
      Height = 13
      Caption = 'Vert :'
    end
    object lblBleu: TLabel
      Left = 16
      Top = 120
      Width = 27
      Height = 13
      Caption = 'Bleu :'
    end
    object lblCouleur: TLabel
      Left = 448
      Top = 32
      Width = 42
      Height = 13
      Caption = 'Couleur :'
    end
    object btnSelectionCouleur: TButton
      Left = 152
      Top = 80
      Width = 137
      Height = 41
      Caption = 'Sélectionner la couleur'
      TabOrder = 0
      OnClick = btnSelectionCouleurClick
    end
    object edtRouge: TEdit
      Left = 16
      Top = 40
      Width = 121
      Height = 21
      TabOrder = 1
      Text = '50'
      OnChange = edtRougeChange
    end
    object edtVert: TEdit
      Left = 16
      Top = 88
      Width = 121
      Height = 21
      TabOrder = 2
      Text = '50'
      OnChange = edtVertChange
    end
    object edtBleu: TEdit
      Left = 16
      Top = 136
      Width = 121
      Height = 21
      TabOrder = 3
      Text = '50'
      OnChange = edtBleuChange
    end
  end
  object ColorDialog: TColorDialog
    Ctl3D = True
    Color = 3289650
    Left = 320
    Top = 408
  end
end
