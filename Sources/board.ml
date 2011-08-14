module Board

open System.Collections 
open Defines 

let color =[|
		0; 0; 0; 0; 0; 0; 0; 0; 0;
		7; 7; 7; 7; 7; 7; 7; 7; 7;
		7; 0; 7; 7; 7; 7; 7; 0; 7;
		0; 7; 0; 7; 0; 7; 0; 7; 0;
		7; 7; 7; 7; 7; 7; 7; 7; 7;
		7; 7; 7; 7; 7; 7; 7; 7; 7;
		1; 7; 1; 7; 1; 7; 1; 7; 1;
		7; 1; 7; 7; 7; 7; 7; 1; 7;
		7; 7; 7; 7; 7; 7; 7; 7; 7;
		1; 1; 1; 1; 1; 1; 1; 1; 1|]
    
let  piece = [|
		5; 3; 2; 1; 6; 1; 2; 3; 5;
		7; 7; 7; 7; 7; 7; 7; 7; 7;
		7; 4; 7; 7; 7; 7; 7; 4; 7;
		0; 7; 0; 7; 0; 7; 0; 7; 0;
		7; 7; 7; 7; 7; 7; 7; 7; 7;
		7; 7; 7; 7; 7; 7; 7; 7; 7;
		0; 7; 0; 7; 0; 7; 0; 7; 0;
		7; 4; 7; 7; 7; 7; 7; 4; 7;
		7; 7; 7; 7; 7; 7; 7; 7; 7;
		5; 3; 2; 1; 6; 1; 2; 3; 5|]        

let  offset=
	[|
		[|-1; 1;13; 0; 0; 0; 0; 0|];	
		[|-12;-14;12;14;0;0;0;0|];		
		[|-28;-24;24;28; 0; 0; 0; 0|];	
		[|-11;-15;-25;-27;11;15;25;27|];
		[|-1; 1;-13;13; 0; 0; 0; 0|];	
		[|-1; 1;-13;13; 0; 0; 0; 0|];	
		[|-1; 1;-13;13; 0; 0; 0; 0|]	
    |]	

let mailbox182 = [|
		-1;	-1;	-1;	-1;	-1;	-1;	-1;	-1;	-1;	-1;	-1;	-1;	-1;
		-1;	-1;	-1;	-1;	-1;	-1;	-1;	-1;	-1;	-1;	-1;	-1;	-1;
		-1;	-1;	 0;	 1;	 2;	 3;	 4;	 5;	 6;	 7;	 8;	-1;	-1;
		-1;	-1;	 9;	10;	11;	12;	13;	14;	15;	16;	17;	-1;	-1;
		-1;	-1;	18;	19;	20;	21;	22;	23;	24;	25;	26;	-1;	-1;
		-1;	-1;	27;	28;	29;	30;	31;	32;	33;	34;	35;	-1;	-1;
		-1;	-1;	36;	37;	38;	39;	40;	41;	42;	43;	44;	-1;	-1;
		-1;	-1;	45;	46;	47;	48;	49;	50;	51;	52;	53;	-1;	-1;
		-1;	-1;	54;	55;	56;	57;	58;	59;	60;	61;	62;	-1;	-1;
		-1;	-1;	63;	64;	65;	66;	67;	68;	69;	70;	71;	-1;	-1;
		-1;	-1;	72;	73;	74;	75;	76;	77;	78;	79;	80;	-1;	-1;
		-1;	-1;	81;	82;	83;	84;	85;	86;	87;	88;	89;	-1;	-1;
		-1;	-1;	-1;	-1;	-1;	-1;	-1;	-1;	-1;	-1;	-1;	-1;	-1;
		-1;	-1;	-1;	-1;	-1;	-1;	-1;	-1;	-1;	-1;	-1;	-1;	-1|]    

let  mailbox90=[|
		 28;	29;		30;		31;		32;		33;		34;		35;		36;
		 41;	42;		43;		44;		45;		46;		47;		48;		49;
		 54;	55;		56;		57;		58;		59;		60;		61;		62;
		 67;	68;		69;		70;		71;		72;		73;		74;		75;
		 80;	81;		82;		83;		84;		85;		86;		87;		88;
		 93;	94;		95;		96;		97;		98;		99;		100;	101;
		106;	107;	108;	109;	110;	111;	112;	113;	114;
		119;	120;	121;	122;	123;	124;	125;	126;	127;
		132;	133;	134;	135;	136;	137;	138;	139;	140;
		145;	146;	147;	148;	149;	150;	151;	152;	153|]        

let legalposition =[|
		1;		1;		5;		3;		3;		3;		5;		1;		1;
		1;		1;		1;		3;		3;		3;		1;		1;		1;
		5;		1;		1;		3;		7;		3;		1;		1;		5;
		9;		1;		9;		1;		9;		1;		9;		1;		9;
		9;		1;		13;		1;		9;		1;		13;		1;		9;
		9;		9;		9;		9;		9;		9;		9;		9;		9;
		9;		9;		9;		9;		9;		9;		9;		9;		9;
		9;		9;		9;		9;		9;		9;		9;		9;		9;
		9;		9;		9;		9;		9;		9;		9;		9;		9;
		9;		9;		9;		9;		9;		9;		9;		9;		9|]

let maskpiece = [|8; 2; 4; 1; 1; 1; 2|] 
let elephancheck=[|-10;-8;8;10;0;0;0;0|]

let	knightcheck =[|1;-1;-9;-9;-1;1;9;9|] 
let knightcheck2 = [|-8;-10;-8;-10;8;10;8;10 |]

