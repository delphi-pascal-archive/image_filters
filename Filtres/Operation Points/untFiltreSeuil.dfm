inherited frmFiltreSeuil: TfrmFiltreSeuil
  Left = 194
  Top = 63
  Height = 635
  Caption = 'Seuil d'#39'une Image'
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object grbCouleurInferieure: TGroupBox
    Left = 8
    Top = 232
    Width = 569
    Height = 177
    Caption = 'Couleur Inférieure'
    TabOrder = 3
    object ShapeCouleurCI: TShape
      Left = 448
      Top = 48
      Width = 105
      Height = 105
      Brush.Color = clGray
    end
    object lblRougeCI: TLabel
      Left = 16
      Top = 24
      Width = 38
      Height = 13
      Caption = 'Rouge :'
    end
    object lblVertCI: TLabel
      Left = 16
      Top = 72
      Width = 25
      Height = 13
      Caption = 'Vert :'
    end
    object lblBleuCI: TLabel
      Left = 16
      Top = 120
      Width = 27
      Height = 13
      Caption = 'Bleu :'
    end
    object lblCouleurCI: TLabel
      Left = 448
      Top = 32
      Width = 42
      Height = 13
      Caption = 'Couleur :'
    end
    object btnSelectionCouleurI: TButton
      Left = 152
      Top = 80
      Width = 137
      Height = 41
      Caption = 'Sélectionner la couleur'
      TabOrder = 0
      OnClick = btnSelectionCouleurIClick
    end
    object edtRougeCI: TEdit
      Left = 16
      Top = 40
      Width = 121
      Height = 21
      TabOrder = 1
      Text = '128'
      OnChange = edtRougeCIChange
    end
    object edtVertCI: TEdit
      Left = 16
      Top = 88
      Width = 121
      Height = 21
      TabOrder = 2
      Text = '128'
      OnChange = edtVertCIChange
    end
    object edtBleuCI: TEdit
      Left = 16
      Top = 136
      Width = 121
      Height = 21
      TabOrder = 3
      Text = '128'
      OnChange = edtBleuCIChange
    end
  end
  object lblVertCS: TGroupBox
    Left = 8
    Top = 416
    Width = 569
    Height = 177
    Caption = 'Couleur Supérieure'
    TabOrder = 4
    object ShapeCouleurCS: TShape
      Left = 448
      Top = 48
      Width = 105
      Height = 105
    end
    object lblRougeCS: TLabel
      Left = 16
      Top = 24
      Width = 38
      Height = 13
      Caption = 'Rouge :'
    end
    object Label2: TLabel
      Left = 16
      Top = 72
      Width = 25
      Height = 13
      Caption = 'Vert :'
    end
    object lblBleuCS: TLabel
      Left = 16
      Top = 120
      Width = 27
      Height = 13
      Caption = 'Bleu :'
    end
    object lblCouleurCS: TLabel
      Left = 448
      Top = 32
      Width = 42
      Height = 13
      Caption = 'Couleur :'
    end
    object btnSelectionCouleurS: TButton
      Left = 152
      Top = 80
      Width = 137
      Height = 41
      Caption = 'Sélectionner la couleur'
      TabOrder = 0
      OnClick = btnSelectionCouleurSClick
    end
    object edtRougeCS: TEdit
      Left = 16
      Top = 40
      Width = 121
      Height = 21
      TabOrder = 1
      Text = '255'
      OnChange = edtRougeCSChange
    end
    object edtVertCS: TEdit
      Left = 16
      Top = 88
      Width = 121
      Height = 21
      TabOrder = 2
      Text = '255'
      OnChange = edtVertCSChange
    end
    object edtBleuCS: TEdit
      Left = 16
      Top = 136
      Width = 121
      Height = 21
      TabOrder = 3
      Text = '255'
      OnChange = edtBleuCSChange
    end
  end
  object ColorDialogCS: TColorDialog
    Ctl3D = True
    Color = clWhite
    Left = 320
    Top = 504
  end
  object ColorDialogCI: TColorDialog
    Ctl3D = True
    Color = clGray
    Left = 320
    Top = 312
  end
end
