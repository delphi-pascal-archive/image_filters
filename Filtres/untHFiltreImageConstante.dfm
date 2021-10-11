object frmHFiltreImageConstante: TfrmHFiltreImageConstante
  Left = 202
  Top = 202
  Width = 729
  Height = 419
  Caption = 'frmHFiltreImageConstante'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object bvbImages: TBevel
    Left = 8
    Top = 8
    Width = 569
    Height = 369
    Shape = bsFrame
  end
  object imgPrevisualisation: TImage
    Left = 584
    Top = 88
    Width = 128
    Height = 128
  end
  object lblPrevisualisation: TLabel
    Left = 584
    Top = 72
    Width = 79
    Height = 13
    Caption = 'Prévisualisation :'
  end
  object lblImage: TLabel
    Left = 16
    Top = 16
    Width = 35
    Height = 13
    Caption = 'Image :'
  end
  object btnOK: TButton
    Left = 636
    Top = 8
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
    OnClick = btnOKClick
  end
  object btnAnnuler: TButton
    Left = 636
    Top = 38
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Annuler'
    ModalResult = 2
    TabOrder = 1
  end
  object lstImage: TListBox
    Left = 16
    Top = 32
    Width = 553
    Height = 153
    ItemHeight = 45
    Style = lbOwnerDrawFixed
    TabOrder = 2
    OnClick = lstImageClick
    OnDrawItem = lstImageDrawItem
  end
  object grbCouleur: TGroupBox
    Left = 16
    Top = 192
    Width = 553
    Height = 177
    Caption = 'Couleur'
    TabOrder = 3
    object ShapeCouleur: TShape
      Left = 432
      Top = 48
      Width = 105
      Height = 105
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
      Left = 432
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
      Text = '255'
      OnChange = edtRougeChange
    end
    object edtVert: TEdit
      Left = 16
      Top = 88
      Width = 121
      Height = 21
      TabOrder = 2
      Text = '255'
      OnChange = edtVertChange
    end
    object edtBleu: TEdit
      Left = 16
      Top = 136
      Width = 121
      Height = 21
      TabOrder = 3
      Text = '255'
      OnChange = edtBleuChange
    end
  end
  object ColorDialog: TColorDialog
    Ctl3D = True
    Color = clWhite
    Left = 312
    Top = 240
  end
end
