module  Gen

open System.Collections 
open Defines
open Board
open Move

let InitGen() = (
m_gen_begin.[0]<- 0; 
m_ply := 0;
)

let Gen_Push(frm ,dst) =
if (IsSafeMove(frm, dst)=true) then (
let i = m_gen_end.[!m_ply] in(
	let pri = if (m_piece.[dst]<>EMPTY)then (m_piece.[dst]+1)*100 - m_piece.[frm]
				else  m_history.[frm,dst]in
	m_gen_dat.[i] <- {	m={from = frm  ;dest = dst};
						p1=PosArray.[frm]; p2=PosArray.[dst];
						prior = pri};
	m_gen_end.[!m_ply] <- (i + 1)
))

let Gene(bcapture) = (
m_gen_end.[!m_ply] <- m_gen_begin.[!m_ply];
for i = 0 to 89 do
if (m_color.[i] = !m_side) then(
let p =m_piece.[i] in 
let j = ref 0 in
while( !j < 8)do (
	let v = offset.[p].[!j]in	
	if(v = 0) then  j := 8
	else(
		let	x = ref mailbox90.[i] in
        let fcannon = ref false in
        let k = ref 1 in
        let n = (if ((p = ROOK) || (p = CANNON) ) then   9 else  1) in
        while(!k <= n) do(	k := (!k + 1);
			if ((p = PAWN )&& ( !m_side  = LIGHT)) then  x := (!x - v)
            else	x := (!x + v);
            let y = mailbox182.[!x] in 
            let t = (if(!m_side = DARK) then y else (89 - y)) in
			if ((y = -1) || (legalposition.[t] &&& maskpiece.[p] = 0))then k :=  10
			else(                    			
				if(!fcannon = false)then(
					if(m_color.[y] <> !m_side ) then(
						match p with 3 -> 
							if(m_color.[i+knightcheck.[!j]]=EMPTY)then(
								if(bcapture = false || m_color.[y] = !m_xside)then
									Gen_Push(i, y);)
                        | 2 ->
							if (m_color.[i+elephancheck.[!j]]=EMPTY)then (
								if(bcapture = false || m_color.[y] = !m_xside)then
									Gen_Push(i, y);)
						| 4 ->
						 	if (m_color.[y] = EMPTY && bcapture = false)then
										Gen_Push(i, y)
                        | _ ->
							 if(bcapture = false || m_color.[y] = !m_xside)then
								Gen_Push(i, y)
					);
					if (m_color.[y] <> EMPTY) then(
						if (p = CANNON) then fcannon := true 	else k := 10;)
				)else(
					if (m_color.[y] <> EMPTY) then(
						if (m_color.[y] = !m_xside )then Gen_Push(i, y);
						k := 10
					)))) done;
		j := !j+1;
		))done	
)done;
m_gen_end.[!m_ply+1] <- m_gen_end.[!m_ply];
m_gen_begin.[!m_ply+1] <- m_gen_end.[!m_ply];

)

let IsThereLegalMove() = 
let kq = ref false in
	PreCalculate();
	Gene(false);
	kq := (m_gen_end.[!m_ply] > m_gen_begin.[!m_ply]);
!kq

let CheckLegalMove(from,dest) =
let kq = ref false in
PreCalculate();
InitGen();
Gene(false);
let i = ref  m_gen_begin.[0] in
while(!i<m_gen_end.[0])do 
	if(m_gen_dat.[!i].m.from = from && 
		m_gen_dat.[!i].m.dest=dest)then(
			kq := true;
			i:= 1000
	)else i := !i + 1 
done;
!kq	
