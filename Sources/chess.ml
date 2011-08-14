(*==================================================================================
ML Chinese Chess Version 1.0
Written by Nguyen Van Thien, Dinh Thi Thuy Nga
Faculty of Information Technology 
Email: nvthien1112@yahoo.com, thuynga48@yahoo.com
===================================================================================*)
open Graphics
open Defines
open Board
open Gen
open File
open Search
open System
open System.Collections 
open System.Windows .Forms 
open System.Drawing 
open System.ComponentModel 
open Controls
open Media

let position = ref 0
let valid = ref true
let quit = ref true
let piecesstyle = ref 0

let SetEMPTY(p)=
let cl = m_color_interface.[p] in let pc = m_piece_interface.[p]in
	NumCheck.[cl].[pc] <- NumCheck.[cl].[pc] - 1;
	m_piece_interface.[p]<-EMPTY;
	m_piece.[p]<-EMPTY;
	m_color_interface.[p]<-EMPTY;
	m_color.[p]<-EMPTY;
	RequireDrawCell(p)
	
let SetValue(p,pv,cv)=
if(Num_Check.[cv].[pv] - NumCheck.[cv].[pv]>0)then(
let pos = if(cv = DARK )then p else 89-p in
if(m_piece_interface.[p]=EMPTY && m_color_interface.[p]=EMPTY)then
if((legalposition.[pos])&&& (maskpiece.[pv]) <>0 )then
if (CheckPosition(pv,pos))then(
m_piece_interface.[p]<-pv;
m_piece.[p]<-pv;
m_color_interface.[p]<-cv;
m_color.[p]<-cv;
NumCheck.[cv].[pv] <- NumCheck.[cv].[pv] + 1;
RequireDrawCell(p)))

let DeletePiece(p)=
if(!m_gameState = CREATING && !SelectedPiece <> NOMOVE;)then (
if(m_piece_interface.[p]<>KING && KingFace(p,p)=false)then(
SetEMPTY(p);
SelectedPiece := NOMOVE;))

let LetDeletePiece()=DeletePiece(!m_pieceSelecting)

