object frmMDIImage: TfrmMDIImage
  Left = 254
  Top = 206
  Width = 783
  Height = 540
  HorzScrollBar.ParentColor = False
  HorzScrollBar.Smooth = True
  HorzScrollBar.Style = ssFlat
  HorzScrollBar.Tracking = True
  VertScrollBar.Smooth = True
  VertScrollBar.Style = ssFlat
  VertScrollBar.Tracking = True
  Caption = 'Image'
  Color = clBtnFace
  Constraints.MinHeight = 200
  Constraints.MinWidth = 200
  ParentFont = True
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poDefault
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object imgImage: TImage
    Left = 0
    Top = 0
    Width = 775
    Height = 506
    Align = alClient
    Center = True
    PopupMenu = PopupMenu
    OnMouseMove = imgImageMouseMove
  end
  object PopupMenu: TPopupMenu
    Left = 8
    Top = 8
    object mnuEnregistrerImage: TMenuItem
      Action = frmPrincipale.actEnregistrerImageSous
    end
  end
end
