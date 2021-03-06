(*Starter code for this exercise copied from
 * https://github.com/psosera/csc312-example-compiler/ ...
 * blob/master/ocaml/src/compiler.ml *)
(* Used 
 *http://scylardor.fr/2013/10/14/ ...
 * ocaml-parsing-a-programs-arguments-with-the-arg-module/
 * for comand-line interface *)
open Lexer
open Parser
open Lang

let parse_mode = ref false  
let step_mode = ref false
let type_mode = ref false  

let filename_to_tokens filename =
  Lexing.from_channel (open_in filename)

let tokens_to_exp tokens = Parser.main Lexer.token tokens

let filename_to_exp filename  =
  (open_in filename)
  |> Lexing.from_channel
  |> Parser.main Lexer.token

let input_handler filename p_mode s_mode t_mode =
  let get_val (env,v) = v
  in 
  let rec output_steps  acc env exp=
    if Lang.is_value exp
    then acc^"--> "^(exp_to_value exp |>string_of_value) ^"\n"
    else let (env,e) = (step env exp) in
	 output_steps (acc^"--> "^(string_of_expression exp)^"\n") env e
  in
  if t_mode then
    filename_to_exp filename |> Lang.typecheck [] |> string_of_type
  else if p_mode then filename_to_exp filename |> string_of_expression
  else if s_mode then filename_to_exp filename |> (output_steps "" [])
  else let expression = filename_to_exp filename
       in ignore (Lang.typecheck [] expression); expression
  |> Lang.eval []
  |> get_val
  |> string_of_value

let main () = begin
  let speclist  =
    [("-parse", Arg.Set parse_mode, "Enables parse mode");
     ("-step", Arg.Set step_mode, "Enables step mode");
     ("-typecheck", Arg.Set type_mode, "Enables typecheck mode")
    ]
  in
  let usage_msg =
    "This is a basic interpreter for a OCaml like language." ^
      "Options available:"
  in Arg.parse speclist
  (fun filename ->  input_handler filename !parse_mode !step_mode !type_mode
      |> print_string) usage_msg
end
  
  

let _ = if !Sys.interactive then () else main ()

    