let LetShowFormPieces()=
let dlgpieces = new Form() in(
LoadDialog(dlgpieces,new Size(402,174),sFileDialog);
let  lbclose = new Label() in let 
	 pbdarkpawn = new PictureBox() in let pbdarkbishop = new PictureBox() in let 
	 pbdarkelephan = new PictureBox() in let pbdarkknight = new PictureBox()in let
	 pbdarkcannon = new PictureBox()in let pbdarkrook = new PictureBox()in let
	 pbdarkking = new PictureBox()in let  pblightking = new PictureBox()in let 
	 pblightpawn = new PictureBox() in let pblightbishop = new PictureBox() in let 
	 pblightelephan = new PictureBox() in let pblightknight = new PictureBox()in let
	 pblightcannon = new PictureBox()in let pblightrook = new PictureBox() in
let	LetCloseDialog()=(dlgpieces.Close())in let
	LetSetDarkPawn()=(dlgpieces.Close();SetValue(!position,PAWN,DARK))in let
	LetSetDarkBishop()=(dlgpieces.Close();SetValue(!position,BISHOP,DARK))in let
	LetSetDarkElephan()=(dlgpieces.Close();SetValue(!position,ELEPHAN,DARK))in let
	LetSetDarkKnight()=(dlgpieces.Close();SetValue(!position,KNIGHT,DARK))in let
	LetSetDarkCannon()=(dlgpieces.Close();SetValue(!position,CANNON,DARK))in let
	LetSetDarkRook()=(dlgpieces.Close();SetValue(!position,ROOK,DARK))in let
	LetSetDarkKing()=(dlgpieces.Close();SetValue(!position,KING,DARK))in let
	LetSetLightPawn()=(dlgpieces.Close();SetValue(!position,PAWN,LIGHT))in let
	LetSetLightBishop()=(dlgpieces.Close();SetValue(!position,BISHOP,LIGHT))in let
	LetSetLightElephan()=(dlgpieces.Close();SetValue(!position,ELEPHAN,LIGHT))in let
	LetSetLightKnight()=(dlgpieces.Close();SetValue(!position,KNIGHT,LIGHT))in let
	LetSetLightCannon()=(dlgpieces.Close();SetValue(!position,CANNON,LIGHT))in let
	LetSetLightRook()=(dlgpieces.Close();SetValue(!position,ROOK,LIGHT))in let
	LetSetLightKing()=(dlgpieces.Close();SetValue(!position,KING,LIGHT))in
LoadLabel(dlgpieces,lbclose,"X",Color.Red,new Size(20,20),new Point(382,1),LetCloseDialog);

LoadPictureBox(dlgpieces,pbdarkpawn,m_string_list.[7],new Point(23,33),
				new Size(50,50),"",LetSetDarkPawn);
pbdarkpawn.BackColor <- Color.Transparent;	
LoadPictureBox(dlgpieces,pbdarkbishop,m_string_list.[8],new Point(74,33),
				new Size(50,50),"",LetSetDarkBishop);
pbdarkbishop.BackColor <- Color.Transparent;
LoadPictureBox(dlgpieces,pbdarkelephan,m_string_list.[9],new Point(125,33),
				new Size(50,50),"",LetSetDarkElephan);
pbdarkelephan.BackColor <- Color.Transparent;	
LoadPictureBox(dlgpieces,pbdarkknight,m_string_list.[10],new Point(176,33),
				new Size(50,50),"",LetSetDarkKnight);
pbdarkknight.BackColor <- Color.Transparent;
LoadPictureBox(dlgpieces,pbdarkcannon,m_string_list.[11],new Point(227,33),
				new Size(50,50),"",LetSetDarkCannon);
pbdarkcannon.BackColor <- Color.Transparent;
LoadPictureBox(dlgpieces,pbdarkrook,m_string_list.[12],new Point(278,33),
				new Size(50,50),"",LetSetDarkRook);
pbdarkrook.BackColor <- Color.Transparent;
LoadPictureBox(dlgpieces,pbdarkking,m_string_list.[13],new Point(329,33),
				new Size(50,50),"",LetSetDarkKing);
pbdarkking.BackColor <- Color.Transparent;

LoadPictureBox(dlgpieces,pblightpawn,m_string_list.[0],new Point(23,96),
				new Size(50,50),"",LetSetLightPawn);
pblightpawn.BackColor <- Color.Transparent;	
LoadPictureBox(dlgpieces,pblightbishop,m_string_list.[1],new Point(74,96),
				new Size(50,50),"",LetSetLightBishop);
pblightbishop.BackColor <- Color.Transparent;
LoadPictureBox(dlgpieces,pblightelephan,m_string_list.[2],new Point(125,96),
				new Size(50,50),"",LetSetLightElephan);
pblightelephan.BackColor <- Color.Transparent;	
LoadPictureBox(dlgpieces,pblightknight,m_string_list.[3],new Point(176,96),
				new Size(50,50),"",LetSetLightKnight);
pblightknight.BackColor <- Color.Transparent;
LoadPictureBox(dlgpieces,pblightcannon,m_string_list.[4],new Point(227,96),
				new Size(50,50),"",LetSetLightCannon);
pblightcannon.BackColor <- Color.Transparent;
LoadPictureBox(dlgpieces,pblightrook,m_string_list.[5],new Point(278,96),
				new Size(50,50),"",LetSetLightRook);
pblightrook.BackColor <- Color.Transparent;
LoadPictureBox(dlgpieces,pblightking,m_string_list.[6],new Point(329,96),
				new Size(50,50),"",LetSetLightKing);
pblightking.BackColor <- Color.Transparent;
ignore(dlgpieces.ShowDialog()))			

let LetAddPiece(x,y)=
let pt = new Point(x,y) in 
if (rectBoard.Contains(pt))then (
position := GetPiecePos(pt);
if(m_piece_interface.[!position]=EMPTY && m_color_interface.[!position]=EMPTY)then(
LetShowFormPieces()
))
	
let ChangePieceImage(z)=
if(!SelectedPiece <> NOMOVE)then(
	let sFileName = GetFileName()in
	if(sFileName<>"")then(
		m_string_list.[z]<- sFileName;
		m_pieceSelecting := NOMOVE;
		SelectedPiece := NOMOVE;
		form.Invalidate();))
else(
	piecesstyle := !piecesstyle + 1;
	piecespath := "PieceImage\\pieces" ^ string (!piecesstyle);
	CreateStringList();
	m_pieceSelecting := NOMOVE;
	form.Invalidate();
	if(!piecesstyle = 6)then piecesstyle := 0;
)	 