let	kingpalace = [| [|3;4;5;12;13;14;21;22;23|];
					[|66;67;68;75;76;77;84;85;86|]|]

let	m_piece =Array.copy(piece) 
let m_piece_interface = Array.copy(piece)

let	m_color_interface  = Array.copy(color) 
let m_color = Array.copy (color)

let	m_side_interface = ref LIGHT 
let m_xside_interface = ref DARK

let	m_side = ref LIGHT 
let m_xside = ref DARK

let	m_hdp = ref 0 
let m_hdp_interface = ref 0

let m_ply = ref 0

let	m_gen_begin = Array.create HIST_STACK 0 
let	m_gen_end = Array.create HIST_STACK 0

let m_gen_dat:GEN_REC array = Array.create  MOVE_STACK ({m={from=0;dest=0};
														p1={x=0;y=0};p2={x=0;y=0};
														prior=0})
let m_hist_dat :HIST_REC array= Array.create HIST_STACK ({mh={from=0;dest=0};capture=0})

let m_newmove:MOVE  = {from = 0 ;dest = 0}

let m_materialnumber =  [|	[|5; 2; 2; 2; 2; 2; 1|];
							[|5; 2; 2; 2; 2; 2; 1|]|]
let m_bFollowPV = ref false

let m_pv = Array.create HIST_STACK {from = 0; dest = 0}							

let m_history =	Array2D.create 90 90 0

let m_from = ref 0 
let m_dest = ref 0

//==================================================================================
let InitData() =(
for  i=0 to 89 do	m_piece_interface.[i] <-  piece.[i];
					m_color_interface.[i] <- color.[i] done;
m_side_interface := LIGHT; 
m_xside_interface := DARK;	
m_hdp_interface := 0;
)
	
let PreCalculate() =(
for i= 0 to 89 do   m_piece.[i]<- m_piece_interface.[i];
					m_color.[i] <-  m_color_interface.[i] done;
m_hdp := !m_hdp_interface;
m_side := !m_side_interface;
m_xside := !m_xside_interface)

let UpdateNewMove(frm, dst) = 
let kq = ref false in 
	if (frm = NOMOVE || dst = NOMOVE) then kq := true
	else(
	let p = m_piece_interface.[dst] in
		m_hist_dat.[!m_hdp_interface] <- {mh={from=frm;dest=dst};capture=p};
		m_piece_interface.[dst] <-  m_piece_interface.[frm];
		m_piece_interface.[frm] <-  EMPTY;
		m_color_interface.[dst] <-  m_color_interface.[frm];
		m_color_interface.[frm] <-  EMPTY;
		m_hdp_interface := !m_hdp_interface + 1;
		kq := (p = KING));
	!kq

let ChangeSide() =
let t = !m_side_interface in
	m_side_interface := !m_xside_interface;
	m_xside_interface := t 

let CanUndoMove()=(!m_hdp_interface >0)

let UndoMove()=(
	m_hdp_interface := !m_hdp_interface - 1;
	m_from := m_hist_dat.[!m_hdp_interface].mh.from;
	m_dest := m_hist_dat.[!m_hdp_interface].mh.dest;
	let p = m_hist_dat.[!m_hdp_interface].capture in
	m_piece_interface.[!m_from] <- m_piece_interface.[!m_dest];
	m_piece_interface.[!m_dest] <- p;
	m_color_interface.[!m_from] <- m_color_interface.[!m_dest];
	if (p=EMPTY)then m_color_interface.[!m_dest] <- EMPTY
	else m_color_interface.[!m_dest] <- !m_side_interface;
	ChangeSide();
)

let KingFace(from,dest)=
    let r = ref false in
    let i = (from % 9) in 
    let mpd = m_piece_interface.[dest] in
    if ((i >= 3) && (i <= 5) && (mpd <> KING))then(
   	    m_piece_interface.[dest] <- m_piece_interface.[from];
   	    m_piece_interface.[from] <- EMPTY ;
	    let k = ref kingpalace.[0].[0]in 
	    while((!k <90)&&(m_piece_interface.[!k]<>KING))do k := !k + 1 done;
	    k := !k + 9;
	    while((!k < 90) && (m_piece_interface.[!k] = EMPTY))do k := !k + 9 done;
	    if(!k < 90 && m_piece_interface.[!k] = KING)then  r := true;
	    m_piece_interface.[from] <- m_piece_interface.[dest]; 
	    m_piece_interface.[dest] <- mpd
    );
    !r

let CheckPosition(pv,pos)=
let kq = ref true in
if(pv = BISHOP)then
	 if(pos = 12 || pos = 14 ||  pos = 22)then kq := false;		
!kq	

let CheckPawnPosition()=
let kq = ref true in
	let i = ref 27 in
		while(!i <= 35) do (
			if(m_piece_interface.[!i] = PAWN &&
				m_piece_interface.[!i] = m_piece_interface.[!i + 9] &&
				m_color_interface.[!i] = m_color_interface.[!i + 9])then (
					kq := false;
					i:= 36;
			);
			i := !i + 2;
		)done;
	if(!kq = true)then(
		let i = ref 45 in
		while(!i <= 53) do (
			if(m_piece_interface.[!i] = PAWN &&
				m_piece_interface.[!i] = m_piece_interface.[!i + 9] &&
				m_color_interface.[!i] = m_color_interface.[!i + 9])then (
					kq := false;
					i:= 54;
			);
			i := !i + 2;	
		)done
	);
!kq		