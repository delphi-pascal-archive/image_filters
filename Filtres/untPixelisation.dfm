inherited frmFiltrePixelisation: TfrmFiltrePixelisation
  Left = 245
  Top = 120
  Height = 347
  Caption = 'Pixelisation d'#39'une Image'
  PixelsPerInch = 96
  TextHeight = 13
  object grbParametres: TGroupBox
    Left = 8
    Top = 232
    Width = 569
    Height = 73
    Caption = 'Paramètres :'
    TabOrder = 3
    object lblTaillePixel: TLabel
      Left = 16
      Top = 24
      Width = 80
      Height = 13
      Caption = 'Taille des pixels :'
    end
    object edtTaillePixels: TEdit
      Left = 16
      Top = 40
      Width = 121
      Height = 21
      TabOrder = 0
      Text = '5'
      OnChange = edtTaillePixelsChange
    end
    object rdgModeCouleur: TRadioGroup
      Left = 248
      Top = 16
      Width = 185
      Height = 105
      Caption = 'Couleur : '
      ItemIndex = 0
      Items.Strings = (
        'Centre'
        'Moyenne'
        'Mediane'
        'Min / Max')
      TabOrder = 1
      Visible = False
      OnClick = rdgModeCouleurClick
    end
  end
end