let LetChangePieceImage() = if(!pause = false)then ChangePieceImage(!SelectedPiece )

let LetChangeBoardImage()=
let sFileName = GetFileName()in
	if(sFileName<>"")then ( 
		fbackgroundimage := sFileName;
		form.Invalidate();)

let LetChangeGridColor()=
if(!pause = false)then
let d = new ColorDialog () in 
	if(d.ShowDialog()=DialogResult.OK) then(
		gridcolor := d.Color ;
		form.Invalidate();)
				
let LetUseDefault()=(
	Default();
	sFileComputer := (Application.StartupPath ^ "\\Images\\Computer\\computer.gif");
	sFileHuman := (Application.StartupPath ^ "\\Images\\Human\\human.gif");
	SetImage(pbc,!sFileComputer);
	SetImage(pbh,!sFileHuman);
	m_pieceSelecting := NOMOVE;
	SelectedPiece := NOMOVE;
	form.Invalidate();
)

let NewGame()=
if(!m_gameState <> COMPUTERTHINKING)then(
InitNumCheck();
m_gameState := CREATING;
m_pieceSelecting := NOMOVE;
SelectedPiece := NOMOVE;
timer.Enabled <- false;
progressbar.Value <- 1;
pbh.Visible <- false;
InitData();
lbstart.Visible <- true;
lbinfo.Visible <- true;
pause := false;
form.Invalidate ();
LetPlayMediaFile(sFileInit);)
	 
let LetStartPlaying() = 
if(!m_gameState = CREATING)then
if(CheckPawnPosition())then(
	lbstart.Visible <- false ;
	lbinfo.Visible <- false;
	lbpause .Text <- "Paus&e";
	timecheck := 0;
	timer.Enabled <- !havechecktime ;
	SelectedPiece := NOMOVE;
	m_pieceSelecting := NOMOVE;
	form.Invalidate();
	LetPlayMediaFile(sFileStart);
	if(!humangofirst = false)then (
		m_gameState := COMPUTERTHINKING;
		ChangeSide();
		LetComputerThink())
	else (
		m_gameState := HUMANTHINKING;
		pbc.Visible <-false;
		pbh.Visible <- true;)
)else LetShowMessage("Pawn Position is invalid !!!")	

let LetUseClock()=
if(!m_gameState =HUMANTHINKING )then
if(!havechecktime =true)then(
	if(timer.Enabled=true)then(
		pause := true;
		lbpause .Text <- "Continu&e";
		timer.Enabled <- false;
	)else(
		lbpause .Text <- "Paus&e";
		pause := false;
		timer.Enabled <- true;
	);
	form.Invalidate()			
)

let LetUndoMoves()=
if(!pause = false)then
if(!m_gameState = HUMANTHINKING )then
let UpdateUndo()= if (CanUndoMove()) then (
	UndoMove();
	RequireDrawCell(!m_from);
	RequireDrawCell(!m_dest);
)in (UpdateUndo();UpdateUndo())

let LetComputerMove()=
if(!pause = false)then
if(!m_gameState=HUMANTHINKING && !valid=true)then(
	valid:=false;
	LetComputerThink();
	LetComputerThink();
	valid:=true)

let LetCheckThinkingTime()=(
	timecheck := !timecheck+1;
	progressbar.Increment(1);
	if ((!timecheck >= (!THINKINGTIME*60)) &&
		 (!m_gameState = HUMANTHINKING))then ComputerWon();
)

let LetShowFormQuit()=
let dlgquit = new Form()in(
LoadDialog(dlgquit,new Size(283,241),sFileForm);
let lbclose = new Label()in let lbask = new Label()in let
	btyes = new Button() in let btno = new Button()in let 
	pbcomputer = new PictureBox()in
let	LetCloseDialog()= (dlgquit.Close()) in let
	LetYes()= (
		dlgquit.Close();
		quit := false;		
		)in			
LoadLabel(dlgquit,lbclose,"X",Color.Red,new Size(20,20),new Point(263,1),LetCloseDialog);	
LoadCaption(dlgquit,lbask,"Are you sure to quit game ?",new Point(28,50));
LoadPictureBox(dlgquit,pbcomputer,!sFileComputer,new Point(105,85),
				new Size(75,75),"",efun);
pbcomputer.Visible <- true;pbcomputer.BackColor <- Color.Transparent;
LoadButton(dlgquit,btyes,"Yes",new Size(72, 25),new Point(57,168),LetYes);
LoadButton(dlgquit,btno,"No",new Size(72,25),new Point(153,168),LetCloseDialog);							
ignore(dlgquit.ShowDialog()))

