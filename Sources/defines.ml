module Defines
open System.Windows .Forms

let	MAX_PLY = ref 2 

let MAXREP = 30 

let INFINITY = - 20000

let	MOVE_STACK = 4096

let HIST_STACK = 1000

let	DARK = 0 

let LIGHT = 1

let	XMARGIN = 22

let YMARGIN = 15

let	IW = 60 

let IH = 60

let m_xcell = 76

let m_ycell = 74

let	PAWN=0 

let BISHOP=1 

let ELEPHAN=2

let KNIGHT=3 

let CANNON=4 

let ROOK=5 

let KING=6

let	NOMOVE = -1 

let EMPTY = 7

let	HUMANTHINKING = 0 

let COMPUTERTHINKING = 1 

let GAMEOVER	= 2 

let CREATING = 3

let THINKINGTIME = ref 2

type POINT =
{
	mutable x:int;
	mutable y:int
}
type  MOVE =
{
	mutable from:int ;
	mutable dest:int
}
type  GEN_REC =
{
	mutable  m: MOVE ;
	mutable p1:POINT;
	mutable p2:POINT;
	mutable  prior:int
}
type  HIST_REC =
{
	mutable mh: MOVE ; 
	mutable  capture:int
}
type Game = { 
	gameState:int;
	level : int;
	checktime :bool;
	thinkingtime:int;
	side_interface:int;
	xside_interface:int;
	hdp_interface:int;
	piece_interface:int array;
	color_interface:int array;
	h_dat:HIST_REC array 
}
let PosArray = Array.create 90 ({x=0;y=0})

let NumCheck = [|[|5;2;2;2;2;2;1|];[|5;2;2;2;2;2;1|]|]

let Num_Check = [|[|5;2;2;2;2;2;1|];[|5;2;2;2;2;2;1|]|]

let InitNumCheck()=(
	for i=0 to 1 do 
		for j=0 to 6 do
			NumCheck.[i].[j] <- Num_Check.[i].[j];
		done
	done
)	
		
let	m_gameState = ref  CREATING

let m_pieceSelecting =  ref NOMOVE

let SelectedPiece = ref NOMOVE

let timecheck = ref 0

let humangofirst = ref true

let sound = ref true

let pause = ref false

let havechecktime = ref true

let sFileDialog = Application.StartupPath ^ "\\Images\\Interface\\dialog.gif"

let sFileForm = Application.StartupPath ^ "\\Images\\Interface\\form.jpg"

let sFileWindowsBackground = Application.StartupPath ^ "\\Images\\Interface\\bg.jpg"

let sFileBackground = Application.StartupPath ^ "\\Images\\BoardImage\\white.gif"

let sFileComputer = ref (Application.StartupPath ^ "\\Images\\Computer\\computer.gif")

let sFileHuman = ref (Application.StartupPath ^ "\\Images\\Human\\human.gif")

let sFileSelect = Application.StartupPath ^ "\\Images\\Interface\\kbselect.gif"

let sFileButton = Application.StartupPath ^ "\\Images\\Interface\\Button.jpg"

let sFileHelp = Application.StartupPath ^ "\\help.mht"

let sFileCursor = Application.StartupPath ^ "\\Images\\Interface\\harrow.cur"

let efun()=() 
