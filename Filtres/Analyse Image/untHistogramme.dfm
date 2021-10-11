object frmHistogramme: TfrmHistogramme
  Left = 225
  Top = 127
  Width = 825
  Height = 643
  Caption = 'Histogramme d'#39'une Image'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object bvbImages: TBevel
    Left = 8
    Top = 8
    Width = 801
    Height = 217
    Shape = bsFrame
  end
  object lblImage: TLabel
    Left = 16
    Top = 16
    Width = 35
    Height = 13
    Caption = 'Image :'
  end
  object grbHistogrammes: TGroupBox
    Left = 8
    Top = 232
    Width = 801
    Height = 337
    Caption = 'Histogrammes'
    TabOrder = 2
    object imgVert: TImage
      Left = 272
      Top = 40
      Width = 256
      Height = 256
    end
    object imgRouge: TImage
      Left = 8
      Top = 40
      Width = 256
      Height = 256
    end
    object imgBleu: TImage
      Left = 536
      Top = 40
      Width = 256
      Height = 256
    end
    object lblRouge: TLabel
      Left = 8
      Top = 24
      Width = 38
      Height = 13
      Caption = 'Rouge :'
    end
    object lblVert: TLabel
      Left = 272
      Top = 24
      Width = 25
      Height = 13
      Caption = 'Vert :'
    end
    object lblBleu: TLabel
      Left = 536
      Top = 24
      Width = 27
      Height = 13
      Caption = 'Bleu :'
    end
    object TrackBar: TTrackBar
      Left = 8
      Top = 300
      Width = 785
      Height = 29
      Max = 100
      Min = 1
      Orientation = trHorizontal
      Frequency = 1
      Position = 1
      SelEnd = 0
      SelStart = 0
      TabOrder = 0
      TickMarks = tmBottomRight
      TickStyle = tsAuto
      OnChange = TrackBarChange
    end
  end
  object lstImage: TListBox
    Left = 16
    Top = 32
    Width = 785
    Height = 185
    ItemHeight = 45
    Style = lbOwnerDrawFixed
    TabOrder = 1
    OnClick = lstImageClick
    OnDrawItem = lstImageDrawItem
  end
  object btnFermer: TButton
    Left = 364
    Top = 576
    Width = 75
    Height = 25
    Caption = 'Fermer'
    Default = True
    ModalResult = 2
    TabOrder = 0
  end
end