let QuitGame()=form.Close()

let LetShowFormGame()=
let dlggame = new Form() in(
LoadDialog(dlggame,new Size(283,241),sFileForm);
let btnew = new Button() in let btload = new Button() in let lbclose = new Label()
in let btsave = new Button()in let bthelp = new Button() in let btquit = new Button()in
let	LetCloseDialog()=(dlggame.Close()) in let 
	LetNewGame()=(dlggame.Close();NewGame())in let
	LetLoadGame()=(dlggame.Close();LoadGame())in let
	LetSaveGame()=(dlggame.Close();SaveGame())in let
	LetShowMLChinessChess()=(
		dlggame.Close();
		try
			Help.ShowHelp(form,sFileHelp);
		with e -> Printf.printf "Error"
		)in let
	LetQuitGame()=(dlggame.Close();QuitGame())in 
LoadLabel(dlggame,lbclose,"X",Color.Red,new Size(20,20),new Point(263,1),LetCloseDialog);
LoadButton(dlggame,btnew,"New Game",new Size(140,30),new Point(71,31),LetNewGame);
LoadButton(dlggame,btload,"Load Game",new Size(140,30),new Point(71,69),LetLoadGame);
LoadButton(dlggame,btsave,"Save Game",new Size(140,30),new Point(71,107),LetSaveGame);
LoadButton(dlggame,bthelp,"Help",new Size(140,30),new Point(71,145),LetShowMLChinessChess);
LoadButton(dlggame,btquit,"Quit",new Size(140,30),new Point(71,183),LetQuitGame);
ignore(dlggame.ShowDialog()))			

let LetShowFormOption()=
if(!pause = false)then
let dlgoption = new Form()in(
LoadDialog(dlgoption,new Size(283,241),sFileForm);
let lbclose = new Label()in let lbminute = new Label()in let
	lblevel = new Label() in let cbblevel = new ComboBox() in let 
	cbthinkingtime = new CheckBox() in let nmrudthinkingtime = new NumericUpDown() in let
	cbcomputergofirst = new CheckBox()in let cbsound = new CheckBox()in let
	btok = new Button() in let btcancel = new Button()in
let	LetCloseDialog()= (dlgoption.Close()) in let
	LetOK()= (
		dlgoption.Close();
		MAX_PLY := if(cbblevel.SelectedIndex >=0 )then
					 cbblevel.SelectedIndex + 1 else !MAX_PLY;
		THINKINGTIME := Convert.ToInt32 (nmrudthinkingtime.Value);
		progressbar.Maximum <- (!THINKINGTIME*60) ;
		humangofirst := not cbcomputergofirst.Checked;
		sound := cbsound.Checked;
		havechecktime := cbthinkingtime.Checked ;
		if(!m_gameState <>CREATING )then timer .Enabled <- !havechecktime ;
		)in			
LoadLabel(dlgoption,lbclose,"X",Color.Red,new Size(20,20),new Point(263,1),LetCloseDialog);	
LoadCaption(dlgoption,lblevel,"Level",new Point(47, 38));
LoadCombobox(dlgoption,cbblevel,new Point(105, 34),new Size(120, 30));			
LoadCheckBox(dlgoption,cbthinkingtime,"Thinking time",!havechecktime,new Point(32,78),new Size(145, 24));
cbthinkingtime .add_CheckedChanged (new EventHandler (
						fun _ _ -> nmrudthinkingtime.Enabled <- cbthinkingtime.Checked ));
LoadNumericUpDown(dlgoption,nmrudthinkingtime,1,30,new Point(176, 76),new Size(48, 27));
LoadCaption(dlgoption,lbminute,"min",new Point(224, 79));
LoadCheckBox(dlgoption,cbcomputergofirst,"Computer go first",not !humangofirst,
				new Point(32,115),new Size(180, 24));
LoadCheckBox(dlgoption,cbsound,"Sound",!sound,new Point(32, 150),new Size(79, 24));				
LoadButton(dlgoption,btok,"OK",new Size(72, 25),new Point(57, 186),LetOK);
LoadButton(dlgoption,btcancel,"Cancel",new Size(72,25),new Point(153,186),LetCloseDialog);							
ignore(dlgoption.ShowDialog()))

