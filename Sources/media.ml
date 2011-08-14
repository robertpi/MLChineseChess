module Media
open Defines
open System
open System.Windows.Forms

let sFileInit = Application.StartupPath ^ "\\Sounds\\init.wav"

let sFileStart = Application.StartupPath ^ "\\Sounds\\start.wav"

let sFileMove = Application.StartupPath ^ "\\Sounds\\move.au"

let sFileClick = Application.StartupPath ^ "\\Sounds\\click.au"

let LetPlayMediaFile(file) =
if(!sound = true)then(
Application.DoEvents ();
 let t = Threading.Thread.CurrentThread in
 // now set in as attribute on main in chess.ml
  //t.SetApartmentState Threading.ApartmentState.STA;
   let mc = new QuartzTypeLib.FilgraphManagerClass() in(  
   try
    mc.RenderFile(file);
	mc.Run ();
   with  e -> Printf.printf "Error"
  ))
