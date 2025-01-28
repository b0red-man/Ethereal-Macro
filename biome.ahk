#Requires AutoHotkey v1.1
#SingleInstance, Force
; so cro
global logPath := "C:\Users\" A_UserName "\AppData\Local\Roblox\logs"

global biomeData := ["Normal", "Windy", "Rainy", "Snowy", "Hell", "Starfall", "Corruption", "Null", "Glitched", "Pumpkin Moon", "Graveyard", "Sandstorm"]
global oldbiome := getBiome(getRPCMsg())

createGui() {
    global
    Menu Tray, Icon, %A_ScriptDir%\cro.ico ; so cro
    gui, main:New
    Gui, Font, s10 Norm, Segoe UI
    Gui, Add, Tab3, x10 y5 w395 h225, Main|Other|Merchant|Credits


    Gui, Tab, Main
        Gui, Font, s10
        Gui, Add, Groupbox, x26 y40 w340 h180, % "Webhook"
            Gui, Font, s9 Norm
            Gui, Add, Checkbox, x40 y65 vWebhookEnabled , % "Enable Webhook"
            Gui, Font, s8 Norm

            Gui, Add, Text, x40 y90, % "Webhook URL"
            Gui, Add, Edit, vWebhookURL x40 y105 h20 w300

            Gui, Add, Text, x40 y130, % "Private Server Link"
            Gui, Add, Edit, vPSLink x40 y145 h20 w300

            Gui, Add, Text, x40 y170, % "User ID"
            Gui, Add, Edit, vUserID x40 y185 h20 w300
    
    ; hi root

    Gui, Tab, Other
        Gui, Font, s9
        Gui, Add, GroupBox, x25 y40 w250 h70, % "Rejoin Mode"
            Gui, Font, s8
            Gui, Add, Checkbox, x40 y65 gRejoinConfirmation vRejoinModeEnabled, % "Rejoin Mode Enabled"
            Gui, Add, Checkbox, x40 y85 vRejoinTimeoutEnabled, % "Rejoin after"
            Gui, Add, Edit, vRejoinTimeout1 h16 w38 x120 y84 Number
            Gui, Add, UpDown, vRejoinTimeout2 Range1-60
            Gui, Add, Text, y85 x162, % "mins of no changes"
            Gui, Font, s10
            Gui, Add, Button, gRejoinModeHelp w25 h25 x245 y52, % "?"
        Gui, Add, GroupBox, x25 y120 h65 w250, % "Auto Equip"
            Gui, Font, s8
            Gui, Add, Checkbox, vAutoEquipEnabled x40 y150, % "Enable Auto Equip"
            Gui, Add, Button, vAutoEquipButton x175 y138 w80 h35, % "Configure"
        /*
        Gui, Font, s10
        Gui, Add, GroupBox, x290 y40 w95 h145, % "Auto Equip"
            Gui, Font, s8
            Gui, Add, Checkbox, x310 y72, % "Enable"
            Gui, Add, Button, x308 y100 w65 h65, % "Configure"
        */
        Gui, Font, s8

        Gui, Add, Button, x300 y45 w85 h65, % "Aura`nSettings"
        Gui, Add, Button, x300 y120 w85 h65, % "Biome`nSettings"

        Gui, Add, Text, x30 y200, % "UI Navigation Key: "
        Gui, Add, Edit, y197 x129 w20 h20 vUINavKey
    Gui, Show, w415 h240
}



RejoinDisable(val) {
    GuiControl, Disable%val%, AutoEquipEnabled
    GuiControl, Disable%val%, AutoEquipButton
}

RejoinConfirmation() {
    GuiControlGet, val,, RejoinModeEnabled
    if (val) {
        GuiControl,, RejoinModeEnabled, 0
        MsgBox, 4, Warning, % "Enabling Rejoin Mode will disable the following features: `n    1. Aura Auto Equip `n    2. Auto Merchant `nAnd change the following features:`n    1. All Item Scheduler Entries will be 'On Biome Start' `nAre you sure you want to continue?"
        IfMsgBox Yes 
            GuiControl,, RejoinModeEnabled, 1
            RejoinDisable(1)
    } else {
        RejoinDisable(0)
    }
}

getLogFile() {
    time := 0
    file := ""
    Loop, %logPath%\*.log {
        if (A_LoopFileTimeModified >= time) {
            time := A_LoopFileTimeModified
            file := A_LoopFileFullPath
        }
    }
    return file
}
getRPCMsg() {
    FileRead, file, % getLogFile()
    msg :=  SubStr(file, InStr(file, "[BloxstrapRPC]",, 0))
    msg := SubStr(msg, 1, InStr(msg, "}}}",, 0)+2)
    return msg
}
getBiome(msg) {
    if (msg) {
        for i,v in biomeData {
            if (InStr(msg, v)) {
                return v
            }
        }

    }
    ; man what the fuck is this code
}
getAura(msg) {
    aura := SubStr(msg, 73)
    string = ","
    aura := SubStr(aura, 1, InStr(aura, string)-3)
    msgbox % aura
}

values := ["WebhookEnabled","WebhookUrl","PSLink","UserID","RejoinModeEnabled","RejoinTimeoutEnabled","RejoinTimeout1","RejoinTimeout2","AutoEquipEnabled","UINavKey"]

createGui()

return
rejoinModeHelp:
    msgbox, % "placeholder"
    return
rejoinConfirmation:
    RejoinConfirmation()
    return
F1::Reload
Esc::ExitApp