inherited frmFiltreFondu: TfrmFiltreFondu
  Left = 289
  Top = 139
  Caption = 'Fondu entre 2 Images'
  ClientHeight = 466
  PixelsPerInch = 96
  TextHeight = 13
  object grbParametres: TGroupBox
    Left = 8
    Top = 384
    Width = 569
    Height = 73
    Caption = 'Pourcentage Fondu :'
    TabOrder = 4
    object lblRouge: TLabel
      Left = 16
      Top = 24
      Width = 38
      Height = 13
      Caption = 'Rouge :'
    end
    object lblBleu: TLabel
      Left = 400
      Top = 24
      Width = 27
      Height = 13
      Caption = 'Bleu :'
    end
    object lblVert: TLabel
      Left = 208
      Top = 24
      Width = 25
      Height = 13
      Caption = 'Vert :'
    end
    object edtRouge: TEdit
      Left = 16
      Top = 40
      Width = 121
      Height = 21
      TabOrder = 0
      Text = '50'
      OnChange = edtRougeChange
    end
    object edtVert: TEdit
      Left = 208
      Top = 40
      Width = 121
      Height = 21
      TabOrder = 1
      Text = '50'
      OnChange = edtVertChange
    end
    object edtBleu: TEdit
      Left = 400
      Top = 40
      Width = 121
      Height = 21
      TabOrder = 2
      Text = '50'
      OnChange = edtBleuChange
    end
  end
end