//----------------------------------------------------------------------------------
let HumanMove(x,y)=
let pt = new Point(x,y) in 
if (rectBoard.Contains(pt) &&  !m_gameState = HUMANTHINKING && !pause = false)then (
	let	k = GetPiecePos(pt) in let z = !m_pieceSelecting in
		let	pc = m_piece_interface.[k] in let cl= m_color_interface.[k] in
		let j = pc + (if(cl=LIGHT)then 0 else 7)in
			if(cl = !m_side_interface) then(
				LetPlayMediaFile(sFileClick);
				if(z <> NOMOVE)then(
					m_pieceSelecting := NOMOVE;
					RequireDrawCell(z));
				m_pieceSelecting := k;
				m_string_list.[14] <- m_string_list.[j];
				RequireDrawCell(k);
			)else if (z <> NOMOVE) then( 
					if (CheckLegalMove(z, k)) then(
						let humanwon = ref false in
						let	pc = m_piece_interface.[z] in let cl= m_color_interface.[z] in
						let i = pc + (if(cl=LIGHT)then 0 else 7)in
							if (UpdateNewMove(z, k)) then humanwon := true;
							m_pieceSelecting := NOMOVE;
							let rz = GetPieceRect(z) in let rk = GetPieceRect(k) in
							LetPlayMediaFile(sFileMove);
							LetShowMove(rz.Left+8,rz.Top+8,rk.Left+8,rk.Top+8,m_string_list.[i],grfx,form);
							if(!humanwon=false)then(
							ChangeSide();
							if (not(IsThereLegalMove())) then humanwon := true;
							);
							if(!humanwon)then HumanWon()
							else(
							m_gameState := COMPUTERTHINKING;
							LetComputerThink();
						    ))))		

let Select(x,y)=
let pt = new Point(x,y) in 
if (rectBoard.Contains(pt))then (
	let	k = GetPiecePos(pt) in let z = !m_pieceSelecting in
		let	pc = m_piece_interface.[k] in let cl= m_color_interface.[k] in
			if(cl <> EMPTY)then (
				LetPlayMediaFile(sFileClick);
				SelectedPiece := pc + (if(cl=LIGHT)then 0 else 7);
				m_string_list.[14] <- m_string_list.[!SelectedPiece];
				)
			else (
				if(!SelectedPiece <> NOMOVE)then(
					let mpz = m_piece_interface.[z] in let 
						mclz = m_color_interface.[z] in
					let pos = if(mclz = DARK )then k else 89-k in
						if((legalposition.[pos])&&& (maskpiece.[mpz]) <>0 &&
							KingFace(z,k)=false && CheckPosition(mpz,pos))then(		
								SetEMPTY(z);
								SetValue(k,mpz,mclz);
							)else SelectedPiece := NOMOVE
				)
			);
		if(z <> NOMOVE)then(
			m_pieceSelecting := NOMOVE;
			RequireDrawCell(z)
		);
		m_pieceSelecting := k;
		RequireDrawCell(k);
)
else (
	m_pieceSelecting := NOMOVE;
	SelectedPiece := NOMOVE;
	form.Invalidate();
)		
	
//----------------------------------------------------------------------------------
let KeysFun(key :Keys)=(
if(key =  Keys.Up)then 
	pbs.Top <- pbs.Top - if(pbs.Top > rectBoard.Top+m_ycell ) then m_ycell else 0
else if(key = Keys.Down)then
	pbs.Top <- pbs.Top + if(pbs.Top < rectBoard.Bottom - m_ycell )then m_ycell else 0 
else if(key = Keys.Left)then
	pbs.Left <- pbs.Left - if(pbs.Left > rectBoard.Left + m_xcell)then m_xcell else 0 
else if(key = Keys.Right)then 
	pbs.Left <- pbs.Left+ if(pbs.Left < rectBoard.Right - m_xcell )then m_xcell else 0 
else if(key = Keys.Enter || key = Keys.Space)then (
		if(!m_gameState = CREATING)then Select(pbs.Left,pbs.Top)
		else HumanMove(pbs.Left,pbs.Top))
else if(key = Keys.Delete )then DeletePiece(!m_pieceSelecting)
else if(key = Keys.K )then pbs.Visible <- not pbs.Visible
else if(key = Keys.S )then LetStartPlaying()
else if(key = Keys.C )then LetComputerMove()
else if(key = Keys.U )then LetUndoMoves()
else if(key = Keys.O )then LetShowFormOption()
else if(key = Keys.G )then LetShowFormGame()
else if(key = Keys.B )then LetChangeBoardImage()
else if(key = Keys.R )then LetChangeGridColor()
else if(key = Keys.P )then LetChangePieceImage()
else if(key = Keys.D )then LetUseDefault()
else if(key = Keys.E )then LetUseClock()
)
//----------------------------------------------------------------------------------
do
LoadPictureBox(form,pbc,!sFileComputer,new Point(845,328),
				new Size(75,75),"computer",efun);
