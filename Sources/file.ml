module File
open Defines
open Board
open Search
open Controls
open Media
open System.Drawing 
open System.Windows .Forms 
open System.IO
open System.Runtime.Serialization.Formatters.Binary
open System.Runtime.Serialization.Formatters.Soap

let SaveBoardToFile (f,fxml) =
try 
let g = {
	gameState = !m_gameState; 
	level = !MAX_PLY;
	checktime = !havechecktime;
	thinkingtime = !THINKINGTIME;
	side_interface = !m_side_interface;	
	xside_interface = !m_xside_interface;
	hdp_interface = !m_hdp_interface;
	piece_interface = Array.copy m_piece_interface;
	color_interface = Array.copy m_color_interface;
	h_dat = Array.sub m_hist_dat 0 !m_hdp_interface;
}in
let s = File.Create (f) in(
		if(fxml) then 
			let sf = new SoapFormatter() in sf.Serialize(s,g)
		else let bf = new BinaryFormatter() in bf.Serialize(s,g));
		s.Close()
with e -> LetShowMessage("Can not save!!!")		
		
let SaveGame()=
let d = new SaveFileDialog() in 
 d.InitialDirectory <- Application.StartupPath ;
 d.Filter <- "Xml files(*.xml)|*.xml|ChessBoard files (*.cb)|*.cb|All files (*.*)|*.*";
 d.FilterIndex <- 1;
 d.RestoreDirectory <- true;
 if(d.ShowDialog()=DialogResult.OK)then
	SaveBoardToFile(d.FileName,d.FileName.EndsWith("xml"));
 d.Dispose()
	
let LoadBoardFromFile (f,fxml) = 
try
let s = File.OpenRead (f) in
let g:Game = if(fxml) then 
				let sf = new SoapFormatter() in unbox(sf.Deserialize(s))
			 else let bf = new BinaryFormatter() in unbox(bf.Deserialize(s))in(
	m_gameState := g.gameState;
	MAX_PLY := g.level;
	havechecktime := g.checktime;
	THINKINGTIME := g.thinkingtime ;
	m_side_interface := g.side_interface; 
	m_xside_interface := g.xside_interface;
	m_hdp_interface := g.hdp_interface;
	for i = 0 to 89 do
		m_piece_interface.[i] <- g.piece_interface.[i];
		m_color_interface.[i] <- g.color_interface.[i]
	done;
	for i =0 to g.hdp_interface - 1  do  
		m_hist_dat.[i] <- g.h_dat.[i]
	done;
	m_pieceSelecting := NOMOVE;
	SelectedPiece := NOMOVE;
	form.Invalidate ();
	lbstart.Visible <- false;
	lbinfo.Visible <- false;
	timecheck := 0;
	progressbar.Value <- 1;
	timer.Enabled <- !havechecktime;
	pause := false;
	LetPlayMediaFile(sFileInit);
	if(!m_gameState = CREATING) then (
		InitNumCheck();
		lbstart.Visible <- true;
		lbinfo.Visible <- true;
		timer.Enabled <- false;
		pbh.Visible <- false;)
	else if(!m_gameState = HUMANTHINKING) then	(
			lbpause .Text <- "Paus&e";
			pbh.Visible <- true)	
	else if(!m_gameState = COMPUTERTHINKING) then (
			LetComputerThink();
			lbpause .Text <- "Paus&e";)
	)
with e -> LetShowMessage("Unknown File !!!")

let LoadGame()=
if(!m_gameState <> COMPUTERTHINKING)then(
let d = new OpenFileDialog()in 
 d.InitialDirectory <- Application.StartupPath;
 d.Filter <- "Xml files(*.xml)|*.xml|ChessBoard files (*.cb)|*.cb|All files (*.*)|*.*";
 d.FilterIndex <- 1; 
 d.RestoreDirectory <- true;
 if(d.ShowDialog() = DialogResult.OK )then 
	LoadBoardFromFile(d.FileName,d.FileName.EndsWith("xml"));
 d.Dispose ())
 