module Graphics
open Defines
open System
open System.Runtime.InteropServices
open System.Collections 
open System.Windows.Forms  
open System.Drawing
open Printf

let rectBoard = new Rectangle (XMARGIN,YMARGIN,m_xcell *9,m_ycell *10)

let fbackgroundimage = ref ""

let gridcolor = ref Color.Black

let m_string_list = Array.create 15 ""
let piecespath = ref "PieceImage"					 
let CreateStringList()=(
	for i= 0 to 13 do
	let sFileName = Application.StartupPath ^
					 "\\Images\\" ^ !piecespath ^ "\\p" ^ string i  ^ ".png" in					 
		m_string_list.[i] <- sFileName					 
	done;					 
	m_string_list.[14] <- "";					 
)

let Default()=(
 fbackgroundimage := sFileBackground;
 gridcolor := Color.Black; 
 piecespath := "PieceImage";
 CreateStringList()
)do Default()

let DrawPiece((grfx :Graphics),piece,color,pos,selecting) = 
if (piece <> EMPTY) then(
	let i = ref 0 in
	try		
	let	x = (pos % 9) * m_xcell + rectBoard.Left + 8  in
	let	y = (pos / 9) * m_ycell + rectBoard.Top + 6   in
	let z = piece + (if(color = LIGHT) then 0 else 7)in
		i := z;
		let image = Image.FromFile(m_string_list.[z])in
			grfx.DrawImage( image,x,y,IW,IH);
	if (selecting) then(
		i := 14;
		let image = Image.FromFile(m_string_list.[14])in
			grfx.DrawImage(image,x-8,y-8,76,76);
	)			
	with e -> ignore(grfx.DrawString("Can not load file " ^ m_string_list.[!i],
			new Font("Times New Roman", 14.0F),new SolidBrush(Color.Red),5.0F,350.0F));		
)

let DrawAllPieces((grfx:Graphics),(piece: array<_>),(color: array<_>),selectingPos) =
	for i=0 to 89 do
		DrawPiece(grfx,piece.[i],color.[i],i,(i=selectingPos))
	done
	
let DrawMark((grfx:Graphics) ,(pen:Pen), x,  y, mode) = 
	let	sx = m_xcell / 5 in
    let  sy = m_ycell / 5 in
	if ((mode &&& 1) >0) then(
		grfx.DrawLine(pen,x-3-sx,y-3,x-3,y-3);
		grfx.DrawLine(pen,x-3,y-3-sy,x-3,y-3);
		grfx.DrawLine(pen,x-3-sx,y+3,x-3,y+3);
		grfx.DrawLine(pen,x-3,y+3+sy,x-3,y+3);
	);				
	if ((mode &&& 2 )>0) then(
		grfx.DrawLine(pen,x+3+sx,y-3,x+3,y-3);
		grfx.DrawLine(pen,x+3,y-3-sy,x+3,y-3);
		grfx.DrawLine(pen,x+3+sx,y+3,x+3,y+3);
		grfx.DrawLine(pen,x+3,y+3+sy,x+3,y+3);
	)

let DrawBackground((grfx:Graphics),f) = 
try
let	img = Image.FromFile (f) in	
grfx.DrawImage (img,rectBoard);
with e -> ignore(grfx.DrawString("\nCan not load file " ^ f ^ " or " ^ sFileForm,
			new Font("Times New Roman", 14.0F),new SolidBrush(Color.Red),5.0F,365.0F))
		
