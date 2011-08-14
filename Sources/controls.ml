module Controls
open Defines
open Graphics
open Media
open System
open System.Windows.Forms 
open System.Resources
open System.Drawing 

let lbinfo = new Label()
let lbcomputermove = new Label()
let lbstart = new Label()
let lbpause = new Label()
let lbgame = new Label()
let lbhelp = new Label()
let lbundomoves = new Label()
let lboptions = new Label()
let lbboard = new Label()
let lbgrid = new Label()
let lbpiece = new Label()
let lbdelete = new Label()
let lbdefault = new Label()
let pbc = new PictureBox()
let pbh = new PictureBox()
let pbs = new PictureBox()
let timer = new Timer()
let progressbar = new ProgressBar()
  
let form  ={ new Form() with override x.OnLoad(e) =base.OnLoad(e);
	base.SetStyle(ControlStyles.AllPaintingInWmPaint,true);  
	base.SetStyle(ControlStyles.DoubleBuffer ,true);
	base.SetStyle(ControlStyles.UserPaint ,true);
	LetPlayMediaFile(sFileInit);
}
do
form.Text <- "ML Chinese Chess ";
form.Size <- new Size(1024,768);	
form.BackColor <- Color.Black ;
form.BackgroundImage <- Image .FromFile (sFileWindowsBackground);
form.FormBorderStyle <- FormBorderStyle.None;
form.StartPosition <- FormStartPosition .CenterScreen 

let LoadIcon(f:string)= 
try	
	let myReader = new ResourceReader(f) in
		let de = myReader.GetEnumerator()in
			let b = de.MoveNext() in form.Icon <- unbox(de.Value) 
with e -> Printf.printf "Can not load file" 
do LoadIcon("MLChineseChess.resources")

let LoadTimer(v,f)=(
	timer.Interval <- 1000;
	timer .Enabled <- v ;
	timer.add_Tick (new EventHandler(fun _ _ -> f()));
	
)

let grfx = form.CreateGraphics ()

let RequireDrawCell(pos) = let rect = GetPieceRect(pos) in form.Invalidate(rect)

let SetImage((p:PictureBox),sFileName)=
try	
	let img = Image.FromFile (sFileName) in	p.Image <- img;
with e -> Printf.printf "Can not load file" 	

let GetFileName()=
let s = ref "" in(
	let d = new OpenFileDialog()in (
		d.Title <- "Select an Image";
		d.InitialDirectory <- Application.StartupPath ;
		d.Filter <- "All Image Files|*.bmp;*.gif;*.tif;*.jpg;*.jpeg;*.png;*.ico;*.emf;*.wmf|" ^
			 "Bitmap  Files(*.bmp,*.gif,*.tif,*.jpg,*.jpeg,*.png,*.ico)|" ^
							 "*.bmp;*.gif;*.tif;*.jpg;*.jpeg;*.png;*.ico|" ^
             "Meta Files(*.emf,*.wmf)|*.emf;*.wmf";
		d.FilterIndex <- 1;
		d.RestoreDirectory <- true;
		if(d.ShowDialog()=DialogResult.OK)then s := d.FileName);d.Dispose());
	!s		
	
let LoadPictureBox((frm:Form),(p:PictureBox),s,(point:Point),(size:Size),name,f) = (
	SetImage(p,s);
	p.Size <- size;
	p.Location <- point; 
	p.SizeMode <- PictureBoxSizeMode .StretchImage ;
	p.Name <- name;
	p.add_Click(new EventHandler (fun _ e -> f())); 
	if(p.Name = "human" || p.Name = "computer")then
	p.add_DoubleClick(new EventHandler (fun _ e -> 
		let sFileName = GetFileName()in
			if(sFileName<>"")then( 
				SetImage(p,sFileName);
				if(p.Name = "human")then sFileHuman := sFileName
				else if(p.Name = "computer")then sFileComputer := sFileName;
			))); 
	frm.Controls .Add (p);
)	

let LoadCaption((frm:Form),(lb:Label),text,(p:Point))=(
	lb.AutoSize <- true;
	lb.BackColor <- Color.Transparent;
	lb.Font <- new Font("Times New Roman", 14.25F, FontStyle.Bold);
	lb.ForeColor <- Color.White;
	lb.Location <- p;
	lb.Text <- text;
	frm.Controls.Add (lb)
)

let LoadCheckBox((frm:Form),(cb:CheckBox),text,b,(p:Point),(s:Size))=(
	cb.BackColor <- Color.Transparent;
	cb.Font <- new Font("Times New Roman", 14.25F, FontStyle.Bold);
	cb.ForeColor <- Color.White;
	cb.Location <- p;
	cb.Size <- s;
	cb.Text <- text;	
	cb.Checked <- b;
	cb.Cursor <- Cursors.Hand;
	frm.Controls.Add (cb)
)

let LoadNumericUpDown((frm:Form),(nmrud:NumericUpDown),
						(min:int),(max:int),(p:Point),(s:Size))=(
	nmrud.Font <- new Font("Times New Roman", 14.25F, FontStyle.Bold);
	nmrud.ForeColor <- Color.Black;
	nmrud.Location <- p;
	nmrud.BackColor <- Color.White;
	nmrud.Size <- s;
	nmrud.Maximum <- new Decimal(max);
	nmrud.Minimum <- new Decimal(min);
	nmrud.Value <- new Decimal(!THINKINGTIME);
	nmrud.TextAlign <- HorizontalAlignment .Center ;
	nmrud.Cursor <- Cursors.Hand;
	nmrud.ReadOnly <- true;
	nmrud.Enabled <- !havechecktime;
	frm.Controls.Add (nmrud)
	
)
let LoadStringToComboBox(cbb:ComboBox)=(
	ignore(cbb.Items.Add("Easy"));
	ignore(cbb.Items.Add("Normal"));
	ignore(cbb.Items.Add("Hard"));
	ignore(cbb.Items.Add("Very Hard"))
)

