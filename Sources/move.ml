module  Move
open Defines
open Board

let MakeMove(mov:MOVE )=
let kq = ref false in
let frm = mov.from in
let dst = mov.dest in
let p = m_piece.[mov.dest] in(
	if (p <> EMPTY) then
		m_materialnumber.[!m_xside].[p] <- m_materialnumber.[!m_xside].[p] - 1;
	m_hist_dat.[!m_hdp] <- {mh={from=frm ;dest=dst};capture=p};
	m_piece.[dst] <-  m_piece.[frm];
	m_piece.[frm] <-  EMPTY;
	m_color.[dst] <-  m_color.[frm]; 
	m_color.[frm] <-  EMPTY;
	m_hdp := !m_hdp + 1;	
	m_ply := !m_ply + 1;
	let t = !m_side in  
		m_side := !m_xside;
		m_xside := t;
	kq :=(p = KING));
	!kq
	
let UnMakeMove() = (
m_hdp := !m_hdp - 1; 
m_ply:= !m_ply-1;
let t = !m_side in 
	m_side := !m_xside ; 
	m_xside := t;
let	from = m_hist_dat.[!m_hdp].mh.from in
let dest = m_hist_dat.[!m_hdp].mh.dest in
let p = m_hist_dat.[!m_hdp].capture in
	m_piece.[from] <-  m_piece.[dest];	
	m_piece.[dest] <- p;
	m_color.[from] <-  m_color.[dest];	
	m_color.[dest] <-  EMPTY;
	if (p <> EMPTY) then( 
		m_color.[dest] <-  !m_xside;
		m_materialnumber.[!m_xside].[p] <- m_materialnumber.[!m_xside].[p] + 1;	
	))
	
let Attack (pos,vside) =(
let kq = ref false in
let sd = vside in
let xsd = 1 - sd in
let j = ref 0 in
while (!j < 4) do(
	let x = ref(mailbox90.[pos]) in
    let fcannon = ref 0 in
    let k = ref 0 in
	while (!k < 9) do(
		x := !x + offset.[ROOK].[!j];
		let y = mailbox182.[!x] in
		if (y = -1) then k := 10
		else(
			if (!fcannon = 0) then(
				if (m_color.[y] = xsd) then(
					match (m_piece.[y]) with 5 ->
						kq := true; k := 10;j := 10
					|6 -> 
						if (m_piece.[pos] = KING) then( 
							kq := true;	k := 10;j := 10;
						)
					|0 ->
						if (!k = 0 && ((sd=DARK && !j<>2) || (sd=LIGHT && !j<>3))) then(
							kq := true;	k := 10;j := 10;
						)
					|_ -> ()						
				);
				if (!kq = false && m_color.[y] <> EMPTY) then fcannon := 1;			
			)else( 	
				if (m_color.[y] <> EMPTY) then(
					if (m_color.[y]=xsd && m_piece.[y]=CANNON) then( 
						kq := true;k := 10;j := 10;
					);
					k := 10;						
					)
				)
			);
		k := !k + 1;
	)done;
	j := !j + 1;
)done;

if(!kq = false) then(
	let j = ref 0 in
	while (!j < 8) do(	
		let y = mailbox182.[mailbox90.[pos] + offset.[KNIGHT].[!j]]in
		if (y <> -1) then(
			if (m_color.[y]=xsd && m_piece.[y]=KNIGHT && 
				m_color.[pos + knightcheck2.[!j]]=EMPTY) then(
				kq := true;j := 10;
			)
		);
		j := !j + 1;
	)done;
);
!kq
)

let IsInCheck (sd) =(
	let kq = ref false in
	let i = ref 0 in
	let pos = ref (kingpalace.[sd].[!i]) in
	i := !i + 1;
	while (m_piece.[!pos] <> KING) do(
		pos := kingpalace.[sd].[!i];				
		i := !i + 1;
	)done;
	kq := Attack(!pos, sd);
	!kq
)

let CheckMoveLoop(side) =(
let kq = ref false in
if ((!m_hdp<4) || (	m_materialnumber.[side].[ROOK] +
					m_materialnumber.[side].[CANNON] +
					m_materialnumber.[side].[KNIGHT] + 
					m_materialnumber.[side].[PAWN]) = 0) then kq := false	
else(
	let	 m = if (!m_hdp > MAXREP) then MAXREP else !m_hdp in
    let  c = ref 0 in
    let i = ref 0 in 
    let k = ref 0 in
    let di = ref 0 in
	let hdmap = Array.create (MAXREP+1) 0 in			 
	while (!i < m && !di = 0) do(
		if (m_hist_dat.[!m_hdp - 1 - !i].capture <> EMPTY) then(
			kq := false; di := 1;
		)
		else(
			if (hdmap.[MAXREP - !i] = 0) then(
				c := !c + 1;
				hdmap.[MAXREP - !i] <- !c;
				let p = m_hist_dat.[!m_hdp - 1 - !i].mh.dest in
                let f = ref (m_hist_dat.[!m_hdp - 1 - !i].mh.from) in
				let j = ref (!i + 1) in
                let dj = ref 0 in
				while (!j < m && !dj = 0) do(
						if (!f = m_hist_dat.[!m_hdp - 1 - !j].mh.dest) then(
							f := m_hist_dat.[!m_hdp - 1 - !j].mh.from;
							hdmap.[MAXREP - !j] <- !c;
							if (p = !f) then(
								if (!k < !j) then k := !j;
								dj := 1;
							)
						);
						if(!dj=0)then j := !j + 1;
				)done;
				if (!j >= m) then (di := 1;kq:=false)
			);
			if(!di=0)then(
				i := !i + 1;
				if (!i > 2 && !i = !k) then(
					let b = Attack (m_hist_dat.[!m_hdp - 1].mh.dest, side) in
					if (b = false) then(
						let cm = m_hist_dat.[!m_hdp - 1].mh in
						UnMakeMove();
						let c = Attack (cm.from, side) in
						let mm = MakeMove(cm) in
						if (c = true) then kq := false
					)
					else kq := true;
					di:=1;
				)
			)
		))done;
	);
	!kq
)

let IsSafeMove(frm,dst)=
	let k = ref false in
	if (m_piece.[dst]=KING)then k := true
	else(
	let mv = {from = frm; dest = dst}in
	let _ = MakeMove(mv)in
	k := IsInCheck(!m_xside);
	if (!k=false)then  k := CheckMoveLoop(!m_xside);
	UnMakeMove();
	k:= not(!k);
	);
	!k


		