let DrawGrid((grfx:Graphics),(gcl:Color))=(
	let	pen = new Pen(gcl ,2.0F) in
	let	x1 = rectBoard.Left + m_xcell/2 in
    let y1 = rectBoard.Top + m_ycell/2  in
	let	x2 = x1 + m_xcell * 8  in
    let y2 = y1+m_ycell * 9 in
	for i=0 to 9 do	
		grfx.DrawLine(pen,x1,y1 + i * m_ycell,x2,y1 + i * m_ycell)
	done;
	grfx.DrawLine (pen,x1,y1,x1,y2);grfx.DrawLine(pen,x2,y1,x2,y2);
    for  i=1 to 7 do 
		grfx.DrawLine(pen,x1+i*m_xcell,y1,x1+i*m_xcell,y1+4*m_ycell);
	 	grfx.DrawLine(pen,x1+i*m_xcell,y1+5*m_ycell, x1+i*m_xcell,y2)
	 done;
	grfx.DrawLine(pen,x1+3*m_xcell,y1,x1+5*m_xcell,y1+2*m_ycell);
	grfx.DrawLine(pen,x1+5*m_xcell,y1,x1+3*m_xcell,y1+2*m_ycell);
    grfx.DrawLine(pen,x1+3*m_xcell,y1+7*m_ycell,x1+5*m_xcell,y1+9*m_ycell);
	grfx.DrawLine(pen,x1+5*m_xcell,y1+7*m_ycell,x1+3*m_xcell,y1+9*m_ycell);
	let j = ref 3 in 
	while( !j <=6) do 
		let i =ref 2 in 
		while( !i <=6 ) do
			DrawMark(grfx,pen, x1 + !i  * m_xcell,y1 + !j * m_ycell, 3);
			i := !i + 2 
		done;
		j := !j + 3 
	done;
	DrawMark(grfx,pen,x1,y1+3*m_ycell, 2);
	DrawMark(grfx,pen,x1,y1+6*m_ycell, 2);
	DrawMark(grfx,pen,x1+8*m_xcell,y1+3*m_ycell,1);
	DrawMark(grfx,pen,x1+8*m_xcell,y1+6*m_ycell, 1);
	DrawMark(grfx,pen,x1+m_xcell,y1+2*m_ycell, 3);
	DrawMark(grfx,pen,x1+7*m_xcell,y1+2*m_ycell, 3);
	DrawMark(grfx,pen,x1+m_xcell,y1+7*m_ycell, 3);
	DrawMark(grfx,pen,x1+7*m_xcell,y1+7*m_ycell, 3);
	pen.Dispose ())
	
let DrawBoard((grfx:Graphics),  piece,  color,  selectingPos) = (
	DrawBackground(grfx,!fbackgroundimage);
	if(!pause=false)then(
	DrawGrid(grfx,!gridcolor);
	DrawAllPieces(grfx,piece,color,selectingPos)))

let GetPiecePos(pt:Point) = 
	let	x = (pt.X - rectBoard.Left) / m_xcell in
    let y = (pt.Y - rectBoard.Top) / m_ycell in
		x + ( y * 9 )
		
let GetPieceRect(pos) =
	let x = XMARGIN + (pos % 9)*m_xcell  in
	let y = YMARGIN + (pos/9)*m_ycell  in
		let  rect = new Rectangle(x,y-2,76,76) in	rect	

let LetShowMove(x1,y1,x2,y2,f,(grfx:Graphics),(form:Form))=(
	let Dx = x2-x1 in
    let Dy = y2-y1 in 
	let	Inversion = ref false in
    let pi = ref 0 in
	let	const1 = ref 0 in
    let const2 = ref 0 in
	let tmpDx = abs(Dx) in
    let	tmpDy = abs(Dy)in
		let themx = ref 0 in
		if (Dx>0)then themx := 1;
		if (Dx<0)then themx := -1;
		let themy = ref 0 in
		if (Dy>0) then themy := 1;
		if (Dy<0) then themy := -1;
		if (tmpDx>tmpDy)then(
			pi := 2*tmpDy-tmpDx ;
			const1 := 2*tmpDy;
			const2 := 2*(tmpDy-tmpDx);
			Inversion := false;
		)else(
			pi := 2*tmpDx-tmpDy;
			const1 := 2*tmpDx;
			const2 := 2*(tmpDx-tmpDy);
			Inversion := true;
		);
		
		let x = ref x1 in
        let y = ref y1 in
		try
		let image = Image.FromFile (f)in
			while ((!x<>x2)||(!y<>y2) )do(
				form.Invalidate();
				if (!pi<0)then pi := !pi + !const1
				else(
					pi := !pi + !const2;
					if(!Inversion=false) then y := !y + !themy
					else x := !x + !themx
				);
				if(!Inversion=true)then y := !y + !themy
				else x := !x + !themx;
				grfx.DrawImage (image,!x,!y,IW,IH );
				for i=0 to 500 do
                    ()
					//printf "Thien"	
				done				
			)done;
		with e -> ignore(grfx.DrawString("Can not load file " ^ f,
			new Font("Times New Roman", 14.0F),new SolidBrush(Color.Red),5.0F,269.0F))			
			
)			