pbc.Visible <- false;
LoadPictureBox(form,pbh,!sFileHuman,new Point(837,328),
				new Size(75,75),"human",efun);
pbh.Visible <- false;
						
LoadPictureBox(form,pbs,sFileSelect,new Point( 352,337),new Size(24,22),"",efun);
pbs.BackColor <- Color.Transparent;
pbs.Visible <- false;

LoadCaption(form,lbinfo,"Prepare the chess board. Click Start to begin",new Point(726,352));
lbinfo.Font <- new Font("Times New Roman", 11.5F,FontStyle.Bold);
LoadLabel(form,lbboard,"&Board Image",Color.Black,new Size(170,35),new Point(795,60),LetChangeBoardImage);
LoadLabel(form,lbgrid,"G&rid Color",Color.Black,new Size(170,35),new Point(795,105),LetChangeGridColor);			
LoadLabel(form,lbpiece,"&Piece Image",Color.Black,new Size(170,35),new Point(795,150),LetChangePieceImage);
LoadLabel(form,lbdelete,"Delete Piece",Color.Black,new Size(170,35),new Point(795,195),LetDeletePiece);
LoadLabel(form,lbdefault,"&Default",Color.Black,new Size(170,35),new Point(795,240),LetUseDefault);			

LoadLabel(form,lbstart,"&Start",Color.Black,new Size(170,35),new Point(795,515),LetStartPlaying);
LoadLabel(form,lbpause,"Paus&e",Color.Black,new Size(170,35),new Point(795,515),LetUseClock);
LoadLabel(form,lbcomputermove,"Let &Computer Move",Color.Black,new Size(170,35),new Point(795,560),LetComputerMove);
LoadLabel(form,lbundomoves,"&Undo Move",Color.Black,new Size(170,35),new Point(795,605),LetUndoMoves);			
LoadLabel(form,lboptions,"&Options",Color.Black,new Size(170,35),new Point(795,650),LetShowFormOption);			
LoadLabel(form,lbgame,"&Game",Color.Black,new Size(170,35),new Point(795,695),LetShowFormGame);

LoadProgressBar(form,progressbar,new Size(250,20),new Point(752,417),120);

LoadTimer(false,LetCheckThinkingTime)			

//----------------------------------------------------------------------------------
[<EntryPoint; STAThread>]
let main(args) = 
	form.add_MouseDown(new MouseEventHandler (fun  _ e ->
		if (e.Button = MouseButtons.Left) then(	
			if(!m_gameState = CREATING)then Select(e.X,e.Y)
			else HumanMove(e.X,e.Y)
		)else 
		if(e.Button = MouseButtons.Right) then (
			if(!m_gameState = CREATING)then LetAddPiece(e.X,e.Y))));
			
	form.add_Activated(new EventHandler (fun  _ _ -> 
		try
			form.Cursor <- new Cursor(sFileCursor);
		with e -> form.Cursor <- Cursors.Hand	));
			
	form.add_Paint(new PaintEventHandler(fun _ e -> 
		DrawBoard(e.Graphics,m_piece_interface,m_color_interface, !m_pieceSelecting)));	 
	
	form.add_KeyDown (new KeyEventHandler (fun _ e -> 
		KeysFun(e.KeyCode)));
	
	form.add_Closing (new CancelEventHandler (fun _ e -> 
		LetShowFormQuit();
		e.Cancel <- !quit ));
	
	form.add_Closed (new EventHandler(fun _ _  ->	grfx.Dispose();	));			
	
	Application .Run (form);
    0


