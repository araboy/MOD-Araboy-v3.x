; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design Tab Chat
; Description ...: This file Includes GUI Design
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: GKevinOD (2014)
; Modified ......: DkEd, Hervidero (2015) , Araboy(2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
global $GrpGlobalChat, $GrpClanChat
  $tabChat = GUICtrlCreateTabItem(GetTranslated(20,1,"Chat"))

	Local $x = 30, $y = 145

	    $GrpGlobalChat = GUICtrlCreateGroup(GetTranslated(20,2,"Global Chat"), $x - 20, $y - 20, 225, 375)
		$y = 140
			$chkGlobalChat = GUICtrlCreateCheckbox(GetTranslated(20,3,"Advertise in global"), $x - 5, $y)
				GUICtrlSetTip($chkGlobalChat, GetTranslated(20,4,"Use global chat to send messages"))
				GUICtrlSetOnEvent(-1, "Global_Chat")
		   $y += 25
		   $chkGlobalScramble = GUICtrlCreateCheckbox(GetTranslated(20,5,"Scramble global chats"), $x - 5, $y)
				GUICtrlSetTip($chkGlobalScramble, GetTranslated(20,6,"Scramble the message pieces defined in the textboxes below to be in a random order"))
		   $y += 25
		   $chkSwitchLang = GUICtrlCreateCheckbox(GetTranslated(20,7,"Switch languages"), $x - 5, $y)
				GUICtrlSetTip($chkSwitchLang, GetTranslated(20,8,"Switch languages after spamming for a new global chatroom"))
		   $y += 25
		   $editGlobalMessages1 = GUICtrlCreateEdit("ba|ca|da|fa|ga", $x - 5, $y, 200, 70)
				GUICtrlSetTip($editGlobalMessages1,GetTranslated(20,9, "Take one item randomly from this list (one per line) and add it to create a message to send to global"))
		   $y += 70
		   $editGlobalMessages2 = GUICtrlCreateEdit("ba|ca|da|fa|ga", $x - 5, $y, 200, 70)
				GUICtrlSetTip($editGlobalMessages2, GetTranslated(20,10,"Take one item randomly from this list (one per line) and add it to create a message to send to global"))
		   $y += 70
		   $editGlobalMessages3 = GUICtrlCreateEdit("ba|ca|da|fa|ga", $x - 5, $y, 200, 70)
				GUICtrlSetTip($editGlobalMessages3, GetTranslated(20,11,"Take one item randomly from this list (one per line) and add it to create a message to send to global"))
		   $y += 70
		   	   $editGlobalMessages4 = GUICtrlCreateEdit("ba|ca|da|fa|ga", $x - 5, $y, 200, 70)
				GUICtrlSetTip($editGlobalMessages4, GetTranslated(20,12,"Take one item randomly from this list (one per line) and add it to create a message to send to global"))
		   $y += 70
		GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = 255
	$y = 145

		$GrpClanChat = GUICtrlCreateGroup(GetTranslated(20,13,"Clan Chat"), $x - 20, $y - 20, 225, 375)
		$y = 140
			$chkClanChat = GUICtrlCreateCheckbox(GetTranslated(20,14,"Chat in clan chat"), $x - 5, $y)
				GUICtrlSetTip($chkClanChat,GetTranslated(20,15, "Use clan chat to send messages"))
				GUICtrlSetOnEvent(-1, "Clan_Chat")
		   $y += 25
		   $chkUseResponses = GUICtrlCreateCheckbox(GetTranslated(20,16,"Use custom responses"), $x - 5, $y)
				GUICtrlSetTip($chkUseResponses, GetTranslated(20,17,"Use the keywords and responses defined below"))

		   $y += 25
		   $chkUseBotlibre = GUICtrlCreateCheckbox(GetTranslated(20,18,"Use Botlibre responses"), $x - 5, $y)
				GUICtrlSetTip($chkUseBotlibre, GetTranslated(20,19,"Get responses from Botlibre.com"))
				GUICtrlSetOnEvent(-1, "ChatGuiCheckboxUpdate2")
		   $y += 25
		   $chkUseSimsimi = GUICtrlCreateCheckbox(GetTranslated(20,20,"Use simsimi responses"), $x - 5, $y)
				GUICtrlSetTip($chkUseSimsimi,GetTranslated(20,21, "Get responses from simsimi.com"))
				GUICtrlSetOnEvent(-1, "ChatGuiCheckboxUpdate")
		   $y += 25
		   $chkUseGeneric = GUICtrlCreateCheckbox(GetTranslated(20,22,"Use generic chats"), $x - 5, $y)
				GUICtrlSetTip($chkUseGeneric,GetTranslated(20,23, "Use generic chats if reading the latest chat failed or there are no new chats"))
		   $y += 25
		   $chkChatPushbullet = GUICtrlCreateCheckbox(GetTranslated(20,24,"Use Telegram for clan chatting"), $x - 5, $y)
				GUICtrlSetTip($chkChatPushbullet,GetTranslated(20,25, "Send and recieve chats via Telegram. Use GETCHATS <interval|NOW|STOP> to get the latest clan chat as an image, and SENDCHAT <chat message> to send a chat to your clan"))
		   $y += 25
		   $chkPbSendNewChats = GUICtrlCreateCheckbox(GetTranslated(20,26,"Send TL message on new clan chat"), $x - 5, $y)
				GUICtrlSetTip($chkPbSendNewChats, GetTranslated(20,27,"Will send an image of your clan chat via Telegram when a new chat is detected. Not guaranteed to be 100% accurate."))
		   $y += 30

		   $editResponses = GUICtrlCreateEdit("keyword:Response|hello:Hi, Selamat Datang di clan|Hadir:Monggo|Joined:Please Intro yg baru join|Askum:waalaikum salam", $x - 5, $y, 200, 85)
				GUICtrlSetTip($editResponses, GetTranslated(20,28,"Look for the specified keywords in clan messages and respond with the responses. One item per line, in the format keyword:response"))
		   $y += 90
		   $editGeneric = GUICtrlCreateEdit("Testing on Chat|Selamat Datang di Clan|Baru Hadir bro|Assalamualaikum bro|Semoga betah ya,..", $x - 5, $y, 200, 85)
				GUICtrlSetTip($editGeneric,GetTranslated(20,29, "Generic messages to send, one per line"))
		GUICtrlCreateGroup("", -99, -99, 1, 1)
    GUICtrlCreateTabItem("")
