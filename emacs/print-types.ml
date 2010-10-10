
(* 
   Print the types of the atoms of terms, thms and the goal.
*) 
module Print_types 
  : sig 
      val goal_types: unit -> unit
      val print_thm_types: thm -> unit
      val print_term_types: term -> unit

      (* I've elided the common symbols from the list
         to avoid clutter.  You can add and remove names
         of constants from this list with (un)suppress *)
      val suppress: string -> unit
      val unsuppress: string -> unit

    end =
struct

  let suppressed = ref 
    ["==>";"?";"!";"/\\";"\\/";",";"~";"APPEND";"CONS";"HD";"LAST";
     "NIL";"=";"real_lt";"real_gt";"real_le";"real_ge";"BIT0";"BIT1";"NUMERAL";
     "real_of_num";"_0";"_1";"real_div";"real_mul";"real_pow";"COND"] 

  let suppress s = suppressed := s :: !suppressed 

  let unsuppress s = suppressed := List.filter ((!=) s) (!suppressed)

  let rec get_type_list tm = 
    match tm with       
        Var(s,t) -> if mem s !suppressed then [] else [(s,t)] 
      | Const(s,t) -> if mem s !suppressed then [] else [(s,t)] 
      | Comb (t1,t2) -> get_type_list t1 @ get_type_list t2 
      | Abs (t1,t2) -> get_type_list t1 @ get_type_list t2 

  let print_atom_type : string * hol_type -> unit =
    fun (s,t) -> 
      begin 
        print_string ("(\"" ^ s ^ "\", ");
        print_type t; 
        print_string ")\n" 
      end

  let setify_types tm = ((sort (<)) o setify o get_type_list) tm 

  let print_term_types = List.iter print_atom_type o setify_types 

  let print_thm_types tm = print_term_types (concl tm) 

  let goal_types() =
    let (asms,g) = top_goal() in
    let tms = g::asms in
    let tm = end_itlist (curry mk_conj) tms in
      (print_term_types tm)

end;;

open Print_types;;
