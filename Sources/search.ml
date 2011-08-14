module Search
open Defines
open Board
open Gen
open Eval
open Move
open Graphics
open Controls
open Media
open System.Windows.Forms
open System.Drawing 

let SetMaterial()=(
for i=0 to 6 do(
	m_materialnumber.[0].[i] <- 0;
	m_materialnumber.[1].[i] <- 0;
)done;
for i=0 to 89 do
if(m_piece.[i] <> EMPTY) then
	let cl = m_color.[i] in
    let pc = m_piece.[i]in
	m_materialnumber.[cl].[pc] <- m_materialnumber.[cl].[pc]+1;
done			
)				

let Check_pv () =(
m_bFollowPV := false;
let i = ref m_gen_begin.[!m_ply]in
while(!i< m_gen_end.[!m_ply])do(
	if((m_gen_dat.[!i].m.from = m_pv.[!m_ply].from) &&
		 (m_gen_dat.[!i].m.dest = m_pv.[!m_ply].dest)) then(
			m_bFollowPV := true;
			let gd = m_gen_dat.[!i]in
			gd.prior <- gd.prior + 1000;
			m_gen_dat.[!i] <- gd;
			i:=1000;
	);
	i := !i+1;
)done	
)

let rec Quicksort(q, r) =(
	let i = ref q in
    let j = ref r in
	let x = m_gen_dat.[(q+r)/2].prior in
	while (!i <= !j) do(
		while (m_gen_dat.[!i].prior > x) do i := !i + 1; done;
		while (m_gen_dat.[!j].prior < x) do j := !j - 1; done;
		if (!i <= !j) then(
			let g = m_gen_dat.[!i]in				
				m_gen_dat.[!i] <- m_gen_dat.[!j];
				m_gen_dat.[!j] <- g;
			i := !i + 1;j := !j - 1;
		)
	)done;
	if (q < !j) then Quicksort(q, !j);
	if (!i < r) then Quicksort(!i, r);
)

let Sort() = Quicksort(m_gen_begin.[!m_ply], m_gen_end.[!m_ply]-1)

let rec Quiescence(alpha, beta) =(
	let best = ref 0 in
	let  value = ref (Evalu())in
	if (!value >= beta) then best := !value
	else( 
		let af = ref alpha in
		if (!value > !af) then 	af := !value;
		Gene(true);
		if(m_gen_begin.[!m_ply] >= m_gen_end.[!m_ply]) then best := !value
		else(
			if (!m_bFollowPV) then Check_pv(); 
			Sort(); 
			best := INFINITY;
			let i = ref m_gen_begin.[!m_ply]in
			while(!i < m_gen_end.[!m_ply] && !best<beta)do(
				if(!best > !af) then af := !best;
				if(MakeMove(m_gen_dat.[!i].m))then  value := 1000 - !m_ply
				else value := -Quiescence(-beta, -(!af));
				UnMakeMove();
				if(!value > !best) then(
					best := !value; 
					m_pv.[!m_ply] <- m_gen_dat.[!i].m;
				);
				i := !i+1;					
			)done
		)	
	);
	!best
)

let rec AlphaBeta(alpha, beta, depth)=(
Application .DoEvents ();
if (depth = 0 )then  Quiescence(alpha, beta)
else( 
	  Gene(false);
   	  let best = ref INFINITY in
      let i = ref m_gen_begin.[!m_ply] in
      let ralpha = ref alpha in
   	  while((!i < m_gen_end.[!m_ply]) && (!best < beta))do(
		if (!best > !ralpha) then ralpha := !best;
		let value = ( if (MakeMove(m_gen_dat.[!i].m))then (1000 - !m_ply)
						else  - AlphaBeta(-beta, -(!ralpha), depth-1) )in
		UnMakeMove();
		if (value > !best) then( 
			best := value; 
			if (!m_ply = 0)then (
			m_newmove.from <- m_gen_dat.[!i].m.from;
			m_newmove.dest <- m_gen_dat.[!i].m.dest)
		);
		i:=!i+1;
		)done;
		!best ))
       
let ComputerThink() = (
	PreCalculate();
	InitGen();
	SetMaterial();
	m_pv.[0] <-{from = NOMOVE ; dest = m_pv.[0].dest};
	for i=0 to 89 do
		for j=0 to 89 do
			m_history.[i,j]<-0;
		done			
	done;
	
	m_newmove.from <- NOMOVE;
	let depth = ref 1 in
    while (!depth <= !MAX_PLY) do(
		m_bFollowPV := true;
		let  best = AlphaBeta(INFINITY, -INFINITY,!depth)in 
		if (m_newmove.from =NOMOVE) then depth := !MAX_PLY+1
			else depth := !depth + 1;
					
	)done;
)
let LetComputerThink() = 
if (!m_gameState <> GAMEOVER)then(
pbh.Visible <- false;
pbc.Visible <- true;		
timecheck := 0;
progressbar.Value <- 1;
timer.Enabled <- false;
ComputerThink();
if(m_newmove.from <> NOMOVE)then(
let	z = m_newmove.from 	in
let	k = m_newmove.dest in
let	compwon = ref false in
let	pc = m_piece_interface.[z] in
let cl= m_color_interface.[z] in
let i = pc + (if(cl=LIGHT)then 0 else 7)in
if (UpdateNewMove(z, k))then compwon := true;
let rz = GetPieceRect(z) in
let rk = GetPieceRect(k) in
	LetPlayMediaFile(sFileMove);
	LetShowMove(rz.Left+8,rz.Top+8,rk.Left+8,rk.Top+8,m_string_list.[i],grfx,form);
	if(!compwon=false)then(
	ChangeSide();
	if (not(IsThereLegalMove()))then compwon := true;
	);
	if(!compwon)then ComputerWon()
	else m_gameState := HUMANTHINKING;
pbc.Visible <- false;
pbh.Visible <- true ;
timer.Enabled <- !havechecktime;
)else HumanWon()
)			