let LoadCombobox((frm:Form),(cbb:ComboBox),(p:Point),(s:Size))=(
	cbb.Font <- new Font("Times New Roman", 14.25F, FontStyle.Bold);
	cbb.ForeColor <- Color.Black;
	cbb.Location <- p;
	cbb.Size <- s;
	LoadStringToComboBox(cbb);
	cbb.DropDownStyle <- ComboBoxStyle.DropDownList;
	cbb.SelectedIndex <- !MAX_PLY - 1;
	cbb.Cursor <- Cursors.Hand;
	frm.Controls.Add (cbb);
	
)

let LoadLabel((frm:Form),(lb:Label),text,(fcl:Color),(size:Size),(p:Point),f)=(
	lb.Size <- size;
	lb.Location  <- p;
	lb.Font <- new Font("Times New Roman", 14.0F);
	lb.Text <- text;
	lb.TextAlign <- ContentAlignment .MiddleCenter ;
	lb.ForeColor <- fcl;
	lb.BackgroundImage <- Image.FromFile(sFileButton);
	lb.BorderStyle <- BorderStyle.FixedSingle ;
	lb.add_MouseEnter(new EventHandler (fun _ _ ->
		lb.ForeColor <- Color.Red;));
	lb.add_MouseLeave(new EventHandler (fun _ _ -> 
		lb.ForeColor <- fcl;));
	lb.add_Click (new EventHandler (fun _ _ ->  f()));
	frm.Controls.Add (lb)
)

let LoadButton((frm:Form),(bt:Button),text,(size:Size),(p:Point),f)=(
	bt.Size <- size;
	bt.Location  <- p;
	bt.Font <- new Font("Times New Roman", 14.0F);
	bt.Text <- text;
	bt.TextAlign <- ContentAlignment .MiddleCenter ;
	bt.ForeColor <- Color.Black;
	bt.BackgroundImage <- Image.FromFile(sFileButton);
	bt.FlatStyle <- FlatStyle.Flat;
	bt.Cursor <- Cursors.Hand;
	bt.add_MouseEnter(new EventHandler (fun _ _ ->
		bt.ForeColor <- Color.Red;
		bt.BackColor <- Color.BurlyWood  ; ));
	bt.add_MouseLeave(new EventHandler (fun _ _ -> 
		bt.ForeColor <- Color.Black;
		bt.BackColor <- Color.Transparent; ));
	bt.add_Click (new EventHandler (fun _ _ ->  f()));
	frm.Controls.Add (bt)
)

let LoadDialog((dlg:Form),(s:Size),f)=(
		dlg.FormBorderStyle <- FormBorderStyle.None;
		dlg.StartPosition <- FormStartPosition .CenterScreen ;
		let image = Image.FromFile(f)in
		dlg.BackgroundImage <- image;
		dlg.Size <- s;
			
)

let LoadProgressBar((frm:Form),(p:ProgressBar),(s:Size),(lc:Point),max)=(
	p.Location <- lc;
	p.Size <-s;
	p.Minimum <-1;
	p.Maximum <- max;
	p.Value <- 1;
	frm.Controls.Add (p)
)
let LetShowMessage(s)=
let dlgmessage = new Form() in(
LoadDialog(dlgmessage,new Size(402,174),sFileDialog);
let  lbclose = new Label() in
let lbmessage = new Label() in
let btok = new Button() in
let pbmessage = new PictureBox()in
let	LetCloseDialog()=(dlgmessage.Close())in
LoadLabel(dlgmessage,lbclose,"X",Color.Red,new Size(20,20),new Point(382,1),LetCloseDialog);
LoadPictureBox(dlgmessage,pbmessage,!sFileComputer,new Point(50,30),new Size(75,75),"",efun);
pbmessage.BackColor <- Color.Transparent;
LoadCaption(dlgmessage,lbmessage,s,new Point(132,55));
lbmessage.ForeColor <- Color.Red;
LoadButton(dlgmessage,btok,"Ok",new Size(100,25),new Point(152,115),LetCloseDialog);
ignore(dlgmessage.ShowDialog())
)


let LetShowFormWon(won,sfilewon)=
let dlgwon = new Form()in(
LoadDialog(dlgwon,new Size(283,241),sFileForm);
let lbclose = new Label()in
let lbwon1 = new Label()in
let lbwon2 = new Label()in
let btok = new Button() in
let pbwon = new PictureBox()in
let	LetCloseDialog()= (dlgwon.Close()) in			
LoadLabel(dlgwon,lbclose,"X",Color.Red,new Size(20,20),new Point(263,1),LetCloseDialog);	
LoadCaption(dlgwon,lbwon1,won,new Point(70,35));
LoadPictureBox(dlgwon,pbwon,sfilewon,new Point(100,68),new Size(75,75),"",efun);
pbwon.BackColor <- Color.Transparent;
LoadCaption(dlgwon,lbwon2,won,new Point(70,150));
LoadButton(dlgwon,btok,"Ok",new Size(100,25),new Point(87,182),LetCloseDialog);							
ignore(dlgwon.ShowDialog()))

let HumanWon()=(
m_gameState := GAMEOVER;
timer.Enabled <- false;
LetShowFormWon("   Human Won!",!sFileHuman);
)

let ComputerWon()=(
m_gameState := GAMEOVER;
timer.Enabled <- false;
LetShowFormWon("Computer Won!",!sFileComputer);
)